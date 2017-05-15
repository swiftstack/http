public enum Language {
    case af
    case afZA
    case ar
    case arAE
    case arBH
    case arDZ
    case arEG
    case arIQ
    case arJO
    case arKW
    case arLB
    case arLY
    case arMA
    case arOM
    case arQA
    case arSA
    case arSY
    case arTN
    case arYE
    case az
    case azAZ
    case be
    case beBY
    case bg
    case bgBG
    case bsBA
    case ca
    case caES
    case cs
    case csCZ
    case cy
    case cyGB
    case da
    case daDK
    case de
    case deAT
    case deCH
    case deDE
    case deLI
    case deLU
    case dv
    case dvMV
    case el
    case elGR
    case en
    case enAU
    case enBZ
    case enCA
    case enCB
    case enGB
    case enIE
    case enJM
    case enNZ
    case enPH
    case enTT
    case enUS
    case enZA
    case enZW
    case eo
    case es
    case esAR
    case esBO
    case esCL
    case esCO
    case esCR
    case esDO
    case esEC
    case esES
    case esGT
    case esHN
    case esMX
    case esNI
    case esPA
    case esPE
    case esPR
    case esPY
    case esSV
    case esUY
    case esVE
    case et
    case etEE
    case eu
    case euES
    case fa
    case faIR
    case fi
    case fiFI
    case fo
    case foFO
    case fr
    case frBE
    case frCA
    case frCH
    case frFR
    case frLU
    case frMC
    case gl
    case glES
    case gu
    case guIN
    case he
    case heIL
    case hi
    case hiIN
    case hr
    case hrBA
    case hrHR
    case hu
    case huHU
    case hy
    case hyAM
    case id
    case idID
    case `is`
    case isIS
    case it
    case itCH
    case itIT
    case ja
    case jaJP
    case ka
    case kaGE
    case kk
    case kkKZ
    case kn
    case knIN
    case ko
    case koKR
    case kok
    case kokIN
    case ky
    case kyKG
    case lt
    case ltLT
    case lv
    case lvLV
    case mi
    case miNZ
    case mk
    case mkMK
    case mn
    case mnMN
    case mr
    case mrIN
    case ms
    case msBN
    case msMY
    case mt
    case mtMT
    case nb
    case nbNO
    case nl
    case nlBE
    case nlNL
    case nnNO
    case ns
    case nsZA
    case pa
    case paIN
    case pl
    case plPL
    case ps
    case psAR
    case pt
    case ptBR
    case ptPT
    case qu
    case quBO
    case quEC
    case quPE
    case ro
    case roRO
    case ru
    case ruRU
    case sa
    case saIN
    case se
    case seFI
    case seNO
    case seSE
    case sk
    case skSK
    case sl
    case slSI
    case sq
    case sqAL
    case srBA
    case srSP
    case sv
    case svFI
    case svSE
    case sw
    case swKE
    case syr
    case syrSY
    case ta
    case taIN
    case te
    case teIN
    case th
    case thTH
    case tl
    case tlPH
    case tn
    case tnZA
    case tr
    case trTR
    case tt
    case ttRU
    case ts
    case uk
    case ukUA
    case ur
    case urPK
    case uz
    case uzUZ
    case vi
    case viVN
    case xh
    case xhZA
    case zh
    case zhCN
    case zhHK
    case zhMO
    case zhSG
    case zhTW
    case zu
    case zuZA
    case any
    case custom(String)
}

public struct AcceptLanguage {
    public let language: Language
    public let priority: Double

    public init(_ language: Language, priority: Double = 1.0) {
        self.language = language
        self.priority = priority
    }
}

