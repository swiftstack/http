import Stream

extension Response {
    // TODO: move to Tests?
    public init(from bytes: [UInt8]) throws {
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        try self.init(from: stream)
    }

    public init<T: BufferedInputStreamReader>(from buffer: T) throws {
        guard let version = try buffer.read(until: .whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.version = try Version(from: version)
        try buffer.consume(count: 1)

        guard let status = try buffer.read(until: .cr) else {
            throw HTTPError.unexpectedEnd
        }
        self.status = try Status(from: status)

        @inline(__always)
        func readLineEnd() throws {
            guard let lineEnd = try? buffer.read(count: 2) else {
                throw HTTPError.unexpectedEnd
            }
            guard lineEnd.elementsEqual(Constants.lineEnd) else {
                throw HTTPError.invalidRequest
            }
        }

        try readLineEnd()

        while true {
            guard let nameSlice = try buffer.read(while: {
                $0 != .colon && $0 != .lf
            }) else {
                throw HTTPError.unexpectedEnd
            }
            // "\r\n" found
            guard nameSlice.first != .cr else {
                try buffer.consume(count: 1)
                break
            }
            let name = try HeaderName(from: nameSlice)

            try buffer.consume(count: 1)

            guard let untrimmend = try buffer.read(until: .cr) else {
                throw HTTPError.unexpectedEnd
            }
            let value = untrimmend.trimmingLeftSpace().trimmingRightSpace()

            try readLineEnd()

            switch name {
            case .connection:
                self.connection = try Connection(from: value)
            case .contentEncoding:
                self.contentEncoding = try [ContentEncoding](from: value)
            case .contentLength:
                self.contentLength = Int(from: value)
            case .contentType:
                self.contentType = try ContentType(from: value)
            case .transferEncoding:
                self.transferEncoding = try [TransferEncoding](from: value)
            case .setCookie:
                self.setCookie.append(try SetCookie(from: value))
            default:
                headers[name] = String(validating: value, as: .text)
            }
        }

        // Body

        // 1. content-lenght
        if let length = self.contentLength {
            guard length > 0 else {
                self.rawBody = nil
                return
            }
            self.rawBody = [UInt8](try buffer.read(count: length))
            return
        }

        // 2. chunked
        guard let transferEncoding = self.transferEncoding,
            transferEncoding.contains(.chunked) else {
                return
        }

        var body = [UInt8]()

        while true {
            guard let sizeBytes = try buffer.read(until: .cr) else {
                throw HTTPError.unexpectedEnd
            }
            try readLineEnd()

            // TODO: optimize using hex table
            guard let size = Int(from: sizeBytes, radix: 16) else {
                throw HTTPError.invalidRequest
            }
            guard size > 0 else {
                break
            }

            body.append(contentsOf: try buffer.read(count: size))
            try readLineEnd()
        }

        self.rawBody = body

        if buffer.count >= 2,
            buffer.peek(count: 2)!.elementsEqual(Constants.lineEnd) {
            try buffer.consume(count: 2)
        }
    }
}
