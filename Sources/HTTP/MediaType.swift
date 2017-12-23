public enum MediaType {
    case application(ApplicationSubtype)
    case audio(AudioSubtype)
    case image(ImageSubtype)
    case multipart(MultipartSubtype)
    case text(TextSubtype)
    case video(VideoSubtype)
    case any
}

public enum ApplicationSubtype {
    case json
    case javascript
    case urlFormEncoded
    case stream
    case pdf
    case zip
    case gzip
    case xgzip
    case xml
    case xhtml
    case any
}

public enum AudioSubtype {
    case mp4
    case aac
    case mpeg
    case webm
    case vorbis
    case any
}

public enum ImageSubtype {
    case gif
    case jpeg
    case png
    case svg
    case tiff
    case webp
    case any
}

public enum MultipartSubtype {
    case formData
    case any
}

public enum TextSubtype {
    case css
    case csv
    case html
    case plain
    case php
    case xml
    case any
}

public enum VideoSubtype {
    case mpeg
    case mp4
    case ogg
    case quicktime
    case webm
    case any
}

extension MediaType: Equatable {
    public static func ==(lhs: MediaType, rhs: MediaType) -> Bool {
        switch (lhs, rhs) {
        case let (.application(lhs), .application(rhs)): return lhs == rhs
        case let (.audio(lhs), .audio(rhs)): return lhs == rhs
        case let (.image(lhs), .image(rhs)): return lhs == rhs
        case let (.multipart(lhs), .multipart(rhs)): return lhs == rhs
        case let (.text(lhs), .text(rhs)): return lhs == rhs
        case let (.video(lhs), .video(rhs)): return lhs == rhs
        case (.any, .any): return true
        default: return false
        }
    }
}
