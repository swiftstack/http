import XCTest
@testable import HTTP

class UtilsTests: TestCase {
    func testString() {
        let bytes = ASCII("wuut")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        assertEqual(String(bytes: bytes), "wuut")
        assertEqual(String(buffer: buffer), "wuut")
    }
}
