import Test
import Stream
@testable import HTTP

class UtilsTests: TestCase {
    func streamWith(_ string: String) -> BufferedInputStream<InputByteStream> {
        let stream = InputByteStream([UInt8](string.utf8))
        return BufferedInputStream(baseStream: stream)
    }

    func testDouble() {
        assertEqual(try Double(from: streamWith("0.1")), 0.1)
        assertEqual(try Double(from: streamWith("1.0")), 1.0)
        assertEqual(try Double(from: streamWith("3.14")), 3.14)
        assertEqual(try Double(from: streamWith("42")), 42)
        assertEqual(try Double(from: streamWith("42.")), 42)
    }
}
