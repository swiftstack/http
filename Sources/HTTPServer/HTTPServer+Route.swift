import Reflection
import HTTPMessage

extension Server {
    // when we don't need anything
    public func route(method: HTTPRequestType, url: String, handler: @escaping (Void) -> Any) {
        let route = Route(type: method, handler: { _ in handler() })
        routeMatcher.add(route: [UInt8](url.utf8), payload: route)
    }

    // only request data
    public func route(method: HTTPRequestType, url: String, handler: @escaping (HTTPRequest) -> Any) {
        let route = Route(type: method, handler: handler)
        routeMatcher.add(route: [UInt8](url.utf8), payload: route)
    }

    // reflection: primitive types: Int, String, Double.
    public func route<A: Primitive>(method: HTTPRequestType, url: String, handler: @escaping (A) -> Any) {
        createRoute(method: method, url: url) { _, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = A(param: value) else {
                    return HTTPResponse(status: .badRequest)
            }
            return handler(param)
        }
    }

    // reflection: request data + primitive types: Int, String, Double.
    public func route<A: Primitive>(method: HTTPRequestType, url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        createRoute(method: method, url: url) { request, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = A(param: value) else {
                    return HTTPResponse(status: .badRequest)
            }
            return handler(request, param)
        }
    }

    // reflection: POD value type
    public func route<A>(method: HTTPRequestType, url: String, handler: @escaping (A) -> Any) {
        createRoute(method: method, url: url) { _, values in
            guard let model = Blueprint(ofType: A.self).construct(using: values) else {
                return HTTPResponse(status: .badRequest)
            }
            return handler(model)
        }
    }

    // reflection: request data + POD value type
    public func route<A>(method: HTTPRequestType, url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        createRoute(method: method, url: url) { request, values in
            guard let model = Blueprint(ofType: A.self).construct(using: values) else {
                return HTTPResponse(status: .badRequest)
            }
            return handler(request, model)
        }
    }

    @inline(__always)
    func createRoute(method: HTTPRequestType, url: String, handler: @escaping (HTTPRequest, [String : Any]) -> Any) {
        let urlMatcher = URLParamMatcher(url)

        let wrapper: RequestHandler = { request in
            var values = urlMatcher.match(from: request.url)

            let queryValues: [String: Any]?

            if method == .get {
                queryValues = QueryParser.parse(urlEncoded: request.queryString)
            } else if let body = request.rawBody,
                let contentType = request.contentType {
                    switch contentType {
                    case .urlEncoded:
                        let query = String(cString: body + [0])
                        queryValues = QueryParser.parse(urlEncoded: query)
                    case .json:
                        queryValues = QueryParser.parse(json: body)
                    }
            } else {
                queryValues = nil
            }

            if let queryValues = queryValues {
                for (key, value) in queryValues {
                    values[key] = value
                }
            }
            return handler(request, values)
        }
        let route = Route(type: method, handler: wrapper)
        routeMatcher.add(route: [UInt8](url.utf8), payload: route)
    }

    // Convenience constructors

    // GET
    public func route(get url: String, handler: @escaping (Void) -> Any) {
        route(method: .get, url: url, handler: handler)
    }

    public func route(get url: String, handler: @escaping (HTTPRequest) -> Any) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A: Primitive>(get url: String, handler: @escaping (A) -> Any) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A: Primitive>(get url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A>(get url: String, handler: @escaping (A) -> Any) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A>(get url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .get, url: url, handler: handler)
    }

    // HEAD
    public func route(head url: String, handler: @escaping (Void) -> Any) {
        route(method: .head, url: url, handler: handler)
    }

    public func route(head url: String, handler: @escaping (HTTPRequest) -> Any) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A: Primitive>(head url: String, handler: @escaping (A) -> Any) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A: Primitive>(head url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A>(head url: String, handler: @escaping (A) -> Any) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A>(head url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .head, url: url, handler: handler)
    }

    // POST
    public func route(post url: String, handler: @escaping (Void) -> Any) {
        route(method: .post, url: url, handler: handler)
    }

    public func route(post url: String, handler: @escaping (HTTPRequest) -> Any) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A: Primitive>(post url: String, handler: @escaping (A) -> Any) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A: Primitive>(post url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A>(post url: String, handler: @escaping (A) -> Any) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A>(post url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .post, url: url, handler: handler)
    }

    // PUT
    public func route(put url: String, handler: @escaping (Void) -> Any) {
        route(method: .put, url: url, handler: handler)
    }

    public func route(put url: String, handler: @escaping (HTTPRequest) -> Any) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A: Primitive>(put url: String, handler: @escaping (A) -> Any) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A: Primitive>(put url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A>(put url: String, handler: @escaping (A) -> Any) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A>(put url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .put, url: url, handler: handler)
    }

    // DELETE
    public func route(delete url: String, handler: @escaping (Void) -> Any) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route(delete url: String, handler: @escaping (HTTPRequest) -> Any) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A: Primitive>(delete url: String, handler: @escaping (A) -> Any) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A: Primitive>(delete url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A>(delete url: String, handler: @escaping (A) -> Any) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A>(delete url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .delete, url: url, handler: handler)
    }

    // OPTIONS
    public func route(options url: String, handler: @escaping (Void) -> Any) {
        route(method: .options, url: url, handler: handler)
    }

    public func route(options url: String, handler: @escaping (HTTPRequest) -> Any) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A: Primitive>(options url: String, handler: @escaping (A) -> Any) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A: Primitive>(options url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A>(options url: String, handler: @escaping (A) -> Any) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A>(options url: String, handler: @escaping (HTTPRequest, A) -> Any) {
        route(method: .options, url: url, handler: handler)
    }
}
