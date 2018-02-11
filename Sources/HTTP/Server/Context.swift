public final class Context {
    public let request: Request
    public var response: Response

    public let authorization: Authorization
    public let services: Services

    public var cookies: Cookies
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
        self.cookies = Cookies()
    }
}

extension Context: Inject {
    public convenience init() {
        fatalError("Context shouldn't be created by DI")
    }
}

import struct Foundation.UUID

public class Cookies {
    let hash: String
    private var values: [String : String]

    var hasChanges = false

    var count: Int {
        return values.count
    }

    public init() {
        self.hash = UUID().uuidString
        self.values = [:]
    }

    public init(hash: String, values: [String : String]) {
        self.hash = hash
        self.values = values
    }

    public subscript(_ name: String) -> String? {
        get {
            return values[name]
        }
        set {
            self.hasChanges = true
            values[name] = newValue
        }
    }
}
