import XCTest
@testable import HTTPMessage

class UtilsTests: XCTestCase {
    func testString() {
        let bytes = ASCII("wuut")
        let slice = bytes.slice
        XCTAssertEqual(String(bytes: bytes), "wuut")
        XCTAssertEqual(String(slice: slice), "wuut")
    }

    func testSlice() {
        let bytes: [UInt8] = [1,2,3,4,5]
        let slice = bytes.slice
        XCTAssertTrue(bytes.elementsEqual(slice))
    }

    func testContains() {
        let bytes: [UInt8] = [1,2,3,4,5]
        let slice = bytes.slice
        XCTAssertTrue(slice.contains(other: [2,3,4]))
        XCTAssertFalse(slice.contains(other: [2,9,1]))
    }
}
