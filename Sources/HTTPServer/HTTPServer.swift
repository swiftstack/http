import Log
import Async
import Socket
import Reflection
import Foundation

@_exported import HTTPMessage

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
        try socket.listen(at: host, port: port)
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
        if let error = error as? SocketError,
            error.number == 54 || error.number == 104 {
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
                let read = try client.read(to: &bytes, count: bytes.count)
                guard read > 0 else {
                    break
                }
                let request = try HTTPRequest(fromBytes: bytes)
                Log.debug(">> \(request.url)")

                let response = provideResponse(for: request)
                Log.debug("<< \(response.status.rawValue)")

                _ = try client.write(bytes: response.bytes)
            }
        } catch {
            handleError(error)
        }
    }

    public typealias RequestHandler = (HTTPRequest) -> Any

    struct Route {
        let type: HTTPRequestType
        let handler: RequestHandler
    }

    func provideResponse(for request: HTTPRequest) -> HTTPResponse {
        let routes = routeMatcher.matches(route: request.urlBytes)
        guard let route = routes.first(where: { $0.type == request.type }) else {
            return HTTPResponse(status: .notFound)
        }

        let response = route.handler(request)

        switch response {
        case let httpResponse as HTTPResponse: return httpResponse
        case let string as String: return HTTPResponse(string: string)
        default: return createJsonResponse(response)
        }
    }

    func createJsonResponse(_ object: Any) -> HTTPResponse {
        var jsonObject: Any

        switch object {
        case let dictonary as [String : Any]: jsonObject = dictonary
        default: jsonObject = serialize(object: object)
        }

        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject as Any) else {
            return HTTPResponse(status: .internalServerError)
        }
        return HTTPResponse(json: [UInt8](data))
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
