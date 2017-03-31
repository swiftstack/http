import XCTest
@testable import HTTP

struct Requests {
    // Start line
    static let simpleDelete = "DELETE /test HTTP/1.1\r\n\r\n"
    static let simpleGet = "GET /test HTTP/1.1\r\n\r\n"
    static let simpleHead = "HEAD /test HTTP/1.1\r\n\r\n"
    static let simplePost = "POST /test HTTP/1.1\r\n\r\n"
    static let simplePut = "PUT /test HTTP/1.1\r\n\r\n"
    static let simpleOnlyMethod = "GET\r\n\r\n"
    static let simpleOnlyMethod2 = "GET \r\n\r\n"
    static let simpleInvalidMethod = "BAD /test HTTP/1.1\r\n\r\n"
    static let simpleInvalidVersion = "GET /test HTTP/0.1\r\n\r\n"
    static let simpleInvalidVersion2 = "GET /test HTTP/1.1WUT\r\n\r\n"
    static let simpleInvalidVersion3 = "GET /test HTTP/1."
    static let simpleInvalidVersion4 = "GET /test HTPP/1.1\r\n\r\n"
    static let simpleInvalidEnd = "GET /test HTTP/1.1\r\n"
    // Headers
    static let startLine = "GET / HTTP/1.1\r\n"
    static let hostHeader = "\(startLine)Host: 0.0.0.0=5000\r\n\r\n"
    static let userAgentHeader = "\(startLine)User-Agent: Mozilla/5.0\r\n\r\n"
    static let twoHeaders = "\(startLine)Host: 0.0.0.0=5000\r\nUser-Agent: Mozilla/5.0\r\n\r\n"
    static let twoHeadersOptionalSpaces = "\(startLine)Host:0.0.0.0=5000\r\nUser-Agent: Mozilla/5.0 \r\n\r\n"
    static let invalidHeaderColon = "\(startLine)User-Agent; Mozilla/5.0\r\n\r\n"
    static let invalidHeaderEnd = "\(startLine)User-Agent: Mozilla/5.0\n\n"
    static let invalidHeaderName = "\(startLine)See-🙈-Evil: No\n\n"
    static let unexpectedEnd = "\(startLine)Header: Value\r\n"
    static let contentType = "\(startLine)Content-Type: application/x-www-form-urlencoded\r\n\r\nHello"
    static let contentLength = "\(startLine)Content-Length: 5\r\n\r\nHello"
    static let keepAliveFalse = "\(startLine)Connection: Close\r\n\r\n"
    static let keepAliveTrue = "\(startLine)Connection: Keep-Alive\r\nKeep-Alive: 300\r\n\r\n"
    static let transferEncodingChunked = "\(startLine)Transfer-Encoding: chunked\r\n\r\n"
    // Body
    static let chunkedBody = "\(transferEncodingChunked)5\r\nHello\r\n0\r\n"
    static let chunkedBodyInvalidSizeSeparator = "\(transferEncodingChunked)5\rHello\r\n0\r\n"
    static let chunkedBodyNoSizeSeparator = "\(transferEncodingChunked)5 Hello\r\n0\r\n"
    static let chunkedInvalidBody = "\(transferEncodingChunked)5\r\nHello"
    static let chunkedJunkAfterBody = "\(chunkedBody)wuut"
}

class RequestTests: TestCase {
    func testType() {
        let type: _Type = .request
        assertEqual(type, .request)
    }

    func testFromBytes() throws {
        let request = try Request(from: ASCII(Requests.simpleGet))
        assertNotNil(request)
    }

