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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        guard let slashIndex = bytes.index(of: Character.slash) else {
            throw HTTPError.invalidMediaType
        }

        let mediaType = bytes[..<slashIndex]

        let subtypeIndex = slashIndex + 1
        let subtype = bytes[subtypeIndex...]

        switch mediaType.lowercasedHashValue {
        case Bytes.application.lowercasedHashValue:
            self = .application(try ApplicationSubtype(from: subtype))

        case Bytes.audio.lowercasedHashValue:
            self = .audio(try AudioSubtype(from: subtype))

        case Bytes.image.lowercasedHashValue:
            self = .image(try ImageSubtype(from: subtype))

        case Bytes.multipart.lowercasedHashValue:
            self = .multipart(try MultipartSubtype(from: subtype))

        case Bytes.text.lowercasedHashValue:
            self = .text(try TextSubtype(from: subtype))

        case Bytes.video.lowercasedHashValue:
            self = .video(try VideoSubtype(from: subtype))

        case Bytes.any.lowercasedHashValue:
            guard subtype.count == 1 &&
                subtype.first == Character.asterisk else {
                    throw HTTPError.unsupportedMediaType
            }
            self = .any

        default:
            throw HTTPError.unsupportedMediaType
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .application(let subtype):
            buffer.append(contentsOf: Bytes.application)
            buffer.append(Character.slash)
            subtype.encode(to: &buffer)
        case .audio(let subtype):
            buffer.append(contentsOf: Bytes.audio)
            buffer.append(Character.slash)
            subtype.encode(to: &buffer)
        case .image(let subtype):
            buffer.append(contentsOf: Bytes.image)
            buffer.append(Character.slash)
            subtype.encode(to: &buffer)
        case .multipart(let subtype):
            buffer.append(contentsOf: Bytes.multipart)
            buffer.append(Character.slash)
            subtype.encode(to: &buffer)
        case .text(let subtype):
            buffer.append(contentsOf: Bytes.text)
            buffer.append(Character.slash)
            subtype.encode(to: &buffer)
        case .video(let subtype):
            buffer.append(contentsOf: Bytes.video)
            buffer.append(Character.slash)
            subtype.encode(to: &buffer)
        case .any:
            buffer.append(Character.asterisk)
            buffer.append(Character.slash)
            buffer.append(Character.asterisk)
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
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

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .json: buffer.append(contentsOf: Bytes.json)
        case .javascript: buffer.append(contentsOf: Bytes.javascript)
        case .urlEncoded: buffer.append(contentsOf: Bytes.urlEncoded)
        case .stream: buffer.append(contentsOf: Bytes.stream)
        case .pdf: buffer.append(contentsOf: Bytes.pdf)
        case .zip: buffer.append(contentsOf: Bytes.zip)
        case .gzip: buffer.append(contentsOf: Bytes.gzip)
        case .xgzip: buffer.append(contentsOf: Bytes.xgzip)
        case .xml: buffer.append(contentsOf: Bytes.xml)
        case .xhtml: buffer.append(contentsOf: Bytes.xhtml)
        case .any: buffer.append(contentsOf: Bytes.any)
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
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

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .mp4: buffer.append(contentsOf: Bytes.mp4)
        case .aac: buffer.append(contentsOf: Bytes.aac)
        case .mpeg: buffer.append(contentsOf: Bytes.mpeg)
        case .webm: buffer.append(contentsOf: Bytes.webm)
        case .vorbis: buffer.append(contentsOf: Bytes.vorbis)
        case .any: buffer.append(contentsOf: Bytes.any)
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
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

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .gif: buffer.append(contentsOf: Bytes.gif)
        case .jpeg: buffer.append(contentsOf: Bytes.jpeg)
        case .png: buffer.append(contentsOf: Bytes.png)
        case .svg: buffer.append(contentsOf: Bytes.svg)
        case .tiff: buffer.append(contentsOf: Bytes.tiff)
        case .webp: buffer.append(contentsOf: Bytes.webp)
        case .any: buffer.append(contentsOf: Bytes.any)
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        switch bytes.lowercasedHashValue {
        case Bytes.formData.lowercasedHashValue: self = .formData
        case Bytes.any.lowercasedHashValue: self = .any
        default: throw HTTPError.unsupportedMediaType
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .formData: buffer.append(contentsOf: Bytes.formData)
        case .any: buffer.append(contentsOf: Bytes.any)
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
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

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .css: buffer.append(contentsOf: Bytes.css)
        case .csv: buffer.append(contentsOf: Bytes.csv)
        case .html: buffer.append(contentsOf: Bytes.html)
        case .plain: buffer.append(contentsOf: Bytes.plain)
        case .php: buffer.append(contentsOf: Bytes.php)
        case .xml: buffer.append(contentsOf: Bytes.xml)
        case .any: buffer.append(contentsOf: Bytes.any)
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
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

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .mpeg: buffer.append(contentsOf: Bytes.mpeg)
        case .mp4: buffer.append(contentsOf: Bytes.mp4)
        case .ogg: buffer.append(contentsOf: Bytes.ogg)
        case .quicktime: buffer.append(contentsOf: Bytes.quicktime)
        case .webm: buffer.append(contentsOf: Bytes.webm)
        case .any: buffer.append(contentsOf: Bytes.any)
        }
    }
}
