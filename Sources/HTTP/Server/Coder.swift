import JSON
import Stream
import Network

public protocol DecodableMessage {
    var contentType: ContentType? { get }
    var body: Body { get }
    var bytes: [UInt8]? { get }
}

extension Request: DecodableMessage {}
extension Response: DecodableMessage {}

// MARK: Coder

public struct Coder {
    public enum Error: Swift.Error {
        case invalidRequest
        case invalidContentType
    }

    // MARK: Transform convenient router result into Response

    @usableFromInline
    @inline(__always)
    static func makeRespone<T: Encodable>(
        for request: Request,
        encoding object: T) throws -> Response
    {
        let response = Response(status: .ok)
        try Coder.updateRespone(response, for: request, with: .object(object))
        return response
    }

    @inline(__always)
    public static func updateRespone(
        _ response: Response,
        for request: Request,
        with result: ApiResult) throws
    {
        switch result {
        case .string(let string):
            response.contentType = .text
            response.string = string
        case .redirect(let to):
            response.status = .found
            response.headers["Location"] = to
        case .status(let status):
            response.status = status
        case .json(let object):
            try Coder.encode(object: object, to: response, contentType: .json)
        case .object(let object):
            // TODO: respect Request.Accept
            switch object {
            case let string as String:
                if response.contentType == nil {
                    response.contentType = .text
                }
                response.string = string
            default:
                try Coder.encode(
                    object: object,
                    to: response,
                    contentType: .json)
            }
        }
    }

    @usableFromInline
    static func encode(
        object: Encodable,
        to response: Response,
        contentType type: ApplicationSubtype) throws
    {
        switch type {
        case .json:
            // TODO: Use stream + chunked?
            let bytes = try JSON.encode(encodable: object)
            response.bytes = bytes
            response.contentLength = bytes.count
            response.contentType = .json

        case .formURLEncoded:
            let bytes = try FormURLEncoded.encode(encodable: object)
            response.bytes = bytes
            response.contentLength = bytes.count
            response.contentType = .formURLEncoded

        default:
            throw ParseError.unsupportedContentType
        }
    }

    // MARK: Transform route's Model from Request

    @inlinable
    public static func decodeModel<Model: Decodable>(
        _ type: Model.Type,
        from request: Request) throws -> Model
    {
        switch request.method {
        case .get:
            let values = request.url.query?.values ?? [:]
            return try KeyValueDecoder().decode(type, from: values)

        default:
            guard let contentType = request.contentType else {
                throw Error.invalidRequest
            }

            switch contentType.mediaType {
            case .application(.json):
                return try decodeJSON(type, from: request)

            case .application(.formURLEncoded):
                return try decodeFormEncoded(type, from: request)

            default:
                throw Error.invalidContentType
            }
        }
    }

    @inlinable
    public static func decodeModel<Model: Decodable, Message: DecodableMessage>(
        _ type: Model.Type,
        from message: Message) throws -> Model
    {
        guard let contentType = message.contentType else {
            throw Error.invalidRequest
        }

        switch contentType.mediaType {
        case .application(.json):
            return try decodeJSON(type, from: message)

        case .application(.formURLEncoded):
            return try decodeFormEncoded(type, from: message)

        default:
            throw Error.invalidContentType
        }
    }

    @inlinable
    public static func decodeJSON<Model: Decodable, Message: DecodableMessage>(
        _ type: Model.Type,
        from message: Message) throws -> Model
    {
        switch message.body {
        case .bytes(let bytes):
            let stream = InputByteStream(bytes)
            return try JSON.decode(type, from: stream)
        case .input(let reader):
            return try JSON.decode(type, from: reader)
        default:
            throw Error.invalidRequest
        }
    }

    @inlinable
    public static func decodeFormEncoded<Model, Message>(
        _ type: Model.Type,
        from message: Message) throws -> Model
        where Model: Decodable, Message: DecodableMessage
    {
        // TODO: Use stream
        guard let bytes = message.bytes else {
            throw Error.invalidRequest
        }
        let values = try URL.Query(from: bytes).values
        return try KeyValueDecoder().decode(type, from: values)
    }
}

extension UnsafeRawInputStream {
    @usableFromInline
    convenience init(_ bytes: UnsafeRawBufferPointer) {
        self.init(pointer: bytes.baseAddress!, count: bytes.count)
    }
}
