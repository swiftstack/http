import Log
import Stream
import Network
import Platform

public class Server {
    public var bufferSize: Int

    let tcpServer: TCP.Server

    public let router = Router(middleware: [ErrorHandlerMiddleware.self])

    public init(host: String, port: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.tcpServer = try TCP.Server(host: host, port: port)
    }

    public init(host: String, reusePort: Int, bufferSize: Int = 4096) throws {
        self.bufferSize = bufferSize
        self.tcpServer = try TCP.Server(host: host, reusePort: reusePort)
    }

    public var address: String {
        return "http://\(tcpServer.address)"
    }

    public func start() async throws {
        await self.tcpServer.onClient(onClient)
        await Log.info("server at \(address) started")
        try await tcpServer.start()
    }

    func onClient(socket: TCP.Socket) async {
        do {
            try await process(stream: TCP.Stream(socket: socket))
        } catch let error as HTTP.Error where error == .unexpectedEnd {
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
            inputStream: .init(baseStream: stream, capacity: bufferSize),
            outputStream: .init(baseStream: stream, capacity: bufferSize))
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
