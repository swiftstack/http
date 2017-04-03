import HTTP

typealias ASCII = [UInt8]
extension Array where Element == UInt8 {
    public init(_ value: String) {
        self = [UInt8](value.utf8)
    }
}

class DecodeRequestTests: TestCase {

    // MARK: Start line

    func testGet() throws {
        let bytes = ASCII("GET /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.get)
    }

    func testHead() throws {
        let bytes = ASCII("HEAD /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.head)
    }

    func testPost() throws {
        let bytes = ASCII("POST /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.post)
    }

    func testPut() throws {
        let bytes = ASCII("PUT /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.put)
    }

    func testDelete() throws {
        let bytes = ASCII("DELETE /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.delete)
    }

    func testVersion() throws {
        let bytes = ASCII("GET /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertEqual(request.version, Version.oneOne)
    }

    func testUrl() throws {
        let bytes = ASCII("GET /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertNotNil(request.url)
        assertEqual(request.url.path, "/test")
    }

    func testUrlString() throws {
        let bytes = ASCII("GET /test HTTP/1.1\r\n\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request)
        assertNotNil(request.url)
        assertEqual(request.url, "/test")
    }

    func testInvalidRequest() throws {
        do {
            let bytes = ASCII("GET\r\n\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidRequest2() throws {
        do {
            let bytes = ASCII("GET \r\n\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidMethod() throws {
        do {
            let bytes = ASCII("BAD /test HTTP/1.1\r\n\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidMethod)
        }
    }

    func testInvalidVersion() throws {
        do {
            let bytes = ASCII("GET /test HTTP/0.1\r\n\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidVersion)
        }
    }

    func testInvalidVersion2() throws {
        do {
            let bytes = ASCII("GET /test HTTP/1.1WUT\r\n\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testInvalidVersion3() throws {
        do {
            let bytes = ASCII("GET /test HTTP/1.")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidVersion4() throws {
        do {
            let bytes = ASCII("GET /test HTPP/1.1\r\n\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidVersion)
        }
    }

    func testInvalidEnd() throws {
        do {
            let bytes = ASCII("GET /test HTTP/1.1\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    // MARK: Headers

    func testHostHeader() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Host: 0.0.0.0=5000\r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request.host)
        if let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
        }
    }

    func testUserAgentHeader() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "User-Agent: Mozilla/5.0\r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent {
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testTwoHeaders() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Host: 0.0.0.0=5000\r\n" +
            "User-Agent: Mozilla/5.0\r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request.host)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testTwoHeadersOptionalSpaces() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Host:0.0.0.0=5000\r\n" +
            "User-Agent: Mozilla/5.0 \r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertNotNil(request.host)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testInvalidHeaderColon() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "User-Agent; Mozilla/5.0\r\n" +
                "\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidHeaderEnd() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "User-Agent; Mozilla/5.0\n\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidHeaderName() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "See-🙈-Evil: No\r\n" +
                "\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidHeaderName)
        }
    }

    func testHeaderName() {
        let headerName = HeaderName(extendedGraphemeClusterLiteral: "Host")
        let headerName2 = HeaderName(unicodeScalarLiteral: "Host")
        assertEqual(headerName, headerName2)
    }

    func testUnexpectedEnd() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Header: Value\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testContentType() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Content-Type: application/x-www-form-urlencoded\r\n" +
                "\r\n" +
                "Hello")
            let request = try Request(from: bytes)
            assertNotNil(request.contentType)
            if let contentType = request.contentType {
                assertEqual(contentType, .urlEncoded)
            }
        } catch let error as RequestError {
            fail("unexpected exception: \(error)")
        }
    }

    func testContentLenght() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let request = try Request(from: bytes)
            assertNotNil(request.contentLength)
            if let contentLength = request.contentLength {
                assertEqual(contentLength, 5)
            }
        } catch let error as RequestError {
            fail("unexpected exception: \(error)")
        }
    }

    func testKeepAliveFalse() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Connection: Close\r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertFalse(request.shouldKeepAlive)
    }

    func testKeepAliveTrue() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Connection: Keep-Alive\r\n" +
            "Keep-Alive: 300\r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertTrue(request.shouldKeepAlive)
        assertEqual(request.keepAlive, 300)
    }

    func testTransferEncodingChunked() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n")
        let request = try Request(from: bytes)
        assertEqual(request.transferEncoding?.lowercased(), "chunked")
    }

    // MARK: Body

    func testChunkedBody() throws {
        let bytes = ASCII(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\r\nHello\r\n" +
            "0\r\n")
        let request = try Request(from: bytes)
        assertEqual(request.body, "Hello")
    }

    func testChunkedBodyInvalidSizeSeparator() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "5\rHello\r\n" +
                "0\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testChunkedBodyNoSizeSeparator() throws {
        do {
           let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "5 Hello\r\n" +
                "0\r\n")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testChunkedInvalidBody() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "5\r\nHello")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testChunkedJunkAfterBody() throws {
        do {
            let bytes = ASCII(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "5\r\nHello\r\n" +
                "0\r\n" +
                "WAT")
            _ = try Request(from: bytes)
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }
}
