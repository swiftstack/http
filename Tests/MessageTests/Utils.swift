import HTTP
import Stream

extension Response {
    func encode() throws -> String {
        let stream = OutputByteStream()
        try encode(to: stream)
        return String(decoding: stream.bytes, as: UTF8.self)
    }
}

extension Request {
    func encode() throws -> String {
        let stream = OutputByteStream()
        try encode(to: stream)
        return String(decoding: stream.bytes, as: UTF8.self)
    }
}

extension InputByteStream {
    convenience
    init(_ string: String) {
        self.init([UInt8](string.utf8))
    }
}

extension OutputByteStream {
    var string: String {
        return String(decoding: bytes, as: UTF8.self)
    }
}

extension StreamReader {
    func readString() throws -> String {
        let bytes = try readUntilEnd()
        return String(decoding: bytes, as: UTF8.self)
    }

    func readUntilEnd() throws -> [UInt8] {
        return try read(while: { _ in true }, allowingExhaustion: true)
    }
}
