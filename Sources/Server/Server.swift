import Log
import Async
import Socket
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
        async.loop.run()
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
                let request = try Request(fromBytes: bytes)
                Log.debug(">> \(request.url)")

                let response = provideResponse(for: request)
                Log.debug("<< \(response.status.rawValue)")

                _ = try client.send(bytes: response.bytes)
            }
        } catch {
            handleError(error)
        }
    }

    public typealias RequestHandler = (Request) -> Any

    struct Route {
        let type: RequestType
        let handler: RequestHandler
    }

    func provideResponse(for request: Request) -> Response {
        let routes = routeMatcher.matches(route: request.urlBytes)
        guard let route = routes.first(where: { $0.type == request.type }) else {
            return Response(status: .notFound)
        }

        let response = route.handler(request)

        switch response {
        case let response as Response: return response
        case let string as String: return Response(string: string)
        default: return createJsonResponse(response)
        }
    }

    func createJsonResponse(_ object: Any) -> Response {
        var jsonObject: Any

        switch object {
        case let dictonary as [String : Any]: jsonObject = dictonary
        default: jsonObject = serialize(object: object)
        }

        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject as Any) else {
            return Response(status: .internalServerError)
        }
        return Response(json: [UInt8](data))
    }

    func serialize(object: Any) -> [String : Any] {
        let mirror = Mirror(reflecting: object)
        var dictionary = [String : Any]()
        for child in mirror.children {
            if let name = child.label {
                switch child.value {
                case let value as String: dictionary[name] = value
                case let value as Int: dictionary[name] = String(describing: value)
                case let value as Bool: dictionary[name] = String(describing: value)
                case let value as Double: dictionary[name] = String(describing: value)
                case let value as [String : String]: dictionary[name] = value
                default: continue
                }
            }
        }
        return dictionary
    }
}
