import Buffer
import MemoryStream

extension Response {
    // TODO: move to Tests?
    public init(from bytes: [UInt8]) throws {
        let stream = MemoryStream(capacity: bytes.count)
        _ = try stream.write(bytes)
        try stream.seek(to: 0, from: .begin)
        let inputBuffer = InputBuffer(source: stream)
        try self.init(from: inputBuffer)
    }

    public init<T: InputBufferProtocol>(from buffer: T) throws {
        guard let version = try buffer.read(until: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.version = try Version(from: version)
        try buffer.consume(count: 1)

        guard let status = try buffer.read(until: Character.cr) else {
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
            guard let headerStart = try buffer.read(while: {
                $0 != Character.colon && $0 != Character.lf
            }) else {
                throw HTTPError.unexpectedEnd
            }
            // "\r\n" found
            guard headerStart.first != Character.cr else {
                try buffer.consume(count: 1)
                break
            }
            let headerName = try HeaderName(from: headerStart)

            try buffer.consume(count: 1)

            guard let value = try buffer.read(until: Character.cr) else {
                throw HTTPError.unexpectedEnd
            }
            let headerValue = value.trimmingLeftSpace().trimmingRightSpace()

            try readLineEnd()

            switch headerName {
            case .connection:
                self.connection = try Connection(from: headerValue)
            case .contentEncoding:
                self.contentEncoding =
                    try [ContentEncoding](from: headerValue)
            case .contentLength:
                self.contentLength = Int(from: headerValue)
            case .contentType:
                self.contentType = try ContentType(from: headerValue)
            case .transferEncoding:
                self.transferEncoding =
                    try [TransferEncoding](from: headerValue)
            case .setCookie:
                self.setCookie.append(try SetCookie(from: headerValue))
            default:
                headers[headerName] =
                    String(validating: headerValue, as: .text)
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
            guard let sizeBytes = try buffer.read(until: Character.cr) else {
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
