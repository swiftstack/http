public protocol Primitive {
    init?(param: String)
}

extension String : Primitive {
    public init?(param: String) {
        self = param
    }
}

extension Bool : Primitive {
    public init?(param: String) {
        guard let bool = Bool(param) else {
            return nil
        }
        self = bool
    }
}

extension Int : Primitive {
    public init?(param: String) {
        guard let integer = Int(param) else {
            return nil
        }
        self = integer
    }
}

extension Double : Primitive {
    public init?(param: String) {
        guard let double = Double(param) else {
            return nil
        }
        self = double
    }
}
