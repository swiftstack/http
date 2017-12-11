extension Request {
    public struct AcceptLanguage {
        public let language: Language
        public let priority: Double

        public init(_ language: Language, priority: Double = 1.0) {
            self.language = language
            self.priority = priority
        }
    }
}

extension Request.AcceptLanguage: Equatable {
    public typealias AcceptLanguage = Request.AcceptLanguage
    public static func ==(lhs: AcceptLanguage, rhs: AcceptLanguage) -> Bool {
        guard lhs.priority == rhs.priority else {
            return false
        }
        switch (lhs.language, rhs.language) {
        case (.af, .af)      : return true
        case (.afZA, .afZA)  : return true
        case (.ar, .ar)      : return true
        case (.arAE, .arAE)  : return true
        case (.arBH, .arBH)  : return true
        case (.arDZ, .arDZ)  : return true
        case (.arEG, .arEG)  : return true
        case (.arIQ, .arIQ)  : return true
        case (.arJO, .arJO)  : return true
        case (.arKW, .arKW)  : return true
        case (.arLB, .arLB)  : return true
        case (.arLY, .arLY)  : return true
        case (.arMA, .arMA)  : return true
        case (.arOM, .arOM)  : return true
        case (.arQA, .arQA)  : return true
        case (.arSA, .arSA)  : return true
        case (.arSY, .arSY)  : return true
        case (.arTN, .arTN)  : return true
        case (.arYE, .arYE)  : return true
        case (.az, .az)      : return true
        case (.azAZ, .azAZ)  : return true
        case (.be, .be)      : return true
        case (.beBY, .beBY)  : return true
        case (.bg, .bg)      : return true
        case (.bgBG, .bgBG)  : return true
        case (.bsBA, .bsBA)  : return true
        case (.ca, .ca)      : return true
        case (.caES, .caES)  : return true
        case (.cs, .cs)      : return true
        case (.csCZ, .csCZ)  : return true
        case (.cy, .cy)      : return true
        case (.cyGB, .cyGB)  : return true
        case (.da, .da)      : return true
        case (.daDK, .daDK)  : return true
        case (.de, .de)      : return true
        case (.deAT, .deAT)  : return true
        case (.deCH, .deCH)  : return true
        case (.deDE, .deDE)  : return true
        case (.deLI, .deLI)  : return true
        case (.deLU, .deLU)  : return true
        case (.dv, .dv)      : return true
        case (.dvMV, .dvMV)  : return true
        case (.el, .el)      : return true
        case (.elGR, .elGR)  : return true
        case (.en, .en)      : return true
        case (.enAU, .enAU)  : return true
        case (.enBZ, .enBZ)  : return true
        case (.enCA, .enCA)  : return true
        case (.enCB, .enCB)  : return true
        case (.enGB, .enGB)  : return true
        case (.enIE, .enIE)  : return true
        case (.enJM, .enJM)  : return true
        case (.enNZ, .enNZ)  : return true
        case (.enPH, .enPH)  : return true
        case (.enTT, .enTT)  : return true
        case (.enUS, .enUS)  : return true
        case (.enZA, .enZA)  : return true
        case (.enZW, .enZW)  : return true
        case (.eo, .eo)      : return true
        case (.es, .es)      : return true
        case (.esAR, .esAR)  : return true
        case (.esBO, .esBO)  : return true
        case (.esCL, .esCL)  : return true
        case (.esCO, .esCO)  : return true
        case (.esCR, .esCR)  : return true
        case (.esDO, .esDO)  : return true
        case (.esEC, .esEC)  : return true
        case (.esES, .esES)  : return true
        case (.esGT, .esGT)  : return true
        case (.esHN, .esHN)  : return true
        case (.esMX, .esMX)  : return true
        case (.esNI, .esNI)  : return true
        case (.esPA, .esPA)  : return true
        case (.esPE, .esPE)  : return true
        case (.esPR, .esPR)  : return true
        case (.esPY, .esPY)  : return true
        case (.esSV, .esSV)  : return true
        case (.esUY, .esUY)  : return true
        case (.esVE, .esVE)  : return true
        case (.et, .et)      : return true
        case (.etEE, .etEE)  : return true
        case (.eu, .eu)      : return true
        case (.euES, .euES)  : return true
        case (.fa, .fa)      : return true
        case (.faIR, .faIR)  : return true
        case (.fi, .fi)      : return true
        case (.fiFI, .fiFI)  : return true
        case (.fo, .fo)      : return true
        case (.foFO, .foFO)  : return true
        case (.fr, .fr)      : return true
        case (.frBE, .frBE)  : return true
        case (.frCA, .frCA)  : return true
        case (.frCH, .frCH)  : return true
        case (.frFR, .frFR)  : return true
        case (.frLU, .frLU)  : return true
        case (.frMC, .frMC)  : return true
        case (.gl, .gl)      : return true
        case (.glES, .glES)  : return true
        case (.gu, .gu)      : return true
        case (.guIN, .guIN)  : return true
        case (.he, .he)      : return true
        case (.heIL, .heIL)  : return true
        case (.hi, .hi)      : return true
        case (.hiIN, .hiIN)  : return true
        case (.hr, .hr)      : return true
        case (.hrBA, .hrBA)  : return true
        case (.hrHR, .hrHR)  : return true
        case (.hu, .hu)      : return true
        case (.huHU, .huHU)  : return true
        case (.hy, .hy)      : return true
        case (.hyAM, .hyAM)  : return true
        case (.id, .id)      : return true
        case (.idID, .idID)  : return true
        case (.is, .is)      : return true
        case (.isIS, .isIS)  : return true
        case (.it, .it)      : return true
        case (.itCH, .itCH)  : return true
        case (.itIT, .itIT)  : return true
        case (.ja, .ja)      : return true
        case (.jaJP, .jaJP)  : return true
        case (.ka, .ka)      : return true
        case (.kaGE, .kaGE)  : return true
        case (.kk, .kk)      : return true
        case (.kkKZ, .kkKZ)  : return true
        case (.kn, .kn)      : return true
        case (.knIN, .knIN)  : return true
        case (.ko, .ko)      : return true
        case (.koKR, .koKR)  : return true
        case (.kok, .kok)    : return true
        case (.kokIN, .kokIN): return true
        case (.ky, .ky)      : return true
        case (.kyKG, .kyKG)  : return true
        case (.lt, .lt)      : return true
        case (.ltLT, .ltLT)  : return true
        case (.lv, .lv)      : return true
        case (.lvLV, .lvLV)  : return true
        case (.mi, .mi)      : return true
        case (.miNZ, .miNZ)  : return true
        case (.mk, .mk)      : return true
        case (.mkMK, .mkMK)  : return true
        case (.mn, .mn)      : return true
        case (.mnMN, .mnMN)  : return true
        case (.mr, .mr)      : return true
        case (.mrIN, .mrIN)  : return true
        case (.ms, .ms)      : return true
        case (.msBN, .msBN)  : return true
        case (.msMY, .msMY)  : return true
        case (.mt, .mt)      : return true
        case (.mtMT, .mtMT)  : return true
        case (.nb, .nb)      : return true
        case (.nbNO, .nbNO)  : return true
        case (.nl, .nl)      : return true
        case (.nlBE, .nlBE)  : return true
        case (.nlNL, .nlNL)  : return true
        case (.nnNO, .nnNO)  : return true
        case (.ns, .ns)      : return true
        case (.nsZA, .nsZA)  : return true
        case (.pa, .pa)      : return true
        case (.paIN, .paIN)  : return true
        case (.pl, .pl)      : return true
        case (.plPL, .plPL)  : return true
        case (.ps, .ps)      : return true
        case (.psAR, .psAR)  : return true
        case (.pt, .pt)      : return true
        case (.ptBR, .ptBR)  : return true
        case (.ptPT, .ptPT)  : return true
        case (.qu, .qu)      : return true
        case (.quBO, .quBO)  : return true
        case (.quEC, .quEC)  : return true
        case (.quPE, .quPE)  : return true
        case (.ro, .ro)      : return true
        case (.roRO, .roRO)  : return true
        case (.ru, .ru)      : return true
        case (.ruRU, .ruRU)  : return true
        case (.sa, .sa)      : return true
        case (.saIN, .saIN)  : return true
        case (.se, .se)      : return true
        case (.seFI, .seFI)  : return true
        case (.seNO, .seNO)  : return true
        case (.seSE, .seSE)  : return true
        case (.sk, .sk)      : return true
        case (.skSK, .skSK)  : return true
        case (.sl, .sl)      : return true
        case (.slSI, .slSI)  : return true
        case (.sq, .sq)      : return true
        case (.sqAL, .sqAL)  : return true
        case (.srBA, .srBA)  : return true
        case (.srSP, .srSP)  : return true
        case (.sv, .sv)      : return true
        case (.svFI, .svFI)  : return true
        case (.svSE, .svSE)  : return true
        case (.sw, .sw)      : return true
        case (.swKE, .swKE)  : return true
        case (.syr, .syr)    : return true
        case (.syrSY, .syrSY): return true
        case (.ta, .ta)      : return true
        case (.taIN, .taIN)  : return true
        case (.te, .te)      : return true
        case (.teIN, .teIN)  : return true
        case (.th, .th)      : return true
        case (.thTH, .thTH)  : return true
        case (.tl, .tl)      : return true
        case (.tlPH, .tlPH)  : return true
        case (.tn, .tn)      : return true
        case (.tnZA, .tnZA)  : return true
        case (.tr, .tr)      : return true
        case (.trTR, .trTR)  : return true
        case (.tt, .tt)      : return true
        case (.ttRU, .ttRU)  : return true
        case (.ts, .ts)      : return true
        case (.uk, .uk)      : return true
        case (.ukUA, .ukUA)  : return true
        case (.ur, .ur)      : return true
        case (.urPK, .urPK)  : return true
        case (.uz, .uz)      : return true
        case (.uzUZ, .uzUZ)  : return true
        case (.vi, .vi)      : return true
        case (.viVN, .viVN)  : return true
        case (.xh, .xh)      : return true
        case (.xhZA, .xhZA)  : return true
        case (.zh, .zh)      : return true
        case (.zhCN, .zhCN)  : return true
        case (.zhHK, .zhHK)  : return true
        case (.zhMO, .zhMO)  : return true
        case (.zhSG, .zhSG)  : return true
        case (.zhTW, .zhTW)  : return true
        case (.zu, .zu)      : return true
        case (.zuZA, .zuZA)  : return true
        case (.any, .any)    : return true
        case let (.custom(lsh), .custom(rhs)): return lsh == rhs
        default: return false
        }
    }
}

