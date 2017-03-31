import Foundation

extension Request {
    public enum ContentType: String {
        case urlEncoded = "application/x-www-form-urlencoded"
        case json = "application/json"
    }
}
