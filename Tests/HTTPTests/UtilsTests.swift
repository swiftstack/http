import Test
@testable import HTTP

class UtilsTests: TestCase {
    func testString() {
        let bytes = ASCII("string")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        assertEqual(String(ascii: bytes), "string")
        assertEqual(String(ascii: buffer), "string")
    }

    func testUnsafeString() {
        let bytes = ASCII("string")
        let buffer = UnsafeRawBufferPointer(
            start: bytes,
            count: bytes.count - 1)
        assertEqual(String(ascii: buffer), "strin")
    }
}
