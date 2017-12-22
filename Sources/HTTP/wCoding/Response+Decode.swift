import Stream
import Network

extension Response {
    @_specialize(exported: true, where T == BufferedInputStream<NetworkStream>)
    public init<T: UnsafeStreamReader>(from stream: T) throws {
        do {
            self.version = try Version(from: stream)
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            let status = try stream.read(until: .cr)
            self.status = try Status(from: status)

            @inline(__always)
            func readLineEnd() throws {
                guard try stream.consume(.cr),
                    try stream.consume(.lf) else {
                        throw ParseError.invalidRequest
                }
            }

            try readLineEnd()

            while true {
                guard let nextLine = try stream.peek(count: 2) else {
                    throw ParseError.unexpectedEnd
                }
                if nextLine.elementsEqual(Constants.lineEnd) {
                    try stream.consume(count: 2)
                    break
                }

                let name = try HeaderName(from: stream)

                let colon = try stream.read(count: 1)
                guard colon[0] == .colon else {
                    throw ParseError.invalidRequest
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
                    throw ParseError.invalidRequest
                }
                guard size > 0 else {
                    break
                }

                body.append(contentsOf: try stream.read(count: size))
                try readLineEnd()
            }

            self.rawBody = body

            // http request can have trailing \r\n
            // but we should avoid extra syscall
            if stream.buffered >= 2 {
                _ = try? stream.consume(sequence: Constants.lineEnd)
            }
        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
