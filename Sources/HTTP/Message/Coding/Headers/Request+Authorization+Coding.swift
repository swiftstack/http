import Stream

extension Request.Authorization {
    private struct Bytes {
        static let basic = ASCII("Basic")
        static let bearer = ASCII("Bearer")
        static let token = ASCII("Token")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        func readCredentials() async throws -> String {
            guard try await stream.consume(.whitespace) else {
                throw ParseError.invalidAuthorizationHeader
            }
            // FIXME: validate with value-specific rule
            return try await stream.read(allowedBytes: .text) { bytes in
                return String(decoding: bytes, as: UTF8.self)
            }
        }

        let bytes = try await stream.read(until: .whitespace)

        switch bytes.lowercasedHashValue {
        case Bytes.basic.lowercasedHashValue:
            return .basic(credentials: try await readCredentials())
        case Bytes.bearer.lowercasedHashValue:
            return .bearer(credentials: try await readCredentials())
        case Bytes.token.lowercasedHashValue:
            return .token(credentials: try await readCredentials())
        default:
            return .custom(
                scheme: String(decoding: bytes, as: UTF8.self),
                credentials: try await readCredentials())
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        switch self {
        case .basic(let credentials):
            try await stream.write(Bytes.basic)
            try await stream.write(.whitespace)
            try await stream.write(credentials)
        case .bearer(let credentials):
            try await stream.write(Bytes.bearer)
            try await stream.write(.whitespace)
            try await stream.write(credentials)
        case .token(let credentials):
            try await stream.write(Bytes.token)
            try await stream.write(.whitespace)
            try await stream.write(credentials)
        case .custom(let schema, let credentials):
            try await stream.write(schema)
            try await stream.write(.whitespace)
            try await stream.write(credentials)
        }
    }
}
