import Log
import Stream
import Network
import Platform

public class Server {
    public var bufferSize: Int

    let networkServer: Network.Server

    public let router = Router(middleware: [ErrorHandlerMiddleware.self])

    public init(host: String, port: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.networkServer = try Network.Server(host: host, port: port)
        self.networkServer.onClient = onClient
    }

    public init(host: String, reusePort: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.networkServer = try Network.Server(host: host, reusePort: reusePort)
        self.networkServer.onClient = onClient
    }

    public var address: String {
        return "http://\(networkServer.address)"
    }

    public func start() async throws {
        await Log.info("server at \(address) started")
        try await networkServer.start()
    }

    func onClient(socket: Socket) async {
        do {
            try await process(stream: NetworkStream(socket: socket))
        } catch let error as ParseError where error == .unexpectedEnd {
            /* connection closed */
        } catch let error as Socket.Error where error == .connectionReset {
            /* connection closed */
        } catch {
            /* log other errors */
            await Log.error(String(describing: error))
        }
    }

    func process<T: Stream>(stream: T) async throws {
        try await process(
            inputStream: BufferedInputStream(
                baseStream: stream,
                capacity: bufferSize),
            outputStream: BufferedOutputStream(
                baseStream: stream,
                capacity: bufferSize))
    }

    func process<I: InputStream, O: OutputStream>(
        inputStream: BufferedInputStream<I>,
        outputStream: BufferedOutputStream<O>
    ) async throws {
        while true {
            let request = try await Request.decode(from: inputStream)
            if request.expect == .continue {
                let `continue` = Response(status: .continue)
                try await `continue`.encode(to: outputStream)
                try await outputStream.flush()
            }
            if let response = await handleRequest(request) {
                try await response.encode(to: outputStream)
                try await outputStream.flush()
            }
            if request.connection == .close {
                break
            }
        }
    }

    @inline(__always)
    func handleRequest(_ request: Request) async -> Response? {
        return await router.handleRequest(request)
    }
}
