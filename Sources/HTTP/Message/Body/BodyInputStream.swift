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

    public var outputStream: ((StreamWriter) async throws -> Void)? {
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
