import Test
@testable import HTTP

class KeyValueEncoderTests: TestCase {
    func testKeyedEncoder() {
        scope {
            struct Model: Encodable {
                let first: String
                let second: String
            }
            let encoder = KeyValueEncoder()
            let values = try encoder.encode(Model(first: "one", second: "two"))
            expect(values["first"] == "one")
            expect(values["second"] == "two")
        }
    }

    func testSingleValueEncoder() {
        scope {
            let encoder = KeyValueEncoder()
            let values = try encoder.encode(42)
            expect(values["integer"] == "42")
        }
    }
}
