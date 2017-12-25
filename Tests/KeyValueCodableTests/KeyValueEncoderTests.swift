import Test
@testable import HTTP

class KeyValueEncoderTests: TestCase {
    func testKeyedEncoder() {
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

    func testSingleValueEncoder() {
        do {
            let encoder = KeyValueEncoder()
            let values = try encoder.encode(42)

            assertEqual(values["integer"], "42")
        } catch {
            print(String(describing: error))
        }
    }
}
