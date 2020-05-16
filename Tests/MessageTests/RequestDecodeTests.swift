import Test
import Stream
@testable import HTTP

class RequestDecodeTests: TestCase {

    // MARK: Start line

    func testGet() {
        scope {
            let stream = InputByteStream("GET /test HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.method == Request.Method.get)
        }
    }

    func testHead() {
        scope {
            let stream = InputByteStream("HEAD /test HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.method == Request.Method.head)
        }
    }

    func testPost() {
        scope {
            let stream = InputByteStream("POST /test HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.method == Request.Method.post)
        }
    }

    func testPut() {
        scope {
            let stream = InputByteStream("PUT /test HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.method == Request.Method.put)
        }
    }

    func testDelete() {
        scope {
            let stream = InputByteStream("DELETE /test HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.method == Request.Method.delete)
        }
    }

    func testVersion() {
        scope {
            let stream = InputByteStream("GET /test HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.version == Version.oneOne)
        }
    }

    func testUrl() {
        scope {
            let stream = InputByteStream(
                "GET /test?k1=v1&k2=v2#fragment HTTP/1.1\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.url.path == "/test")
            expect(request.url.query?.values == ["k1":"v1", "k2":"v2"])
            expect(request.url.fragment == "fragment")
        }
    }

    func testInvalidRequest() {
        let stream = InputByteStream("GET\r\n\r\n")
        expect(throws: ParseError.invalidStartLine) {
            try Request(from: stream)
        }
    }

    func testInvalidRequest2() {
        let stream = InputByteStream("GET \r\n\r\n")
        expect(throws: ParseError.invalidStartLine) {
            try Request(from: stream)
        }
    }

    func testInvalidMethod() {
        let stream = InputByteStream("BAD /test HTTP/1.1\r\n\r\n")
        expect(throws: ParseError.invalidMethod) {
            try Request(from: stream)
        }
    }

    func testInvalidVersion() {
        let stream = InputByteStream("GET /test HTTP/0.1\r\n\r\n")
        expect(throws: ParseError.invalidVersion) {
            try Request(from: stream)
        }
    }

    func testInvalidVersion2() {
        let stream = InputByteStream("GET /test HTTP/1.1WUT\r\n\r\n")
        expect(throws: ParseError.invalidRequest) {
            try Request(from: stream)
        }
    }

    func testInvalidVersion3() {
        let stream = InputByteStream("GET /test HTTP/1.")
        expect(throws: ParseError.unexpectedEnd) {
            try Request(from: stream)
        }
    }

    func testInvalidVersion4() {
        let stream = InputByteStream("GET /test HTPP/1.1\r\n\r\n")
        expect(throws: ParseError.invalidVersion) {
            try Request(from: stream)
        }
    }

    func testInvalidEnd() {
        let stream = InputByteStream("GET /test HTTP/1.1\r\n")
        expect(throws: ParseError.unexpectedEnd) {
            try Request(from: stream)
        }
    }

    // MARK: Headers

    func testHostHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Host: 0.0.0.0:5000\r\n" +
                "\r\n")
            let expected = URL.Host(address: "0.0.0.0", port: 5000)
            let request = try Request(from: stream)
            expect(request.host == expected)
        }
    }

    func testHostDomainHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Host: domain.com:5000\r\n" +
                "\r\n")
            let expected = URL.Host(address: "domain.com", port: 5000)
            let request = try Request(from: stream)
            expect(request.host == expected)
        }
    }

    func testHostEncodedHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Host: xn--d1acufc.xn--p1ai:5000\r\n" +
                "\r\n")
            let expected = URL.Host(address: "домен.рф", port: 5000)
            let request = try Request(from: stream)
            expect(request.host == expected)
        }
    }

    func testUserAgentHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "User-Agent: Mozilla/5.0\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.userAgent == "Mozilla/5.0")
        }
    }

    func testAcceptHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Accept: text/html,application/xml;q=0.9,*/*;q=0.8\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.accept == [
                Request.Accept(.text(.html),priority: 1.0),
                Request.Accept(.application(.xml), priority: 0.9),
                Request.Accept(.any, priority: 0.8)
            ])
        }
    }

    func testAcceptLanguageHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Accept-Language: en-US,en;q=0.5\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.acceptLanguage == [
                Request.AcceptLanguage(.enUS, priority: 1.0),
                Request.AcceptLanguage(.en, priority: 0.5)
            ])
        }
    }

    func testAcceptEncodingHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.acceptEncoding == [.gzip, .deflate])
        }
    }

    func testAcceptCharset() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Accept-Charset: ISO-8859-1,utf-7,utf-8;q=0.7,*;q=0.7\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            let expectedAcceptCharset = [
                Request.AcceptCharset(.isoLatin1),
                Request.AcceptCharset(.custom("utf-7")),
                Request.AcceptCharset(.utf8, priority: 0.7),
                Request.AcceptCharset(.any, priority: 0.7)
            ]
            expect(request.acceptCharset == expectedAcceptCharset)
        }
    }

    func testAcceptCharsetSpaceSeparator() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Accept-Charset: ISO-8859-1, utf-8\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            let expectedAcceptCharset = [
                Request.AcceptCharset(.isoLatin1),
                Request.AcceptCharset(.utf8)
            ]
            expect(request.acceptCharset == expectedAcceptCharset)
        }
    }

    func testAuthorization() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            let expected: Request.Authorization = .basic(
                credentials: "QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
            expect(request.authorization == expected)
        }
    }

    func testCustomHeader() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "User: guest\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.headers["User"] == "guest")
        }
    }

    func testTwoHeaders() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Host: 0.0.0.0:5000\r\n" +
                "User-Agent: Mozilla/5.0\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
            expect(request.userAgent == "Mozilla/5.0")
        }
    }

    func testTwoHeadersOptionalSpaces() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Host:0.0.0.0:5000\r\n" +
                "User-Agent: Mozilla/5.0 \r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
            expect(request.userAgent == "Mozilla/5.0")
        }
    }

    func testInvalidHeaderColon() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "User-Agent; Mozilla/5.0\r\n" +
            "\r\n")
        expect(throws: ParseError.invalidHeaderName) {
            try Request(from: stream)
        }
    }

    func testInvalidHeaderEnd() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "User-Agent: Mozilla/5.0\n\n")
        expect(throws: ParseError.unexpectedEnd) {
            try Request(from: stream)
        }
    }

    func testInvalidHeaderName() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "See-🙈-Evil: No\r\n" +
            "\r\n")
        expect(throws: ParseError.invalidHeaderName) {
            try Request(from: stream)
        }
    }

    func testHeaderName() {
        let headerName = HeaderName(extendedGraphemeClusterLiteral: "Host")
        let headerName2 = HeaderName(unicodeScalarLiteral: "Host")
        expect(headerName == headerName2)
    }

    func testUnexpectedEnd() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Header: Value\r\n")
        expect(throws: ParseError.unexpectedEnd) {
            try Request(from: stream)
        }
    }

    func testContentType() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Type: application/x-www-form-urlencoded\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(
                request.contentType
                ==
                ContentType(mediaType: .application(.formURLEncoded))
            )
        }
    }

    func testContentTypeCharset() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Type: text/plain; charset=utf-8\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(
                request.contentType
                ==
                ContentType(mediaType: .text(.plain), charset: .utf8)
            )
        }
    }

    func testContentTypeEmptyCharset() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Content-Type: text/plain;\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n")
        expect(throws: ParseError.invalidContentTypeHeader) {
            try Request(from: stream)
        }
    }

    func testContentTypeBoundary() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Type: multipart/form-data; boundary=---\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(
                request.contentType
                ==
                ContentType(
                    multipart: .formData,
                    boundary: try Boundary("---"))
            )
        }
    }

    func testContentTypeEmptyBoundary() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Content-Type: multipart/form-data;\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n")
        expect(throws: ParseError.invalidBoundary) {
            try Request(from: stream)
        }
    }

    func testContentLength() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.contentLength == 0)
        }
    }

    func testKeepAliveFalse() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Connection: Close\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(!request.shouldKeepAlive)
        }
    }

    func testKeepAliveTrue() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Connection: Keep-Alive\r\n" +
                "Keep-Alive: 300\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.shouldKeepAlive)
            expect(request.keepAlive == 300)
        }
    }

    func testTransferEncodingChunked() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "0\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.transferEncoding == [.chunked])
        }
    }

    func testCookies() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Cookie: username=tony\r\n" +
                "Cookie: lang=aurebesh\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.cookies == [
                Cookie(name: "username", value: "tony"),
                Cookie(name: "lang", value: "aurebesh")
            ])
        }
    }

    func testCookiesJoined() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Cookie: username=tony; lang=aurebesh\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.cookies == [
                Cookie(name: "username", value: "tony"),
                Cookie(name: "lang", value: "aurebesh")
            ])
        }
    }

    func testCookiesNoSpace() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Cookie: username=tony;lang=aurebesh\r\n" +
            "\r\n")
        expect(throws: ParseError.invalidRequest) {
            try Request(from: stream)
        }
    }

    func testCookiesTrailingSemicolon() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Cookie: username=tony;\r\n" +
            "\r\n")
        expect(throws: ParseError.invalidRequest) {
            try Request(from: stream)
        }
    }

    func testEscaped() {
        scope {
            let escapedUrl = "/%D0%BF%D1%83%D1%82%D1%8C" +
                "?%D0%BA%D0%BB%D1%8E%D1%87" +
                "=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5" +
                "#%D1%84%D1%80%D0%B0%D0%B3%D0%BC%D0%B5%D0%BD%D1%82"
            let stream = InputByteStream("GET \(escapedUrl) HTTP/1.1\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.url == "/путь?ключ=значение")
            expect(request.url.fragment == "фрагмент")
        }
    }

    func testExpect() {
        scope {
            let stream = InputByteStream(
                "PUT / HTTP/1.1\r\n" +
                "Expect: 100-continue\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            expect(request.expect == .continue)
        }
    }

    // MARK: Body

    func testBodyContentLength() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let request = try Request(from: stream)
            expect(request.contentLength == 5)
            expect(request.string == "Hello")
        }
    }

    func testBodyChunked() {
        scope {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "5\r\nHello\r\n" +
                "0\r\n\r\n")
            let request = try Request(from: stream)
            expect(request.string == "Hello")
        }
    }

    func testBodyChunkedInvalidSizeSeparator() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\rHello\r\n" +
            "0\r\n\r\n")
        scope {
            let request = try Request(from: stream)
            expect(throws: ParseError.invalidRequest) {
                try request.readBytes()
            }
        }
    }

    func testBodyChunkedNoSizeSeparator() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5 Hello\r\n" +
            "0\r\n\r\n")
        scope {
            let request = try Request(from: stream)
            expect(throws: ParseError.invalidRequest) {
                try request.readBytes()
            }
        }
    }

    func testBodyChunkedMissingLineEnd() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\r\nHello\r\n" +
            "0\r\n")
        scope {
            let request = try Request(from: stream)
            expect(throws: ParseError.unexpectedEnd) {
                try request.readBytes()
            }
        }
    }

    func testBodyChunkedInvalidBody() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\r\nHello")
        scope {
            let request = try Request(from: stream)
            expect(throws: ParseError.unexpectedEnd) {
                try request.readBytes()
            }
        }
    }
}
