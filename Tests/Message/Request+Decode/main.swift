import URL
import Test
import Stream

@testable import HTTP

// MARK: Start line

test("Get") {
    let stream = InputByteStream("GET /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.get)
}

test("Head") {
    let stream = InputByteStream("HEAD /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.head)
}

test("Post") {
    let stream = InputByteStream("POST /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.post)
}

test("Put") {
    let stream = InputByteStream("PUT /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.put)
}

test("Delete") {
    let stream = InputByteStream("DELETE /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.method == Request.Method.delete)
}

test("Version") {
    let stream = InputByteStream("GET /test HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.version == Version.oneOne)
}

test("Url") {
    let stream = InputByteStream(
        "GET /test?k1=v1&k2=v2#fragment HTTP/1.1\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.url.path == "/test")
    expect(request.url.query?.values == ["k1":"v1", "k2":"v2"])
    expect(request.url.fragment == "fragment")
}

test("InvalidRequest") {
    let stream = InputByteStream("GET\r\n\r\n")
    await expect(throws: Error.invalidStartLine) {
        try await Request.decode(from: stream)
    }
}

test("InvalidRequest2") {
    let stream = InputByteStream("GET \r\n\r\n")
    await expect(throws: Error.invalidStartLine) {
        try await Request.decode(from: stream)
    }
}

test("InvalidMethod") {
    let stream = InputByteStream("BAD /test HTTP/1.1\r\n\r\n")
    await expect(throws: Error.invalidMethod) {
        try await Request.decode(from: stream)
    }
}

test("InvalidVersion") {
    let stream = InputByteStream("GET /test HTTP/0.1\r\n\r\n")
    await expect(throws: Error.invalidVersion) {
        try await Request.decode(from: stream)
    }
}

test("InvalidVersion2") {
    let stream = InputByteStream("GET /test HTTP/1.1WUT\r\n\r\n")
    await expect(throws: Error.invalidRequest) {
        try await Request.decode(from: stream)
    }
}

test("InvalidVersion3") {
    let stream = InputByteStream("GET /test HTTP/1.")
    await expect(throws: Error.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

test("InvalidVersion4") {
    let stream = InputByteStream("GET /test HTPP/1.1\r\n\r\n")
    await expect(throws: Error.invalidVersion) {
        try await Request.decode(from: stream)
    }
}

test("InvalidEnd") {
    let stream = InputByteStream("GET /test HTTP/1.1\r\n")
    await expect(throws: Error.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

// MARK: Headers

test("HostHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: 0.0.0.0:5000\r\n" +
        "\r\n")
    let expected = URL.Host(address: "0.0.0.0", port: 5000)
    let request = try await Request.decode(from: stream)
    expect(request.host == expected)
}

test("HostDomainHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: domain.com:5000\r\n" +
        "\r\n")
    let expected = URL.Host(address: "domain.com", port: 5000)
    let request = try await Request.decode(from: stream)
    expect(request.host == expected)
}

test("HostEncodedHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: xn--d1acufc.xn--p1ai:5000\r\n" +
        "\r\n")
    let expected = URL.Host(address: "домен.рф", port: 5000)
    let request = try await Request.decode(from: stream)
    expect(request.host == expected)
}

test("UserAgentHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User-Agent: Mozilla/5.0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.userAgent == "Mozilla/5.0")
}

test("AcceptHeader") {
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

test("AcceptLanguageHeader") {
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

test("AcceptEncodingHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Accept-Encoding: gzip, deflate\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.acceptEncoding == [.gzip, .deflate])
}

test("AcceptCharset") {
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

test("AcceptCharsetSpaceSeparator") {
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

test("Authorization") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    let expected: Request.Authorization = .basic(
        credentials: "QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
    expect(request.authorization == expected)
}

test("CustomHeader") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User: guest\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.headers["User"] == "guest")
}

test("TwoHeaders") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host: 0.0.0.0:5000\r\n" +
        "User-Agent: Mozilla/5.0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
    expect(request.userAgent == "Mozilla/5.0")
}

test("TwoHeadersOptionalSpaces") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Host:0.0.0.0:5000\r\n" +
        "User-Agent: Mozilla/5.0 \r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
    expect(request.userAgent == "Mozilla/5.0")
}

test("InvalidHeaderColon") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User-Agent; Mozilla/5.0\r\n" +
        "\r\n")
    await expect(throws: Error.invalidHeaderName) {
        try await Request.decode(from: stream)
    }
}

test("InvalidHeaderEnd") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "User-Agent: Mozilla/5.0\n\n")
    await expect(throws: Error.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

test("InvalidHeaderName") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "See-🙈-Evil: No\r\n" +
        "\r\n")
    await expect(throws: Error.invalidHeaderName) {
        try await Request.decode(from: stream)
    }
}

test("HeaderName") {
    let headerName = HeaderName(extendedGraphemeClusterLiteral: "Host")
    let headerName2 = HeaderName(unicodeScalarLiteral: "Host")
    expect(headerName == headerName2)
}

test("UnexpectedEnd") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Header: Value\r\n")
    await expect(throws: Error.unexpectedEnd) {
        try await Request.decode(from: stream)
    }
}

test("ContentType") {
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

test("ContentTypeCharset") {
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

test("ContentTypeEmptyCharset") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: text/plain;\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    await expect(throws: Error.invalidContentTypeHeader) {
        try await Request.decode(from: stream)
    }
}

test("ContentTypeBoundary") {
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

test("ContentTypeEmptyBoundary") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Type: multipart/form-data;\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    await expect(throws: Error.invalidBoundary) {
        try await Request.decode(from: stream)
    }
}

test("ContentLength") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.contentLength == 0)
}

test("ContentEncoding") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 0\r\n" +
        "Content-Encoding: gzip\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.contentEncoding == [.gzip])
}

test("KeepAliveFalse") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Connection: Close\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(!request.shouldKeepAlive)
}

