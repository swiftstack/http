import XCTest
@testable import HTTP

class UtilsTests: TestCase {
    func testString() {
        let bytes = ASCII("wuut")
        let slice = bytes.slice
        assertEqual(String(bytes: bytes), "wuut")
        assertEqual(String(slice: slice), "wuut")
    }

    func testSlice() {
        let bytes: [UInt8] = [1,2,3,4,5]
        let slice = bytes.slice
        assertTrue(bytes.elementsEqual(slice))
    }

    func testContains() {
        let bytes: [UInt8] = [1,2,3,4,5]
        let slice = bytes.slice
        assertTrue(slice.contains(other: [2,3,4]))
        assertFalse(slice.contains(other: [2,9,1]))
    }
}
