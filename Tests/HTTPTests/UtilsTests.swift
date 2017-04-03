@testable import HTTP

class UtilsTests: TestCase {
    func testString() {
        let bytes = ASCII("string")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        assertEqual(String(bytes: bytes), "string")
        assertEqual(String(buffer: buffer), "string")
    }

    func testUnsafeString() {
        let bytes = ASCII("string")
        let buffer = UnsafeRawBufferPointer(
            start: bytes,
            count: bytes.count - 1)
        assertEqual(String(buffer: buffer), "strin")
    }
}
