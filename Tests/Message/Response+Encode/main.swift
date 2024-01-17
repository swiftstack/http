import Test
import Stream

@testable import HTTP
import struct Foundation.Date

extension Response {
    func encode() async throws -> String {
        let stream = OutputByteStream()
        try await encode(to: stream)
        return String(decoding: stream.bytes, as: UTF8.self)
    }
}

test("Ok") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .ok)
    expect(response.status == .ok)
    expect(try await response.encode() == expected)
}

test("NotFound") {
    let expected =
        "HTTP/1.1 404 Not Found\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .notFound)
    expect(response.status == .notFound)
    expect(try await response.encode() == expected)
}

test("Moved") {
    let expected =
        "HTTP/1.1 301 Moved Permanently\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .moved)
    expect(response.status == .moved)
    expect(try await response.encode() == expected)
}

test("Bad") {
    let expected =
        "HTTP/1.1 400 Bad Request\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .badRequest)
    expect(response.status == .badRequest)
    expect(try await response.encode() == expected)
}

test("Unauthorized") {
    let expected =
        "HTTP/1.1 401 Unauthorized\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .unauthorized)
    expect(response.status == .unauthorized)
    expect(try await response.encode() == expected)
}

test("InternalServerError") {
    let expected =
        "HTTP/1.1 500 Internal Server Error\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .internalServerError)
    expect(response.status == .internalServerError)
    expect(try await response.encode() == expected)
}

test("ContentType") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response()
    response.contentType = ContentType(mediaType: .text(.plain))
    expect(response.contentLength == 0)
    expect(try await response.encode() == expected)
}

test("ResponseHasContentLenght") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let response = Response(status: .ok)
    expect(response.status == .ok)
    expect(try await response.encode() == expected)
}

test("Connection") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Connection: close\r\n" +
        "\r\n"
    let response = Response(status: .ok)
    response.connection = .close
    expect(try await response.encode() == expected)
}

test("ContentEncoding") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Content-Encoding: gzip, deflate\r\n" +
        "\r\n"
    let response = Response(status: .ok)
    response.contentEncoding = [.gzip, .deflate]
    expect(try await response.encode() == expected)
}

test("TransferEncoding") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n"
    let response = Response(status: .ok)
    response.transferEncoding = [.chunked]
    expect(try await response.encode() == expected)
}

test("CustomHeader") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "User: guest\r\n" +
        "\r\n"
    let response = Response(status: .ok)
    response.headers["User"] = "guest"
    expect(try await response.encode() == expected)
}

test("SetCookie") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "username", value: "tony")
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieExpires") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; " +
            "Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(
            name: "username",
            value: "tony",
            expires: Date(timeIntervalSinceReferenceDate: 467105280))
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieMaxAge") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Max-Age=42\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "username", value: "tony", maxAge: 42)
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieHttpOnly") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; HttpOnly\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "username", value: "tony", httpOnly: true)
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieSecure") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Secure\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "username", value: "tony", secure: true)
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieDomain") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "username", value: "tony", domain: "somedomain.com")
    ]
    expect(try await response.encode() == expected)
}

test("SetCookiePath") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Path=/\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "username", value: "tony", path: "/")
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieManyValues") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: user=tony; Secure; HttpOnly\r\n" +
        "Set-Cookie: token=1234; Max-Age=42; Secure\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        SetCookie(name: "user", value: "tony", secure: true, httpOnly: true),
        SetCookie(name: "token", value: "1234", maxAge: 42, secure: true)
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieEqualSingInTheValue") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: key=value=\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        .init(name: "key", value: "value=")
    ]
    expect(try await response.encode() == expected)
}

test("SetCookieSameSite") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: n=v; SameSite=Lax\r\n" +
        "\r\n"
    let response = Response()
    response.cookies = [
        .init(name: "n", value: "v", sameSite: "Lax")
    ]
    expect(try await response.encode() == expected)
}

// MARK: Body

test("BodyStringResponse") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: 5\r\n" +
        "\r\n" +
        "Hello"
    let response = Response(string: "Hello")
    expect(
        response.contentType
        ==
        ContentType(mediaType: .text(.plain))
    )
    expect(response.contentLength == ASCII("Hello").count)
    expect(try await response.encode() == expected)
}

test("BodyHtmlResponse") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/html\r\n" +
        "Content-Length: 13\r\n" +
        "\r\n" +
        "<html></html>"
    let response = Response(html: "<html></html>")
    expect(response.contentType == .html)
    expect(response.contentLength == 13)
    expect(try await response.encode() == expected)
}

test("BodyBytesResponse") {
    let expected = ASCII(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: application/stream\r\n" +
        "Content-Length: 3\r\n" +
        "\r\n") + [1,2,3]
    let data: [UInt8] = [1,2,3]
    let response = Response(bytes: data)
    expect(response.contentType == .stream)
    expect(response.contentLength == 3)
    expect(ASCII(try await response.encode()) == expected)
}

test("BodyJsonResponse") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: application/json\r\n" +
        "Content-Length: 27\r\n" +
        "\r\n" +
        "{\"message\":\"Hello, World!\"}"

    let response = try Response.init(
        body: ["message" : "Hello, World!"])

    expect(response.contentType == .json)
    expect(response.contentLength == 27)
    expect(try await response.encode() == expected)
}

test("BodyUrlFormEncodedResponse") {
    let expected =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: application/x-www-form-urlencoded\r\n" +
        "Content-Length: 23\r\n" +
        "\r\n" +
        "message=Hello,%20World!"

    let response = try Response(
        body: ["message" : "Hello, World!"],
        contentType: .formURLEncoded)

    expect(response.contentType == .formURLEncoded)
    expect(response.contentLength == 23)
    expect(try await response.encode() == expected)
}

await run()
