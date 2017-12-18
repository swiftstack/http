import Stream
import struct Foundation.CharacterSet

extension Request {
    public func encode<T: OutputStream>(to stream: inout T) throws {
        var buffer = [UInt8]()
        encode(to: &buffer)
        var written = 0
        while written < buffer.count {
            written += try stream.write(buffer)
        }
    }

    public func encode(to buffer: inout [UInt8]) {
        // Start Line
        method.encode(to: &buffer)
        buffer.append(.whitespace)
        url.path.encode(to: &buffer, allowedCharacters: .urlPathAllowed)
        if method == .get, let query = url.query, query.values.count > 0 {
            buffer.append(.questionMark)
            query.encode(to: &buffer)
        }
        buffer.append(.whitespace)
        version.encode(to: &buffer)
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

        if let host = self.host {
            writeHeader(.host, encoder: host.encode)
        }

        if let contentType = self.contentType {
            writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            writeHeader(.contentLength, value: String(contentLength))
        }

        if let userAgent = self.userAgent {
            writeHeader(.userAgent, value: userAgent)
        }

        if let accept = self.accept {
            writeHeader(.accept, encoder: accept.encode)
        }

        if let acceptLanguage = self.acceptLanguage {
            writeHeader(.acceptLanguage, encoder: acceptLanguage.encode)
        }

        if let acceptEncoding = self.acceptEncoding {
            writeHeader(.acceptEncoding, encoder: acceptEncoding.encode)
        }

        if let acceptCharset = self.acceptCharset {
            writeHeader(.acceptCharset, encoder: acceptCharset.encode)
        }

        if let authorization = self.authorization {
            writeHeader(.authorization, encoder: authorization.encode)
        }

        if let keepAlive = self.keepAlive {
            writeHeader(.keepAlive, value: String(keepAlive))
        }

        if let connection = self.connection {
            writeHeader(.connection, encoder: connection.encode)
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            writeHeader(key, value: value)
        }

        // Cookies
        for cookie in cookies {
            writeHeader(.cookie, encoder: cookie.encode)
        }

        // Separator
        buffer.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            buffer.append(contentsOf: rawBody)
        }
    }
}

extension String {
    public func encode(
        to buffer: inout [UInt8],
        allowedCharacters: CharacterSet
    ) {
        let escaped = addingPercentEncoding(
            withAllowedCharacters: allowedCharacters)!
        buffer.append(contentsOf: escaped.utf8)
    }
}

extension URL.Query {
    public func encode(to buffer: inout [UInt8]) {
        let queryString = values
            .map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        buffer.append(contentsOf: queryString.utf8)
    }
}

extension URL.Host {
    public func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: Punycode.encode(domain: address))
        if let port = port {
            buffer.append(.colon)
            buffer.append(contentsOf: "\(port)".utf8)
        }
    }
}
