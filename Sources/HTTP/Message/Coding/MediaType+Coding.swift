import Stream

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

    init<T: StreamReader>(from stream: T) throws {
        let hashValue = try stream.read(until: .slash) { bytes -> Int in
            guard bytes.count > 0 else {
                throw ParseError.invalidMediaTypeHeader
            }
            try stream.consume(count: 1)
            return bytes.lowercasedHashValue
        }

        switch hashValue {
        case Bytes.application.lowercasedHashValue:
            self = .application(try ApplicationSubtype(from: stream))

        case Bytes.audio.lowercasedHashValue:
            self = .audio(try AudioSubtype(from: stream))

        case Bytes.image.lowercasedHashValue:
            self = .image(try ImageSubtype(from: stream))

        case Bytes.multipart.lowercasedHashValue:
            self = .multipart(try MultipartSubtype(from: stream))

        case Bytes.text.lowercasedHashValue:
            self = .text(try TextSubtype(from: stream))

        case Bytes.video.lowercasedHashValue:
            self = .video(try VideoSubtype(from: stream))

        case Bytes.any.lowercasedHashValue:
            guard try stream.consume(.asterisk) else {
                throw ParseError.unsupportedMediaType
            }
            self = .any

        default:
            throw ParseError.unsupportedMediaType
        }
    }

    func encode<T: StreamWriter>(to stream: T) throws {
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

extension ApplicationSubtype {
    private struct Bytes {
        static let json = ASCII("json")
        static let javascript = ASCII("javascript")
        static let formURLEncoded = ASCII("x-www-form-urlencoded")
        static let stream = ASCII("stream")
        static let pdf = ASCII("pdf")
        static let zip = ASCII("zip")
        static let gzip = ASCII("gzip")
        static let xgzip = ASCII("x-gzip")
        static let xml = ASCII("xml")
        static let xhtml = ASCII("xhtml+xml")
        static let any = ASCII("*")
    }

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.json.lowercasedHashValue: return .json
            case Bytes.javascript.lowercasedHashValue: return .javascript
            case Bytes.formURLEncoded.lowercasedHashValue: return .formURLEncoded
            case Bytes.stream.lowercasedHashValue: return .stream
            case Bytes.pdf.lowercasedHashValue: return .pdf
            case Bytes.zip.lowercasedHashValue: return .zip
            case Bytes.gzip.lowercasedHashValue: return .gzip
            case Bytes.xgzip.lowercasedHashValue: return .xgzip
            case Bytes.xml.lowercasedHashValue: return .xml
            case Bytes.xhtml.lowercasedHashValue: return .xhtml
            case Bytes.any.lowercasedHashValue:  return .any
            default: throw ParseError.unsupportedMediaType
            }
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .json: return Bytes.json
        case .javascript: return Bytes.javascript
        case .formURLEncoded: return Bytes.formURLEncoded
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

extension AudioSubtype {
    private struct Bytes {
        static let mp4 = ASCII("mp4")
        static let aac = ASCII("aac")
        static let mpeg = ASCII("mpeg")
        static let webm = ASCII("webm")
        static let vorbis = ASCII("vorbis")
        static let any = ASCII("*")
    }

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.mp4.lowercasedHashValue: return .mp4
            case Bytes.aac.lowercasedHashValue: return .aac
            case Bytes.mpeg.lowercasedHashValue: return .mpeg
            case Bytes.webm.lowercasedHashValue: return .webm
            case Bytes.vorbis.lowercasedHashValue: return .vorbis
            case Bytes.any.lowercasedHashValue: return .any
            default: throw ParseError.unsupportedMediaType
            }
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

extension ImageSubtype {
    private struct Bytes {
        static let gif = ASCII("gif")
        static let jpeg = ASCII("jpeg")
        static let apng = ASCII("apng")
        static let png = ASCII("png")
        static let svg = ASCII("svg")
        static let svgXML = ASCII("svg+xml")
        static let tiff = ASCII("tiff")
        static let webp = ASCII("webp")
        static let any = ASCII("*")
    }

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.gif.lowercasedHashValue: return .gif
            case Bytes.jpeg.lowercasedHashValue: return .jpeg
            case Bytes.apng.lowercasedHashValue: return .apng
            case Bytes.png.lowercasedHashValue: return .png
            case Bytes.svg.lowercasedHashValue: return .svg
            case Bytes.svgXML.lowercasedHashValue: return .svgXML
            case Bytes.tiff.lowercasedHashValue: return .tiff
            case Bytes.webp.lowercasedHashValue: return .webp
            case Bytes.any.lowercasedHashValue: return .any
            default: throw ParseError.unsupportedMediaType
            }
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .gif: return Bytes.gif
        case .jpeg: return Bytes.jpeg
        case .png: return Bytes.png
        case .apng: return Bytes.apng
        case .svg: return Bytes.svg
        case .svgXML: return Bytes.svgXML
        case .tiff: return Bytes.tiff
        case .webp: return Bytes.webp
        case .any: return Bytes.any
        }
    }
}

extension MultipartSubtype {
    private struct Bytes {
        static let formData = ASCII("form-data")
        static let any = ASCII("*")
    }

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.formData.lowercasedHashValue: return .formData
            case Bytes.any.lowercasedHashValue: return .any
            default: throw ParseError.unsupportedMediaType
            }
        }
    }

    var rawValue: [UInt8] {
        switch self {
        case .formData: return Bytes.formData
        case .any: return Bytes.any
        }
    }
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

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.css.lowercasedHashValue: return .css
            case Bytes.csv.lowercasedHashValue: return .csv
            case Bytes.html.lowercasedHashValue: return .html
            case Bytes.plain.lowercasedHashValue: return .plain
            case Bytes.php.lowercasedHashValue: return .php
            case Bytes.xml.lowercasedHashValue: return .xml
            case Bytes.any.lowercasedHashValue: return .any
            default: throw ParseError.unsupportedMediaType
            }
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

extension VideoSubtype {
    private struct Bytes {
        static let mpeg = ASCII("mpeg")
        static let mp4 = ASCII("mp4")
        static let ogg = ASCII("ogg")
        static let quicktime = ASCII("quicktime")
        static let webm = ASCII("webm")
        static let any = ASCII("*")
    }

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.mpeg.lowercasedHashValue: return .mpeg
            case Bytes.mp4.lowercasedHashValue: return .mp4
            case Bytes.ogg.lowercasedHashValue: return .ogg
            case Bytes.quicktime.lowercasedHashValue: return .quicktime
            case Bytes.webm.lowercasedHashValue: return .webm
            case Bytes.any.lowercasedHashValue: return .any
            default: throw ParseError.unsupportedMediaType
            }
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
