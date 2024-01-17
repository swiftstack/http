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

extension DecodingError {
    static func keyNotFound(_ key: any CodingKey) -> Self {
        .keyNotFound(key, .init(codingPath: [], debugDescription: ""))
    }

    static func valueNotFound(_ type: any Any.Type) -> Self {
        .valueNotFound(type, .init(codingPath: [], debugDescription: ""))
    }
}
