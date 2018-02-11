import JSON

// MARK: Coder

@_versioned
struct Coder {
    public enum Error: Swift.Error {
        case invalidRequest
        case invalidContentType
    }

    // MARK: Transform convenient router result into Response

    @_versioned
    @inline(__always)
    static func makeRespone<T: Encodable>(
        for request: Request,
        encoding object: T
    ) throws -> Response {
        let response = Response(status: .ok)
        try Coder.updateRespone(response, for: request, encoding: object)
        return response
    }

    @_versioned
    @inline(__always)
    static func updateRespone<T: Encodable>(
        _ response: Response,
        for request: Request,
        encoding object: T
    ) throws {
        // TODO: respect Request.Accept

        switch object {
        case let string as String:
            response.contentType = .text
            response.string = string
        case let value as Optional<Any> where value == nil:
            fallthrough
        case is Void:
            response.status = .noContent
            response.body = .none
        default:
            try Coder.encode(object: object, to: response, contentType: .json)
        }
    }

    @_versioned
    static func encode(
        object: Encodable,
        to response: Response,
        contentType type: ApplicationSubtype
    ) throws {
        switch type {
        case .json:
            let bytes = try JSONEncoder().encode(object)
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

    @_versioned
    @inline(__always)
    static func decodeModel<T: Decodable>(
        _ type: T.Type,
        from request: Request
    ) throws -> T {
        switch request.method {
        case .get:
            let values = request.url.query?.values ?? [:]
            return try KeyValueDecoder().decode(type, from: values)

        default:
            guard let body = request.bytes,
                let contentType = request.contentType else {
                    throw Error.invalidRequest
            }

            switch contentType.mediaType {
            case .application(.json):
                return try JSONDecoder().decode(type, from: body)

            case .application(.formURLEncoded):
                let values = try URL.Query(from: body).values
                return try KeyValueDecoder().decode(type, from: values)

            default:
                throw Error.invalidContentType
            }
        }
    }
}
