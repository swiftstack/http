public enum ApiResult {
    case redirect(to: String)
    case status(Response.Status)
    case object(Encodable)
    case json(Encodable)
    case string(String)
}
