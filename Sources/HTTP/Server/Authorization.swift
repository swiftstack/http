protocol AuthorizationProtocol {
    func authenticate(context: Context) throws
    func loginRequired(context: Context)
    func accessDenied(context: Context)
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
    enum Result {
        case ok
        case unauthorized
        case unauthenticated
    }
    func authorize(user: UserProtocol?) -> Result {
        guard let user = user else {
            switch self {
            case .allowAnonymous: return .ok
            default: return .unauthenticated
            }
        }
        switch self {
        case .allowAnonymous: return .ok
        case .any: return .ok
        case .user(let name) where user.name == name: return .ok
        case .users(let users) where users.contains(user.name): return .ok
        case .claim(let claim) where user.claims.contains(claim): return .ok
        default: return .unauthorized
        }
    }
}
