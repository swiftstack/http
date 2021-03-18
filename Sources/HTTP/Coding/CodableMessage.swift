import Stream

public protocol DecodableMessage: AnyObject {
    var contentType: ContentType? { get }
    var transferEncoding: [TransferEncoding]? { get }
    var contentLength: Int? { get }
    var body: Body { get set }
}

extension Request: DecodableMessage {}
extension Response: DecodableMessage {}

extension DecodableMessage {
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
