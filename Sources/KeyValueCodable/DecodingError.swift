extension DecodingError.Context {
    static func description(_ string: String) -> DecodingError.Context {
        return DecodingError.Context(codingPath: [], debugDescription: string)
    }

    static func incompatible(
        with value: String
    ) -> DecodingError.Context {
        return .description("incompatible with \(value)")
    }

    static func incompatible<T: CodingKey>(
        with value: String, for key: T
    ) -> DecodingError.Context {
        return .description("incompatible with \(value) for \(key)")
    }
}

extension DecodingError.Context: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.codingPath = []
        self.debugDescription = value
    }
}

extension DecodingError.Context: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.codingPath = []
        self.debugDescription = ""
    }
}
