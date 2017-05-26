enum HTTPError: Error {
    case invalidRequest
    case invalidResponse
    case invalidURL
    case invalidMethod
    case invalidStatus
    case invalidVersion
    case invalidHeaderName
    case invalidHeaderValue
    case invalidContentType
    case invalidMediaType
    case invalidBoundary
    case invalidCookie
    case unsupportedMediaType
    case unsupportedContentType
    case unsupportedAcceptCharset
    case unsupportedAuthorization
    case unexpectedEnd
}
