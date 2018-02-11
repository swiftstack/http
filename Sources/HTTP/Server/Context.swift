public final class Context {
    public let request: Request
    public var response: Response

    public let authorization: Authorization
    public let services: Services

    public var user: UserProtocol? = nil

    init(
        request: Request,
        authorization: Authorization,
        services: Services
    ) {
        self.request = request
        self.authorization = authorization
        self.services = services

        self.response = Response(status: .ok)
    }
}

extension Context: Service {
    public convenience init() {
        fatalError("Context shouldn't be created by DI")
    }
}
