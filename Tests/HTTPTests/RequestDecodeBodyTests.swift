import Test
import Stream
@testable import HTTP

class RequestContextTests: TestCase {
    func testContentLength() {
        do {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let request = try Request(from: stream)
            assertEqual(request.contentLength, 5)
            assertEqual(request.body, "Hello")
        } catch {
            fail(String(describing: error))
        }
    }

    func testChunkedBody() {
        do {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "5\r\nHello\r\n" +
                "0\r\n")
            let request = try Request(from: stream)
            assertEqual(request.body, "Hello")
        } catch {
            fail(String(describing: error))
        }
    }

    func testChunkedBodyInvalidSizeSeparator() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\rHello\r\n" +
            "0\r\n")
        assertThrowsError(try Request(from: stream)) { error in
            assertEqual(error as? ParseError, .invalidRequest)
        }
    }

    func testChunkedBodyNoSizeSeparator() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5 Hello\r\n" +
            "0\r\n")
        assertThrowsError(try Request(from: stream)) { error in
            assertEqual(error as? ParseError, .invalidRequest)
        }
    }

    func testChunkedInvalidBody() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\r\nHello")
        assertThrowsError(try Request(from: stream)) { error in
            assertEqual(error as? ParseError, .unexpectedEnd)
        }
    }
}