test("KeepAliveTrue") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Connection: Keep-Alive\r\n" +
        "Keep-Alive: 300\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.shouldKeepAlive)
    expect(request.keepAlive == 300)
}

test("TransferEncodingChunked") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "0\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.transferEncoding == [.chunked])
}

test("Cookies") {
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

test("CookiesJoined") {
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

test("CookiesNoSpace") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony;lang=aurebesh\r\n" +
        "\r\n")
    await expect(throws: Error.invalidRequest) {
        try await Request.decode(from: stream)
    }
}

test("CookiesTrailingSemicolon") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony;\r\n" +
        "\r\n")
    await expect(throws: Error.invalidRequest) {
        try await Request.decode(from: stream)
    }
}

test("Escaped") {
    let escapedUrl = "/%D0%BF%D1%83%D1%82%D1%8C" +
        "?%D0%BA%D0%BB%D1%8E%D1%87" +
        "=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5" +
        "#%D1%84%D1%80%D0%B0%D0%B3%D0%BC%D0%B5%D0%BD%D1%82"
    let stream = InputByteStream("GET \(escapedUrl) HTTP/1.1\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.url == "/путь?ключ=значение")
    expect(request.url.fragment == "фрагмент")
}

test("Expect") {
    let stream = InputByteStream(
        "PUT / HTTP/1.1\r\n" +
        "Expect: 100-continue\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.expect == .continue)
}

// MARK: Body

test("BodyContentLength") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 5\r\n" +
        "\r\n" +
        "Hello")
    let request = try await Request.decode(from: stream)
    expect(request.contentLength == 5)
    expect(try await request.readBody() == ASCII("Hello"))
}

test("BodyChunked") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\r\nHello\r\n" +
        "0\r\n\r\n")
    let request = try await Request.decode(from: stream)
    expect(try await request.readBody() == ASCII("Hello"))
}

test("BodyChunkedInvalidSizeSeparator") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\rHello\r\n" +
        "0\r\n\r\n")
    let request = try await Request.decode(from: stream)
    await expect(throws: Error.invalidRequest) {
        _ = try await request.readBody()
    }
}

test("BodyChunkedNoSizeSeparator") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5 Hello\r\n" +
        "0\r\n\r\n")
    let request = try await Request.decode(from: stream)
    await expect(throws: Error.invalidRequest) {
        _ = try await request.readBody()
    }
}

test("BodyChunkedMissingLineEnd") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\r\nHello\r\n" +
        "0\r\n")
    let request = try await Request.decode(from: stream)
    await expect(throws: Error.unexpectedEnd) {
        _ = try await request.readBody()
    }
}

test("BodyChunkedInvalidBody") {
    let stream = InputByteStream(
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "5\r\nHello")
    let request = try await Request.decode(from: stream)
    await expect(throws: Error.unexpectedEnd) {
        _ = try await request.readBody()
    }
}

await run()
