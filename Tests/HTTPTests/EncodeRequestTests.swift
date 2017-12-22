import Test
import Stream
@testable import HTTP

class EncodeRequestTests: TestCase {
    class Encoder {
        static func encode(_ request: Request) -> String? {
            let stream = OutputByteStream()
            try? request.encode(to: stream)
            return String(decoding: stream.bytes, as: UTF8.self)
        }
    }

    func testRequest() {
        let expected = "GET /test HTTP/1.1\r\n\r\n"
        let request = Request(method: .get, url: "/test")
        assertEqual(Encoder.encode(request), expected)
    }

    func testUrl() {
        let expected = "GET /test HTTP/1.1\r\n\r\n"
        let request = Request(
            method: .get,
            url: URL(path: "/test", fragment: "fragment"))
        assertEqual(Encoder.encode(request), expected)
    }

    func testUrlQueryGet() {
        let expected = "GET /test?key=value HTTP/1.1\r\n\r\n"
        let request = Request(
            method: .get,
            url: URL(
                path: "/test",
                query: ["key" : "value"],
                fragment: "fragment"))
        assertEqual(Encoder.encode(request), expected)
    }

    func testUrlQueryPost() {
        let expected = "POST /test HTTP/1.1\r\n" +
            "Content-Type: application/x-www-form-urlencoded\r\n" +
            "Content-Length: 9\r\n" +
            "\r\n" +
            "key=value"
        let request = Request(
            method: .post,
            url: URL(
                path: "/test",
                query: ["key" : "value"],
                fragment: "fragment"))
        assertEqual(Encoder.encode(request), expected)
    }

    func testHost() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Host: 0.0.0.0:5000\r\n" +
            "\r\n"
        var request = Request()
        request.host = URL.Host(address: "0.0.0.0", port: 5000)
        assertEqual(Encoder.encode(request), expected)
    }

    func testHostDomain() {
        do {
            let expected = "GET / HTTP/1.1\r\n" +
                "Host: domain.com:5000\r\n" +
                "\r\n"
            let request = Request(url: try URL("http://domain.com:5000"))
            assertEqual(Encoder.encode(request), expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testHostEncoded() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Host: xn--d1acufc.xn--p1ai:5000\r\n" +
            "\r\n"
        var request = Request()
        request.host = URL.Host(address: "домен.рф", port: 5000)
        assertEqual(Encoder.encode(request), expected)
    }

    func testUserAgent() {
        let expected = "GET / HTTP/1.1\r\n" +
            "User-Agent: Mozilla/5.0\r\n" +
            "\r\n"
        var request = Request()
        request.userAgent = "Mozilla/5.0"
        assertEqual(Encoder.encode(request), expected)
    }

    func testAccept() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept: */*\r\n" +
            "\r\n"
        var request = Request()
        request.accept = [
            Request.Accept(.any, priority: 1.0)
        ]
        assertEqual(Encoder.encode(request), expected)
    }

    func testAcceptLanguage() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept-Language: en-US,en;q=0.5\r\n" +
            "\r\n"
        var request = Request()
        request.acceptLanguage = [
            Request.AcceptLanguage(.enUS, priority: 1.0),
            Request.AcceptLanguage(.en, priority: 0.5)
        ]
        assertEqual(Encoder.encode(request), expected)
    }

    func testAcceptEncoding() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept-Encoding: gzip, deflate\r\n" +
            "\r\n"
        var request = Request()
        request.acceptEncoding = [.gzip, .deflate]
        assertEqual(Encoder.encode(request), expected)
    }

    func testAcceptCharset() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Accept-Charset: ISO-8859-1,utf-7,utf-8;q=0.7,*;q=0.7\r\n" +
            "\r\n"
        var request = Request()
        request.acceptCharset = [
            Request.AcceptCharset(.isoLatin1),
            Request.AcceptCharset(.custom("utf-7")),
            Request.AcceptCharset(.utf8, priority: 0.7),
            Request.AcceptCharset(.any, priority: 0.7)
        ]
        assertEqual(Encoder.encode(request), expected)
    }

    func testAuthorization() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\r\n" +
            "\r\n"

        var request = Request()
        request.authorization = .basic(
            credentials: "QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
        assertEqual(Encoder.encode(request), expected)
    }

    func testKeepAlive() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Keep-Alive: 300\r\n" +
            "\r\n"
        var request = Request()
        request.keepAlive = 300
        assertEqual(Encoder.encode(request), expected)
    }

    func testConnection() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Connection: close\r\n" +
            "\r\n"
        var request = Request()
        request.connection = .close
        assertEqual(Encoder.encode(request), expected)
    }

    func testContentType() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Content-Type: text/plain\r\n" +
            "\r\n"
        var request = Request()
        request.contentType = ContentType(mediaType: .text(.plain))
        assertEqual(Encoder.encode(request), expected)
    }

    func testContentLength() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        var request = Request()
        request.contentLength = 0
        assertEqual(Encoder.encode(request), expected)
    }

    func testTransferEncoding() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n"
        var request = Request()
        request.transferEncoding = [.chunked]
        assertEqual(Encoder.encode(request), expected)
    }

    func testCustomHeaders() {
        let expected = "GET / HTTP/1.1\r\n" +
            "User: guest\r\n" +
            "\r\n"
        var request = Request()
        request.headers["User"] = "guest"
        assertEqual(Encoder.encode(request), expected)
    }

    func testJsonInitializer() {
        let expected = "POST / HTTP/1.1\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: 27\r\n" +
            "\r\n" +
            "{\"message\":\"Hello, World!\"}"
        let values = ["message": "Hello, World!"]
        let request = try! Request(method: .post, url: "/", body: values)
        assertEqual(Encoder.encode(request), expected)
    }

    func testUrlEncodedInitializer() {
        let expected = "POST / HTTP/1.1\r\n" +
            "Content-Type: application/x-www-form-urlencoded\r\n" +
            "Content-Length: 23\r\n" +
            "\r\n" +
            "message=Hello,%20World!"

        struct Query: Encodable {
            let message = "Hello, World!"
        }
        let request = try! Request(
            method: .post,
            url: "/",
            body: Query(),
            contentType: .urlEncoded)
        assertEqual(Encoder.encode(request), expected)
    }

    func testCookie() {
        let expected = "GET / HTTP/1.1\r\n" +
            "Cookie: username=tony\r\n" +
            "Cookie: lang=aurebesh\r\n" +
            "\r\n"
        var request = Request()
        request.cookies = [
            Cookie(name: "username", value: "tony"),
            Cookie(name: "lang", value: "aurebesh")
        ]
        assertEqual(Encoder.encode(request), expected)
    }

    func testEscaped() {
        let escapedUrl = "/%D0%BF%D1%83%D1%82%D1%8C" +
            "?%D0%BA%D0%BB%D1%8E%D1%87" +
            "=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5"
        let expected = "GET \(escapedUrl) HTTP/1.1\r\n\r\n"
        let request = Request(url: try! URL("/путь?ключ=значение#фрагмент"))
        assertEqual(Encoder.encode(request), expected)
    }
}
