import Test
@testable import HTTP

class KeyValueDecoderTests: TestCase {
    func testKeyedDecoder() {
        scope {
            let values = ["first":"one","second":"two"]
            struct Model: Decodable {
                let first: String
                let second: String?
            }
            let object = try Model(from: KeyValueDecoder(values))
            expect(object.first == "one")
            expect(object.second == "two")
        }
    }

    func testSingleValueDecoder() {
        scope {
            let value = ["integer":"42"]
            let integer = try Int(from: KeyValueDecoder(value))
            expect(integer == 42)
        }
    }
}
