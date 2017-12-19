public enum HTTPError: Error {
    case invalidRequest
    case invalidResponse
    case invalidURL
    case invalidMethod
    case invalidStatus
    case invalidVersion
    case invalidHeaderName
    case invalidHost
    case invalidPort
    case invalidAcceptHeader
    case invalidAcceptLanguageHeader
    case invalidAcceptCharsetHeader
    case invalidAuthorizationHeader
    case invalidContentTypeHeader
    case invalidContentEncodingHeader
    case invalidTransferEncodingHeader
    case invalidMediaTypeHeader
    case invalidBoundary
    case invalidCookieHeader
    case invalidSetCookieHeader
    case invalidLanguageHeader
    case unsupportedMediaType
    case unsupportedContentType
    case unsupportedAcceptCharset
    case unsupportedAuthorization
    case unexpectedEnd
}
