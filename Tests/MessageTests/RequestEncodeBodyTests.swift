import Test
import Stream
@testable import HTTP

class RequestEncodeBodyTests: TestCase {
    class Encoder {
        static func encode(_ request: Request) -> String? {
            let stream = OutputByteStream()
            try? request.encode(to: stream)
            return String(decoding: stream.bytes, as: UTF8.self)
        }
    }

    func testJsonInitializer() {
        let expected = "POST / HTTP/1.1\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: 27\r\n" +
            "\r\n" +
            "{\"message\":\"Hello, World!\"}"
        let values = ["message": "Hello, World!"]
        let request = try! Request(url: "/", method: .post, body: values)
        assertEqual(Encoder.encode(request), expected)
    }

    func testFormURLEncodedInitializer() {
        let expected = "POST / HTTP/1.1\r\n" +
            "Content-Type: application/x-www-form-urlencoded\r\n" +
            "Content-Length: 23\r\n" +
            "\r\n" +
            "message=Hello,%20World!"
        struct Query: Encodable {
            let message = "Hello, World!"
        }
        let request = try! Request(
            url: "/",
            method: .post,
            body: Query(),
            contentType: .formURLEncoded)
        assertEqual(Encoder.encode(request), expected)
    }
}
