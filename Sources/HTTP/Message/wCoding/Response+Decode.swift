import Stream
import Network

extension Response {
    @_specialize(exported: true, where T == BufferedInputStream<NetworkStream>)
    public convenience init<T: StreamReader>(from stream: T) throws {
        self.init()
        self.contentLength = nil
        do {
            self.version = try Version(from: stream)
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            self.status = try Status(from: stream)

            @inline(__always)
            func readLineEnd() throws {
                guard try stream.consume(.cr),
                    try stream.consume(.lf) else {
                        throw ParseError.invalidResponse
                }
            }

            try readLineEnd()

            while true {
                guard try stream.cache(count: 2) else {
                    throw ParseError.unexpectedEnd
                }
                if try stream.next(is: Constants.lineEnd) {
                    try stream.consume(count: 2)
                    break
                }

                let name = try HeaderName(from: stream)

                guard try stream.consume(.colon) else {
                    throw ParseError.invalidResponse
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
                    self.cookies.append(try Cookie(responseCookieFrom: stream))
                default:
                    // FIXME: validate
                    headers[name] = try stream.read(until: .cr) { bytes in
                        return String(decoding: bytes, as: UTF8.self)
                    }
                }

                try readLineEnd()
            }

            // Body

            self.body = .input(stream)

        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
