import Test
import Stream
@testable import HTTP

class RequestEncodeTests: TestCase {
    func testRequest() {
        scope {
            let expected = "GET /test HTTP/1.1\r\n\r\n"
            let request = Request(url: "/test", method: .get)
            assertEqual(try request.encode(), expected)
        }
    }

    func testUrl() {
        scope {
            let expected = "GET /test HTTP/1.1\r\n\r\n"
            let request = Request(
                url: URL(path: "/test", fragment: "fragment"),
                method: .get)
            assertEqual(try request.encode(), expected)
        }
    }

    func testUrlQueryGet() {
        scope {
            let expected = "GET /test?key=value HTTP/1.1\r\n\r\n"
            let request = Request(
                url: URL(
                    path: "/test",
                    query: ["key" : "value"],
                    fragment: "fragment"),
                method: .get)
            assertEqual(try request.encode(), expected)
        }
    }

    func testUrlQueryPost() {
        scope {
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
            assertEqual(try request.encode(), expected)
        }
    }

    func testHost() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Host: 0.0.0.0:5000\r\n" +
                "\r\n"
            let request = Request()
            request.host = URL.Host(address: "0.0.0.0", port: 5000)
            assertEqual(try request.encode(), expected)
        }
    }

    func testHostDomain() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Host: domain.com:5000\r\n" +
                "\r\n"
            let request = Request(url: "http://domain.com:5000")
            assertEqual(try request.encode(), expected)
        }
    }

    func testHostEncoded() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Host: xn--d1acufc.xn--p1ai:5000\r\n" +
                "\r\n"
            let request = Request()
            request.host = URL.Host(address: "домен.рф", port: 5000)
            assertEqual(try request.encode(), expected)
        }
    }

    func testUserAgent() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "User-Agent: Mozilla/5.0\r\n" +
                "\r\n"
            let request = Request()
            request.userAgent = "Mozilla/5.0"
            assertEqual(try request.encode(), expected)
        }
    }

    func testAccept() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Accept: */*\r\n" +
                "\r\n"
            let request = Request()
            request.accept = [
                Request.Accept(.any, priority: 1.0)
            ]
            assertEqual(try request.encode(), expected)
        }
    }

    func testAcceptLanguage() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Accept-Language: en-US,en;q=0.5\r\n" +
                "\r\n"
            let request = Request()
            request.acceptLanguage = [
                Request.AcceptLanguage(.enUS, priority: 1.0),
                Request.AcceptLanguage(.en, priority: 0.5)
            ]
            assertEqual(try request.encode(), expected)
        }
    }

    func testAcceptEncoding() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"
            let request = Request()
            request.acceptEncoding = [.gzip, .deflate]
            assertEqual(try request.encode(), expected)
        }
    }

    func testAcceptCharset() {
        scope {
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
            assertEqual(try request.encode(), expected)
        }
    }

    func testAuthorization() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\r\n" +
                "\r\n"

            let request = Request()
            request.authorization = .basic(
                credentials: "QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
            assertEqual(try request.encode(), expected)
        }
    }

    func testKeepAlive() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Keep-Alive: 300\r\n" +
                "\r\n"
            let request = Request()
            request.keepAlive = 300
            assertEqual(try request.encode(), expected)
        }
    }

    func testConnection() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Connection: close\r\n" +
                "\r\n"
            let request = Request()
            request.connection = .close
            assertEqual(try request.encode(), expected)
        }
    }

    func testContentType() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Content-Type: text/plain\r\n" +
                "\r\n"
            let request = Request()
            request.contentType = ContentType(mediaType: .text(.plain))
            assertEqual(try request.encode(), expected)
        }
    }

    func testContentLength() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n"
            let request = Request()
            request.contentLength = 0
            assertEqual(try request.encode(), expected)
        }
    }

    func testTransferEncoding() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n"
            let request = Request()
            request.transferEncoding = [.chunked]
            assertEqual(try request.encode(), expected)
        }
    }

    func testCustomHeaders() {
        scope {
            let expected =
                "GET / HTTP/1.1\r\n" +
                "User: guest\r\n" +
                "\r\n"
            let request = Request()
            request.headers["User"] = "guest"
            assertEqual(try request.encode(), expected)
        }
    }

    func testCookie() {
        scope {
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
            assertEqual(try request.encode(), expected)
        }
    }

    func testEscaped() {
        scope {
            let escapedUrl =
                "/%D0%BF%D1%83%D1%82%D1%8C" +
                "?%D0%BA%D0%BB%D1%8E%D1%87" +
                "=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5"
            let expected = "GET \(escapedUrl) HTTP/1.1\r\n\r\n"
            let request = Request(url: "/путь?ключ=значение#фрагмент")
            assertEqual(try request.encode(), expected)
        }
    }

    // MARK: Body

    func testBodyJsonInitializer() {
        scope {
            let expected =
                "POST / HTTP/1.1\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 27\r\n" +
                "\r\n" +
                "{\"message\":\"Hello, World!\"}"
            let values = ["message": "Hello, World!"]
            let request = try Request(url: "/", method: .post, body: values)
            assertEqual(try request.encode(), expected)
        }
    }

    func testBodyFormURLEncodedInitializer() {
        scope {
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
            assertEqual(try request.encode(), expected)
        }
    }
}