extension AcceptLanguage: Equatable {
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

extension Array where Element == AcceptLanguage {
    init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = 0
        var values = [AcceptLanguage]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: Character.comma, offset: startIndex) ??
                bytes.endIndex
            let value = try AcceptLanguage(from: bytes[startIndex..<endIndex])
            values.append(value)
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

extension AcceptLanguage {
    struct Bytes {
        static let af    = ASCII("af")     // Afrikaans
        static let afZA  = ASCII("af-ZA")  // Afrikaans (South Africa)
        static let ar    = ASCII("ar")     // Arabic
        static let arAE  = ASCII("ar-AE")  // Arabic (U.A.E.)
        static let arBH  = ASCII("ar-BH")  // Arabic (Bahrain)
        static let arDZ  = ASCII("ar-DZ")  // Arabic (Algeria)
        static let arEG  = ASCII("ar-EG")  // Arabic (Egypt)
        static let arIQ  = ASCII("ar-IQ")  // Arabic (Iraq)
        static let arJO  = ASCII("ar-JO")  // Arabic (Jordan)
        static let arKW  = ASCII("ar-KW")  // Arabic (Kuwait)
        static let arLB  = ASCII("ar-LB")  // Arabic (Lebanon)
        static let arLY  = ASCII("ar-LY")  // Arabic (Libya)
        static let arMA  = ASCII("ar-MA")  // Arabic (Morocco)
        static let arOM  = ASCII("ar-OM")  // Arabic (Oman)
        static let arQA  = ASCII("ar-QA")  // Arabic (Qatar)
        static let arSA  = ASCII("ar-SA")  // Arabic (Saudi Arabia)
        static let arSY  = ASCII("ar-SY")  // Arabic (Syria)
        static let arTN  = ASCII("ar-TN")  // Arabic (Tunisia)
        static let arYE  = ASCII("ar-YE")  // Arabic (Yemen)
        static let az    = ASCII("az")     // Azeri (Latin)
        static let azAZ  = ASCII("az-AZ")  // Azeri (Azerbaijan)
        static let be    = ASCII("be")     // Belarusian
        static let beBY  = ASCII("be-BY")  // Belarusian (Belarus)
        static let bg    = ASCII("bg")     // Bulgarian
        static let bgBG  = ASCII("bg-BG")  // Bulgarian (Bulgaria)
        static let bsBA  = ASCII("bs-BA")  // Bosnian (Bosnia and Herzegovina)
        static let ca    = ASCII("ca")     // Catalan
        static let caES  = ASCII("ca-ES")  // Catalan (Spain)
        static let cs    = ASCII("cs")     // Czech
        static let csCZ  = ASCII("cs-CZ")  // Czech (Czech Republic)
        static let cy    = ASCII("cy")     // Welsh
        static let cyGB  = ASCII("cy-GB")  // Welsh (United Kingdom)
        static let da    = ASCII("da")     // Danish
        static let daDK  = ASCII("da-DK")  // Danish (Denmark)
        static let de    = ASCII("de")     // German
        static let deAT  = ASCII("de-AT")  // German (Austria)
        static let deCH  = ASCII("de-CH")  // German (Switzerland)
        static let deDE  = ASCII("de-DE")  // German (Germany)
        static let deLI  = ASCII("de-LI")  // German (Liechtenstein)
        static let deLU  = ASCII("de-LU")  // German (Luxembourg)
        static let dv    = ASCII("dv")     // Divehi
        static let dvMV  = ASCII("dv-MV")  // Divehi (Maldives)
        static let el    = ASCII("el")     // Greek
        static let elGR  = ASCII("el-GR")  // Greek (Greece)
        static let en    = ASCII("en")     // English
        static let enAU  = ASCII("en-AU")  // English (Australia)
        static let enBZ  = ASCII("en-BZ")  // English (Belize)
        static let enCA  = ASCII("en-CA")  // English (Canada)
        static let enCB  = ASCII("en-CB")  // English (Caribbean)
        static let enGB  = ASCII("en-GB")  // English (United Kingdom)
        static let enIE  = ASCII("en-IE")  // English (Ireland)
        static let enJM  = ASCII("en-JM")  // English (Jamaica)
        static let enNZ  = ASCII("en-NZ")  // English (New Zealand)
        static let enPH  = ASCII("en-PH")  // English (Republic of the Philippines)
        static let enTT  = ASCII("en-TT")  // English (Trinidad and Tobago)
        static let enUS  = ASCII("en-US")  // English (United States)
        static let enZA  = ASCII("en-ZA")  // English (South Africa)
        static let enZW  = ASCII("en-ZW")  // English (Zimbabwe)
        static let eo    = ASCII("eo")     // Esperanto
        static let es    = ASCII("es")     // Spanish
        static let esAR  = ASCII("es-AR")  // Spanish (Argentina)
        static let esBO  = ASCII("es-BO")  // Spanish (Bolivia)
        static let esCL  = ASCII("es-CL")  // Spanish (Chile)
        static let esCO  = ASCII("es-CO")  // Spanish (Colombia)
        static let esCR  = ASCII("es-CR")  // Spanish (Costa Rica)
        static let esDO  = ASCII("es-DO")  // Spanish (Dominican Republic)
        static let esEC  = ASCII("es-EC")  // Spanish (Ecuador)
        static let esES  = ASCII("es-ES")  // Spanish (Castilian, Spain)
        static let esGT  = ASCII("es-GT")  // Spanish (Guatemala)
        static let esHN  = ASCII("es-HN")  // Spanish (Honduras)
        static let esMX  = ASCII("es-MX")  // Spanish (Mexico)
        static let esNI  = ASCII("es-NI")  // Spanish (Nicaragua)
        static let esPA  = ASCII("es-PA")  // Spanish (Panama)
        static let esPE  = ASCII("es-PE")  // Spanish (Peru)
        static let esPR  = ASCII("es-PR")  // Spanish (Puerto Rico)
        static let esPY  = ASCII("es-PY")  // Spanish (Paraguay)
        static let esSV  = ASCII("es-SV")  // Spanish (El Salvador)
        static let esUY  = ASCII("es-UY")  // Spanish (Uruguay)
        static let esVE  = ASCII("es-VE")  // Spanish (Venezuela)
        static let et    = ASCII("et")     // Estonian
        static let etEE  = ASCII("et-EE")  // Estonian (Estonia)
        static let eu    = ASCII("eu")     // Basque
        static let euES  = ASCII("eu-ES")  // Basque (Spain)
        static let fa    = ASCII("fa")     // Farsi
        static let faIR  = ASCII("fa-IR")  // Farsi (Iran)
        static let fi    = ASCII("fi")     // Finnish
        static let fiFI  = ASCII("fi-FI")  // Finnish (Finland)
        static let fo    = ASCII("fo")     // Faroese
        static let foFO  = ASCII("fo-FO")  // Faroese (Faroe Islands)
        static let fr    = ASCII("fr")     // French
        static let frBE  = ASCII("fr-BE")  // French (Belgium)
        static let frCA  = ASCII("fr-CA")  // French (Canada)
        static let frCH  = ASCII("fr-CH")  // French (Switzerland)
        static let frFR  = ASCII("fr-FR")  // French (France)
        static let frLU  = ASCII("fr-LU")  // French (Luxembourg)
        static let frMC  = ASCII("fr-MC")  // French (Principality of Monaco)
        static let gl    = ASCII("gl")     // Galician
        static let glES  = ASCII("gl-ES")  // Galician (Spain)
        static let gu    = ASCII("gu")     // Gujarati
        static let guIN  = ASCII("gu-IN")  // Gujarati (India)
        static let he    = ASCII("he")     // Hebrew
        static let heIL  = ASCII("he-IL")  // Hebrew (Israel)
        static let hi    = ASCII("hi")     // Hindi
        static let hiIN  = ASCII("hi-IN")  // Hindi (India)
        static let hr    = ASCII("hr")     // Croatian
        static let hrBA  = ASCII("hr-BA")  // Croatian (Bosnia and Herzegovina)
        static let hrHR  = ASCII("hr-HR")  // Croatian (Croatia)
        static let hu    = ASCII("hu")     // Hungarian
        static let huHU  = ASCII("hu-HU")  // Hungarian (Hungary)
        static let hy    = ASCII("hy")     // Armenian
        static let hyAM  = ASCII("hy-AM")  // Armenian (Armenia)
        static let id    = ASCII("id")     // Indonesian
        static let idID  = ASCII("id-ID")  // Indonesian (Indonesia)
        static let `is`  = ASCII("is")     // Icelandic
        static let isIS  = ASCII("is-IS")  // Icelandic (Iceland)
        static let it    = ASCII("it")     // Italian
        static let itCH  = ASCII("it-CH")  // Italian (Switzerland)
        static let itIT  = ASCII("it-IT")  // Italian (Italy)
        static let ja    = ASCII("ja")     // Japanese
        static let jaJP  = ASCII("ja-JP")  // Japanese (Japan)
        static let ka    = ASCII("ka")     // Georgian
        static let kaGE  = ASCII("ka-GE")  // Georgian (Georgia)
        static let kk    = ASCII("kk")     // Kazakh
        static let kkKZ  = ASCII("kk-KZ")  // Kazakh (Kazakhstan)
        static let kn    = ASCII("kn")     // Kannada
        static let knIN  = ASCII("kn-IN")  // Kannada (India)
        static let ko    = ASCII("ko")     // Korean
        static let koKR  = ASCII("ko-KR")  // Korean (Korea)
        static let kok   = ASCII("kok")    // Konkani
        static let kokIN = ASCII("kok-IN") // Konkani (India)
        static let ky    = ASCII("ky")     // Kyrgyz
        static let kyKG  = ASCII("ky-KG")  // Kyrgyz (Kyrgyzstan)
        static let lt    = ASCII("lt")     // Lithuanian
        static let ltLT  = ASCII("lt-LT")  // Lithuanian (Lithuania)
        static let lv    = ASCII("lv")     // Latvian
        static let lvLV  = ASCII("lv-LV")  // Latvian (Latvia)
        static let mi    = ASCII("mi")     // Maori
        static let miNZ  = ASCII("mi-NZ")  // Maori (New Zealand)
        static let mk    = ASCII("mk")     // FYRO Macedonian
        static let mkMK  = ASCII("mk-MK")  // FYRO Macedonian (Former Yugoslav Republic of Macedonia)
        static let mn    = ASCII("mn")     // Mongolian
        static let mnMN  = ASCII("mn-MN")  // Mongolian (Mongolia)
        static let mr    = ASCII("mr")     // Marathi
        static let mrIN  = ASCII("mr-IN")  // Marathi (India)
        static let ms    = ASCII("ms")     // Malay
        static let msBN  = ASCII("ms-BN")  // Malay (Brunei Darussalam)
        static let msMY  = ASCII("ms-MY")  // Malay (Malaysia)
        static let mt    = ASCII("mt")     // Maltese
        static let mtMT  = ASCII("mt-MT")  // Maltese (Malta)
        static let nb    = ASCII("nb")     // Norwegian (Bokm?l)
        static let nbNO  = ASCII("nb-NO")  // Norwegian (Bokm?l) (Norway)
        static let nl    = ASCII("nl")     // Dutch
        static let nlBE  = ASCII("nl-BE")  // Dutch (Belgium)
        static let nlNL  = ASCII("nl-NL")  // Dutch (Netherlands)
        static let nnNO  = ASCII("nn-NO")  // Norwegian (Nynorsk) (Norway)
        static let ns    = ASCII("ns")     // Northern Sotho
        static let nsZA  = ASCII("ns-ZA")  // Northern Sotho (South Africa)
        static let pa    = ASCII("pa")     // Punjabi
        static let paIN  = ASCII("pa-IN")  // Punjabi (India)
        static let pl    = ASCII("pl")     // Polish
        static let plPL  = ASCII("pl-PL")  // Polish (Poland)
        static let ps    = ASCII("ps")     // Pashto
        static let psAR  = ASCII("ps-AR")  // Pashto (Afghanistan)
        static let pt    = ASCII("pt")     // Portuguese
        static let ptBR  = ASCII("pt-BR")  // Portuguese (Brazil)
        static let ptPT  = ASCII("pt-PT")  // Portuguese (Portugal)
        static let qu    = ASCII("qu")     // Quechua
        static let quBO  = ASCII("qu-BO")  // Quechua (Bolivia)
        static let quEC  = ASCII("qu-EC")  // Quechua (Ecuador)
        static let quPE  = ASCII("qu-PE")  // Quechua (Peru)
        static let ro    = ASCII("ro")     // Romanian
        static let roRO  = ASCII("ro-RO")  // Romanian (Romania)
        static let ru    = ASCII("ru")     // Russian
        static let ruRU  = ASCII("ru-RU")  // Russian (Russia)
        static let sa    = ASCII("sa")     // Sanskrit
        static let saIN  = ASCII("sa-IN")  // Sanskrit (India)
        static let se    = ASCII("se")     // Sami (Northern)
        static let seFI  = ASCII("se-FI")  // Sami (Finland)
        static let seNO  = ASCII("se-NO")  // Sami (Norway)
        static let seSE  = ASCII("se-SE")  // Sami (Sweden)
        static let sk    = ASCII("sk")     // Slovak
        static let skSK  = ASCII("sk-SK")  // Slovak (Slovakia)
        static let sl    = ASCII("sl")     // Slovenian
        static let slSI  = ASCII("sl-SI")  // Slovenian (Slovenia)
        static let sq    = ASCII("sq")     // Albanian
        static let sqAL  = ASCII("sq-AL")  // Albanian (Albania)
        static let srBA  = ASCII("sr-BA")  // Serbian (Bosnia and Herzegovina)
        static let srSP  = ASCII("sr-SP")  // Serbian (Serbia and Montenegro)
        static let sv    = ASCII("sv")     // Swedish
        static let svFI  = ASCII("sv-FI")  // Swedish (Finland)
        static let svSE  = ASCII("sv-SE")  // Swedish (Sweden)
        static let sw    = ASCII("sw")     // Swahili
        static let swKE  = ASCII("sw-KE")  // Swahili (Kenya)
        static let syr   = ASCII("syr")    // Syriac
        static let syrSY = ASCII("syr-SY") // Syriac (Syria)
        static let ta    = ASCII("ta")     // Tamil
        static let taIN  = ASCII("ta-IN")  // Tamil (India)
        static let te    = ASCII("te")     // Telugu
        static let teIN  = ASCII("te-IN")  // Telugu (India)
        static let th    = ASCII("th")     // Thai
        static let thTH  = ASCII("th-TH")  // Thai (Thailand)
        static let tl    = ASCII("tl")     // Tagalog
        static let tlPH  = ASCII("tl-PH")  // Tagalog (Philippines)
        static let tn    = ASCII("tn")     // Tswana
        static let tnZA  = ASCII("tn-ZA")  // Tswana (South Africa)
        static let tr    = ASCII("tr")     // Turkish
        static let trTR  = ASCII("tr-TR")  // Turkish (Turkey)
        static let tt    = ASCII("tt")     // Tatar
        static let ttRU  = ASCII("tt-RU")  // Tatar (Russia)
        static let ts    = ASCII("ts")     // Tsonga
        static let uk    = ASCII("uk")     // Ukrainian
        static let ukUA  = ASCII("uk-UA")  // Ukrainian (Ukraine)
        static let ur    = ASCII("ur")     // Urdu
        static let urPK  = ASCII("ur-PK")  // Urdu (Islamic Republic of Pakistan)
        static let uz    = ASCII("uz")     // Uzbek (Latin)
        static let uzUZ  = ASCII("uz-UZ")  // Uzbek (Uzbekistan)
        static let vi    = ASCII("vi")     // Vietnamese
        static let viVN  = ASCII("vi-VN")  // Vietnamese (Viet Nam)
        static let xh    = ASCII("xh")     // Xhosa
        static let xhZA  = ASCII("xh-ZA")  // Xhosa (South Africa)
        static let zh    = ASCII("zh")     // Chinese
        static let zhCN  = ASCII("zh-CN")  // Chinese (S)
        static let zhHK  = ASCII("zh-HK")  // Chinese (Hong Kong)
        static let zhMO  = ASCII("zh-MO")  // Chinese (Macau)
        static let zhSG  = ASCII("zh-SG")  // Chinese (Singapore)
        static let zhTW  = ASCII("zh-TW")  // Chinese (T)
        static let zu    = ASCII("zu")     // Zulu
        static let zuZA  = ASCII("zu-ZA")  // Zulu (South Africa)

