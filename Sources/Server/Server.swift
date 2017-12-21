import Log
import Async
import Network
import Platform
import Stream

@_exported import HTTP

public class Server {
    let socket: Socket
    let host: URL.Host

    public var bufferSize = 4096

    var router = Router()

    public init(host: String, port: Int) throws {
        let socket = try Socket()
        try socket.bind(to: host, port: port)
        self.socket = socket
        self.host = URL.Host(address: host, port: port)
    }

    convenience
    public init(host: String, reusePort: Int) throws {
        try self.init(host: host, port: reusePort)
        try socket.options.set(.reusePort, true)
    }

    deinit {
        try? socket.close()
    }

    public func start() throws {
        try socket.listen()
        log(event: .info, message: "\(self) started")
        async.task {
            while true {
                do {
                    let client = try self.socket.accept()
                    async.task { [unowned self] in
                        self.handleClient(client)
                    }
                } catch {
                    self.handleError(error)
                }
            }
        }
    }

    func handleClient(_ client: Socket) {
        do {
            let stream = NetworkStream(socket: client)

            let inputStream = BufferedInputStream(
                baseStream: stream, capacity: bufferSize)
            let outputStream = BufferedOutputStream(
                baseStream: stream, capacity: bufferSize)

            while true {
                let request = try Request(from: inputStream)
                let response = router.handleRequest(request)
                try response.encode(to: outputStream)
                try outputStream.flush()
                if request.connection == .close {
                    break
                }
            }
        } catch let error as ParseError where error == .unexpectedEnd {
            /* connection closed */
        } catch let error as NetworkStream.Error where error == .closed {
            /* connection closed */
        } catch {
            handleError(error)
        }
    }

    func handleError (_ error: Error) {
        if let error = error as? SocketError, error.number == ECONNRESET {
            /* connection reset by peer */
            /* do nothing, it's fine. */
        } else {
            log(event: .error, message: String(describing: error))
        }
    }
}
