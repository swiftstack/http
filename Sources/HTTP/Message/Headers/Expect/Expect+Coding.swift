import Stream

extension Expect {
    private struct Bytes {
        static let `continue` = ASCII("100-continue")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        // FIXME: validate with value-specific rule
        return try await stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.`continue`.lowercasedHashValue: return .`continue`
            default: throw Error.unsupportedExpect
            }
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        let bytes: [UInt8]
        switch self {
        case .`continue`: bytes = Bytes.`continue`
        }
        try await stream.write(bytes)
    }
}
