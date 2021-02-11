import Test
import Stream

@testable import HTTP

// MARK: Start line

test.case("Get") {
    let stream = InputByteStream("GET /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.get)
}

test.case("Head") {
    let stream = InputByteStream("HEAD /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.head)
}

test.case("Post") {
    let stream = InputByteStream("POST /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.post)
}

test.case("Put") {
    let stream = InputByteStream("PUT /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.put)
}

test.case("Delete") {
    let stream = InputByteStream("DELETE /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.delete)
}

test.case("Version") {
    let stream = InputByteStream("GET /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.version == Version.oneOne)
}

test.case("Url") {
    let stream = InputByteStream(
        "GET /test?k1=v1&k2=v2#fragment HTTP/1.1\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.url.path == "/test")
    expect(request.url.query?.values == ["k1":"v1", "k2":"v2"])
    expect(request.url.fragment == "fragment")
}

test.case("InvalidRequest") {
    let stream = InputByteStream("GET\r\n\r\n")
    expect(throws: ParseError.invalidStartLine) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidRequest2") {
    let stream = InputByteStream("GET \r\n\r\n")
    expect(throws: ParseError.invalidStartLine) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidMethod") {
    let stream = InputByteStream("BAD /test HTTP/1.1\r\n\r\n")
    expect(throws: ParseError.invalidMethod) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidVersion") {
    let stream = InputByteStream("GET /test HTTP/0.1\r\n\r\n")
    expect(throws: ParseError.invalidVersion) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidVersion2") {
    let stream = InputByteStream("GET /test HTTP/1.1WUT\r\n\r\n")
    expect(throws: ParseError.invalidRequest) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidVersion3") {
    let stream = InputByteStream("GET /test HTTP/1.")
    expect(throws: ParseError.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidVersion4") {
    let stream = InputByteStream("GET /test HTPP/1.1\r\n\r\n")
    expect(throws: ParseError.invalidVersion) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidEnd") {
    let stream = InputByteStream("GET /test HTTP/1.1\r\n")
    expect(throws: ParseError.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

// MARK: Headers

test.case("HostHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: 0.0.0.0:5000\r\n" +
        "\r\n")
    let expected = URL.Host(address: "0.0.0.0", port: 5000)
    let request = try await Request.decode(from: stream)
    expect(request.host == expected)
}

test.case("HostDomainHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: domain.com:5000\r\n" +
        "\r\n")
    let expected = URL.Host(address: "domain.com", port: 5000)
    let request = try await Request.decode(from: stream)
    expect(request.host == expected)
}

test.case("HostEncodedHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: xn--d1acufc.xn--p1ai:5000\r\n" +
        "\r\n")
    let expected = URL.Host(address: "домен.рф", port: 5000)
    let request = try await Request.decode(from: stream)
    expect(request.host == expected)
}

test.case("UserAgentHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User-Agent: Mozilla/5.0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.userAgent == "Mozilla/5.0")
}

test.case("AcceptHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Accept: text/html,application/xml;q=0.9,*/*;q=0.8\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.accept == [
        Request.Accept(.text(.html),priority: 1.0),
        Request.Accept(.application(.xml), priority: 0.9),
        Request.Accept(.any, priority: 0.8)
    ])
}

test.case("AcceptLanguageHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Accept-Language: en-US,en;q=0.5\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.acceptLanguage == [
        Request.AcceptLanguage(.enUS, priority: 1.0),
        Request.AcceptLanguage(.en, priority: 0.5)
    ])
}

test.case("AcceptEncodingHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Accept-Encoding: gzip, deflate\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.acceptEncoding == [.gzip, .deflate])
}

test.case("AcceptCharset") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Accept-Charset: ISO-8859-1,utf-7,utf-8;q=0.7,*;q=0.7\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    let expectedAcceptCharset = [
        Request.AcceptCharset(.isoLatin1),
        Request.AcceptCharset(.custom("utf-7")),
        Request.AcceptCharset(.utf8, priority: 0.7),
        Request.AcceptCharset(.any, priority: 0.7)
    ]
    expect(request.acceptCharset == expectedAcceptCharset)
}

test.case("AcceptCharsetSpaceSeparator") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Accept-Charset: ISO-8859-1, utf-8\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    let expectedAcceptCharset = [
        Request.AcceptCharset(.isoLatin1),
        Request.AcceptCharset(.utf8)
    ]
    expect(request.acceptCharset == expectedAcceptCharset)
}

test.case("Authorization") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    let expected: Request.Authorization = .basic(
        credentials: "QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
    expect(request.authorization == expected)
}

test.case("CustomHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User: guest\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.headers["User"] == "guest")
}

test.case("TwoHeaders") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: 0.0.0.0:5000\r\n" +
        "User-Agent: Mozilla/5.0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
    expect(request.userAgent == "Mozilla/5.0")
}

test.case("TwoHeadersOptionalSpaces") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host:0.0.0.0:5000\r\n" +
        "User-Agent: Mozilla/5.0 \r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
    expect(request.userAgent == "Mozilla/5.0")
}

