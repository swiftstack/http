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

extension Language {
    private struct Bytes {
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
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.af.lowercasedHashValue:    self = .af
        case Bytes.afZA.lowercasedHashValue:  self = .afZA
        case Bytes.ar.lowercasedHashValue:    self = .ar
        case Bytes.arAE.lowercasedHashValue:  self = .arAE
        case Bytes.arBH.lowercasedHashValue:  self = .arBH
        case Bytes.arDZ.lowercasedHashValue:  self = .arDZ
        case Bytes.arEG.lowercasedHashValue:  self = .arEG
        case Bytes.arIQ.lowercasedHashValue:  self = .arIQ
        case Bytes.arJO.lowercasedHashValue:  self = .arJO
        case Bytes.arKW.lowercasedHashValue:  self = .arKW
        case Bytes.arLB.lowercasedHashValue:  self = .arLB
        case Bytes.arLY.lowercasedHashValue:  self = .arLY
        case Bytes.arMA.lowercasedHashValue:  self = .arMA
        case Bytes.arOM.lowercasedHashValue:  self = .arOM
        case Bytes.arQA.lowercasedHashValue:  self = .arQA
        case Bytes.arSA.lowercasedHashValue:  self = .arSA
        case Bytes.arSY.lowercasedHashValue:  self = .arSY
        case Bytes.arTN.lowercasedHashValue:  self = .arTN
        case Bytes.arYE.lowercasedHashValue:  self = .arYE
        case Bytes.az.lowercasedHashValue:    self = .az
        case Bytes.azAZ.lowercasedHashValue:  self = .azAZ
        case Bytes.be.lowercasedHashValue:    self = .be
        case Bytes.beBY.lowercasedHashValue:  self = .beBY
        case Bytes.bg.lowercasedHashValue:    self = .bg
        case Bytes.bgBG.lowercasedHashValue:  self = .bgBG
        case Bytes.bsBA.lowercasedHashValue:  self = .bsBA
        case Bytes.ca.lowercasedHashValue:    self = .ca
        case Bytes.caES.lowercasedHashValue:  self = .caES
        case Bytes.cs.lowercasedHashValue:    self = .cs
        case Bytes.csCZ.lowercasedHashValue:  self = .csCZ
        case Bytes.cy.lowercasedHashValue:    self = .cy
        case Bytes.cyGB.lowercasedHashValue:  self = .cyGB
        case Bytes.da.lowercasedHashValue:    self = .da
        case Bytes.daDK.lowercasedHashValue:  self = .daDK
        case Bytes.de.lowercasedHashValue:    self = .de
        case Bytes.deAT.lowercasedHashValue:  self = .deAT
        case Bytes.deCH.lowercasedHashValue:  self = .deCH
        case Bytes.deDE.lowercasedHashValue:  self = .deDE
        case Bytes.deLI.lowercasedHashValue:  self = .deLI
        case Bytes.deLU.lowercasedHashValue:  self = .deLU
        case Bytes.dv.lowercasedHashValue:    self = .dv
        case Bytes.dvMV.lowercasedHashValue:  self = .dvMV
        case Bytes.el.lowercasedHashValue:    self = .el
        case Bytes.elGR.lowercasedHashValue:  self = .elGR
        case Bytes.en.lowercasedHashValue:    self = .en
        case Bytes.enAU.lowercasedHashValue:  self = .enAU
        case Bytes.enBZ.lowercasedHashValue:  self = .enBZ
        case Bytes.enCA.lowercasedHashValue:  self = .enCA
        case Bytes.enCB.lowercasedHashValue:  self = .enCB
        case Bytes.enGB.lowercasedHashValue:  self = .enGB
        case Bytes.enIE.lowercasedHashValue:  self = .enIE
        case Bytes.enJM.lowercasedHashValue:  self = .enJM
        case Bytes.enNZ.lowercasedHashValue:  self = .enNZ
        case Bytes.enPH.lowercasedHashValue:  self = .enPH
        case Bytes.enTT.lowercasedHashValue:  self = .enTT
        case Bytes.enUS.lowercasedHashValue:  self = .enUS
        case Bytes.enZA.lowercasedHashValue:  self = .enZA
        case Bytes.enZW.lowercasedHashValue:  self = .enZW
        case Bytes.eo.lowercasedHashValue:    self = .eo
        case Bytes.es.lowercasedHashValue:    self = .es
        case Bytes.esAR.lowercasedHashValue:  self = .esAR
        case Bytes.esBO.lowercasedHashValue:  self = .esBO
        case Bytes.esCL.lowercasedHashValue:  self = .esCL
        case Bytes.esCO.lowercasedHashValue:  self = .esCO
        case Bytes.esCR.lowercasedHashValue:  self = .esCR
        case Bytes.esDO.lowercasedHashValue:  self = .esDO
        case Bytes.esEC.lowercasedHashValue:  self = .esEC
        case Bytes.esES.lowercasedHashValue:  self = .esES
        case Bytes.esGT.lowercasedHashValue:  self = .esGT
        case Bytes.esHN.lowercasedHashValue:  self = .esHN
        case Bytes.esMX.lowercasedHashValue:  self = .esMX
        case Bytes.esNI.lowercasedHashValue:  self = .esNI
        case Bytes.esPA.lowercasedHashValue:  self = .esPA
        case Bytes.esPE.lowercasedHashValue:  self = .esPE
        case Bytes.esPR.lowercasedHashValue:  self = .esPR
        case Bytes.esPY.lowercasedHashValue:  self = .esPY
        case Bytes.esSV.lowercasedHashValue:  self = .esSV
        case Bytes.esUY.lowercasedHashValue:  self = .esUY
        case Bytes.esVE.lowercasedHashValue:  self = .esVE
        case Bytes.et.lowercasedHashValue:    self = .et
        case Bytes.etEE.lowercasedHashValue:  self = .etEE
        case Bytes.eu.lowercasedHashValue:    self = .eu
        case Bytes.euES.lowercasedHashValue:  self = .euES
        case Bytes.fa.lowercasedHashValue:    self = .fa
        case Bytes.faIR.lowercasedHashValue:  self = .faIR
        case Bytes.fi.lowercasedHashValue:    self = .fi
        case Bytes.fiFI.lowercasedHashValue:  self = .fiFI
        case Bytes.fo.lowercasedHashValue:    self = .fo
        case Bytes.foFO.lowercasedHashValue:  self = .foFO
        case Bytes.fr.lowercasedHashValue:    self = .fr
        case Bytes.frBE.lowercasedHashValue:  self = .frBE
        case Bytes.frCA.lowercasedHashValue:  self = .frCA
        case Bytes.frCH.lowercasedHashValue:  self = .frCH
        case Bytes.frFR.lowercasedHashValue:  self = .frFR
        case Bytes.frLU.lowercasedHashValue:  self = .frLU
        case Bytes.frMC.lowercasedHashValue:  self = .frMC
        case Bytes.gl.lowercasedHashValue:    self = .gl
        case Bytes.glES.lowercasedHashValue:  self = .glES
        case Bytes.gu.lowercasedHashValue:    self = .gu
        case Bytes.guIN.lowercasedHashValue:  self = .guIN
        case Bytes.he.lowercasedHashValue:    self = .he
        case Bytes.heIL.lowercasedHashValue:  self = .heIL
        case Bytes.hi.lowercasedHashValue:    self = .hi
        case Bytes.hiIN.lowercasedHashValue:  self = .hiIN
        case Bytes.hr.lowercasedHashValue:    self = .hr
        case Bytes.hrBA.lowercasedHashValue:  self = .hrBA
        case Bytes.hrHR.lowercasedHashValue:  self = .hrHR
        case Bytes.hu.lowercasedHashValue:    self = .hu
        case Bytes.huHU.lowercasedHashValue:  self = .huHU
        case Bytes.hy.lowercasedHashValue:    self = .hy
        case Bytes.hyAM.lowercasedHashValue:  self = .hyAM
        case Bytes.id.lowercasedHashValue:    self = .id
        case Bytes.idID.lowercasedHashValue:  self = .idID
        case Bytes.is.lowercasedHashValue:    self = .is
        case Bytes.isIS.lowercasedHashValue:  self = .isIS
        case Bytes.it.lowercasedHashValue:    self = .it
        case Bytes.itCH.lowercasedHashValue:  self = .itCH
        case Bytes.itIT.lowercasedHashValue:  self = .itIT
        case Bytes.ja.lowercasedHashValue:    self = .ja
        case Bytes.jaJP.lowercasedHashValue:  self = .jaJP
        case Bytes.ka.lowercasedHashValue:    self = .ka
        case Bytes.kaGE.lowercasedHashValue:  self = .kaGE
        case Bytes.kk.lowercasedHashValue:    self = .kk
        case Bytes.kkKZ.lowercasedHashValue:  self = .kkKZ
        case Bytes.kn.lowercasedHashValue:    self = .kn
        case Bytes.knIN.lowercasedHashValue:  self = .knIN
        case Bytes.ko.lowercasedHashValue:    self = .ko
        case Bytes.koKR.lowercasedHashValue:  self = .koKR
        case Bytes.kok.lowercasedHashValue:   self = .kok
        case Bytes.kokIN.lowercasedHashValue: self = .kokIN
        case Bytes.ky.lowercasedHashValue:    self = .ky
        case Bytes.kyKG.lowercasedHashValue:  self = .kyKG
        case Bytes.lt.lowercasedHashValue:    self = .lt
        case Bytes.ltLT.lowercasedHashValue:  self = .ltLT
        case Bytes.lv.lowercasedHashValue:    self = .lv
        case Bytes.lvLV.lowercasedHashValue:  self = .lvLV
        case Bytes.mi.lowercasedHashValue:    self = .mi
        case Bytes.miNZ.lowercasedHashValue:  self = .miNZ
        case Bytes.mk.lowercasedHashValue:    self = .mk
        case Bytes.mkMK.lowercasedHashValue:  self = .mkMK
        case Bytes.mn.lowercasedHashValue:    self = .mn
        case Bytes.mnMN.lowercasedHashValue:  self = .mnMN
        case Bytes.mr.lowercasedHashValue:    self = .mr
        case Bytes.mrIN.lowercasedHashValue:  self = .mrIN
        case Bytes.ms.lowercasedHashValue:    self = .ms
        case Bytes.msBN.lowercasedHashValue:  self = .msBN
        case Bytes.msMY.lowercasedHashValue:  self = .msMY
        case Bytes.mt.lowercasedHashValue:    self = .mt
        case Bytes.mtMT.lowercasedHashValue:  self = .mtMT
        case Bytes.nb.lowercasedHashValue:    self = .nb
        case Bytes.nbNO.lowercasedHashValue:  self = .nbNO
        case Bytes.nl.lowercasedHashValue:    self = .nl
        case Bytes.nlBE.lowercasedHashValue:  self = .nlBE
        case Bytes.nlNL.lowercasedHashValue:  self = .nlNL
        case Bytes.nnNO.lowercasedHashValue:  self = .nnNO
        case Bytes.ns.lowercasedHashValue:    self = .ns
        case Bytes.nsZA.lowercasedHashValue:  self = .nsZA
        case Bytes.pa.lowercasedHashValue:    self = .pa
        case Bytes.paIN.lowercasedHashValue:  self = .paIN
        case Bytes.pl.lowercasedHashValue:    self = .pl
        case Bytes.plPL.lowercasedHashValue:  self = .plPL
        case Bytes.ps.lowercasedHashValue:    self = .ps
        case Bytes.psAR.lowercasedHashValue:  self = .psAR
        case Bytes.pt.lowercasedHashValue:    self = .pt
        case Bytes.ptBR.lowercasedHashValue:  self = .ptBR
        case Bytes.ptPT.lowercasedHashValue:  self = .ptPT
        case Bytes.qu.lowercasedHashValue:    self = .qu
        case Bytes.quBO.lowercasedHashValue:  self = .quBO
        case Bytes.quEC.lowercasedHashValue:  self = .quEC
        case Bytes.quPE.lowercasedHashValue:  self = .quPE
        case Bytes.ro.lowercasedHashValue:    self = .ro
        case Bytes.roRO.lowercasedHashValue:  self = .roRO
        case Bytes.ru.lowercasedHashValue:    self = .ru
        case Bytes.ruRU.lowercasedHashValue:  self = .ruRU
        case Bytes.sa.lowercasedHashValue:    self = .sa
        case Bytes.saIN.lowercasedHashValue:  self = .saIN
        case Bytes.se.lowercasedHashValue:    self = .se
        case Bytes.seFI.lowercasedHashValue:  self = .seFI
        case Bytes.seNO.lowercasedHashValue:  self = .seNO
        case Bytes.seSE.lowercasedHashValue:  self = .seSE
        case Bytes.sk.lowercasedHashValue:    self = .sk
        case Bytes.skSK.lowercasedHashValue:  self = .skSK
        case Bytes.sl.lowercasedHashValue:    self = .sl
        case Bytes.slSI.lowercasedHashValue:  self = .slSI
        case Bytes.sq.lowercasedHashValue:    self = .sq
        case Bytes.sqAL.lowercasedHashValue:  self = .sqAL
        case Bytes.srBA.lowercasedHashValue:  self = .srBA
        case Bytes.srSP.lowercasedHashValue:  self = .srSP
        case Bytes.sv.lowercasedHashValue:    self = .sv
        case Bytes.svFI.lowercasedHashValue:  self = .svFI
        case Bytes.svSE.lowercasedHashValue:  self = .svSE
        case Bytes.sw.lowercasedHashValue:    self = .sw
        case Bytes.swKE.lowercasedHashValue:  self = .swKE
        case Bytes.syr.lowercasedHashValue:   self = .syr
        case Bytes.syrSY.lowercasedHashValue: self = .syrSY
        case Bytes.ta.lowercasedHashValue:    self = .ta
        case Bytes.taIN.lowercasedHashValue:  self = .taIN
        case Bytes.te.lowercasedHashValue:    self = .te
        case Bytes.teIN.lowercasedHashValue:  self = .teIN
        case Bytes.th.lowercasedHashValue:    self = .th
        case Bytes.thTH.lowercasedHashValue:  self = .thTH
        case Bytes.tl.lowercasedHashValue:    self = .tl
        case Bytes.tlPH.lowercasedHashValue:  self = .tlPH
        case Bytes.tn.lowercasedHashValue:    self = .tn
        case Bytes.tnZA.lowercasedHashValue:  self = .tnZA
        case Bytes.tr.lowercasedHashValue:    self = .tr
        case Bytes.trTR.lowercasedHashValue:  self = .trTR
        case Bytes.tt.lowercasedHashValue:    self = .tt
        case Bytes.ttRU.lowercasedHashValue:  self = .ttRU
        case Bytes.ts.lowercasedHashValue:    self = .ts
        case Bytes.uk.lowercasedHashValue:    self = .uk
        case Bytes.ukUA.lowercasedHashValue:  self = .ukUA
        case Bytes.ur.lowercasedHashValue:    self = .ur
        case Bytes.urPK.lowercasedHashValue:  self = .urPK
        case Bytes.uz.lowercasedHashValue:    self = .uz
        case Bytes.uzUZ.lowercasedHashValue:  self = .uzUZ
        case Bytes.vi.lowercasedHashValue:    self = .vi
        case Bytes.viVN.lowercasedHashValue:  self = .viVN
        case Bytes.xh.lowercasedHashValue:    self = .xh
        case Bytes.xhZA.lowercasedHashValue:  self = .xhZA
        case Bytes.zh.lowercasedHashValue:    self = .zh
        case Bytes.zhCN.lowercasedHashValue:  self = .zhCN
        case Bytes.zhHK.lowercasedHashValue:  self = .zhHK
        case Bytes.zhMO.lowercasedHashValue:  self = .zhMO
        case Bytes.zhSG.lowercasedHashValue:  self = .zhSG
        case Bytes.zhTW.lowercasedHashValue:  self = .zhTW
        case Bytes.zu.lowercasedHashValue:    self = .zu
        case Bytes.zuZA.lowercasedHashValue:  self = .zuZA
        case Bytes.any.lowercasedHashValue:   self = .any
        default:
            guard let language = String(validating: bytes, as: .token) else {
                throw HTTPError.invalidLanguage
            }
            self = .custom(language)
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
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
    }
}
