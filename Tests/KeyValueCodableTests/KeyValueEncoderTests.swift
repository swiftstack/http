import Test
@testable import KeyValueCodable

class KeyValueEncoderTests: TestCase {
    func testEncoder() {
        struct Model: Encodable {
            let first: String
            let second: String
        }
        do {
            let encoder = KeyValueEncoder()
            let values = try encoder.encode(Model(first: "one", second: "two"))

            assertEqual(values["first"], "one")
            assertEqual(values["second"], "two")
        } catch {
            print(String(describing: error))
        }
    }
}
