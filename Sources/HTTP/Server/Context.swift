public final class Context {
    public var request: Request
    public var response: Response
    public var services: Services

    init(
        request: Request,
        response: Response = Response(status: .ok),
        services: Services
    ) {
        self.request = request
        self.response = response
        self.services = services
    }
}

extension Context: Service {
    public convenience init() {
        let request = Request(url: "/", method: .get)
        let response = Response(status: .ok)
        let services = Services.shared
        self.init(request: request, response: response, services: services)
    }
}
