import Log
import Async
import Network
import Platform
import Stream

public class Server {
    public var bufferSize: Int

    let networkServer: Network.Server?

    @_versioned
    var router = Router()

    init(bufferSize: Int = 4096) {
        self.networkServer = nil
        self.bufferSize = bufferSize
    }

    public init(host: String, port: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.networkServer = try Network.Server(host: host, port: port)
        self.networkServer!.onClient = onClient
    }

    public init(host: String, reusePort: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.networkServer = try Network.Server(host: host, reusePort: reusePort)
        self.networkServer!.onClient = onClient
    }

    public var address: String {
        guard let networkServer = networkServer else {
            return "unknowns"
        }
        return "http://\(networkServer.address)"
    }

    public func start() throws {
        guard let networkServer = networkServer else {
            fatalError("networkServer is nil")
        }
        Log.info("server at \(address) started")
        try networkServer.start()
    }

    func onClient(socket: Socket) {
        let stream = NetworkStream(socket: socket)
        process(stream: stream)
    }

    func process<T: Stream>(stream: T) {
        do {
            let inputStream = BufferedInputStream(
                baseStream: stream, capacity: bufferSize)
            let outputStream = BufferedOutputStream(
                baseStream: stream, capacity: bufferSize)

            while true {
                let request = try Request(from: inputStream)
                if request.expect == .continue {
                    let `continue` = Response(status: .continue)
                    try `continue`.encode(to: outputStream)
                    try outputStream.flush()
                }
                let response = router.handleRequest(request)
                try response.encode(to: outputStream)
                try outputStream.flush()
                if request.connection == .close {
                    break
                }
            }
        } catch let error as ParseError where error == .unexpectedEnd {
            /* connection closed */
        } catch let error as SocketError where error.number == ECONNRESET {
            /* connection closed */
        } catch let error as NetworkStream.Error where error == .closed {
            /* connection closed */
        } catch {
            /* log other errors */
            log(event: .error, message: String(describing: error))
        }
    }
}