extension Array where Element == Request.AcceptLanguage {
    public typealias AcceptLanguage = Request.AcceptLanguage

    init(from bytes: UnsafeRawBufferPointer.SubSequence) throws {
        var startIndex = bytes.startIndex
        var endIndex = startIndex
        var values = [AcceptLanguage]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: .comma, offset: startIndex) ??
                bytes.endIndex
            values.append(
                try AcceptLanguage(from: bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == .whitespace {
                    startIndex += 1
            }
        }
        self = values
    }

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(.comma)
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension Request.AcceptLanguage {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init(from bytes: UnsafeRawBufferPointer.SubSequence) throws {
        if let semicolon = bytes.index(of: .semicolon) {
            self.language = try Language(from: bytes[..<semicolon])

            let index = semicolon.advanced(by: 1)
            let bytes = UnsafeRawBufferPointer(rebasing: bytes[index...])
            guard bytes.count == 5,
                bytes.starts(with: Bytes.qEqual),
                let priority = Double(from: bytes[2...]) else {
                    throw HTTPError.invalidHeaderValue
            }
            self.priority = priority
        } else {
            self.language = try Language(from: bytes)
            self.priority = 1.0
        }
    }

    func encode(to buffer: inout [UInt8]) {
        language.encode(to: &buffer)

        if priority < 1.0 {
            buffer.append(.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
