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
        expect(response.status == .ok)
        expect(try response.encode() == expected)
    }

    func testNotFound() {
        let expected =
            "HTTP/1.1 404 Not Found\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .notFound)
        expect(response.status == .notFound)
        expect(try response.encode() == expected)
    }

    func testMoved() {
        let expected =
            "HTTP/1.1 301 Moved Permanently\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .moved)
        expect(response.status == .moved)
        expect(try response.encode() == expected)
    }

    func testBad() {
        let expected =
            "HTTP/1.1 400 Bad Request\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .badRequest)
        expect(response.status == .badRequest)
        expect(try response.encode() == expected)
    }

    func testUnauthorized() {
        let expected =
            "HTTP/1.1 401 Unauthorized\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .unauthorized)
        expect(response.status == .unauthorized)
        expect(try response.encode() == expected)
    }

    func testInternalServerError() {
        let expected =
            "HTTP/1.1 500 Internal Server Error\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .internalServerError)
        expect(response.status == .internalServerError)
        expect(try response.encode() == expected)
    }

    func testContentType() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response()
        response.contentType = ContentType(mediaType: .text(.plain))
        expect(response.contentLength == 0)
        expect(try response.encode() == expected)
    }

    func testResponseHasContentLenght() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        expect(response.status == .ok)
        expect(try response.encode() == expected)
    }

    func testConnection() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Connection: close\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.connection = .close
        expect(try response.encode() == expected)
    }

    func testContentEncoding() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Content-Encoding: gzip, deflate\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.contentEncoding = [.gzip, .deflate]
        expect(try response.encode() == expected)
    }

    func testTransferEncoding() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.transferEncoding = [.chunked]
        expect(try response.encode() == expected)
    }

    func testCustomHeader() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "User: guest\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.headers["User"] = "guest"
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(try response.encode() == expected)
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
        expect(response.string == "Hello")
        expect(response.bytes == ASCII("Hello"))
        expect(
            response.contentType
            ==
            ContentType(mediaType: .text(.plain))
        )
        expect(response.contentLength == ASCII("Hello").count)
        expect(try response.encode() == expected)
    }

    func testBodyHtmlResponse() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/html\r\n" +
            "Content-Length: 13\r\n" +
            "\r\n" +
            "<html></html>"
        let response = Response(html: "<html></html>")
        expect(response.string == "<html></html>")
        expect(response.bytes == ASCII("<html></html>"))
        expect(response.contentType == .html)
        expect(response.contentLength == 13)
        expect(try response.encode() == expected)
    }

    func testBodyBytesResponse() {
        let expected = ASCII(
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/stream\r\n" +
            "Content-Length: 3\r\n" +
            "\r\n") + [1,2,3]
        let data: [UInt8] = [1,2,3]
        let response = Response(bytes: data)
        expect(response.bytes == data)
        expect(response.contentType == .stream)
        expect(response.contentLength == 3)
        expect(ASCII(try response.encode()) == expected)
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
            expect(response.string == body)
            expect(response.bytes == ASCII(body))
            expect(response.contentType == .json)
            expect(response.contentLength == 27)
            expect(try response.encode() == expected)
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

            expect(response.string == "message=Hello,%20World!")
            expect(response.bytes == ASCII("message=Hello,%20World!"))
            expect(response.contentType == .formURLEncoded)
            expect(response.contentLength == 23)
            expect(try response.encode() == expected)
        }
    }
}
