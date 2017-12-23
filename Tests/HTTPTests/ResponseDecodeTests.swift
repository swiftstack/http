import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseDecodeTests: TestCase {
    func testOk() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testNotFound() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 404 Not Found\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .notFound)
        } catch {
            fail(String(describing: error))
        }
    }

    func testMoved() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 301 Moved Permanently\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .moved)
        } catch {
            fail(String(describing: error))
        }
    }

    func testBad() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 400 Bad Request\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .badRequest)
        } catch {
            fail(String(describing: error))
        }
    }

    func testUnauthorized() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 401 Unauthorized\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .unauthorized)
        } catch {
            fail(String(describing: error))
        }
    }

    func testInternalServerError() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 500 Internal Server Error\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.status, .internalServerError)
        } catch {
            fail(String(describing: error))
        }
    }


    func testContentLength() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentLength, 0)
        } catch {
            fail(String(describing: error))
        }
    }

    func testContentType() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            let expected = ContentType(mediaType: .text(.plain))
            assertEqual(response.contentType, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testConnection() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Connection: close\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.connection, .close)
        } catch {
            fail(String(describing: error))
        }
    }

    func testContentEncoding() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Content-Encoding: gzip, deflate\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentEncoding, [.gzip, .deflate])
        } catch {
            fail(String(describing: error))
        }
    }

    func testTransferEncoding() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Transfer-Encoding: gzip, chunked\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.transferEncoding, [.gzip, .chunked])
        } catch {
            fail(String(describing: error))
        }
    }

    func testCustomHeader() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "User: guest\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.headers["User"], "guest")
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookie() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"))
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieExpires() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; " +
                    "Expires=Wed, 21 Oct 2015 07:28:00 GMT\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    expires: Date(timeIntervalSinceReferenceDate: 467105280))
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieMaxAge() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Max-Age=42\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    maxAge: 42)
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieHttpOnly() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; HttpOnly\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    httpOnly: true)
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieSecure() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Secure\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    secure: true)
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieDomain() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Domain=somedomain.com\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    domain: "somedomain.com")
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookiePath() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "Set-Cookie: username=tony; Path=/\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.setCookie, [
                Response.SetCookie(
                    Cookie(name: "username", value: "tony"),
                    path: "/")
                ])
        } catch {
            fail(String(describing: error))
        }
    }

    func testSetCookieManyValues() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Set-Cookie: num=0; Path=/; Max-Age=42; Secure; HttpOnly\r\n" +
                "Set-Cookie: key=value; Secure; HttpOnly\r\n" +
                "Set-Cookie: date=; Expires=Thu, 06-Sep-18 12:41:14 GMT\r\n" +
                "Set-Cookie: date=; Expires=Thu, 06 Sep 2018 12:41:14 GMT\r\n" +
                "\r\n")
            let response = try Response(from: stream)

            assertEqual(response.setCookie[0],
                        Response.SetCookie(
                            Cookie(name: "num", value: "0"),
                            path: "/",
                            maxAge: 42,
                            secure: true,
                            httpOnly: true))

            assertEqual(response.setCookie[1],
                        Response.SetCookie(
                            Cookie(name: "key", value: "value"),
                            secure: true,
                            httpOnly: true))

            assertEqual(response.setCookie[2],
                        Response.SetCookie(
                            Cookie(name: "date", value: ""),
                            expires: Date(timeIntervalSince1970: 1536237674.0)))

            assertEqual(response.setCookie[3],
                        Response.SetCookie(
                            Cookie(name: "date", value: ""),
                            expires: Date(timeIntervalSince1970: 1536237674.0)))
        } catch {
            fail(String(describing: error))
        }
    }
}
