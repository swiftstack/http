import Stream

public enum Body {
    case none
    case bytes([UInt8])
    case input(UnsafeStreamReader)
    case output((UnsafeStreamWriter) throws -> Void)
}

extension Body: Equatable {
    public static func == (lhs: Body, rhs: Body) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case let (.bytes(lhs), .bytes(rhs)): return lhs == rhs
        default: return false
        }
    }
}

public protocol BodyInpuStream: class {
    var body: Body { get set }
    var contentLength: Int? { get set }
    var transferEncoding: [TransferEncoding]? { get set }
    var inputStream: UnsafeStreamReader? { get }
}

extension BodyInpuStream {
    public var inputStream: UnsafeStreamReader? {
        get {
            guard case .input(let reader) = body else {
                return nil
            }
            return reader
        }
        set {
            switch newValue {
            case .none: self.body = .none
            case .some(let reader): self.body = .input(reader)
            }
        }
    }

    public var outputStream: ((UnsafeStreamWriter) throws -> Void)? {
        get {
            guard case .output(let writer) = body else {
                return nil
            }
            return writer
        }
        set {
            switch newValue {
            case .none: self.body = .none
            case .some(let writer): self.body = .output(writer)
            }
        }
    }
}

extension BodyInpuStream {
    public var string: String? {
        get {
            guard let bytes = bytes else {
                return nil
            }
            return String(bytes: bytes, encoding: .utf8)
        }
    }

    public var bytes: [UInt8]? {
        get {
            switch body {
            case .bytes(let bytes): return bytes
            case .input(_):
                guard let bytes = try? readBytes() else {
                    return nil
                }
                return bytes
            default: return nil
            }
        }
        set {
            switch newValue {
            case .none:
                self.body = .none
            case .some(let bytes):
                self.body = .bytes(bytes)
                self.contentLength = bytes.count
            }
        }
    }

    func readBytes() throws -> [UInt8] {
        guard let reader = inputStream else {
            throw ParseError.invalidRequest
        }
        do {
            let bytes: [UInt8]
            if let contentLength = contentLength {
                let buffer = try reader.read(count: contentLength)
                guard buffer.count > 0 else {
                    body = .none
                    throw ParseError.invalidRequest
                }
                bytes = [UInt8](buffer)
            } else if self.transferEncoding?.contains(.chunked) == true  {
                let reader = ChunkedStreamReader(baseStream: reader)
                bytes = try reader.readBytes()
            } else {
                throw ParseError.invalidRequest
            }
            // cache
            body = .bytes(bytes)
            return bytes
        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}

fileprivate extension ChunkedStreamReader {
    func readBytes() throws -> [UInt8] {
        let buffer = try read(while: {_ in true}, allowingExhaustion: true)
        return [UInt8](buffer)
    }
}
