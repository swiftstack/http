public protocol CookiesStorage: Inject {
    func get(hash: String) throws -> Cookies?
    func upsert(cookies: Cookies) throws
    func delete(hash: String) throws
}

public final class InMemoryCookiesStorage: CookiesStorage {
    var cookies: [String : [String : String]]

    public init() {
        self.cookies = [:]
    }

    public func get(hash: String) throws -> Cookies? {
        guard let values = self.cookies[hash] else {
            return nil
        }
        return Cookies(hash: hash, values: values)
    }

    public func upsert(cookies: Cookies) throws {
        self.cookies[cookies.hash] = cookies.values
    }

    public func delete(hash: String) throws {
        cookies[hash] = nil
    }
}
