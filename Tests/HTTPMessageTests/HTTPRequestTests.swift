import XCTest
@testable import HTTPMessage

struct HTTPRequests {
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

class HTTPRequestTests: TestCase {
    func testType() {
        let httpRequest: HTTPType = .request
        assertEqual(httpRequest, .request)
    }

    func testFromBytes() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        assertNotNil(httpRequest)
    }

    func testDelete() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleDelete))
        assertNotNil(httpRequest)
        assertEqual(httpRequest.type, HTTPRequestType.delete)
    }

    func testGet() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        assertNotNil(httpRequest)
        assertEqual(httpRequest.type, HTTPRequestType.get)
    }

    func testLazy() throws {
        let httpRequest = try HTTPRequest()
        assertNotNil(httpRequest)
        httpRequest.userAgent = "wut"
        assertEqual(httpRequest.type, HTTPRequestType.get)
        assertEqual(httpRequest.userAgent, "wut")
    }

    func testHead() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleHead))
        assertNotNil(httpRequest)
        assertEqual(httpRequest.type, HTTPRequestType.head)
    }

    func testPost() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simplePost))
        assertNotNil(httpRequest)
        assertEqual(httpRequest.type, HTTPRequestType.post)
    }

    func testPut() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simplePut))
        assertNotNil(httpRequest)
        assertEqual(httpRequest.type, HTTPRequestType.put)
    }

    func testHTTPVersion() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        assertNotNil(httpRequest)
        assertEqual(httpRequest.version, HTTPVersion.oneOne)

    }

    func testUrl() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        assertNotNil(httpRequest)
        assertNotNil(httpRequest.url)
        assertEqual(httpRequest.urlBytes, ASCII("/test"))
    }

    func testUrlString() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        assertNotNil(httpRequest)
        assertNotNil(httpRequest.url)
        assertEqual(httpRequest.url, "/test")
    }

    func testInvalidRequest() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleOnlyMethod))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testInvalidRequest2() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleOnlyMethod2))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testInvalidMethod() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidMethod))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidMethod)
        }
    }

    func testInvalidVersion() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidVersion)
        }
    }

    func testInvalidVersion2() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion2))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testInvalidVersion3() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion3))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidVersion4() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion4))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidVersion)
        }
    }

    func testInvalidEnd() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidEnd))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testHostHeader() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.hostHeader))
        assertNotNil(request.host)
        if let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
        }
    }

    func testUserAgentHeader() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.userAgentHeader))
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent {
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testTwoHeaders() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.twoHeaders))
        assertNotNil(request.host)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testTwoHeadersOptionalSpaces() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.twoHeadersOptionalSpaces))
        assertNotNil(request.host)
        assertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            assertEqual(host, "0.0.0.0=5000")
            assertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testInvalidHeaderColon() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.invalidHeaderColon))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidHeaderName)
        }
    }

    func testInvalidHeaderName() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.invalidHeaderName))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidHeaderName)
        }
    }

    func testInvalidHeaderEnd() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.invalidHeaderEnd))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
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
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.unexpectedEnd))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testContentType() throws {
        do {
            let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.contentType))
            assertNotNil(request.contentType)
            if let contentType = request.contentType {
                assertEqual(contentType, .urlEncoded)
            }
        } catch let error as HTTPRequestError {
            fail("unexpected exception: \(error)")
        }
    }

    func testContentLenght() throws {
        do {
            let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.contentLength))
            assertNotNil(request.contentLength)
            if let contentLength = request.contentLength {
                assertEqual(contentLength, 5)
            }
        } catch let error as HTTPRequestError {
            fail("unexpected exception: \(error)")
        }
    }

    func testKeepAliveFalse() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.keepAliveFalse))
        assertFalse(request.shouldKeepAlive)
    }

    func testKeepAliveTrue() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.keepAliveTrue))
        assertTrue(request.shouldKeepAlive)
        assertEqual(request.keepAlive, 300)
    }

    func testTransferEncodingChunked() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.transferEncodingChunked))
        assertEqual(request.transferEncoding?.lowercased(), "chunked")
    }

    func testChunkedBody() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedBody))
        assertEqual(request.body, "Hello")
    }

    func testChunkedBodyInvalidSizeSeparator() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedBodyInvalidSizeSeparator))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testChunkedBodyNoSizeSeparator() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedBodyNoSizeSeparator))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .invalidRequest)
        }
    }

    func testChunkedInvalidBody() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedInvalidBody))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }

    func testChunkedJunkAfterBody() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedJunkAfterBody))
            fail("this method should throw")
        } catch let error as HTTPRequestError {
            assertEqual(error, .unexpectedEnd)
        }
    }
}
