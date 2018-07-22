import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseDecodeTests: TestCase {
    func testOk() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .ok)
        }
    }

    func testNotFound() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 404 Not Found\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .notFound)
        }
    }

    func testMoved() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 301 Moved Permanently\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .moved)
        }
    }

    func testBad() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 400 Bad Request\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .badRequest)
        }
    }

    func testUnauthorized() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 401 Unauthorized\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .unauthorized)
        }
    }

    func testInternalServerError() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 500 Internal Server Error\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .internalServerError)
        }
    }


    func testContentLength() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentLength, 0)
        }
    }

    func testContentType() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentType, .text)
        }
    }

    func testConnection() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Connection: close\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.connection, .close)
        }
    }

    func testContentEncoding() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Content-Encoding: gzip, deflate\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentEncoding, [.gzip, .deflate])
        }
    }

    func testTransferEncoding() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Transfer-Encoding: gzip, chunked\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.transferEncoding, [.gzip, .chunked])
        }
    }

    func testCustomHeader() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "User: guest\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.headers["User"], "guest")
        }
    }

    func testSetCookie() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(name: "username", value: "tony")
            ])
        }
    }

    func testSetCookieExpires() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; " +
                    "Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(
                    name: "username",
                    value: "tony",
                    expires: Date(timeIntervalSinceReferenceDate: 467105280))
                ])
        }
    }

    func testSetCookieMaxAge() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Max-Age=42\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(name: "username", value: "tony", maxAge: 42)
            ])
        }
    }

    func testSetCookieHttpOnly() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; HttpOnly\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(name: "username", value: "tony", httpOnly: true)
            ])
        }
    }

    func testSetCookieSecure() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Secure\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(name: "username", value: "tony", secure: true)
            ])
        }
    }

    func testSetCookieDomain() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(
                    name: "username",
                    value: "tony",
                    domain: "somedomain.com")
            ])
        }
    }

    func testSetCookiePath() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Path=/\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.cookies, [
                Cookie(name: "username", value: "tony", path: "/")
            ])
        }
    }

    func testSetCookieManyValues() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Set-Cookie: num=0; Path=/; Max-Age=42; Secure; HttpOnly\r\n" +
                "Set-Cookie: key=value; Secure; HttpOnly\r\n" +
                "Set-Cookie: date=; Expires=Thu, 06-Sep-18 12:41:14 GMT\r\n" +
                "Set-Cookie: date=; Expires=Thu, 06 Sep 2018 12:41:14 GMT\r\n" +
                "\r\n")
            let response = try Response(from: stream)

            assertEqual(response.cookies[0],
                        Cookie(
                            name: "num",
                            value: "0",
                            path: "/",
                            maxAge: 42,
                            secure: true,
                            httpOnly: true))

            assertEqual(response.cookies[1],
                        Cookie(
                            name: "key",
                            value: "value",
                            secure: true,
                            httpOnly: true))

            assertEqual(response.cookies[2],
                        Cookie(
                            name: "date",
                            value: "",
                            expires: Date(timeIntervalSince1970: 1536237674.0)))

            assertEqual(response.cookies[3],
                        Cookie(
                            name: "date",
                            value: "",
                            expires: Date(timeIntervalSince1970: 1536237674.0)))
        }
    }

    // MARK: Body

    func testBodyStringResponse() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.plain)))
            assertEqual(response.contentLength, 5)
            assertEqual(response.bytes, ASCII("Hello"))
            assertEqual(response.string, "Hello")
        }
    }

    func testBodyHtmlResponse() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/html\r\n" +
                "Content-Length: 13\r\n" +
                "\r\n" +
                "<html></html>")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.html))
            )
            assertEqual(response.contentLength, 13)
            assertEqual(response.bytes, ASCII("<html></html>"))
            assertEqual(response.string, "<html></html>")
        }
    }

    func testBodyBytesResponse() {
        scope {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/stream\r\n" +
                "Content-Length: 3\r\n" +
                "\r\n") + [1,2,3]
            let stream = InputByteStream(bytes)
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.stream))
            )
            assertEqual(response.contentLength, 3)
            assertEqual(response.bytes, [1,2,3])
        }
    }

    func testBodyJsonResponse() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 28\r\n" +
                "\r\n" +
                "{'message': 'Hello, World!'}")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.json))
            )
            assertEqual(response.contentLength, 28)
            assertEqual(response.bytes, ASCII("{'message': 'Hello, World!'}"))
            assertEqual(response.string, "{'message': 'Hello, World!'}")
        }
    }

    func testBodyZeroContentLenght() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentLength, 0)
            assertNil(response.bytes)
            assertEqual(response.body, .none)
        }
    }

    func testBodyChunked() {
        scope {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "d\r\n" +
                "Hello, World!\r\n" +
                "0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.string, "Hello, World!")
        }
    }
}
