import Stream

public enum MediaType {
    case application(ApplicationSubtype)
    case audio(AudioSubtype)
    case image(ImageSubtype)
    case multipart(MultipartSubtype)
    case text(TextSubtype)
    case video(VideoSubtype)
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

extension MediaType {
    private struct Bytes {
        static let application = ASCII("application")
        static let audio = ASCII("audio")
        static let image = ASCII("image")
        static let multipart = ASCII("multipart")
        static let text = ASCII("text")
        static let video = ASCII("video")
        static let any = ASCII("*")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var buffer = try stream.read(until: .slash)
        guard buffer.count > 0 else {
            throw HTTPError.invalidMediaTypeHeader
        }
        try stream.consume(count: 1)
        let hashValue = buffer.lowercasedHashValue

        buffer = try stream.read(allowedBytes: .token)

        switch hashValue {
        case Bytes.application.lowercasedHashValue:
            self = .application(try ApplicationSubtype(from: buffer))

        case Bytes.audio.lowercasedHashValue:
            self = .audio(try AudioSubtype(from: buffer))

        case Bytes.image.lowercasedHashValue:
            self = .image(try ImageSubtype(from: buffer))

        case Bytes.multipart.lowercasedHashValue:
            self = .multipart(try MultipartSubtype(from: buffer))

        case Bytes.text.lowercasedHashValue:
            self = .text(try TextSubtype(from: buffer))

        case Bytes.video.lowercasedHashValue:
            self = .video(try VideoSubtype(from: buffer))

        case Bytes.any.lowercasedHashValue:
            guard buffer.count == 1 && buffer.first == .asterisk else {
                throw HTTPError.unsupportedMediaType
            }
            self = .any

        default:
            throw HTTPError.unsupportedMediaType
        }
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
        switch self {
        case .application(let subtype):
            try stream.write(Bytes.application)
            try stream.write(.slash)
            try stream.write(subtype.rawValue)
        case .audio(let subtype):
            try stream.write(Bytes.audio)
            try stream.write(.slash)
            try stream.write(subtype.rawValue)
        case .image(let subtype):
            try stream.write(Bytes.image)
            try stream.write(.slash)
            try stream.write(subtype.rawValue)
        case .multipart(let subtype):
            try stream.write(Bytes.multipart)
            try stream.write(.slash)
            try stream.write(subtype.rawValue)
        case .text(let subtype):
            try stream.write(Bytes.text)
            try stream.write(.slash)
            try stream.write(subtype.rawValue)
        case .video(let subtype):
            try stream.write(Bytes.video)
            try stream.write(.slash)
            try stream.write(subtype.rawValue)
        case .any:
            try stream.write(.asterisk)
            try stream.write(.slash)
            try stream.write(.asterisk)
        }
    }
}

public enum ApplicationSubtype {
    case json
    case javascript
    case urlEncoded
    case stream
    case pdf
    case zip
    case gzip
    case xgzip
    case xml
    case xhtml
    case any
}

extension ApplicationSubtype {
    private struct Bytes {
        static let json = ASCII("json")
        static let javascript = ASCII("javascript")
        static let urlEncoded = ASCII("x-www-form-urlencoded")
        static let stream = ASCII("stream")
        static let pdf = ASCII("pdf")
        static let zip = ASCII("zip")
        static let gzip = ASCII("gzip")
        static let xgzip = ASCII("x-gzip")
        static let xml = ASCII("xml")
        static let xhtml = ASCII("xhtml+xml")
        static let any = ASCII("*")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.json.lowercasedHashValue: self = .json
        case Bytes.javascript.lowercasedHashValue: self = .javascript
        case Bytes.urlEncoded.lowercasedHashValue: self = .urlEncoded
        case Bytes.stream.lowercasedHashValue: self = .stream
        case Bytes.pdf.lowercasedHashValue: self = .pdf
        case Bytes.zip.lowercasedHashValue: self = .zip
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.xgzip.lowercasedHashValue: self = .xgzip
        case Bytes.xml.lowercasedHashValue: self = .xml
        case Bytes.xhtml.lowercasedHashValue: self = .xhtml
        case Bytes.any.lowercasedHashValue:  self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .json: return Bytes.json
        case .javascript: return Bytes.javascript
        case .urlEncoded: return Bytes.urlEncoded
        case .stream: return Bytes.stream
        case .pdf: return Bytes.pdf
        case .zip: return Bytes.zip
        case .gzip: return Bytes.gzip
        case .xgzip: return Bytes.xgzip
        case .xml: return Bytes.xml
        case .xhtml: return Bytes.xhtml
        case .any: return Bytes.any
        }
    }
}

