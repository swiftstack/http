import URL
import JSON
import Stream
import Network

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
        encoding object: T) async throws -> Response
    {
        let response = Response(status: .ok)
        try await Coder.updateRespone(response, for: request, with: .object(object))
        return response
    }

    @inline(__always)
    public static func updateRespone(
        _ response: Response,
        for request: Request,
        with result: ApiResult) async throws
    {
        switch result {
        case .string(let string):
            response.contentType = .text
            response.body = .output(string)
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
                response.body = .output(string)
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
            response.body = .output(bytes)
            response.contentLength = bytes.count
            response.contentType = .json

        case .formURLEncoded:
            let bytes = try FormURLEncoded.encode(encodable: object)
            response.body = .output(bytes)
            response.contentLength = bytes.count
            response.contentType = .formURLEncoded

        default:
            throw HTTP.Error.unsupportedContentType
        }
    }

    // MARK: Transform route's Model from Request

    @inlinable
    public static func getDecoder(for request: Request)
        async throws -> Swift.Decoder
    {
        switch request.method {
        case .get:
            let values = request.url.query?.values ?? [:]
            return KeyValueDecoder(values)

        default:
            return try await getBodyDecoder(for: request)
        }
    }

    @inlinable
    public static func getDecoder<Message>(for message: Message)
        async throws -> Swift.Decoder where Message: DecodableMessage
    {
        return try await getBodyDecoder(for: message)
    }

    @inlinable
    public static func getBodyDecoder<Message>(for message: Message)
        async throws -> Swift.Decoder where Message: DecodableMessage
    {
        guard let contentType = message.contentType else {
            throw Error.invalidRequest
        }

        switch contentType.mediaType {
        case .application(.json):
            return try await getJSONDecoder(for: message)
        case .application(.formURLEncoded):
            return try await getFormDecoder(for: message)

        default:
            throw Error.invalidContentType
        }
    }

    @inlinable
    public static func getJSONDecoder<Message>(for message: Message) async throws
        -> Swift.Decoder where Message: DecodableMessage
    {
        switch message.body {
        case .input(let reader):
            let json = try await JSON.Value.decode(from: reader)
            return try JSON.Decoder(json)
        // @testable
        case .output(let writer):
            let stream = OutputByteStream()
            try await writer(stream)
            let reader = InputByteStream(stream.bytes)
            let json = try await JSON.Value.decode(from: reader)
            return try JSON.Decoder(json)
        }
    }

    @inlinable
    public static func getFormDecoder<Message>(for message: Message) async throws
        -> Swift.Decoder where Message: DecodableMessage
    {
        // TODO: Use stream
        let bytes = try await message.readBody()
        let values = try URL.Query(from: bytes).values
        return KeyValueDecoder(values)
    }

    @inlinable
    public static func decode<Model: Decodable>(
        _ type: Model.Type,
        from request: Request) async throws -> Model
    {
        let decoder = try await getDecoder(for: request)
        return try type.init(from: decoder)
    }

    @inlinable
    public static func decode<Model: Decodable, Message: DecodableMessage>(
        _ type: Model.Type,
        from message: Message) async throws -> Model
    {
        let decoder = try await getDecoder(for: message)
        return try type.init(from: decoder)
    }
}