        static let any   = ASCII("*")

        static let qEqual = ASCII("q=")
    }

    init(from bytes: UnsafeRawBufferPointer) throws {
        let semicolonIndex = bytes.index(of: Character.semicolon, offset: 0)

        let valueEndIndex = semicolonIndex ?? bytes.endIndex
        let valueBytes = bytes.prefix(upTo: valueEndIndex)

        switch valueBytes.lowercasedHashValue {
        case Bytes.af.lowercasedHashValue:    self.language = .af
        case Bytes.afZA.lowercasedHashValue:  self.language = .afZA
        case Bytes.ar.lowercasedHashValue:    self.language = .ar
        case Bytes.arAE.lowercasedHashValue:  self.language = .arAE
        case Bytes.arBH.lowercasedHashValue:  self.language = .arBH
        case Bytes.arDZ.lowercasedHashValue:  self.language = .arDZ
        case Bytes.arEG.lowercasedHashValue:  self.language = .arEG
        case Bytes.arIQ.lowercasedHashValue:  self.language = .arIQ
        case Bytes.arJO.lowercasedHashValue:  self.language = .arJO
        case Bytes.arKW.lowercasedHashValue:  self.language = .arKW
        case Bytes.arLB.lowercasedHashValue:  self.language = .arLB
        case Bytes.arLY.lowercasedHashValue:  self.language = .arLY
        case Bytes.arMA.lowercasedHashValue:  self.language = .arMA
        case Bytes.arOM.lowercasedHashValue:  self.language = .arOM
        case Bytes.arQA.lowercasedHashValue:  self.language = .arQA
        case Bytes.arSA.lowercasedHashValue:  self.language = .arSA
        case Bytes.arSY.lowercasedHashValue:  self.language = .arSY
        case Bytes.arTN.lowercasedHashValue:  self.language = .arTN
        case Bytes.arYE.lowercasedHashValue:  self.language = .arYE
        case Bytes.az.lowercasedHashValue:    self.language = .az
        case Bytes.azAZ.lowercasedHashValue:  self.language = .azAZ
        case Bytes.be.lowercasedHashValue:    self.language = .be
        case Bytes.beBY.lowercasedHashValue:  self.language = .beBY
        case Bytes.bg.lowercasedHashValue:    self.language = .bg
        case Bytes.bgBG.lowercasedHashValue:  self.language = .bgBG
        case Bytes.bsBA.lowercasedHashValue:  self.language = .bsBA
        case Bytes.ca.lowercasedHashValue:    self.language = .ca
        case Bytes.caES.lowercasedHashValue:  self.language = .caES
        case Bytes.cs.lowercasedHashValue:    self.language = .cs
        case Bytes.csCZ.lowercasedHashValue:  self.language = .csCZ
        case Bytes.cy.lowercasedHashValue:    self.language = .cy
        case Bytes.cyGB.lowercasedHashValue:  self.language = .cyGB
        case Bytes.da.lowercasedHashValue:    self.language = .da
        case Bytes.daDK.lowercasedHashValue:  self.language = .daDK
        case Bytes.de.lowercasedHashValue:    self.language = .de
        case Bytes.deAT.lowercasedHashValue:  self.language = .deAT
        case Bytes.deCH.lowercasedHashValue:  self.language = .deCH
        case Bytes.deDE.lowercasedHashValue:  self.language = .deDE
        case Bytes.deLI.lowercasedHashValue:  self.language = .deLI
        case Bytes.deLU.lowercasedHashValue:  self.language = .deLU
        case Bytes.dv.lowercasedHashValue:    self.language = .dv
        case Bytes.dvMV.lowercasedHashValue:  self.language = .dvMV
        case Bytes.el.lowercasedHashValue:    self.language = .el
        case Bytes.elGR.lowercasedHashValue:  self.language = .elGR
        case Bytes.en.lowercasedHashValue:    self.language = .en
        case Bytes.enAU.lowercasedHashValue:  self.language = .enAU
        case Bytes.enBZ.lowercasedHashValue:  self.language = .enBZ
        case Bytes.enCA.lowercasedHashValue:  self.language = .enCA
        case Bytes.enCB.lowercasedHashValue:  self.language = .enCB
        case Bytes.enGB.lowercasedHashValue:  self.language = .enGB
        case Bytes.enIE.lowercasedHashValue:  self.language = .enIE
        case Bytes.enJM.lowercasedHashValue:  self.language = .enJM
        case Bytes.enNZ.lowercasedHashValue:  self.language = .enNZ
        case Bytes.enPH.lowercasedHashValue:  self.language = .enPH
        case Bytes.enTT.lowercasedHashValue:  self.language = .enTT
        case Bytes.enUS.lowercasedHashValue:  self.language = .enUS
        case Bytes.enZA.lowercasedHashValue:  self.language = .enZA
        case Bytes.enZW.lowercasedHashValue:  self.language = .enZW
        case Bytes.eo.lowercasedHashValue:    self.language = .eo
        case Bytes.es.lowercasedHashValue:    self.language = .es
        case Bytes.esAR.lowercasedHashValue:  self.language = .esAR
        case Bytes.esBO.lowercasedHashValue:  self.language = .esBO
        case Bytes.esCL.lowercasedHashValue:  self.language = .esCL
        case Bytes.esCO.lowercasedHashValue:  self.language = .esCO
        case Bytes.esCR.lowercasedHashValue:  self.language = .esCR
        case Bytes.esDO.lowercasedHashValue:  self.language = .esDO
        case Bytes.esEC.lowercasedHashValue:  self.language = .esEC
        case Bytes.esES.lowercasedHashValue:  self.language = .esES
        case Bytes.esGT.lowercasedHashValue:  self.language = .esGT
        case Bytes.esHN.lowercasedHashValue:  self.language = .esHN
        case Bytes.esMX.lowercasedHashValue:  self.language = .esMX
        case Bytes.esNI.lowercasedHashValue:  self.language = .esNI
        case Bytes.esPA.lowercasedHashValue:  self.language = .esPA
        case Bytes.esPE.lowercasedHashValue:  self.language = .esPE
        case Bytes.esPR.lowercasedHashValue:  self.language = .esPR
        case Bytes.esPY.lowercasedHashValue:  self.language = .esPY
        case Bytes.esSV.lowercasedHashValue:  self.language = .esSV
        case Bytes.esUY.lowercasedHashValue:  self.language = .esUY
        case Bytes.esVE.lowercasedHashValue:  self.language = .esVE
        case Bytes.et.lowercasedHashValue:    self.language = .et
        case Bytes.etEE.lowercasedHashValue:  self.language = .etEE
        case Bytes.eu.lowercasedHashValue:    self.language = .eu
        case Bytes.euES.lowercasedHashValue:  self.language = .euES
        case Bytes.fa.lowercasedHashValue:    self.language = .fa
        case Bytes.faIR.lowercasedHashValue:  self.language = .faIR
        case Bytes.fi.lowercasedHashValue:    self.language = .fi
        case Bytes.fiFI.lowercasedHashValue:  self.language = .fiFI
        case Bytes.fo.lowercasedHashValue:    self.language = .fo
        case Bytes.foFO.lowercasedHashValue:  self.language = .foFO
        case Bytes.fr.lowercasedHashValue:    self.language = .fr
        case Bytes.frBE.lowercasedHashValue:  self.language = .frBE
        case Bytes.frCA.lowercasedHashValue:  self.language = .frCA
        case Bytes.frCH.lowercasedHashValue:  self.language = .frCH
        case Bytes.frFR.lowercasedHashValue:  self.language = .frFR
        case Bytes.frLU.lowercasedHashValue:  self.language = .frLU
        case Bytes.frMC.lowercasedHashValue:  self.language = .frMC
        case Bytes.gl.lowercasedHashValue:    self.language = .gl
        case Bytes.glES.lowercasedHashValue:  self.language = .glES
        case Bytes.gu.lowercasedHashValue:    self.language = .gu
        case Bytes.guIN.lowercasedHashValue:  self.language = .guIN
        case Bytes.he.lowercasedHashValue:    self.language = .he
        case Bytes.heIL.lowercasedHashValue:  self.language = .heIL
        case Bytes.hi.lowercasedHashValue:    self.language = .hi
        case Bytes.hiIN.lowercasedHashValue:  self.language = .hiIN
        case Bytes.hr.lowercasedHashValue:    self.language = .hr
        case Bytes.hrBA.lowercasedHashValue:  self.language = .hrBA
        case Bytes.hrHR.lowercasedHashValue:  self.language = .hrHR
        case Bytes.hu.lowercasedHashValue:    self.language = .hu
        case Bytes.huHU.lowercasedHashValue:  self.language = .huHU
        case Bytes.hy.lowercasedHashValue:    self.language = .hy
        case Bytes.hyAM.lowercasedHashValue:  self.language = .hyAM
        case Bytes.id.lowercasedHashValue:    self.language = .id
        case Bytes.idID.lowercasedHashValue:  self.language = .idID
        case Bytes.is.lowercasedHashValue:    self.language = .is
        case Bytes.isIS.lowercasedHashValue:  self.language = .isIS
        case Bytes.it.lowercasedHashValue:    self.language = .it
        case Bytes.itCH.lowercasedHashValue:  self.language = .itCH
        case Bytes.itIT.lowercasedHashValue:  self.language = .itIT
        case Bytes.ja.lowercasedHashValue:    self.language = .ja
        case Bytes.jaJP.lowercasedHashValue:  self.language = .jaJP
        case Bytes.ka.lowercasedHashValue:    self.language = .ka
        case Bytes.kaGE.lowercasedHashValue:  self.language = .kaGE
        case Bytes.kk.lowercasedHashValue:    self.language = .kk
        case Bytes.kkKZ.lowercasedHashValue:  self.language = .kkKZ
        case Bytes.kn.lowercasedHashValue:    self.language = .kn
        case Bytes.knIN.lowercasedHashValue:  self.language = .knIN
        case Bytes.ko.lowercasedHashValue:    self.language = .ko
        case Bytes.koKR.lowercasedHashValue:  self.language = .koKR
        case Bytes.kok.lowercasedHashValue:   self.language = .kok
        case Bytes.kokIN.lowercasedHashValue: self.language = .kokIN
        case Bytes.ky.lowercasedHashValue:    self.language = .ky
        case Bytes.kyKG.lowercasedHashValue:  self.language = .kyKG
        case Bytes.lt.lowercasedHashValue:    self.language = .lt
        case Bytes.ltLT.lowercasedHashValue:  self.language = .ltLT
        case Bytes.lv.lowercasedHashValue:    self.language = .lv
        case Bytes.lvLV.lowercasedHashValue:  self.language = .lvLV
        case Bytes.mi.lowercasedHashValue:    self.language = .mi
        case Bytes.miNZ.lowercasedHashValue:  self.language = .miNZ
        case Bytes.mk.lowercasedHashValue:    self.language = .mk
        case Bytes.mkMK.lowercasedHashValue:  self.language = .mkMK
        case Bytes.mn.lowercasedHashValue:    self.language = .mn
        case Bytes.mnMN.lowercasedHashValue:  self.language = .mnMN
        case Bytes.mr.lowercasedHashValue:    self.language = .mr
        case Bytes.mrIN.lowercasedHashValue:  self.language = .mrIN
        case Bytes.ms.lowercasedHashValue:    self.language = .ms
        case Bytes.msBN.lowercasedHashValue:  self.language = .msBN
        case Bytes.msMY.lowercasedHashValue:  self.language = .msMY
        case Bytes.mt.lowercasedHashValue:    self.language = .mt
        case Bytes.mtMT.lowercasedHashValue:  self.language = .mtMT
        case Bytes.nb.lowercasedHashValue:    self.language = .nb
        case Bytes.nbNO.lowercasedHashValue:  self.language = .nbNO
        case Bytes.nl.lowercasedHashValue:    self.language = .nl
        case Bytes.nlBE.lowercasedHashValue:  self.language = .nlBE
        case Bytes.nlNL.lowercasedHashValue:  self.language = .nlNL
        case Bytes.nnNO.lowercasedHashValue:  self.language = .nnNO
        case Bytes.ns.lowercasedHashValue:    self.language = .ns
        case Bytes.nsZA.lowercasedHashValue:  self.language = .nsZA
        case Bytes.pa.lowercasedHashValue:    self.language = .pa
        case Bytes.paIN.lowercasedHashValue:  self.language = .paIN
        case Bytes.pl.lowercasedHashValue:    self.language = .pl
        case Bytes.plPL.lowercasedHashValue:  self.language = .plPL
        case Bytes.ps.lowercasedHashValue:    self.language = .ps
        case Bytes.psAR.lowercasedHashValue:  self.language = .psAR
        case Bytes.pt.lowercasedHashValue:    self.language = .pt
        case Bytes.ptBR.lowercasedHashValue:  self.language = .ptBR
        case Bytes.ptPT.lowercasedHashValue:  self.language = .ptPT
        case Bytes.qu.lowercasedHashValue:    self.language = .qu
        case Bytes.quBO.lowercasedHashValue:  self.language = .quBO
        case Bytes.quEC.lowercasedHashValue:  self.language = .quEC
        case Bytes.quPE.lowercasedHashValue:  self.language = .quPE
        case Bytes.ro.lowercasedHashValue:    self.language = .ro
        case Bytes.roRO.lowercasedHashValue:  self.language = .roRO
        case Bytes.ru.lowercasedHashValue:    self.language = .ru
        case Bytes.ruRU.lowercasedHashValue:  self.language = .ruRU
        case Bytes.sa.lowercasedHashValue:    self.language = .sa
        case Bytes.saIN.lowercasedHashValue:  self.language = .saIN
        case Bytes.se.lowercasedHashValue:    self.language = .se
        case Bytes.seFI.lowercasedHashValue:  self.language = .seFI
        case Bytes.seNO.lowercasedHashValue:  self.language = .seNO
        case Bytes.seSE.lowercasedHashValue:  self.language = .seSE
        case Bytes.sk.lowercasedHashValue:    self.language = .sk
        case Bytes.skSK.lowercasedHashValue:  self.language = .skSK
        case Bytes.sl.lowercasedHashValue:    self.language = .sl
        case Bytes.slSI.lowercasedHashValue:  self.language = .slSI
        case Bytes.sq.lowercasedHashValue:    self.language = .sq
        case Bytes.sqAL.lowercasedHashValue:  self.language = .sqAL
        case Bytes.srBA.lowercasedHashValue:  self.language = .srBA
        case Bytes.srSP.lowercasedHashValue:  self.language = .srSP
        case Bytes.sv.lowercasedHashValue:    self.language = .sv
        case Bytes.svFI.lowercasedHashValue:  self.language = .svFI
        case Bytes.svSE.lowercasedHashValue:  self.language = .svSE
        case Bytes.sw.lowercasedHashValue:    self.language = .sw
        case Bytes.swKE.lowercasedHashValue:  self.language = .swKE
        case Bytes.syr.lowercasedHashValue:   self.language = .syr
        case Bytes.syrSY.lowercasedHashValue: self.language = .syrSY
        case Bytes.ta.lowercasedHashValue:    self.language = .ta
        case Bytes.taIN.lowercasedHashValue:  self.language = .taIN
        case Bytes.te.lowercasedHashValue:    self.language = .te
        case Bytes.teIN.lowercasedHashValue:  self.language = .teIN
        case Bytes.th.lowercasedHashValue:    self.language = .th
        case Bytes.thTH.lowercasedHashValue:  self.language = .thTH
        case Bytes.tl.lowercasedHashValue:    self.language = .tl
        case Bytes.tlPH.lowercasedHashValue:  self.language = .tlPH
        case Bytes.tn.lowercasedHashValue:    self.language = .tn
        case Bytes.tnZA.lowercasedHashValue:  self.language = .tnZA
        case Bytes.tr.lowercasedHashValue:    self.language = .tr
        case Bytes.trTR.lowercasedHashValue:  self.language = .trTR
        case Bytes.tt.lowercasedHashValue:    self.language = .tt
        case Bytes.ttRU.lowercasedHashValue:  self.language = .ttRU
        case Bytes.ts.lowercasedHashValue:    self.language = .ts
        case Bytes.uk.lowercasedHashValue:    self.language = .uk
        case Bytes.ukUA.lowercasedHashValue:  self.language = .ukUA
        case Bytes.ur.lowercasedHashValue:    self.language = .ur
        case Bytes.urPK.lowercasedHashValue:  self.language = .urPK
        case Bytes.uz.lowercasedHashValue:    self.language = .uz
        case Bytes.uzUZ.lowercasedHashValue:  self.language = .uzUZ
        case Bytes.vi.lowercasedHashValue:    self.language = .vi
        case Bytes.viVN.lowercasedHashValue:  self.language = .viVN
        case Bytes.xh.lowercasedHashValue:    self.language = .xh
        case Bytes.xhZA.lowercasedHashValue:  self.language = .xhZA
        case Bytes.zh.lowercasedHashValue:    self.language = .zh
        case Bytes.zhCN.lowercasedHashValue:  self.language = .zhCN
        case Bytes.zhHK.lowercasedHashValue:  self.language = .zhHK
        case Bytes.zhMO.lowercasedHashValue:  self.language = .zhMO
        case Bytes.zhSG.lowercasedHashValue:  self.language = .zhSG
        case Bytes.zhTW.lowercasedHashValue:  self.language = .zhTW
        case Bytes.zu.lowercasedHashValue:    self.language = .zu
        case Bytes.zuZA.lowercasedHashValue:  self.language = .zuZA

        case Bytes.any.lowercasedHashValue:   self.language = .any
        default: self.language = .custom(String(buffer: valueBytes))
        }

        if let semicolonIndex = semicolonIndex {
            let priorityBytes = bytes.suffix(
                from: semicolonIndex.advanced(by: 1))
            guard priorityBytes.count == 5,
                priorityBytes.starts(with: Bytes.qEqual),
                let priority = Double(
                    String(buffer: priorityBytes.suffix(from: 2))) else {
                        throw HTTPError.invalidHeaderValue
            }
            self.priority = priority
        } else {
            self.priority = 1.0
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self.language {
        case .af:    buffer.append(contentsOf: Bytes.af)
        case .afZA:  buffer.append(contentsOf: Bytes.afZA)
        case .ar:    buffer.append(contentsOf: Bytes.ar)
        case .arAE:  buffer.append(contentsOf: Bytes.arAE)
        case .arBH:  buffer.append(contentsOf: Bytes.arBH)
        case .arDZ:  buffer.append(contentsOf: Bytes.arDZ)
        case .arEG:  buffer.append(contentsOf: Bytes.arEG)
        case .arIQ:  buffer.append(contentsOf: Bytes.arIQ)
        case .arJO:  buffer.append(contentsOf: Bytes.arJO)
        case .arKW:  buffer.append(contentsOf: Bytes.arKW)
        case .arLB:  buffer.append(contentsOf: Bytes.arLB)
        case .arLY:  buffer.append(contentsOf: Bytes.arLY)
        case .arMA:  buffer.append(contentsOf: Bytes.arMA)
        case .arOM:  buffer.append(contentsOf: Bytes.arOM)
        case .arQA:  buffer.append(contentsOf: Bytes.arQA)
        case .arSA:  buffer.append(contentsOf: Bytes.arSA)
        case .arSY:  buffer.append(contentsOf: Bytes.arSY)
        case .arTN:  buffer.append(contentsOf: Bytes.arTN)
        case .arYE:  buffer.append(contentsOf: Bytes.arYE)
        case .az:    buffer.append(contentsOf: Bytes.az)
        case .azAZ:  buffer.append(contentsOf: Bytes.azAZ)
        case .be:    buffer.append(contentsOf: Bytes.be)
        case .beBY:  buffer.append(contentsOf: Bytes.beBY)
        case .bg:    buffer.append(contentsOf: Bytes.bg)
        case .bgBG:  buffer.append(contentsOf: Bytes.bgBG)
        case .bsBA:  buffer.append(contentsOf: Bytes.bsBA)
        case .ca:    buffer.append(contentsOf: Bytes.ca)
        case .caES:  buffer.append(contentsOf: Bytes.caES)
        case .cs:    buffer.append(contentsOf: Bytes.cs)
        case .csCZ:  buffer.append(contentsOf: Bytes.csCZ)
        case .cy:    buffer.append(contentsOf: Bytes.cy)
        case .cyGB:  buffer.append(contentsOf: Bytes.cyGB)
        case .da:    buffer.append(contentsOf: Bytes.da)
        case .daDK:  buffer.append(contentsOf: Bytes.daDK)
        case .de:    buffer.append(contentsOf: Bytes.de)
        case .deAT:  buffer.append(contentsOf: Bytes.deAT)
        case .deCH:  buffer.append(contentsOf: Bytes.deCH)
        case .deDE:  buffer.append(contentsOf: Bytes.deDE)
        case .deLI:  buffer.append(contentsOf: Bytes.deLI)
        case .deLU:  buffer.append(contentsOf: Bytes.deLU)
        case .dv:    buffer.append(contentsOf: Bytes.dv)
        case .dvMV:  buffer.append(contentsOf: Bytes.dvMV)
        case .el:    buffer.append(contentsOf: Bytes.el)
        case .elGR:  buffer.append(contentsOf: Bytes.elGR)
        case .en:    buffer.append(contentsOf: Bytes.en)
        case .enAU:  buffer.append(contentsOf: Bytes.enAU)
        case .enBZ:  buffer.append(contentsOf: Bytes.enBZ)
        case .enCA:  buffer.append(contentsOf: Bytes.enCA)
        case .enCB:  buffer.append(contentsOf: Bytes.enCB)
        case .enGB:  buffer.append(contentsOf: Bytes.enGB)
        case .enIE:  buffer.append(contentsOf: Bytes.enIE)
        case .enJM:  buffer.append(contentsOf: Bytes.enJM)
        case .enNZ:  buffer.append(contentsOf: Bytes.enNZ)
        case .enPH:  buffer.append(contentsOf: Bytes.enPH)
        case .enTT:  buffer.append(contentsOf: Bytes.enTT)
        case .enUS:  buffer.append(contentsOf: Bytes.enUS)
        case .enZA:  buffer.append(contentsOf: Bytes.enZA)
        case .enZW:  buffer.append(contentsOf: Bytes.enZW)
        case .eo:    buffer.append(contentsOf: Bytes.eo)
        case .es:    buffer.append(contentsOf: Bytes.es)
        case .esAR:  buffer.append(contentsOf: Bytes.esAR)
        case .esBO:  buffer.append(contentsOf: Bytes.esBO)
        case .esCL:  buffer.append(contentsOf: Bytes.esCL)
        case .esCO:  buffer.append(contentsOf: Bytes.esCO)
        case .esCR:  buffer.append(contentsOf: Bytes.esCR)
        case .esDO:  buffer.append(contentsOf: Bytes.esDO)
        case .esEC:  buffer.append(contentsOf: Bytes.esEC)
        case .esES:  buffer.append(contentsOf: Bytes.esES)
        case .esGT:  buffer.append(contentsOf: Bytes.esGT)
        case .esHN:  buffer.append(contentsOf: Bytes.esHN)
        case .esMX:  buffer.append(contentsOf: Bytes.esMX)
        case .esNI:  buffer.append(contentsOf: Bytes.esNI)
        case .esPA:  buffer.append(contentsOf: Bytes.esPA)
        case .esPE:  buffer.append(contentsOf: Bytes.esPE)
        case .esPR:  buffer.append(contentsOf: Bytes.esPR)
        case .esPY:  buffer.append(contentsOf: Bytes.esPY)
        case .esSV:  buffer.append(contentsOf: Bytes.esSV)
        case .esUY:  buffer.append(contentsOf: Bytes.esUY)
        case .esVE:  buffer.append(contentsOf: Bytes.esVE)
        case .et:    buffer.append(contentsOf: Bytes.et)
        case .etEE:  buffer.append(contentsOf: Bytes.etEE)
        case .eu:    buffer.append(contentsOf: Bytes.eu)
        case .euES:  buffer.append(contentsOf: Bytes.euES)
        case .fa:    buffer.append(contentsOf: Bytes.fa)
        case .faIR:  buffer.append(contentsOf: Bytes.faIR)
        case .fi:    buffer.append(contentsOf: Bytes.fi)
        case .fiFI:  buffer.append(contentsOf: Bytes.fiFI)
        case .fo:    buffer.append(contentsOf: Bytes.fo)
        case .foFO:  buffer.append(contentsOf: Bytes.foFO)
        case .fr:    buffer.append(contentsOf: Bytes.fr)
        case .frBE:  buffer.append(contentsOf: Bytes.frBE)
        case .frCA:  buffer.append(contentsOf: Bytes.frCA)
        case .frCH:  buffer.append(contentsOf: Bytes.frCH)
        case .frFR:  buffer.append(contentsOf: Bytes.frFR)
        case .frLU:  buffer.append(contentsOf: Bytes.frLU)
        case .frMC:  buffer.append(contentsOf: Bytes.frMC)
        case .gl:    buffer.append(contentsOf: Bytes.gl)
        case .glES:  buffer.append(contentsOf: Bytes.glES)
        case .gu:    buffer.append(contentsOf: Bytes.gu)
        case .guIN:  buffer.append(contentsOf: Bytes.guIN)
        case .he:    buffer.append(contentsOf: Bytes.he)
        case .heIL:  buffer.append(contentsOf: Bytes.heIL)
        case .hi:    buffer.append(contentsOf: Bytes.hi)
        case .hiIN:  buffer.append(contentsOf: Bytes.hiIN)
        case .hr:    buffer.append(contentsOf: Bytes.hr)
        case .hrBA:  buffer.append(contentsOf: Bytes.hrBA)
        case .hrHR:  buffer.append(contentsOf: Bytes.hrHR)
        case .hu:    buffer.append(contentsOf: Bytes.hu)
        case .huHU:  buffer.append(contentsOf: Bytes.huHU)
        case .hy:    buffer.append(contentsOf: Bytes.hy)
        case .hyAM:  buffer.append(contentsOf: Bytes.hyAM)
        case .id:    buffer.append(contentsOf: Bytes.id)
        case .idID:  buffer.append(contentsOf: Bytes.idID)
        case .`is`:  buffer.append(contentsOf: Bytes.is)
        case .isIS:  buffer.append(contentsOf: Bytes.isIS)
        case .it:    buffer.append(contentsOf: Bytes.it)
        case .itCH:  buffer.append(contentsOf: Bytes.itCH)
        case .itIT:  buffer.append(contentsOf: Bytes.itIT)
        case .ja:    buffer.append(contentsOf: Bytes.ja)
        case .jaJP:  buffer.append(contentsOf: Bytes.jaJP)
        case .ka:    buffer.append(contentsOf: Bytes.ka)
        case .kaGE:  buffer.append(contentsOf: Bytes.kaGE)
        case .kk:    buffer.append(contentsOf: Bytes.kk)
        case .kkKZ:  buffer.append(contentsOf: Bytes.kkKZ)
        case .kn:    buffer.append(contentsOf: Bytes.kn)
        case .knIN:  buffer.append(contentsOf: Bytes.knIN)
        case .ko:    buffer.append(contentsOf: Bytes.ko)
        case .koKR:  buffer.append(contentsOf: Bytes.koKR)
        case .kok:   buffer.append(contentsOf: Bytes.kok)
        case .kokIN: buffer.append(contentsOf: Bytes.kokIN)
        case .ky:    buffer.append(contentsOf: Bytes.ky)
        case .kyKG:  buffer.append(contentsOf: Bytes.kyKG)
        case .lt:    buffer.append(contentsOf: Bytes.lt)
        case .ltLT:  buffer.append(contentsOf: Bytes.ltLT)
        case .lv:    buffer.append(contentsOf: Bytes.lv)
        case .lvLV:  buffer.append(contentsOf: Bytes.lvLV)
        case .mi:    buffer.append(contentsOf: Bytes.mi)
        case .miNZ:  buffer.append(contentsOf: Bytes.miNZ)
        case .mk:    buffer.append(contentsOf: Bytes.mk)
        case .mkMK:  buffer.append(contentsOf: Bytes.mkMK)
        case .mn:    buffer.append(contentsOf: Bytes.mn)
        case .mnMN:  buffer.append(contentsOf: Bytes.mnMN)
        case .mr:    buffer.append(contentsOf: Bytes.mr)
        case .mrIN:  buffer.append(contentsOf: Bytes.mrIN)
        case .ms:    buffer.append(contentsOf: Bytes.ms)
        case .msBN:  buffer.append(contentsOf: Bytes.msBN)
        case .msMY:  buffer.append(contentsOf: Bytes.msMY)
        case .mt:    buffer.append(contentsOf: Bytes.mt)
        case .mtMT:  buffer.append(contentsOf: Bytes.mtMT)
        case .nb:    buffer.append(contentsOf: Bytes.nb)
        case .nbNO:  buffer.append(contentsOf: Bytes.nbNO)
        case .nl:    buffer.append(contentsOf: Bytes.nl)
        case .nlBE:  buffer.append(contentsOf: Bytes.nlBE)
        case .nlNL:  buffer.append(contentsOf: Bytes.nlNL)
        case .nnNO:  buffer.append(contentsOf: Bytes.nnNO)
        case .ns:    buffer.append(contentsOf: Bytes.ns)
        case .nsZA:  buffer.append(contentsOf: Bytes.nsZA)
        case .pa:    buffer.append(contentsOf: Bytes.pa)
        case .paIN:  buffer.append(contentsOf: Bytes.paIN)
        case .pl:    buffer.append(contentsOf: Bytes.pl)
        case .plPL:  buffer.append(contentsOf: Bytes.plPL)
        case .ps:    buffer.append(contentsOf: Bytes.ps)
        case .psAR:  buffer.append(contentsOf: Bytes.psAR)
        case .pt:    buffer.append(contentsOf: Bytes.pt)
        case .ptBR:  buffer.append(contentsOf: Bytes.ptBR)
        case .ptPT:  buffer.append(contentsOf: Bytes.ptPT)
        case .qu:    buffer.append(contentsOf: Bytes.qu)
        case .quBO:  buffer.append(contentsOf: Bytes.quBO)
        case .quEC:  buffer.append(contentsOf: Bytes.quEC)
        case .quPE:  buffer.append(contentsOf: Bytes.quPE)
        case .ro:    buffer.append(contentsOf: Bytes.ro)
        case .roRO:  buffer.append(contentsOf: Bytes.roRO)
        case .ru:    buffer.append(contentsOf: Bytes.ru)
        case .ruRU:  buffer.append(contentsOf: Bytes.ruRU)
        case .sa:    buffer.append(contentsOf: Bytes.sa)
        case .saIN:  buffer.append(contentsOf: Bytes.saIN)
        case .se:    buffer.append(contentsOf: Bytes.se)
        case .seFI:  buffer.append(contentsOf: Bytes.seFI)
        case .seNO:  buffer.append(contentsOf: Bytes.seNO)
        case .seSE:  buffer.append(contentsOf: Bytes.seSE)
        case .sk:    buffer.append(contentsOf: Bytes.sk)
        case .skSK:  buffer.append(contentsOf: Bytes.skSK)
        case .sl:    buffer.append(contentsOf: Bytes.sl)
        case .slSI:  buffer.append(contentsOf: Bytes.slSI)
        case .sq:    buffer.append(contentsOf: Bytes.sq)
        case .sqAL:  buffer.append(contentsOf: Bytes.sqAL)
        case .srBA:  buffer.append(contentsOf: Bytes.srBA)
        case .srSP:  buffer.append(contentsOf: Bytes.srSP)
        case .sv:    buffer.append(contentsOf: Bytes.sv)
        case .svFI:  buffer.append(contentsOf: Bytes.svFI)
        case .svSE:  buffer.append(contentsOf: Bytes.svSE)
        case .sw:    buffer.append(contentsOf: Bytes.sw)
        case .swKE:  buffer.append(contentsOf: Bytes.swKE)
        case .syr:   buffer.append(contentsOf: Bytes.syr)
        case .syrSY: buffer.append(contentsOf: Bytes.syrSY)
        case .ta:    buffer.append(contentsOf: Bytes.ta)
        case .taIN:  buffer.append(contentsOf: Bytes.taIN)
        case .te:    buffer.append(contentsOf: Bytes.te)
        case .teIN:  buffer.append(contentsOf: Bytes.teIN)
        case .th:    buffer.append(contentsOf: Bytes.th)
        case .thTH:  buffer.append(contentsOf: Bytes.thTH)
        case .tl:    buffer.append(contentsOf: Bytes.tl)
        case .tlPH:  buffer.append(contentsOf: Bytes.tlPH)
        case .tn:    buffer.append(contentsOf: Bytes.tn)
        case .tnZA:  buffer.append(contentsOf: Bytes.tnZA)
        case .tr:    buffer.append(contentsOf: Bytes.tr)
        case .trTR:  buffer.append(contentsOf: Bytes.trTR)
        case .tt:    buffer.append(contentsOf: Bytes.tt)
        case .ttRU:  buffer.append(contentsOf: Bytes.ttRU)
        case .ts:    buffer.append(contentsOf: Bytes.ts)
        case .uk:    buffer.append(contentsOf: Bytes.uk)
        case .ukUA:  buffer.append(contentsOf: Bytes.ukUA)
        case .ur:    buffer.append(contentsOf: Bytes.ur)
        case .urPK:  buffer.append(contentsOf: Bytes.urPK)
        case .uz:    buffer.append(contentsOf: Bytes.uz)
        case .uzUZ:  buffer.append(contentsOf: Bytes.uzUZ)
        case .vi:    buffer.append(contentsOf: Bytes.vi)
        case .viVN:  buffer.append(contentsOf: Bytes.viVN)
        case .xh:    buffer.append(contentsOf: Bytes.xh)
        case .xhZA:  buffer.append(contentsOf: Bytes.xhZA)
        case .zh:    buffer.append(contentsOf: Bytes.zh)
        case .zhCN:  buffer.append(contentsOf: Bytes.zhCN)
        case .zhHK:  buffer.append(contentsOf: Bytes.zhHK)
        case .zhMO:  buffer.append(contentsOf: Bytes.zhMO)
        case .zhSG:  buffer.append(contentsOf: Bytes.zhSG)
        case .zhTW:  buffer.append(contentsOf: Bytes.zhTW)
        case .zu:    buffer.append(contentsOf: Bytes.zu)
        case .zuZA:  buffer.append(contentsOf: Bytes.zuZA)

        case .any:   buffer.append(contentsOf: Bytes.any)
        case .custom(let value): buffer.append(contentsOf: [UInt8](value))
        }

        if priority < 1.0 {
            buffer.append(Character.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
