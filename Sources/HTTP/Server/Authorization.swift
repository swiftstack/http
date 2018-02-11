protocol AuthorizationProtocol {
    func authenticate(context: Context) throws
    func authorizationFailed(context: Context)
}

public enum Authorization {
    case allowAnonymous
    case any
    case user(String)
    case users([String])
    case claim(String)
    case claims([String])
}

extension Authorization {
    func authorize(user: UserProtocol?) -> Bool {
        guard let user = user else {
            switch self {
            case .allowAnonymous: return true
            default: return false
            }
        }
        switch self {
        case .allowAnonymous: return true
        case .any: return true
        case .user(let name) where user.name == name: return true
        case .users(let users) where users.contains(user.name): return true
        case .claim(let claim) where user.claims.contains(claim): return true
        default: return false
        }
    }
}
