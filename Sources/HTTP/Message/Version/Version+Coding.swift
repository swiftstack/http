import Stream

extension Version {
    private struct Bytes {
        static let httpSlash = ASCII("HTTP/")
        static let oneOne = ASCII("1.1")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        try await stream.read(count: Bytes.httpSlash.count) { bytes in
            guard bytes.elementsEqual(Bytes.httpSlash) else {
                throw Error.invalidVersion
            }
        }

        return try await stream.read(count: Bytes.oneOne.count) { bytes in
            guard bytes.elementsEqual(Bytes.oneOne) else {
                throw Error.invalidVersion
            }
            return .oneOne
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await stream.write(Bytes.httpSlash)
        switch self {
        case .oneOne: try await stream.write(Bytes.oneOne)
        }
    }
}
