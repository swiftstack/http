public enum HTTPError: Error {
    case invalidRequest
    case invalidResponse
    case invalidURL
    case invalidMethod
    case invalidStatus
    case invalidVersion
    case invalidHeaderName
    case invalidHeaderValue
    case invalidHost
    case invalidPort
    case invalidContentType
    case invalidContentEncoding
    case invalidMediaType
    case invalidBoundary
    case invalidCookie
    case invalidSetCookie
    case invalidLanguage
    case unsupportedMediaType
    case unsupportedContentType
    case unsupportedAcceptCharset
    case unsupportedAuthorization
    case unexpectedEnd
}
