extension Request {
    public struct AcceptLanguage: Equatable {
        public let language: Language
        public let priority: Double

        public init(_ language: Language, priority: Double = 1.0) {
            self.language = language
            self.priority = priority
        }
    }
}
