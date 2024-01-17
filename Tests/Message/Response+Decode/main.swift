import Test
import Stream

@testable import HTTP
import struct Foundation.Date

test("Ok") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.status == .ok)
}

test("NotFound") {
    let stream = InputByteStream(
        "HTTP/1.1 404 Not Found\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.status == .notFound)
}

test("Moved") {
    let stream = InputByteStream(
        "HTTP/1.1 301 Moved Permanently\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.status == .moved)
}

test("Bad") {
    let stream = InputByteStream(
        "HTTP/1.1 400 Bad Request\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.status == .badRequest)
}

test("Unauthorized") {
    let stream = InputByteStream(
        "HTTP/1.1 401 Unauthorized\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.status == .unauthorized)
}

test("InternalServerError") {
    let stream = InputByteStream(
        "HTTP/1.1 500 Internal Server Error\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.status == .internalServerError)
}

test("ContentLength") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.contentLength == 0)
}

test("ContentType") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.contentType == .text)
}

test("Connection") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Connection: close\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.connection == .close)
}

test("ContentEncoding") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Content-Encoding: gzip, deflate\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.contentEncoding == [.gzip, .deflate])
}

test("TransferEncoding") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Transfer-Encoding: gzip, chunked\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.transferEncoding == [.gzip, .chunked])
}

test("CustomHeader") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "User: guest\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.headers["User"] == "guest")
}

test("SetCookie") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(name: "username", value: "tony")
    ])
}

test("SetCookieExpires") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(
            name: "username",
            value: "tony",
            expires: Date(timeIntervalSinceReferenceDate: 467105280))
        ])
}

test("SetCookieMaxAge") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Max-Age=42\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(name: "username", value: "tony", maxAge: 42)
    ])
}

test("SetCookieHttpOnly") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; HttpOnly\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(name: "username", value: "tony", httpOnly: true)
    ])
}

test("SetCookieSecure") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Secure\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(name: "username", value: "tony", secure: true)
    ])
}

test("SetCookieDomain") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(
            name: "username",
            value: "tony",
            domain: "somedomain.com")
    ])
}

test("SetCookiePath") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "Set-Cookie: username=tony; Path=/\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [
        SetCookie(name: "username", value: "tony", path: "/")
    ])
}

test("SetCookieManyValues") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Set-Cookie: num=0; Path=/; Max-Age=42; Secure; HttpOnly\r\n" +
        "Set-Cookie: key=value; Secure; HttpOnly\r\n" +
        "Set-Cookie: date=; Expires=Thu, 06-Sep-18 12:41:14 GMT\r\n" +
        "Set-Cookie: date=; Expires=Thu, 06 Sep 2018 12:41:14 GMT\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)

    expect(
        response.cookies[0]
        ==
        SetCookie(
            name: "num",
            value: "0",
            path: "/",
            maxAge: 42,
            secure: true,
            httpOnly: true))

    expect(
        response.cookies[1]
        ==
        SetCookie(
            name: "key",
            value: "value",
            secure: true,
            httpOnly: true))

    expect(
        response.cookies[2]
        ==
        SetCookie(
            name: "date",
            value: "",
            expires: Date(timeIntervalSince1970: 1536237674.0)))

    expect(
        response.cookies[3]
        ==
        SetCookie(
            name: "date",
            value: "",
            expires: Date(timeIntervalSince1970: 1536237674.0)))
}

test("SetCookieEqualSingInTheValue") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Set-Cookie: key=value=\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [.init(name: "key", value: "value=")])
}

test("SetCookieSameSite") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Set-Cookie: n=v; SameSite=Lax\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.cookies == [.init(name: "n", value: "v", sameSite: "Lax")])
}

// MARK: Body

test("BodyStringResponse") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: 5\r\n" +
        "\r\n" +
        "Hello")
    let response = try await Response.decode(from: stream)
    expect(
        response.contentType
        ==
        ContentType(mediaType: .text(.plain)))
    expect(response.contentLength == 5)
    expect(try await response.readBody() == ASCII("Hello"))
}

test("BodyHtmlResponse") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/html\r\n" +
        "Content-Length: 13\r\n" +
        "\r\n" +
        "<html></html>")
    let response = try await Response.decode(from: stream)
    expect(
        response.contentType
        ==
        ContentType(mediaType: .text(.html))
    )
    expect(response.contentLength == 13)
    expect(try await response.readBody() == ASCII("<html></html>"))
}

test("BodyBytesResponse") {
    let bytes = ASCII(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: application/stream\r\n" +
        "Content-Length: 3\r\n" +
        "\r\n") + [1,2,3]
    let stream = InputByteStream(bytes)
    let response = try await Response.decode(from: stream)
    expect(
        response.contentType
        ==
        ContentType(mediaType: .application(.stream))
    )
    expect(response.contentLength == 3)
    expect(try await response.readBody() == [1,2,3])
}

test("BodyJsonResponse") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Type: application/json\r\n" +
        "Content-Length: 28\r\n" +
        "\r\n" +
        "{'message': 'Hello, World!'}")
    let response = try await Response.decode(from: stream)
    expect(
        response.contentType
        ==
        ContentType(mediaType: .application(.json))
    )
    expect(response.contentLength == 28)
    expect(try await response.readBody() == ASCII("{'message': 'Hello, World!'}"))
}

test("BodyZeroContentLenght") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(response.contentLength == 0)
    expect(try await response.readBody() == [])
}

test("BodyChunked") {
    let stream = InputByteStream(
        "HTTP/1.1 200 OK\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "d\r\n" +
        "Hello, World!\r\n" +
        "0\r\n" +
        "\r\n")
    let response = try await Response.decode(from: stream)
    expect(try await response.readBody() == ASCII("Hello, World!"))
}

await run()
