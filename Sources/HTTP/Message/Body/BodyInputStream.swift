import JSON
import Stream

public protocol BodyInputStream: AnyObject {
    var body: Body { get set }
    var contentLength: Int? { get set }
    var transferEncoding: [TransferEncoding]? { get set }
    var inputStream: StreamReader? { get }
}

extension BodyInputStream {
    public var inputStream: StreamReader? {
        get {
            switch body {
            case let .input(reader): return reader
            default: return nil
            }
        }
        set {
            switch newValue {
            case .none: body = .none
            case .some(let reader): self.body = .input(reader)
            }
        }
    }

    public var outputStream: ((StreamWriter) async throws -> Void)? {
        get {
            switch body {
            case let .output(writer): return writer
            default: return nil
            }
        }
        set {
            switch newValue {
            case .none: self.body = .none
            case .some(let writer): self.body = .output(writer)
            }
        }
    }
}
