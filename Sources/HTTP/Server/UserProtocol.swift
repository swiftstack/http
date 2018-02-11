public protocol UserProtocol: Codable {
    var name: String { get }
    var claims: [String] { get }
}

public extension UserProtocol {
    var claims: [String] {
        return []
    }
}

public protocol UserRepository: Inject {
    func get(id: String) throws -> UserProtocol?
    func add(user: UserProtocol) throws
}
