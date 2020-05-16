import Test
import Stream
@testable import HTTP

class UtilsTests: TestCase {
    func testDouble() {
        expect(try Double(from: InputByteStream("0.1")) == 0.1)
        expect(try Double(from: InputByteStream("1.0")) == 1.0)
        expect(try Double(from: InputByteStream("0.7")) == 0.7)
        expect(try Double(from: InputByteStream("3.14")) == 3.14)
        expect(try Double(from: InputByteStream("42")) == 42)
        expect(try Double(from: InputByteStream("42.")) == 42)
    }
}
