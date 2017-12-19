import Stream
import Network

extension Response {
    public init(from bytes: [UInt8]) throws {
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        try self.init(from: stream)
    }

    @_specialize(exported: true, where T == NetworkStream)
    public init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        do {
            self.version = try Version(from: stream)
            try stream.consume(count: 1)

            let status = try stream.read(until: .cr)
            self.status = try Status(from: status)

            @inline(__always)
            func readLineEnd() throws {
                let lineEnd = try stream.read(count: 2)
                guard lineEnd.elementsEqual(Constants.lineEnd) else {
                    throw HTTPError.invalidRequest
                }
            }

            try readLineEnd()

            while true {
                guard let nextLine = try stream.peek(count: 2) else {
                    throw HTTPError.unexpectedEnd
                }
                if nextLine.elementsEqual(Constants.lineEnd) {
                    try stream.consume(count: 2)
                    break
                }

                let name = try HeaderName(from: stream)

                let colon = try stream.read(count: 1)
                guard colon[0] == .colon else {
                    throw HTTPError.invalidRequest
                }
                try stream.consume(while: { $0 == .whitespace })

                switch name {
                case .connection:
                    self.connection = try Connection(from: stream)
                case .contentEncoding:
                    self.contentEncoding = try [ContentEncoding](from: stream)
                case .contentLength:
                    self.contentLength = try Int(from: stream)
                case .contentType:
                    self.contentType = try ContentType(from: stream)
                case .transferEncoding:
                    self.transferEncoding = try [TransferEncoding](from: stream)
                case .setCookie:
                    self.setCookie.append(try SetCookie(from: stream))
                default:
                    // FIXME: validate
                    let bytes = try stream.read(until: .cr)
                    headers[name] = String(decoding: bytes, as: UTF8.self)
                }

                try readLineEnd()
            }

            // Body

            // 1. content-lenght
            if let length = self.contentLength {
                guard length > 0 else {
                    self.rawBody = nil
                    return
                }
                self.rawBody = [UInt8](try stream.read(count: length))
                return
            }

            // 2. chunked
            guard let transferEncoding = self.transferEncoding,
                transferEncoding.contains(.chunked) else {
                    return
            }

            var body = [UInt8]()

            while true {
                let sizeBytes = try stream.read(until: .cr)
                try readLineEnd()

                // TODO: optimize using hex table
                guard let size = Int(from: sizeBytes, radix: 16) else {
                    throw HTTPError.invalidRequest
                }
                guard size > 0 else {
                    break
                }

                body.append(contentsOf: try stream.read(count: size))
                try readLineEnd()
            }

            self.rawBody = body

            if stream.count >= 2,
                try stream.peek(count: 2)!.elementsEqual(Constants.lineEnd) {
                try stream.consume(count: 2)
            }
        } catch let error as BufferedInputStream<T>.Error
            where error == .insufficientData {
                throw HTTPError.unexpectedEnd
        }
    }
}
