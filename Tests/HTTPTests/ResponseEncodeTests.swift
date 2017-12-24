import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseEncodeTests: TestCase {
    class Encoder {
        static func encode(_ response: Response) -> String? {
            let stream = OutputByteStream()
            try? response.encode(to: stream)
            return String(decoding: stream.bytes, as: UTF8.self)
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
        let response = Response()
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
        let response = Response(status: .ok)
        response.connection = .close
        assertEqual(Encoder.encode(response), expected)
    }

    func testContentEncoding() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Content-Encoding: gzip, deflate\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.contentEncoding = [.gzip, .deflate]
        assertEqual(Encoder.encode(response), expected)
    }

    func testTransferEncoding() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.transferEncoding = [.chunked]
        assertEqual(Encoder.encode(response), expected)
    }

    func testCustomHeader() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "User: guest\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        response.headers["User"] = "guest"
        assertEqual(Encoder.encode(response), expected)
    }

    func testSetCookie() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "Set-Cookie: username=tony\r\n" +
            "\r\n"
        let response = Response()
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
        let response = Response()
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
        let response = Response()
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
        let response = Response()
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
        let response = Response()
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
        let response = Response()
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
        let response = Response()
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
        let response = Response()
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
