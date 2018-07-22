import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseEncodeTests: TestCase {
    func testOk() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(try response.encode(), expected)
    }

    func testNotFound() {
        let expected =
            "HTTP/1.1 404 Not Found\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .notFound)
        assertEqual(response.status, .notFound)
        assertEqual(try response.encode(), expected)
    }

    func testMoved() {
        let expected =
            "HTTP/1.1 301 Moved Permanently\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .moved)
        assertEqual(response.status, .moved)
        assertEqual(try response.encode(), expected)
    }

    func testBad() {
        let expected =
            "HTTP/1.1 400 Bad Request\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .badRequest)
        assertEqual(response.status, .badRequest)
        assertEqual(try response.encode(), expected)
    }

    func testUnauthorized() {
        let expected =
            "HTTP/1.1 401 Unauthorized\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .unauthorized)
        assertEqual(response.status, .unauthorized)
        assertEqual(try response.encode(), expected)
    }

    func testInternalServerError() {
        let expected =
            "HTTP/1.1 500 Internal Server Error\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .internalServerError)
        assertEqual(response.status, .internalServerError)
        assertEqual(try response.encode(), expected)
    }

    func testContentType() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response()
        response.contentType = ContentType(mediaType: .text(.plain))
        assertEqual(response.contentLength, 0)
        assertEqual(try response.encode(), expected)
    }

    func testResponseHasContentLenght() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(try response.encode(), expected)
    }

    func testConnection() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Connection: close\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.connection = .close
        assertEqual(try response.encode(), expected)
    }

    func testContentEncoding() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Content-Encoding: gzip, deflate\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.contentEncoding = [.gzip, .deflate]
        assertEqual(try response.encode(), expected)
    }

    func testTransferEncoding() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.transferEncoding = [.chunked]
        assertEqual(try response.encode(), expected)
    }

    func testCustomHeader() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "User: guest\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.headers["User"] = "guest"
        assertEqual(try response.encode(), expected)
    }

    func testSetCookie() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "username", value: "tony")
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookieExpires() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; " +
                "Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(
                name: "username",
                value: "tony",
                expires: Date(timeIntervalSinceReferenceDate: 467105280))
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookieMaxAge() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Max-Age=42\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "username", value: "tony", maxAge: 42)
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookieHttpOnly() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; HttpOnly\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "username", value: "tony", httpOnly: true)
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookieSecure() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Secure\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "username", value: "tony", secure: true)
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookieDomain() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "username", value: "tony", domain: "somedomain.com")
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookiePath() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony; Path=/\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "username", value: "tony", path: "/")
        ]
        assertEqual(try response.encode(), expected)
    }

    func testSetCookieManyValues() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: user=tony; Secure; HttpOnly\r\n" +
            "Set-Cookie: token=1234; Max-Age=42; Secure\r\n" +
            "\r\n"
        let response = Response()
        response.cookies = [
            Cookie(name: "user", value: "tony", secure: true, httpOnly: true),
            Cookie(name: "token", value: "1234", maxAge: 42, secure: true)
        ]
        assertEqual(try response.encode(), expected)
    }

    // MARK: Body

    func testBodyStringResponse() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 5\r\n" +
            "\r\n" +
            "Hello"
        let response = Response(string: "Hello")
        assertEqual(response.string, "Hello")
        assertEqual(response.bytes, ASCII("Hello"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .text(.plain))
        )
        assertEqual(response.contentLength, ASCII("Hello").count)
        assertEqual(try response.encode(), expected)
    }

    func testBodyHtmlResponse() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/html\r\n" +
            "Content-Length: 13\r\n" +
            "\r\n" +
            "<html></html>"
        let response = Response(html: "<html></html>")
        assertEqual(response.string, "<html></html>")
        assertEqual(response.bytes, ASCII("<html></html>"))
        assertEqual(response.contentType, .html)
        assertEqual(response.contentLength, 13)
        assertEqual(try response.encode(), expected)
    }

    func testBodyBytesResponse() {
        let expected = ASCII(
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/stream\r\n" +
            "Content-Length: 3\r\n" +
            "\r\n") + [1,2,3]
        let data: [UInt8] = [1,2,3]
        let response = Response(bytes: data)
        assertEqual(response.bytes, data)
        assertEqual(response.contentType, .stream)
        assertEqual(response.contentLength, 3)
        assertEqual(ASCII(try response.encode()), expected)
    }

    func testBodyJsonResponse() {
        scope {
            let expected =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 27\r\n" +
                "\r\n" +
                "{\"message\":\"Hello, World!\"}"

            let response = try Response(body: ["message" : "Hello, World!"])

            let body = "{\"message\":\"Hello, World!\"}"
            assertEqual(response.string, body)
            assertEqual(response.bytes, ASCII(body))
            assertEqual(response.contentType, .json)
            assertEqual(response.contentLength, 27)
            assertEqual(try response.encode(), expected)
        }
    }

    func testBodyUrlFormEncodedResponse() {
        scope {
            let expected =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/x-www-form-urlencoded\r\n" +
                "Content-Length: 23\r\n" +
                "\r\n" +
                "message=Hello,%20World!"

            let response = try Response(
                body: ["message" : "Hello, World!"],
                contentType: .formURLEncoded)

            assertEqual(response.string, "message=Hello,%20World!")
            assertEqual(response.bytes, ASCII("message=Hello,%20World!"))
            assertEqual(response.contentType, .formURLEncoded)
            assertEqual(response.contentLength, 23)
            assertEqual(try response.encode(), expected)
        }
    }
}
