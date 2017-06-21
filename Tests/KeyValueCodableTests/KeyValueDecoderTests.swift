import Test
@testable import KeyValueCodable

class KeyValueDecoderTests: TestCase {
    func testKeyedDecoder() {
        let values = ["first":"one","second":"two"]
        struct Model: Decodable {
            let first: String
            let second: String
        }
        do {
            let object = try KeyValueDecoder().decode(Model.self, from: values)
            assertEqual(object.first, "one")
            assertEqual(object.second, "two")
        } catch {
            print(String(describing: error))
        }
    }

    func testSingleValueDecoder() {
        let value = ["integer":"42"]
        do {
            let integer = try KeyValueDecoder().decode(Int.self, from: value)
            assertEqual(integer, 42)
        } catch {
            print(String(describing: error))
        }
    }
}
