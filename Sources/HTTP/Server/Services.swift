public protocol Service {
    init()
}

public class Services {
    enum Error: Swift.Error {
        case typeMismatch(type: Any.Type, proto: Any.Type)
        case typeNotFound(Any.Type)
    }

    public static let shared = Services()

    enum Lifetime {
        case singleton(Any)
        case transient(Service.Type)
    }

    var values: [Int: Lifetime] = [:]

    @inline(__always)
    func id<T>(_ type: T.Type) -> Int {
        return unsafeBitCast(type, to: Int.self)
    }

    // singleton
    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Service
    {
        guard let instance = T() as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    // transient
    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Service
    {
        guard T() is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient(type)
    }

    public func resolve<P>(_ proto: P.Type) throws -> P {
        guard let lifetime = values[id(proto)] else {
            throw Error.typeNotFound(P.self)
        }
        switch lifetime {
        case .singleton(let instance): return instance as! P
        case .transient(let type): return type.init() as! P
        }
    }
}

extension Services.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .typeMismatch(let type, let proto):
            return "type \(type) must conform to \(proto)"
        case .typeNotFound(let type):
            return "type \(type) is not registered"
        }
    }
}
