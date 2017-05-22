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
        switch (lhs.language, rhs.language) {
        case (.af, .af)       where lhs.priority == rhs.priority: return true
        case (.afZA, .afZA)   where lhs.priority == rhs.priority: return true
        case (.ar, .ar)       where lhs.priority == rhs.priority: return true
        case (.arAE, .arAE)   where lhs.priority == rhs.priority: return true
        case (.arBH, .arBH)   where lhs.priority == rhs.priority: return true
        case (.arDZ, .arDZ)   where lhs.priority == rhs.priority: return true
        case (.arEG, .arEG)   where lhs.priority == rhs.priority: return true
        case (.arIQ, .arIQ)   where lhs.priority == rhs.priority: return true
        case (.arJO, .arJO)   where lhs.priority == rhs.priority: return true
        case (.arKW, .arKW)   where lhs.priority == rhs.priority: return true
        case (.arLB, .arLB)   where lhs.priority == rhs.priority: return true
        case (.arLY, .arLY)   where lhs.priority == rhs.priority: return true
        case (.arMA, .arMA)   where lhs.priority == rhs.priority: return true
        case (.arOM, .arOM)   where lhs.priority == rhs.priority: return true
        case (.arQA, .arQA)   where lhs.priority == rhs.priority: return true
        case (.arSA, .arSA)   where lhs.priority == rhs.priority: return true
        case (.arSY, .arSY)   where lhs.priority == rhs.priority: return true
        case (.arTN, .arTN)   where lhs.priority == rhs.priority: return true
        case (.arYE, .arYE)   where lhs.priority == rhs.priority: return true
        case (.az, .az)       where lhs.priority == rhs.priority: return true
        case (.azAZ, .azAZ)   where lhs.priority == rhs.priority: return true
        case (.be, .be)       where lhs.priority == rhs.priority: return true
        case (.beBY, .beBY)   where lhs.priority == rhs.priority: return true
        case (.bg, .bg)       where lhs.priority == rhs.priority: return true
        case (.bgBG, .bgBG)   where lhs.priority == rhs.priority: return true
        case (.bsBA, .bsBA)   where lhs.priority == rhs.priority: return true
        case (.ca, .ca)       where lhs.priority == rhs.priority: return true
        case (.caES, .caES)   where lhs.priority == rhs.priority: return true
        case (.cs, .cs)       where lhs.priority == rhs.priority: return true
        case (.csCZ, .csCZ)   where lhs.priority == rhs.priority: return true
        case (.cy, .cy)       where lhs.priority == rhs.priority: return true
        case (.cyGB, .cyGB)   where lhs.priority == rhs.priority: return true
        case (.da, .da)       where lhs.priority == rhs.priority: return true
        case (.daDK, .daDK)   where lhs.priority == rhs.priority: return true
        case (.de, .de)       where lhs.priority == rhs.priority: return true
        case (.deAT, .deAT)   where lhs.priority == rhs.priority: return true
        case (.deCH, .deCH)   where lhs.priority == rhs.priority: return true
        case (.deDE, .deDE)   where lhs.priority == rhs.priority: return true
        case (.deLI, .deLI)   where lhs.priority == rhs.priority: return true
        case (.deLU, .deLU)   where lhs.priority == rhs.priority: return true
        case (.dv, .dv)       where lhs.priority == rhs.priority: return true
        case (.dvMV, .dvMV)   where lhs.priority == rhs.priority: return true
        case (.el, .el)       where lhs.priority == rhs.priority: return true
        case (.elGR, .elGR)   where lhs.priority == rhs.priority: return true
        case (.en, .en)       where lhs.priority == rhs.priority: return true
        case (.enAU, .enAU)   where lhs.priority == rhs.priority: return true
        case (.enBZ, .enBZ)   where lhs.priority == rhs.priority: return true
        case (.enCA, .enCA)   where lhs.priority == rhs.priority: return true
        case (.enCB, .enCB)   where lhs.priority == rhs.priority: return true
        case (.enGB, .enGB)   where lhs.priority == rhs.priority: return true
        case (.enIE, .enIE)   where lhs.priority == rhs.priority: return true
        case (.enJM, .enJM)   where lhs.priority == rhs.priority: return true
        case (.enNZ, .enNZ)   where lhs.priority == rhs.priority: return true
        case (.enPH, .enPH)   where lhs.priority == rhs.priority: return true
        case (.enTT, .enTT)   where lhs.priority == rhs.priority: return true
        case (.enUS, .enUS)   where lhs.priority == rhs.priority: return true
        case (.enZA, .enZA)   where lhs.priority == rhs.priority: return true
        case (.enZW, .enZW)   where lhs.priority == rhs.priority: return true
        case (.eo, .eo)       where lhs.priority == rhs.priority: return true
        case (.es, .es)       where lhs.priority == rhs.priority: return true
        case (.esAR, .esAR)   where lhs.priority == rhs.priority: return true
        case (.esBO, .esBO)   where lhs.priority == rhs.priority: return true
        case (.esCL, .esCL)   where lhs.priority == rhs.priority: return true
        case (.esCO, .esCO)   where lhs.priority == rhs.priority: return true
        case (.esCR, .esCR)   where lhs.priority == rhs.priority: return true
        case (.esDO, .esDO)   where lhs.priority == rhs.priority: return true
        case (.esEC, .esEC)   where lhs.priority == rhs.priority: return true
        case (.esES, .esES)   where lhs.priority == rhs.priority: return true
        case (.esGT, .esGT)   where lhs.priority == rhs.priority: return true
        case (.esHN, .esHN)   where lhs.priority == rhs.priority: return true
        case (.esMX, .esMX)   where lhs.priority == rhs.priority: return true
        case (.esNI, .esNI)   where lhs.priority == rhs.priority: return true
        case (.esPA, .esPA)   where lhs.priority == rhs.priority: return true
        case (.esPE, .esPE)   where lhs.priority == rhs.priority: return true
        case (.esPR, .esPR)   where lhs.priority == rhs.priority: return true
        case (.esPY, .esPY)   where lhs.priority == rhs.priority: return true
        case (.esSV, .esSV)   where lhs.priority == rhs.priority: return true
        case (.esUY, .esUY)   where lhs.priority == rhs.priority: return true
        case (.esVE, .esVE)   where lhs.priority == rhs.priority: return true
        case (.et, .et)       where lhs.priority == rhs.priority: return true
        case (.etEE, .etEE)   where lhs.priority == rhs.priority: return true
        case (.eu, .eu)       where lhs.priority == rhs.priority: return true
        case (.euES, .euES)   where lhs.priority == rhs.priority: return true
        case (.fa, .fa)       where lhs.priority == rhs.priority: return true
        case (.faIR, .faIR)   where lhs.priority == rhs.priority: return true
        case (.fi, .fi)       where lhs.priority == rhs.priority: return true
        case (.fiFI, .fiFI)   where lhs.priority == rhs.priority: return true
        case (.fo, .fo)       where lhs.priority == rhs.priority: return true
        case (.foFO, .foFO)   where lhs.priority == rhs.priority: return true
        case (.fr, .fr)       where lhs.priority == rhs.priority: return true
        case (.frBE, .frBE)   where lhs.priority == rhs.priority: return true
        case (.frCA, .frCA)   where lhs.priority == rhs.priority: return true
        case (.frCH, .frCH)   where lhs.priority == rhs.priority: return true
        case (.frFR, .frFR)   where lhs.priority == rhs.priority: return true
        case (.frLU, .frLU)   where lhs.priority == rhs.priority: return true
        case (.frMC, .frMC)   where lhs.priority == rhs.priority: return true
        case (.gl, .gl)       where lhs.priority == rhs.priority: return true
        case (.glES, .glES)   where lhs.priority == rhs.priority: return true
        case (.gu, .gu)       where lhs.priority == rhs.priority: return true
        case (.guIN, .guIN)   where lhs.priority == rhs.priority: return true
        case (.he, .he)       where lhs.priority == rhs.priority: return true
        case (.heIL, .heIL)   where lhs.priority == rhs.priority: return true
        case (.hi, .hi)       where lhs.priority == rhs.priority: return true
        case (.hiIN, .hiIN)   where lhs.priority == rhs.priority: return true
        case (.hr, .hr)       where lhs.priority == rhs.priority: return true
        case (.hrBA, .hrBA)   where lhs.priority == rhs.priority: return true
        case (.hrHR, .hrHR)   where lhs.priority == rhs.priority: return true
        case (.hu, .hu)       where lhs.priority == rhs.priority: return true
        case (.huHU, .huHU)   where lhs.priority == rhs.priority: return true
        case (.hy, .hy)       where lhs.priority == rhs.priority: return true
        case (.hyAM, .hyAM)   where lhs.priority == rhs.priority: return true
        case (.id, .id)       where lhs.priority == rhs.priority: return true
        case (.idID, .idID)   where lhs.priority == rhs.priority: return true
        case (.is, .is)       where lhs.priority == rhs.priority: return true
        case (.isIS, .isIS)   where lhs.priority == rhs.priority: return true
        case (.it, .it)       where lhs.priority == rhs.priority: return true
        case (.itCH, .itCH)   where lhs.priority == rhs.priority: return true
        case (.itIT, .itIT)   where lhs.priority == rhs.priority: return true
        case (.ja, .ja)       where lhs.priority == rhs.priority: return true
        case (.jaJP, .jaJP)   where lhs.priority == rhs.priority: return true
        case (.ka, .ka)       where lhs.priority == rhs.priority: return true
        case (.kaGE, .kaGE)   where lhs.priority == rhs.priority: return true
        case (.kk, .kk)       where lhs.priority == rhs.priority: return true
        case (.kkKZ, .kkKZ)   where lhs.priority == rhs.priority: return true
        case (.kn, .kn)       where lhs.priority == rhs.priority: return true
        case (.knIN, .knIN)   where lhs.priority == rhs.priority: return true
        case (.ko, .ko)       where lhs.priority == rhs.priority: return true
        case (.koKR, .koKR)   where lhs.priority == rhs.priority: return true
        case (.kok, .kok)     where lhs.priority == rhs.priority: return true
        case (.kokIN, .kokIN) where lhs.priority == rhs.priority: return true
        case (.ky, .ky)       where lhs.priority == rhs.priority: return true
        case (.kyKG, .kyKG)   where lhs.priority == rhs.priority: return true
        case (.lt, .lt)       where lhs.priority == rhs.priority: return true
        case (.ltLT, .ltLT)   where lhs.priority == rhs.priority: return true
        case (.lv, .lv)       where lhs.priority == rhs.priority: return true
        case (.lvLV, .lvLV)   where lhs.priority == rhs.priority: return true
        case (.mi, .mi)       where lhs.priority == rhs.priority: return true
        case (.miNZ, .miNZ)   where lhs.priority == rhs.priority: return true
        case (.mk, .mk)       where lhs.priority == rhs.priority: return true
        case (.mkMK, .mkMK)   where lhs.priority == rhs.priority: return true
        case (.mn, .mn)       where lhs.priority == rhs.priority: return true
        case (.mnMN, .mnMN)   where lhs.priority == rhs.priority: return true
        case (.mr, .mr)       where lhs.priority == rhs.priority: return true
        case (.mrIN, .mrIN)   where lhs.priority == rhs.priority: return true
        case (.ms, .ms)       where lhs.priority == rhs.priority: return true
        case (.msBN, .msBN)   where lhs.priority == rhs.priority: return true
        case (.msMY, .msMY)   where lhs.priority == rhs.priority: return true
        case (.mt, .mt)       where lhs.priority == rhs.priority: return true
        case (.mtMT, .mtMT)   where lhs.priority == rhs.priority: return true
        case (.nb, .nb)       where lhs.priority == rhs.priority: return true
        case (.nbNO, .nbNO)   where lhs.priority == rhs.priority: return true
        case (.nl, .nl)       where lhs.priority == rhs.priority: return true
        case (.nlBE, .nlBE)   where lhs.priority == rhs.priority: return true
        case (.nlNL, .nlNL)   where lhs.priority == rhs.priority: return true
        case (.nnNO, .nnNO)   where lhs.priority == rhs.priority: return true
        case (.ns, .ns)       where lhs.priority == rhs.priority: return true
        case (.nsZA, .nsZA)   where lhs.priority == rhs.priority: return true
        case (.pa, .pa)       where lhs.priority == rhs.priority: return true
        case (.paIN, .paIN)   where lhs.priority == rhs.priority: return true
        case (.pl, .pl)       where lhs.priority == rhs.priority: return true
        case (.plPL, .plPL)   where lhs.priority == rhs.priority: return true
        case (.ps, .ps)       where lhs.priority == rhs.priority: return true
        case (.psAR, .psAR)   where lhs.priority == rhs.priority: return true
        case (.pt, .pt)       where lhs.priority == rhs.priority: return true
        case (.ptBR, .ptBR)   where lhs.priority == rhs.priority: return true
        case (.ptPT, .ptPT)   where lhs.priority == rhs.priority: return true
        case (.qu, .qu)       where lhs.priority == rhs.priority: return true
        case (.quBO, .quBO)   where lhs.priority == rhs.priority: return true
        case (.quEC, .quEC)   where lhs.priority == rhs.priority: return true
        case (.quPE, .quPE)   where lhs.priority == rhs.priority: return true
        case (.ro, .ro)       where lhs.priority == rhs.priority: return true
        case (.roRO, .roRO)   where lhs.priority == rhs.priority: return true
        case (.ru, .ru)       where lhs.priority == rhs.priority: return true
        case (.ruRU, .ruRU)   where lhs.priority == rhs.priority: return true
        case (.sa, .sa)       where lhs.priority == rhs.priority: return true
        case (.saIN, .saIN)   where lhs.priority == rhs.priority: return true
        case (.se, .se)       where lhs.priority == rhs.priority: return true
        case (.seFI, .seFI)   where lhs.priority == rhs.priority: return true
        case (.seNO, .seNO)   where lhs.priority == rhs.priority: return true
        case (.seSE, .seSE)   where lhs.priority == rhs.priority: return true
        case (.sk, .sk)       where lhs.priority == rhs.priority: return true
        case (.skSK, .skSK)   where lhs.priority == rhs.priority: return true
        case (.sl, .sl)       where lhs.priority == rhs.priority: return true
        case (.slSI, .slSI)   where lhs.priority == rhs.priority: return true
        case (.sq, .sq)       where lhs.priority == rhs.priority: return true
        case (.sqAL, .sqAL)   where lhs.priority == rhs.priority: return true
        case (.srBA, .srBA)   where lhs.priority == rhs.priority: return true
        case (.srSP, .srSP)   where lhs.priority == rhs.priority: return true
        case (.sv, .sv)       where lhs.priority == rhs.priority: return true
        case (.svFI, .svFI)   where lhs.priority == rhs.priority: return true
        case (.svSE, .svSE)   where lhs.priority == rhs.priority: return true
        case (.sw, .sw)       where lhs.priority == rhs.priority: return true
        case (.swKE, .swKE)   where lhs.priority == rhs.priority: return true
        case (.syr, .syr)     where lhs.priority == rhs.priority: return true
        case (.syrSY, .syrSY) where lhs.priority == rhs.priority: return true
        case (.ta, .ta)       where lhs.priority == rhs.priority: return true
        case (.taIN, .taIN)   where lhs.priority == rhs.priority: return true
        case (.te, .te)       where lhs.priority == rhs.priority: return true
        case (.teIN, .teIN)   where lhs.priority == rhs.priority: return true
        case (.th, .th)       where lhs.priority == rhs.priority: return true
        case (.thTH, .thTH)   where lhs.priority == rhs.priority: return true
        case (.tl, .tl)       where lhs.priority == rhs.priority: return true
        case (.tlPH, .tlPH)   where lhs.priority == rhs.priority: return true
        case (.tn, .tn)       where lhs.priority == rhs.priority: return true
        case (.tnZA, .tnZA)   where lhs.priority == rhs.priority: return true
        case (.tr, .tr)       where lhs.priority == rhs.priority: return true
        case (.trTR, .trTR)   where lhs.priority == rhs.priority: return true
        case (.tt, .tt)       where lhs.priority == rhs.priority: return true
        case (.ttRU, .ttRU)   where lhs.priority == rhs.priority: return true
        case (.ts, .ts)       where lhs.priority == rhs.priority: return true
        case (.uk, .uk)       where lhs.priority == rhs.priority: return true
        case (.ukUA, .ukUA)   where lhs.priority == rhs.priority: return true
        case (.ur, .ur)       where lhs.priority == rhs.priority: return true
        case (.urPK, .urPK)   where lhs.priority == rhs.priority: return true
        case (.uz, .uz)       where lhs.priority == rhs.priority: return true
        case (.uzUZ, .uzUZ)   where lhs.priority == rhs.priority: return true
        case (.vi, .vi)       where lhs.priority == rhs.priority: return true
        case (.viVN, .viVN)   where lhs.priority == rhs.priority: return true
        case (.xh, .xh)       where lhs.priority == rhs.priority: return true
        case (.xhZA, .xhZA)   where lhs.priority == rhs.priority: return true
        case (.zh, .zh)       where lhs.priority == rhs.priority: return true
        case (.zhCN, .zhCN)   where lhs.priority == rhs.priority: return true
        case (.zhHK, .zhHK)   where lhs.priority == rhs.priority: return true
        case (.zhMO, .zhMO)   where lhs.priority == rhs.priority: return true
        case (.zhSG, .zhSG)   where lhs.priority == rhs.priority: return true
        case (.zhTW, .zhTW)   where lhs.priority == rhs.priority: return true
        case (.zu, .zu)       where lhs.priority == rhs.priority: return true
        case (.zuZA, .zuZA)   where lhs.priority == rhs.priority: return true
        case (.any, .any)     where lhs.priority == rhs.priority: return true
        case let (.custom(lhsValue), .custom(rhsValue))
            where lhsValue == rhsValue && lhs.priority == rhs.priority:
            return true
        default:
            return false
        }
    }
}

extension Array where Element == Request.AcceptLanguage {
    public typealias AcceptLanguage = Request.AcceptLanguage

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var startIndex = bytes.startIndex
        var endIndex = startIndex
        var values = [AcceptLanguage]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: Character.comma, offset: startIndex) ??
                bytes.endIndex
            values.append(
                try AcceptLanguage(from: bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == Character.whitespace {
                    startIndex += 1
            }
        }
        self = values
    }

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(Character.comma)
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension Request.AcceptLanguage {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        if let semicolon = bytes.index(of: Character.semicolon) {
            self.language = try Language(from: bytes[..<semicolon])

            let index = semicolon.advanced(by: 1)
            let bytes = UnsafeRawBufferPointer(rebasing: bytes[index...])
            guard bytes.count == 5,
                bytes.starts(with: Bytes.qEqual),
                let priority = Double(String(buffer: bytes[2...])) else {
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
            buffer.append(Character.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
