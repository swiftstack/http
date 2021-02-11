import Test
import Stream

@testable import HTTP

test.case("Double") {
    expect(try await Double.decode(from: InputByteStream("0.1")) == 0.1)
    expect(try await Double.decode(from: InputByteStream("1.0")) == 1.0)
    expect(try await Double.decode(from: InputByteStream("0.7")) == 0.7)
    expect(try await Double.decode(from: InputByteStream("3.14")) == 3.14)
    expect(try await Double.decode(from: InputByteStream("42")) == 42)
    expect(try await Double.decode(from: InputByteStream("42.")) == 42)
}

test.run()
