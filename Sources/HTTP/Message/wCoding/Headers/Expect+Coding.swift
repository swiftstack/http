import Stream

extension Expect {
    private struct Bytes {
        static let `continue` = ASCII("100-continue")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        // FIXME: validate with value-specific rule
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.`continue`.lowercasedHashValue: self = .`continue`
        default: throw ParseError.unsupportedExpect
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .`continue`: bytes = Bytes.`continue`
        }
        try stream.write(bytes)
    }
}
