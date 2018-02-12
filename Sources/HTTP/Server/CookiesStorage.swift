protocol CookiesStorage: Inject {
    func get(hash: String) throws -> Cookies?
    func upsert(cookies: Cookies) throws
    func delete(hash: String) throws
}

public final class InMemoryCookiesStorage: CookiesStorage {
    var cookies: [String : Cookies]

    public init() {
        self.cookies = [:]
    }

    func get(hash: String) throws -> Cookies? {
        return self.cookies[hash]
    }

    func upsert(cookies: Cookies) throws {
        self.cookies[cookies.hash] = cookies
    }

    func delete(hash: String) throws {
        cookies[hash] = nil
    }
}