test.case("InvalidHeaderColon") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User-Agent; Mozilla/5.0\r\n" +
        "\r\n")
    expect(throws: ParseError.invalidHeaderName) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidHeaderEnd") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User-Agent: Mozilla/5.0\n\n")
    expect(throws: ParseError.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

test.case("InvalidHeaderName") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "See-🙈-Evil: No\r\n" +
        "\r\n")
    expect(throws: ParseError.invalidHeaderName) {
        try await Request.decode(from: stream)
    }
}

test.case("HeaderName") {
    let headerName = HeaderName(extendedGraphemeClusterLiteral: "Host")
    let headerName2 = HeaderName(unicodeScalarLiteral: "Host")
    expect(headerName == headerName2)
}

test.case("UnexpectedEnd") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Header: Value\r\n")
    expect(throws: ParseError.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

test.case("ContentType") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: application/x-www-form-urlencoded\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(
        request.contentType
        ==
        ContentType(mediaType: .application(.formURLEncoded))
    )
}

test.case("ContentTypeCharset") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: text/plain; charset=utf-8\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(
        request.contentType
        ==
        ContentType(mediaType: .text(.plain), charset: .utf8)
    )
}

test.case("ContentTypeEmptyCharset") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: text/plain;\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    expect(throws: ParseError.invalidContentTypeHeader) {
        try await Request.decode(from: stream)
    }
}

test.case("ContentTypeBoundary") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: multipart/form-data; boundary=---\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(
        request.contentType
        ==
        ContentType(
            multipart: .formData,
            boundary: try Boundary("---"))
    )
}

test.case("ContentTypeEmptyBoundary") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: multipart/form-data;\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    expect(throws: ParseError.invalidBoundary) {
        try await Request.decode(from: stream)
    }
}

test.case("ContentLength") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.contentLength == 0)
}

test.case("KeepAliveFalse") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Connection: Close\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(!request.shouldKeepAlive)
}

test.case("KeepAliveTrue") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Connection: Keep-Alive\r\n" +
        "Keep-Alive: 300\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.shouldKeepAlive)
    expect(request.keepAlive == 300)
}

test.case("TransferEncodingChunked") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "0\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.transferEncoding == [.chunked])
}

test.case("Cookies") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony\r\n" +
        "Cookie: lang=aurebesh\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.cookies == [
        Cookie(name: "username", value: "tony"),
        Cookie(name: "lang", value: "aurebesh")
    ])
}

test.case("CookiesJoined") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony; lang=aurebesh\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.cookies == [
        Cookie(name: "username", value: "tony"),
        Cookie(name: "lang", value: "aurebesh")
    ])
}

test.case("CookiesNoSpace") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony;lang=aurebesh\r\n" +
        "\r\n")
    expect(throws: ParseError.invalidRequest) {
        try await Request.decode(from: stream)
    }
}

test.case("CookiesTrailingSemicolon") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony;\r\n" +
        "\r\n")
    expect(throws: ParseError.invalidRequest) {
        try await Request.decode(from: stream)
    }
}

test.case("Escaped") {
    let escapedUrl = "/%D0%BF%D1%83%D1%82%D1%8C" +
        "?%D0%BA%D0%BB%D1%8E%D1%87" +
        "=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5" +
        "#%D1%84%D1%80%D0%B0%D0%B3%D0%BC%D0%B5%D0%BD%D1%82"
    let stream = InputByteStream("GET \(escapedUrl) HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.url == "/путь?ключ=значение")
    expect(request.url.fragment == "фрагмент")
}

test.case("Expect") {
    let stream = InputByteStream(
        "PUT / HTTP/1.1\r\n" +
        "Expect: 100-continue\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.expect == .continue)
}

// MARK: Body

test.case("BodyContentLength") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 5\r\n" +
        "\r\n" +
        "Hello")
    let request = try await Request.decode(from: stream)
    expect(request.contentLength == 5)
    expect(request.string == "Hello")
}

test.case("BodyChunked") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\r\nHello\r\n" +
        "0\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.string == "Hello")
}

test.case("BodyChunkedInvalidSizeSeparator") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\rHello\r\n" +
        "0\r\n\r\n")
    expect(throws: ParseError.invalidRequest) {
        // FIXME: [Concurrency] move out
        let request = try await Request.decode(from: stream)
        _ = try await request.readBytes()
    }
}

test.case("BodyChunkedNoSizeSeparator") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5 Hello\r\n" +
        "0\r\n\r\n")
    expect(throws: ParseError.invalidRequest) {
        // FIXME: [Concurrency] move out
        let request = try await Request.decode(from: stream)
        _ = try await request.readBytes()
    }
}

test.case("BodyChunkedMissingLineEnd") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\r\nHello\r\n" +
        "0\r\n")
    expect(throws: ParseError.unexpectedEnd) {
        // FIXME: [Concurrency] move out
        let request = try await Request.decode(from: stream)
        _ = try await request.readBytes()
    }
}

test.case("BodyChunkedInvalidBody") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\r\nHello")
    expect(throws: ParseError.unexpectedEnd) {
        // FIXME: [Concurrency] move out
        let request = try await Request.decode(from: stream)
        _ = try await request.readBytes()
    }
}

test.run()