public enum AudioSubtype {
    case mp4
    case aac
    case mpeg
    case webm
    case vorbis
    case any
}

extension AudioSubtype {
    private struct Bytes {
        static let mp4 = ASCII("mp4")
        static let aac = ASCII("aac")
        static let mpeg = ASCII("mpeg")
        static let webm = ASCII("webm")
        static let vorbis = ASCII("vorbis")
        static let any = ASCII("*")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.mp4.lowercasedHashValue: self = .mp4
        case Bytes.aac.lowercasedHashValue: self = .aac
        case Bytes.mpeg.lowercasedHashValue: self = .mpeg
        case Bytes.webm.lowercasedHashValue: self = .webm
        case Bytes.vorbis.lowercasedHashValue: self = .vorbis
        case Bytes.any.lowercasedHashValue: self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .mp4: return Bytes.mp4
        case .aac: return Bytes.aac
        case .mpeg: return Bytes.mpeg
        case .webm: return Bytes.webm
        case .vorbis: return Bytes.vorbis
        case .any: return Bytes.any
        }
    }
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

extension ImageSubtype {
    private struct Bytes {
        static let gif = ASCII("gif")
        static let jpeg = ASCII("jpeg")
        static let png = ASCII("png")
        static let svg = ASCII("svg")
        static let tiff = ASCII("tiff")
        static let webp = ASCII("webp")
        static let any = ASCII("*")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.gif.lowercasedHashValue: self = .gif
        case Bytes.jpeg.lowercasedHashValue: self = .jpeg
        case Bytes.png.lowercasedHashValue: self = .png
        case Bytes.svg.lowercasedHashValue: self = .svg
        case Bytes.tiff.lowercasedHashValue: self = .tiff
        case Bytes.webp.lowercasedHashValue: self = .webp
        case Bytes.any.lowercasedHashValue: self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .gif: return Bytes.gif
        case .jpeg: return Bytes.jpeg
        case .png: return Bytes.png
        case .svg: return Bytes.svg
        case .tiff: return Bytes.tiff
        case .webp: return Bytes.webp
        case .any: return Bytes.any
        }
    }
}

public enum MultipartSubtype {
    case formData
    case any
}

extension MultipartSubtype {
    private struct Bytes {
        static let formData = ASCII("form-data")
        static let any = ASCII("*")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.formData.lowercasedHashValue: self = .formData
        case Bytes.any.lowercasedHashValue: self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .formData: return Bytes.formData
        case .any: return Bytes.any
        }
    }
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

extension TextSubtype {
    private struct Bytes {
        static let css = ASCII("css")
        static let csv = ASCII("csv")
        static let html = ASCII("html")
        static let plain = ASCII("plain")
        static let php = ASCII("php")
        static let xml = ASCII("xml")
        static let any = ASCII("*")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.css.lowercasedHashValue: self = .css
        case Bytes.csv.lowercasedHashValue: self = .csv
        case Bytes.html.lowercasedHashValue: self = .html
        case Bytes.plain.lowercasedHashValue: self = .plain
        case Bytes.php.lowercasedHashValue: self = .php
        case Bytes.xml.lowercasedHashValue: self = .xml
        case Bytes.any.lowercasedHashValue: self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .css: return Bytes.css
        case .csv: return Bytes.csv
        case .html: return Bytes.html
        case .plain: return Bytes.plain
        case .php: return Bytes.php
        case .xml: return Bytes.xml
        case .any: return Bytes.any
        }
    }
}

public enum VideoSubtype {
    case mpeg
    case mp4
    case ogg
    case quicktime
    case webm
    case any
}

extension VideoSubtype {
    private struct Bytes {
        static let mpeg = ASCII("mpeg")
        static let mp4 = ASCII("mp4")
        static let ogg = ASCII("ogg")
        static let quicktime = ASCII("quicktime")
        static let webm = ASCII("webm")
        static let any = ASCII("*")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.mpeg.lowercasedHashValue: self = .mpeg
        case Bytes.mp4.lowercasedHashValue: self = .mp4
        case Bytes.ogg.lowercasedHashValue: self = .ogg
        case Bytes.quicktime.lowercasedHashValue: self = .quicktime
        case Bytes.webm.lowercasedHashValue: self = .webm
        case Bytes.any.lowercasedHashValue: self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .mpeg: return Bytes.mpeg
        case .mp4: return Bytes.mp4
        case .ogg: return Bytes.ogg
        case .quicktime: return Bytes.quicktime
        case .webm: return Bytes.webm
        case .any: return Bytes.any
        }
    }
}
