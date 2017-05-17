import Log
import Async
import Network
import Reflection
import Foundation

@_exported import HTTP

public class Server {
    let async: Async
    let socket: Socket
    public let host: String
    public let port: UInt16

    public let bufferSize = 1024
    internal var routeMatcher = RouteMatcher<Route>()

    public init(host: String, port: UInt16, async: Async) throws {
        self.host = host
        self.port = port
        self.async = async
        self.socket = try Socket(awaiter: async.awaiter)
    }

    convenience
    public init(host: String, reusePort: UInt16, async: Async) throws {
        try self.init(host: host, port: reusePort, async: async)
        socket.configure(reusePort: true)
    }

    deinit {
        try? socket.close(silent: true)
    }

    public func start() throws {
        try socket.bind(to: host, port: port).listen()
        log(event: .info, message: "\(self) started")
        async.task {
            while true {
                do {
                    let client = try self.socket.accept()
                    self.async.task { [unowned self] in
                        self.handleClient(client)
                    }
                } catch {
                    self.handleError(error)
                }
            }
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

    func handleClient(_ client: Socket) {
        do {
            var bytes = [UInt8](repeating: 0, count: bufferSize)
            while true {
                let read = try client.receive(to: &bytes)
                guard read > 0 else {
                    break
                }
                let request = try Request(from: bytes)
                let response = provideResponse(for: request)
                _ = try client.send(bytes: response.bytes)
            }
        } catch {
            handleError(error)
        }
    }

    public typealias RequestHandler = (Request) throws -> Response

    struct Route {
        let method: Request.Method
        let handler: RequestHandler
    }

    func provideResponse(for request: Request) -> Response {
        let routes = routeMatcher.matches(route: request.url.path)
        guard let route = routes.first(where: { route in
            route.method == request.method
        }) else {
            return Response(status: .notFound)
        }

        do {
            return try route.handler(request)
        } catch {
            Log.debug(String(describing: error))
            return Response(status: .internalServerError)
        }
    }
}
