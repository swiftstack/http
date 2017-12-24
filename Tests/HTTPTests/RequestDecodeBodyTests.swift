import Test
import Stream
@testable import HTTP

class RequestDecodeBodyTests: TestCase {
    func testContentLength() {
        do {
            let stream = InputByteStream(
                "GET / HTTP/1.1\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let request = try Request(from: stream)
            assertEqual(request.contentLength, 5)
            assertEqual(request.string, "Hello")
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
                "0\r\n\r\n")
            let request = try Request(from: stream)
            assertEqual(request.string, "Hello")
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
            "0\r\n\r\n")
        do {
            let request = try Request(from: stream)
            assertThrowsError(try request.readBytes()) { error in
                assertEqual(error as? ParseError, .invalidRequest)
            }
        } catch {
            fail(String(describing: error))
        }
    }

    func testChunkedBodyNoSizeSeparator() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5 Hello\r\n" +
            "0\r\n\r\n")
        do {
            let request = try Request(from: stream)
            assertThrowsError(try request.readBytes()) { error in
                assertEqual(error as? ParseError, .invalidRequest)
            }
        } catch {
            fail(String(describing: error))
        }
    }

    func testChunkedMissingLineEnd() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\r\nHello\r\n" +
            "0\r\n")
        do {
            let request = try Request(from: stream)
            assertThrowsError(try request.readBytes()) { error in
                assertEqual(error as? ParseError, .unexpectedEnd)
            }
        } catch {
            fail(String(describing: error))
        }
    }

    func testChunkedInvalidBody() {
        let stream = InputByteStream(
            "GET / HTTP/1.1\r\n" +
            "Transfer-Encoding: chunked\r\n" +
            "\r\n" +
            "5\r\nHello")
        do {
            let request = try Request(from: stream)
            assertThrowsError(try request.readBytes()) { error in
                assertEqual(error as? ParseError, .unexpectedEnd)
            }
        } catch {
            fail(String(describing: error))
        }
    }
}
