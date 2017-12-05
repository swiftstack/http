import Stream

extension Response {
    public func encode<T: OutputStream>(to stream: inout T) throws {
        var buffer = [UInt8]()
        encode(to: &buffer)
        var written = 0
        while written < buffer.count {
            written += try stream.write(buffer)
        }
    }

    public func encode(to buffer: inout [UInt8]) {
        // Start line
        version.encode(to: &buffer)
        buffer.append(.whitespace)
        status.encode(to: &buffer)
        buffer.append(contentsOf: Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(_ name: HeaderName, encoder: (inout [UInt8]) -> Void) {
            buffer.append(contentsOf: name.bytes)
            buffer.append(.colon)
            buffer.append(.whitespace)
            encoder(&buffer)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(_ name: HeaderName, value: String) {
            buffer.append(contentsOf: name.bytes)
            buffer.append(.colon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: value.utf8)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        if let contentType = self.contentType {
            writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            writeHeader(.contentLength, value: String(contentLength))
        }

        if let connection = self.connection {
            writeHeader(.connection, encoder: connection.encode)
        }

        if let contentEncoding = self.contentEncoding {
            writeHeader(.contentEncoding, encoder: contentEncoding.encode)
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for cookie in self.setCookie {
            writeHeader(.setCookie, encoder: cookie.encode)
        }

        for (key, value) in headers {
            writeHeader(key, value: value)
        }

        // Separator
        buffer.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            buffer.append(contentsOf: rawBody)
        }
    }
}
