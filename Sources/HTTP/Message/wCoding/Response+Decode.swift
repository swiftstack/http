import Stream
import Network

extension Response {
    @_specialize(exported: true, where T == BufferedInputStream<NetworkStream>)
    public convenience init<T: UnsafeStreamReader>(from stream: T) throws {
        self.init()
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

            self.body = .input(stream)

        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
