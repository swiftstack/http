import Test
import HTTP

test.case("Encode") {
    let encoded = Punycode.encode(domain: "привет.рф")
    expect(encoded == "xn--b1agh1afp.xn--p1ai")
}

test.case("Decode") {
    let decoded = Punycode.decode(domain: "xn--b1agh1afp.xn--p1ai")
    expect(decoded == "привет.рф")
}

test.case("EncodeMixedCase") {
    let encoded = Punycode.encode(domain: "Привет.рф")
    expect(encoded == "xn--r0a2bjk3bp.xn--p1ai")
}

test.case("DecodeMixedCase") {
    let decoded = Punycode.decode(domain: "xn--r0a2bjk3bp.xn--p1ai")
    expect(decoded == "Привет.рф")
}

test.case("EncodeMixedASCII") {
    let encoded = Punycode.encode(domain: "hello-мир.рф")
    expect(encoded == "xn--hello--upf5a1b.xn--p1ai")
}

test.case("DecodeMixedASCII") {
    let decoded = Punycode.decode(domain: "xn--hello--upf5a1b.xn--p1ai")
    expect(decoded == "hello-мир.рф")
}

test.run()
