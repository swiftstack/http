public enum Version {
    case oneOne
}

extension Version {
    private struct Bytes {
        static let httpSlash = ASCII("HTTP/")
        static let oneOne = ASCII("1.1")

        static let versionLength = httpSlash.count + oneOne.count
    }

    init(from buffer: UnsafeRawBufferPointer) throws {
        guard buffer.starts(with: Bytes.httpSlash) else {
            throw HTTPError.invalidVersion
        }
        guard buffer.count >= 8,
            buffer.suffix(from: 5).elementsEqual(Bytes.oneOne) else {
                throw HTTPError.invalidVersion
        }
        self = .oneOne
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: Bytes.httpSlash)
        switch self {
        case .oneOne: buffer.append(contentsOf: Bytes.oneOne)
        }
    }
}
