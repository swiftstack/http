import URL
import Test
import Stream

@testable import HTTP

extension Request {
    func encode() async throws -> String {
        let stream = OutputByteStream()
        try await encode(to: stream)
        return String(decoding: stream.bytes, as: UTF8.self)
    }
}

test("Request") {
    let expected = "GET /test HTTP/1.1\r\n\r\n"
    let request = Request(url: "/test", method: .get)
    expect(try await request.encode() == expected)
}

test("Url") {
    let expected = "GET /test HTTP/1.1\r\n\r\n"
    let request = Request(
        url: URL(path: "/test", fragment: "fragment"),
        method: .get)
    expect(try await request.encode() == expected)
}

test("UrlQueryGet") {
    let expected = "GET /test?key=value HTTP/1.1\r\n\r\n"
    let request = Request(
        url: URL(
            path: "/test",
            query: ["key" : "value"],
            fragment: "fragment"),
        method: .get)
    expect(try await request.encode() == expected)
}

test("UrlQueryPost") {
    let expected =
        "POST /test HTTP/1.1\r\n" +
        "Content-Type: application/x-www-form-urlencoded\r\n" +
        "Content-Length: 9\r\n" +
        "\r\n" +
        "key=value"
    let request = Request(
        url: URL(
            path: "/test",
            query: ["key" : "value"],
            fragment: "fragment"),
        method: .post)
    expect(try await request.encode() == expected)
}

test("Host") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Host: 0.0.0.0:5000\r\n" +
        "\r\n"
    let request = Request()
    request.host = URL.Host(address: "0.0.0.0", port: 5000)
    expect(try await request.encode() == expected)
}

test("HostDomain") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Host: domain.com:5000\r\n" +
        "\r\n"
    let request = Request(url: "http://domain.com:5000")
    expect(try await request.encode() == expected)
}

test("HostEncoded") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Host: xn--d1acufc.xn--p1ai:5000\r\n" +
        "\r\n"
    let request = Request()
    request.host = URL.Host(address: "домен.рф", port: 5000)
    expect(try await request.encode() == expected)
}

test("UserAgent") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "User-Agent: Mozilla/5.0\r\n" +
        "\r\n"
    let request = Request()
    request.userAgent = "Mozilla/5.0"
    expect(try await request.encode() == expected)
}

test("Accept") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Accept: */*\r\n" +
        "\r\n"
    let request = Request()
    request.accept = [
        Request.Accept(.any, priority: 1.0)
    ]
    expect(try await request.encode() == expected)
}

test("AcceptLanguage") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Accept-Language: en-US,en;q=0.5\r\n" +
        "\r\n"
    let request = Request()
    request.acceptLanguage = [
        Request.AcceptLanguage(.enUS, priority: 1.0),
        Request.AcceptLanguage(.en, priority: 0.5)
    ]
    expect(try await request.encode() == expected)
}

test("AcceptEncoding") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Accept-Encoding: gzip, deflate\r\n" +
        "\r\n"
    let request = Request()
    request.acceptEncoding = [.gzip, .deflate]
    expect(try await request.encode() == expected)
}

test("AcceptCharset") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Accept-Charset: ISO-8859-1,utf-7,utf-8;q=0.7,*;q=0.7\r\n" +
        "\r\n"
    let request = Request()
    request.acceptCharset = [
        Request.AcceptCharset(.isoLatin1),
        Request.AcceptCharset(.custom("utf-7")),
        Request.AcceptCharset(.utf8, priority: 0.7),
        Request.AcceptCharset(.any, priority: 0.7)
    ]
    expect(try await request.encode() == expected)
}

test("Authorization") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\r\n" +
        "\r\n"

    let request = Request()
    request.authorization = .basic(
        credentials: "QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
    expect(try await request.encode() == expected)
}

test("KeepAlive") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Keep-Alive: 300\r\n" +
        "\r\n"
    let request = Request()
    request.keepAlive = 300
    expect(try await request.encode() == expected)
}

test("Connection") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Connection: close\r\n" +
        "\r\n"
    let request = Request()
    request.connection = .close
    expect(try await request.encode() == expected)
}

test("ContentType") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Content-Type: text/plain\r\n" +
        "\r\n"
    let request = Request()
    request.contentType = ContentType(mediaType: .text(.plain))
    expect(try await request.encode() == expected)
}

test("ContentLength") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let request = Request()
    request.contentLength = 0
    expect(try await request.encode() == expected)
}

test("ContentEncoding") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Content-Length: 0\r\n" +
        "Content-Encoding: gzip\r\n" +
        "\r\n"
    let request = Request()
    request.contentLength = 0
    request.contentEncoding = [.gzip]
    expect(try await request.encode() == expected)
}

test("TransferEncoding") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n"
    let request = Request()
    request.transferEncoding = [.chunked]
    expect(try await request.encode() == expected)
}

test("CustomHeaders") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "User: guest\r\n" +
        "\r\n"
    let request = Request()
    request.headers["User"] = "guest"
    expect(try await request.encode() == expected)
}

test("Cookie") {
    let expected =
        "GET / HTTP/1.1\r\n" +
        "Cookie: username=tony\r\n" +
        "Cookie: lang=aurebesh\r\n" +
        "\r\n"
    let request = Request()
    request.cookies = [
        Cookie(name: "username", value: "tony"),
        Cookie(name: "lang", value: "aurebesh")
    ]
    expect(try await request.encode() == expected)
}

test("Escaped") {
    let escapedUrl =
        "/%D0%BF%D1%83%D1%82%D1%8C" +
        "?%D0%BA%D0%BB%D1%8E%D1%87" +
        "=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5"
    let expected = "GET \(escapedUrl) HTTP/1.1\r\n\r\n"
    let request = Request(url: "/путь?ключ=значение#фрагмент")
    expect(try await request.encode() == expected)
}

// MARK: Body

test("BodyJsonInitializer") {
    let expected =
        "POST / HTTP/1.1\r\n" +
        "Content-Type: application/json\r\n" +
        "Content-Length: 27\r\n" +
        "\r\n" +
        "{\"message\":\"Hello, World!\"}"
    let values = ["message": "Hello, World!"]
    let request = try Request(
        url: "/",
        method: .post,
        body: values)
    expect(try await request.encode() == expected)
}

test("BodyFormURLEncodedInitializer") {
    let expected =
        "POST / HTTP/1.1\r\n" +
        "Content-Type: application/x-www-form-urlencoded\r\n" +
        "Content-Length: 23\r\n" +
        "\r\n" +
        "message=Hello,%20World!"
    struct Query: Encodable {
        let message = "Hello, World!"
    }
    let request = try Request(
        url: "/",
        method: .post,
        body: Query(),
        contentType: .formURLEncoded)
    expect(try await request.encode() == expected)
}

await run()