    func testDelete() throws {
        let request = try Request(from: ASCII(Requests.simpleDelete))
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.delete)
    }

    func testGet() throws {
        let request = try Request(from: ASCII(Requests.simpleGet))
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.get)
    }

    func testHead() throws {
        let request = try Request(from: ASCII(Requests.simpleHead))
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.head)
    }

    func testPost() throws {
        let request = try Request(from: ASCII(Requests.simplePost))
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.post)
    }

    func testPut() throws {
        let request = try Request(from: ASCII(Requests.simplePut))
        assertNotNil(request)
        assertEqual(request.type, Request.Kind.put)
    }

    func testVersion() throws {
        let request = try Request(from: ASCII(Requests.simpleGet))
        assertNotNil(request)
        assertEqual(request.version, Version.oneOne)

    }

    func testUrl() throws {
        let request = try Request(from: ASCII(Requests.simpleGet))
        assertNotNil(request)
        assertNotNil(request.url)
        assertEqual(request.url.path, "/test")
    }

    func testUrlString() throws {
        let request = try Request(from: ASCII(Requests.simpleGet))
        assertNotNil(request)
        assertNotNil(request.url)
        assertEqual(request.url, "/test")
    }

    func testInvalidRequest() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleOnlyMethod))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidRequest2() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleOnlyMethod2))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidMethod() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleInvalidMethod))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidMethod)
        }
    }

    func testInvalidVersion() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleInvalidVersion))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidVersion)
        }
    }

    func testInvalidVersion2() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleInvalidVersion2))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testInvalidVersion3() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleInvalidVersion3))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidVersion4() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleInvalidVersion4))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidVersion)
        }
    }

    func testInvalidEnd() throws {
        do {
            _ = try Request(from: ASCII(Requests.simpleInvalidEnd))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testHostHeader() throws {
        let request = try Request(from: ASCII(Requests.hostHeader))
        assertNotNil(request.host)
        if let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
        }
    }

    func testUserAgentHeader() throws {
        let request = try Request(from: ASCII(Requests.userAgentHeader))
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent {
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testTwoHeaders() throws {
        let request = try Request(from: ASCII(Requests.twoHeaders))
        assertNotNil(request.host)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testTwoHeadersOptionalSpaces() throws {
        let request = try Request(from: ASCII(Requests.twoHeadersOptionalSpaces))
        assertNotNil(request.host)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testInvalidHeaderColon() throws {
        do {
            _ = try Request(from: ASCII(Requests.invalidHeaderColon))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidHeaderName() throws {
        do {
            _ = try Request(from: ASCII(Requests.invalidHeaderName))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidHeaderName)
        }
    }

    func testInvalidHeaderEnd() throws {
        do {
            _ = try Request(from: ASCII(Requests.invalidHeaderEnd))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testHeaderName() {
        let headerName = HeaderName(extendedGraphemeClusterLiteral: "Host")
        let headerName2 = HeaderName(unicodeScalarLiteral: "Host")
        assertEqual(headerName, headerName2)
    }

    func testUnexpectedEnd() throws {
        do {
            _ = try Request(from: ASCII(Requests.unexpectedEnd))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testContentType() throws {
        do {
            let request = try Request(from: ASCII(Requests.contentType))
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
            let request = try Request(from: ASCII(Requests.contentLength))
            assertNotNil(request.contentLength)
            if let contentLength = request.contentLength {
                assertEqual(contentLength, 5)
            }
        } catch let error as RequestError {
            fail("unexpected exception: \(error)")
        }
    }

    func testKeepAliveFalse() throws {
        let request = try Request(from: ASCII(Requests.keepAliveFalse))
        assertFalse(request.shouldKeepAlive)
    }

    func testKeepAliveTrue() throws {
        let request = try Request(from: ASCII(Requests.keepAliveTrue))
        assertTrue(request.shouldKeepAlive)
        assertEqual(request.keepAlive, 300)
    }

    func testTransferEncodingChunked() throws {
        let request = try Request(from: ASCII(Requests.transferEncodingChunked))
        assertEqual(request.transferEncoding?.lowercased(), "chunked")
    }

    func testChunkedBody() throws {
        let request = try Request(from: ASCII(Requests.chunkedBody))
        assertEqual(request.body, "Hello")
    }

    func testChunkedBodyInvalidSizeSeparator() throws {
        do {
            _ = try Request(from: ASCII(Requests.chunkedBodyInvalidSizeSeparator))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testChunkedBodyNoSizeSeparator() throws {
        do {
            _ = try Request(from: ASCII(Requests.chunkedBodyNoSizeSeparator))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testChunkedInvalidBody() throws {
        do {
            _ = try Request(from: ASCII(Requests.chunkedInvalidBody))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testChunkedJunkAfterBody() throws {
        do {
            _ = try Request(from: ASCII(Requests.chunkedJunkAfterBody))
            fail("this method should throw")
        } catch let error as RequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }
}
