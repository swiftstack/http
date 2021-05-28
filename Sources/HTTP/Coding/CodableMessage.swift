import Stream

public protocol DecodableMessage: AnyObject {
    var contentType: ContentType? { get }
    var contentEncoding: [ContentEncoding]? { get }
    var transferEncoding: [TransferEncoding]? { get }
    var contentLength: Int? { get set }
    var body: Body { get set }
}

public protocol EncodableMessage: AnyObject {
    var contentType: ContentType? { get set }
    var contentLength: Int? { get set }
    var body: Body { get set }
}

extension Request: DecodableMessage, EncodableMessage {}
extension Response: DecodableMessage, EncodableMessage {}

extension DecodableMessage {
    // TODO: Add support for Unicode.Encoding.Type
    public func readBody(as encoding: UTF8.Type) async throws -> String {
        .init(decoding: try await readBody(), as: encoding)
    }

    public func readBody() async throws -> [UInt8] {
        switch body {
        case .input(let stream):
            return try await readBody(from: stream)
        case .output(let writer):
            let output = OutputByteStream()
            try await writer(output)
            body = .input(InputByteStream(output.bytes))
            return output.bytes
        }
    }

    private func readBody(from stream: StreamReader) async throws -> [UInt8] {
        do {
            let bytes: [UInt8]
            if let contentLength = self.contentLength {
                guard contentLength > 0 else {
                    return []
                }
                bytes = try await stream.read(count: contentLength) { bytes in
                    return [UInt8](bytes)
                }
            } else if self.transferEncoding?.contains(.chunked) == true  {
                let reader = ChunkedStreamReader(baseStream: stream)
                bytes = try await reader.readUntilEnd()
            } else {
                throw Error.invalidRequest
            }
            // cache
            self.body = .input(InputByteStream(bytes))
            return bytes
        } catch let error as StreamError where error == .insufficientData {
            throw Error.unexpectedEnd
        }
    }
}
