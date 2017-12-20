import Test
import Stream
@testable import HTTP

import struct Foundation.Date

extension Response {
    func encode() throws -> [UInt8] {
        let stream = OutputByteStream()
        let buffer = BufferedOutputStream(baseStream: stream)
        try self.encode(to: buffer)
        try buffer.flush()
        return stream.bytes
    }
}

class EncodeResponseTests: TestCase {
    class Encoder {
        static func encode(_ response: Response) -> String? {
            guard let bytes = try? response.encode() else {
                return nil
            }
            return String(decoding: bytes, as: UTF8.self)
        }
    }

    func testOk() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(Encoder.encode(response), expected)
    }

    func testNotFound() {
        let expected = "HTTP/1.1 404 Not Found\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .notFound)
        assertEqual(response.status, .notFound)
        assertEqual(Encoder.encode(response), expected)
    }

    func testMoved() {
        let expected = "HTTP/1.1 301 Moved Permanently\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .moved)
        assertEqual(response.status, .moved)
        assertEqual(Encoder.encode(response), expected)
    }

    func testBad() {
        let expected = "HTTP/1.1 400 Bad Request\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .badRequest)
        assertEqual(response.status, .badRequest)
        assertEqual(Encoder.encode(response), expected)
    }

    func testUnauthorized() {
        let expected = "HTTP/1.1 401 Unauthorized\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .unauthorized)
        assertEqual(response.status, .unauthorized)
        assertEqual(Encoder.encode(response), expected)
    }

    func testInternalServerError() {
        let expected = "HTTP/1.1 500 Internal Server Error\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .internalServerError)
        assertEqual(response.status, .internalServerError)
        assertEqual(Encoder.encode(response), expected)
    }

    func testContentType() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        var response = Response()
        response.contentType = ContentType(mediaType: .text(.plain))
        assertEqual(response.contentLength, 0)
        assertEqual(Encoder.encode(response), expected)
    }

    func testResponseHasContentLenght() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(Encoder.encode(response), expected)
    }

    func testConnection() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Connection: close\r\n" +
            "\r\n"
        var response = Response(status: .ok)
        response.connection = .close
        assertEqual(Encoder.encode(response), expected)
    }

    func testContentEncoding() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Content-Encoding: gzip, deflate\r\n" +
            "\r\n"
        var response = Response(status: .ok)
        response.contentEncoding = [.gzip, .deflate]
        assertEqual(Encoder.encode(response), expected)
    }

    func testTransferEncoding() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n"
        var response = Response(status: .ok)
        response.transferEncoding = [.chunked]
        assertEqual(Encoder.encode(response), expected)
    }

    func testCustomHeader() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "User: guest\r\n" +
            "\r\n"
        var response = Response(status: .ok)
        response.headers["User"] = "guest"
        assertEqual(Encoder.encode(response), expected)
    }

    func testStringResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 5\r\n" +
            "\r\n" +
            "Hello"
        let response = Response(string: "Hello")
        guard let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "Hello")
        assertEqual(rawBody, ASCII("Hello"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .text(.plain))
        )
        assertEqual(response.contentLength, ASCII("Hello").count)
        assertEqual(Encoder.encode(response), expected)
    }

    func testHtmlResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/html\r\n" +
            "Content-Length: 13\r\n" +
            "\r\n" +
            "<html></html>"
        let response = Response(html: "<html></html>")
        guard let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "<html></html>")
        assertEqual(rawBody, ASCII("<html></html>"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .text(.html))
        )
        assertEqual(response.contentLength, 13)
        assertEqual(Encoder.encode(response), expected)
    }

    func testBytesResponse() {
        let expected = ASCII("HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/stream\r\n" +
            "Content-Length: 3\r\n" +
            "\r\n") + [1,2,3]
        let data: [UInt8] = [1,2,3]
        let response = Response(bytes: data)
        guard let rawBody = response.rawBody else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(rawBody, data)
        assertEqual(
            response.contentType,
            ContentType(mediaType: .application(.stream))
        )
        assertEqual(response.contentLength, 3)
        assertEqual(try response.encode(), expected)
    }

    func testJsonResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: 27\r\n" +
            "\r\n" +
            "{\"message\":\"Hello, World!\"}"
        guard let response = try? Response(
            body: ["message" : "Hello, World!"]),
            let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "{\"message\":\"Hello, World!\"}")
        assertEqual(rawBody, ASCII("{\"message\":\"Hello, World!\"}"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .application(.json))
        )
        assertEqual(response.contentLength, 27)
        assertEqual(Encoder.encode(response), expected)
    }

    func testUrlEncodedResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/x-www-form-urlencoded\r\n" +
            "Content-Length: 23\r\n" +
            "\r\n" +
            "message=Hello,%20World!"
        guard let response = try? Response(
            body: ["message" : "Hello, World!"],
            contentType: .urlEncoded),
            let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "message=Hello,%20World!")
        assertEqual(rawBody, ASCII("message=Hello,%20World!"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .application(.urlEncoded))
        )
        assertEqual(response.contentLength, 23)
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookie() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(Cookie(name: "username", value: "tony"))
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookieExpires() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; " +
                "Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "username", value: "tony"),
                expires: Date(timeIntervalSinceReferenceDate: 467105280))
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookieMaxAge() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Max-Age=42\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "username", value: "tony"),
                maxAge: 42)
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookieHttpOnly() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; HttpOnly\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "username", value: "tony"),
                httpOnly: true)
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookieSecure() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Secure\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "username", value: "tony"),
                secure: true)
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookieDomain() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "username", value: "tony"),
                domain: "somedomain.com")
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookiePath() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Path=/\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "username", value: "tony"),
                path: "/")
        ]
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookieManyValues() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: user=tony; Secure; HttpOnly\r\n" +
            "Set-Cookie: token=1234; Max-Age=42; Secure\r\n" +
            "\r\n"
        var response = Response()
        response.setCookie = [
            Response.SetCookie(
                Cookie(name: "user", value: "tony"),
                secure: true,
                httpOnly: true),
            Response.SetCookie(
                Cookie(name: "token", value: "1234"),
                maxAge: 42,
                secure: true)
        ]
        assertEqual(Encoder.encode(response), expected)
    }
}
