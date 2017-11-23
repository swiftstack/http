public struct Cookie {
    let name: String
    let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension Cookie: Equatable {
    public static func ==(lhs: Cookie, rhs: Cookie) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}

extension Array where Element == Cookie {
    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var cookies = [Cookie]()
        var startIndex = bytes.startIndex
        var endIndex = startIndex

        while endIndex < bytes.endIndex {
            endIndex = bytes.index(
                of: .semicolon,
                offset: startIndex)
                ?? bytes.endIndex

            // should be separated by a semi-colon and a space ('; ')
            if endIndex < bytes.endIndex {
                guard endIndex + 1 < bytes.endIndex,
                    bytes[endIndex + 1] == .whitespace else {
                        throw HTTPError.invalidCookie
                }
            }

            let cookie = try Cookie(
                from: bytes[startIndex..<endIndex].trimmingLeftSpace())

            cookies.append(cookie)
            startIndex = endIndex + 1
        }
        self = cookies
    }

    func encode(to buffer: inout [UInt8]) {
        for i in 0..<count {
            self[i].encode(to: &buffer)
            if i + 1 < count {
                buffer.append(.semicolon)
                buffer.append(.whitespace)
            }
        }
    }
}

extension Cookie {
    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        guard let equal = bytes.index(of: .equal) else {
            throw HTTPError.invalidCookie
        }
        guard
            let name = String(
                validating: bytes[..<equal].trimmingRightSpace(), as: .token),
            let value = String(
                validating: bytes[(equal+1)...].trimmingLeftSpace(), as: .token)
            else {
                throw HTTPError.invalidCookie
        }
        self.name = name
        self.value = value
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: name.utf8)
        buffer.append(.equal)
        buffer.append(contentsOf: value.utf8)
    }
}
