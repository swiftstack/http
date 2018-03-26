import Stream

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
}

extension Language {
    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.af.lowercasedHashValue:    return .af
            case Bytes.afZA.lowercasedHashValue:  return .afZA
            case Bytes.ar.lowercasedHashValue:    return .ar
            case Bytes.arAE.lowercasedHashValue:  return .arAE
            case Bytes.arBH.lowercasedHashValue:  return .arBH
            case Bytes.arDZ.lowercasedHashValue:  return .arDZ
            case Bytes.arEG.lowercasedHashValue:  return .arEG
            case Bytes.arIQ.lowercasedHashValue:  return .arIQ
            case Bytes.arJO.lowercasedHashValue:  return .arJO
            case Bytes.arKW.lowercasedHashValue:  return .arKW
            case Bytes.arLB.lowercasedHashValue:  return .arLB
            case Bytes.arLY.lowercasedHashValue:  return .arLY
            case Bytes.arMA.lowercasedHashValue:  return .arMA
            case Bytes.arOM.lowercasedHashValue:  return .arOM
            case Bytes.arQA.lowercasedHashValue:  return .arQA
            case Bytes.arSA.lowercasedHashValue:  return .arSA
            case Bytes.arSY.lowercasedHashValue:  return .arSY
            case Bytes.arTN.lowercasedHashValue:  return .arTN
            case Bytes.arYE.lowercasedHashValue:  return .arYE
            case Bytes.az.lowercasedHashValue:    return .az
            case Bytes.azAZ.lowercasedHashValue:  return .azAZ
            case Bytes.be.lowercasedHashValue:    return .be
            case Bytes.beBY.lowercasedHashValue:  return .beBY
            case Bytes.bg.lowercasedHashValue:    return .bg
            case Bytes.bgBG.lowercasedHashValue:  return .bgBG
            case Bytes.bsBA.lowercasedHashValue:  return .bsBA
            case Bytes.ca.lowercasedHashValue:    return .ca
            case Bytes.caES.lowercasedHashValue:  return .caES
            case Bytes.cs.lowercasedHashValue:    return .cs
            case Bytes.csCZ.lowercasedHashValue:  return .csCZ
            case Bytes.cy.lowercasedHashValue:    return .cy
            case Bytes.cyGB.lowercasedHashValue:  return .cyGB
            case Bytes.da.lowercasedHashValue:    return .da
            case Bytes.daDK.lowercasedHashValue:  return .daDK
            case Bytes.de.lowercasedHashValue:    return .de
            case Bytes.deAT.lowercasedHashValue:  return .deAT
            case Bytes.deCH.lowercasedHashValue:  return .deCH
            case Bytes.deDE.lowercasedHashValue:  return .deDE
            case Bytes.deLI.lowercasedHashValue:  return .deLI
            case Bytes.deLU.lowercasedHashValue:  return .deLU
            case Bytes.dv.lowercasedHashValue:    return .dv
            case Bytes.dvMV.lowercasedHashValue:  return .dvMV
            case Bytes.el.lowercasedHashValue:    return .el
            case Bytes.elGR.lowercasedHashValue:  return .elGR
            case Bytes.en.lowercasedHashValue:    return .en
            case Bytes.enAU.lowercasedHashValue:  return .enAU
            case Bytes.enBZ.lowercasedHashValue:  return .enBZ
            case Bytes.enCA.lowercasedHashValue:  return .enCA
            case Bytes.enCB.lowercasedHashValue:  return .enCB
            case Bytes.enGB.lowercasedHashValue:  return .enGB
            case Bytes.enIE.lowercasedHashValue:  return .enIE
            case Bytes.enJM.lowercasedHashValue:  return .enJM
            case Bytes.enNZ.lowercasedHashValue:  return .enNZ
            case Bytes.enPH.lowercasedHashValue:  return .enPH
            case Bytes.enTT.lowercasedHashValue:  return .enTT
            case Bytes.enUS.lowercasedHashValue:  return .enUS
            case Bytes.enZA.lowercasedHashValue:  return .enZA
            case Bytes.enZW.lowercasedHashValue:  return .enZW
            case Bytes.eo.lowercasedHashValue:    return .eo
            case Bytes.es.lowercasedHashValue:    return .es
            case Bytes.esAR.lowercasedHashValue:  return .esAR
            case Bytes.esBO.lowercasedHashValue:  return .esBO
            case Bytes.esCL.lowercasedHashValue:  return .esCL
            case Bytes.esCO.lowercasedHashValue:  return .esCO
            case Bytes.esCR.lowercasedHashValue:  return .esCR
            case Bytes.esDO.lowercasedHashValue:  return .esDO
            case Bytes.esEC.lowercasedHashValue:  return .esEC
            case Bytes.esES.lowercasedHashValue:  return .esES
            case Bytes.esGT.lowercasedHashValue:  return .esGT
            case Bytes.esHN.lowercasedHashValue:  return .esHN
            case Bytes.esMX.lowercasedHashValue:  return .esMX
            case Bytes.esNI.lowercasedHashValue:  return .esNI
            case Bytes.esPA.lowercasedHashValue:  return .esPA
            case Bytes.esPE.lowercasedHashValue:  return .esPE
            case Bytes.esPR.lowercasedHashValue:  return .esPR
            case Bytes.esPY.lowercasedHashValue:  return .esPY
            case Bytes.esSV.lowercasedHashValue:  return .esSV
            case Bytes.esUY.lowercasedHashValue:  return .esUY
            case Bytes.esVE.lowercasedHashValue:  return .esVE
            case Bytes.et.lowercasedHashValue:    return .et
            case Bytes.etEE.lowercasedHashValue:  return .etEE
            case Bytes.eu.lowercasedHashValue:    return .eu
            case Bytes.euES.lowercasedHashValue:  return .euES
            case Bytes.fa.lowercasedHashValue:    return .fa
            case Bytes.faIR.lowercasedHashValue:  return .faIR
            case Bytes.fi.lowercasedHashValue:    return .fi
            case Bytes.fiFI.lowercasedHashValue:  return .fiFI
            case Bytes.fo.lowercasedHashValue:    return .fo
            case Bytes.foFO.lowercasedHashValue:  return .foFO
            case Bytes.fr.lowercasedHashValue:    return .fr
            case Bytes.frBE.lowercasedHashValue:  return .frBE
            case Bytes.frCA.lowercasedHashValue:  return .frCA
            case Bytes.frCH.lowercasedHashValue:  return .frCH
            case Bytes.frFR.lowercasedHashValue:  return .frFR
            case Bytes.frLU.lowercasedHashValue:  return .frLU
            case Bytes.frMC.lowercasedHashValue:  return .frMC
            case Bytes.gl.lowercasedHashValue:    return .gl
            case Bytes.glES.lowercasedHashValue:  return .glES
            case Bytes.gu.lowercasedHashValue:    return .gu
            case Bytes.guIN.lowercasedHashValue:  return .guIN
            case Bytes.he.lowercasedHashValue:    return .he
            case Bytes.heIL.lowercasedHashValue:  return .heIL
            case Bytes.hi.lowercasedHashValue:    return .hi
            case Bytes.hiIN.lowercasedHashValue:  return .hiIN
            case Bytes.hr.lowercasedHashValue:    return .hr
            case Bytes.hrBA.lowercasedHashValue:  return .hrBA
            case Bytes.hrHR.lowercasedHashValue:  return .hrHR
            case Bytes.hu.lowercasedHashValue:    return .hu
            case Bytes.huHU.lowercasedHashValue:  return .huHU
            case Bytes.hy.lowercasedHashValue:    return .hy
            case Bytes.hyAM.lowercasedHashValue:  return .hyAM
            case Bytes.id.lowercasedHashValue:    return .id
            case Bytes.idID.lowercasedHashValue:  return .idID
            case Bytes.is.lowercasedHashValue:    return .is
            case Bytes.isIS.lowercasedHashValue:  return .isIS
            case Bytes.it.lowercasedHashValue:    return .it
            case Bytes.itCH.lowercasedHashValue:  return .itCH
            case Bytes.itIT.lowercasedHashValue:  return .itIT
            case Bytes.ja.lowercasedHashValue:    return .ja
            case Bytes.jaJP.lowercasedHashValue:  return .jaJP
            case Bytes.ka.lowercasedHashValue:    return .ka
            case Bytes.kaGE.lowercasedHashValue:  return .kaGE
            case Bytes.kk.lowercasedHashValue:    return .kk
            case Bytes.kkKZ.lowercasedHashValue:  return .kkKZ
            case Bytes.kn.lowercasedHashValue:    return .kn
            case Bytes.knIN.lowercasedHashValue:  return .knIN
            case Bytes.ko.lowercasedHashValue:    return .ko
            case Bytes.koKR.lowercasedHashValue:  return .koKR
            case Bytes.kok.lowercasedHashValue:   return .kok
            case Bytes.kokIN.lowercasedHashValue: return .kokIN
            case Bytes.ky.lowercasedHashValue:    return .ky
            case Bytes.kyKG.lowercasedHashValue:  return .kyKG
            case Bytes.lt.lowercasedHashValue:    return .lt
            case Bytes.ltLT.lowercasedHashValue:  return .ltLT
            case Bytes.lv.lowercasedHashValue:    return .lv
            case Bytes.lvLV.lowercasedHashValue:  return .lvLV
            case Bytes.mi.lowercasedHashValue:    return .mi
            case Bytes.miNZ.lowercasedHashValue:  return .miNZ
            case Bytes.mk.lowercasedHashValue:    return .mk
            case Bytes.mkMK.lowercasedHashValue:  return .mkMK
            case Bytes.mn.lowercasedHashValue:    return .mn
            case Bytes.mnMN.lowercasedHashValue:  return .mnMN
            case Bytes.mr.lowercasedHashValue:    return .mr
            case Bytes.mrIN.lowercasedHashValue:  return .mrIN
            case Bytes.ms.lowercasedHashValue:    return .ms
            case Bytes.msBN.lowercasedHashValue:  return .msBN
            case Bytes.msMY.lowercasedHashValue:  return .msMY
            case Bytes.mt.lowercasedHashValue:    return .mt
            case Bytes.mtMT.lowercasedHashValue:  return .mtMT
            case Bytes.nb.lowercasedHashValue:    return .nb
            case Bytes.nbNO.lowercasedHashValue:  return .nbNO
            case Bytes.nl.lowercasedHashValue:    return .nl
            case Bytes.nlBE.lowercasedHashValue:  return .nlBE
            case Bytes.nlNL.lowercasedHashValue:  return .nlNL
            case Bytes.nnNO.lowercasedHashValue:  return .nnNO
            case Bytes.ns.lowercasedHashValue:    return .ns
            case Bytes.nsZA.lowercasedHashValue:  return .nsZA
            case Bytes.pa.lowercasedHashValue:    return .pa
            case Bytes.paIN.lowercasedHashValue:  return .paIN
            case Bytes.pl.lowercasedHashValue:    return .pl
            case Bytes.plPL.lowercasedHashValue:  return .plPL
            case Bytes.ps.lowercasedHashValue:    return .ps
            case Bytes.psAR.lowercasedHashValue:  return .psAR
            case Bytes.pt.lowercasedHashValue:    return .pt
            case Bytes.ptBR.lowercasedHashValue:  return .ptBR
            case Bytes.ptPT.lowercasedHashValue:  return .ptPT
            case Bytes.qu.lowercasedHashValue:    return .qu
            case Bytes.quBO.lowercasedHashValue:  return .quBO
            case Bytes.quEC.lowercasedHashValue:  return .quEC
            case Bytes.quPE.lowercasedHashValue:  return .quPE
            case Bytes.ro.lowercasedHashValue:    return .ro
            case Bytes.roRO.lowercasedHashValue:  return .roRO
            case Bytes.ru.lowercasedHashValue:    return .ru
            case Bytes.ruRU.lowercasedHashValue:  return .ruRU
            case Bytes.sa.lowercasedHashValue:    return .sa
            case Bytes.saIN.lowercasedHashValue:  return .saIN
            case Bytes.se.lowercasedHashValue:    return .se
            case Bytes.seFI.lowercasedHashValue:  return .seFI
            case Bytes.seNO.lowercasedHashValue:  return .seNO
            case Bytes.seSE.lowercasedHashValue:  return .seSE
            case Bytes.sk.lowercasedHashValue:    return .sk
            case Bytes.skSK.lowercasedHashValue:  return .skSK
            case Bytes.sl.lowercasedHashValue:    return .sl
            case Bytes.slSI.lowercasedHashValue:  return .slSI
            case Bytes.sq.lowercasedHashValue:    return .sq
            case Bytes.sqAL.lowercasedHashValue:  return .sqAL
            case Bytes.srBA.lowercasedHashValue:  return .srBA
            case Bytes.srSP.lowercasedHashValue:  return .srSP
            case Bytes.sv.lowercasedHashValue:    return .sv
            case Bytes.svFI.lowercasedHashValue:  return .svFI
            case Bytes.svSE.lowercasedHashValue:  return .svSE
            case Bytes.sw.lowercasedHashValue:    return .sw
            case Bytes.swKE.lowercasedHashValue:  return .swKE
            case Bytes.syr.lowercasedHashValue:   return .syr
            case Bytes.syrSY.lowercasedHashValue: return .syrSY
            case Bytes.ta.lowercasedHashValue:    return .ta
            case Bytes.taIN.lowercasedHashValue:  return .taIN
            case Bytes.te.lowercasedHashValue:    return .te
            case Bytes.teIN.lowercasedHashValue:  return .teIN
            case Bytes.th.lowercasedHashValue:    return .th
            case Bytes.thTH.lowercasedHashValue:  return .thTH
            case Bytes.tl.lowercasedHashValue:    return .tl
            case Bytes.tlPH.lowercasedHashValue:  return .tlPH
            case Bytes.tn.lowercasedHashValue:    return .tn
            case Bytes.tnZA.lowercasedHashValue:  return .tnZA
            case Bytes.tr.lowercasedHashValue:    return .tr
            case Bytes.trTR.lowercasedHashValue:  return .trTR
            case Bytes.tt.lowercasedHashValue:    return .tt
            case Bytes.ttRU.lowercasedHashValue:  return .ttRU
            case Bytes.ts.lowercasedHashValue:    return .ts
            case Bytes.uk.lowercasedHashValue:    return .uk
            case Bytes.ukUA.lowercasedHashValue:  return .ukUA
            case Bytes.ur.lowercasedHashValue:    return .ur
            case Bytes.urPK.lowercasedHashValue:  return .urPK
            case Bytes.uz.lowercasedHashValue:    return .uz
            case Bytes.uzUZ.lowercasedHashValue:  return .uzUZ
            case Bytes.vi.lowercasedHashValue:    return .vi
            case Bytes.viVN.lowercasedHashValue:  return .viVN
            case Bytes.xh.lowercasedHashValue:    return .xh
            case Bytes.xhZA.lowercasedHashValue:  return .xhZA
            case Bytes.zh.lowercasedHashValue:    return .zh
            case Bytes.zhCN.lowercasedHashValue:  return .zhCN
            case Bytes.zhHK.lowercasedHashValue:  return .zhHK
            case Bytes.zhMO.lowercasedHashValue:  return .zhMO
            case Bytes.zhSG.lowercasedHashValue:  return .zhSG
            case Bytes.zhTW.lowercasedHashValue:  return .zhTW
            case Bytes.zu.lowercasedHashValue:    return .zu
            case Bytes.zuZA.lowercasedHashValue:  return .zuZA
            case Bytes.any.lowercasedHashValue:   return .any
            default: return .custom(String(decoding: bytes, as: UTF8.self))
            }
        }
    }
}

extension Language {
    func encode<T: StreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .af:    bytes = Bytes.af
        case .afZA:  bytes = Bytes.afZA
        case .ar:    bytes = Bytes.ar
        case .arAE:  bytes = Bytes.arAE
        case .arBH:  bytes = Bytes.arBH
        case .arDZ:  bytes = Bytes.arDZ
        case .arEG:  bytes = Bytes.arEG
        case .arIQ:  bytes = Bytes.arIQ
        case .arJO:  bytes = Bytes.arJO
        case .arKW:  bytes = Bytes.arKW
        case .arLB:  bytes = Bytes.arLB
        case .arLY:  bytes = Bytes.arLY
        case .arMA:  bytes = Bytes.arMA
        case .arOM:  bytes = Bytes.arOM
        case .arQA:  bytes = Bytes.arQA
        case .arSA:  bytes = Bytes.arSA
        case .arSY:  bytes = Bytes.arSY
        case .arTN:  bytes = Bytes.arTN
        case .arYE:  bytes = Bytes.arYE
        case .az:    bytes = Bytes.az
        case .azAZ:  bytes = Bytes.azAZ
        case .be:    bytes = Bytes.be
        case .beBY:  bytes = Bytes.beBY
        case .bg:    bytes = Bytes.bg
        case .bgBG:  bytes = Bytes.bgBG
        case .bsBA:  bytes = Bytes.bsBA
        case .ca:    bytes = Bytes.ca
        case .caES:  bytes = Bytes.caES
        case .cs:    bytes = Bytes.cs
        case .csCZ:  bytes = Bytes.csCZ
        case .cy:    bytes = Bytes.cy
        case .cyGB:  bytes = Bytes.cyGB
        case .da:    bytes = Bytes.da
        case .daDK:  bytes = Bytes.daDK
        case .de:    bytes = Bytes.de
        case .deAT:  bytes = Bytes.deAT
        case .deCH:  bytes = Bytes.deCH
        case .deDE:  bytes = Bytes.deDE
        case .deLI:  bytes = Bytes.deLI
        case .deLU:  bytes = Bytes.deLU
        case .dv:    bytes = Bytes.dv
        case .dvMV:  bytes = Bytes.dvMV
        case .el:    bytes = Bytes.el
        case .elGR:  bytes = Bytes.elGR
        case .en:    bytes = Bytes.en
        case .enAU:  bytes = Bytes.enAU
        case .enBZ:  bytes = Bytes.enBZ
        case .enCA:  bytes = Bytes.enCA
        case .enCB:  bytes = Bytes.enCB
        case .enGB:  bytes = Bytes.enGB
        case .enIE:  bytes = Bytes.enIE
        case .enJM:  bytes = Bytes.enJM
        case .enNZ:  bytes = Bytes.enNZ
        case .enPH:  bytes = Bytes.enPH
        case .enTT:  bytes = Bytes.enTT
        case .enUS:  bytes = Bytes.enUS
        case .enZA:  bytes = Bytes.enZA
        case .enZW:  bytes = Bytes.enZW
        case .eo:    bytes = Bytes.eo
        case .es:    bytes = Bytes.es
        case .esAR:  bytes = Bytes.esAR
        case .esBO:  bytes = Bytes.esBO
        case .esCL:  bytes = Bytes.esCL
        case .esCO:  bytes = Bytes.esCO
        case .esCR:  bytes = Bytes.esCR
        case .esDO:  bytes = Bytes.esDO
        case .esEC:  bytes = Bytes.esEC
        case .esES:  bytes = Bytes.esES
        case .esGT:  bytes = Bytes.esGT
        case .esHN:  bytes = Bytes.esHN
        case .esMX:  bytes = Bytes.esMX
        case .esNI:  bytes = Bytes.esNI
        case .esPA:  bytes = Bytes.esPA
        case .esPE:  bytes = Bytes.esPE
        case .esPR:  bytes = Bytes.esPR
        case .esPY:  bytes = Bytes.esPY
        case .esSV:  bytes = Bytes.esSV
        case .esUY:  bytes = Bytes.esUY
        case .esVE:  bytes = Bytes.esVE
        case .et:    bytes = Bytes.et
        case .etEE:  bytes = Bytes.etEE
        case .eu:    bytes = Bytes.eu
        case .euES:  bytes = Bytes.euES
        case .fa:    bytes = Bytes.fa
        case .faIR:  bytes = Bytes.faIR
        case .fi:    bytes = Bytes.fi
        case .fiFI:  bytes = Bytes.fiFI
        case .fo:    bytes = Bytes.fo
        case .foFO:  bytes = Bytes.foFO
        case .fr:    bytes = Bytes.fr
        case .frBE:  bytes = Bytes.frBE
        case .frCA:  bytes = Bytes.frCA
        case .frCH:  bytes = Bytes.frCH
        case .frFR:  bytes = Bytes.frFR
        case .frLU:  bytes = Bytes.frLU
        case .frMC:  bytes = Bytes.frMC
        case .gl:    bytes = Bytes.gl
        case .glES:  bytes = Bytes.glES
        case .gu:    bytes = Bytes.gu
        case .guIN:  bytes = Bytes.guIN
        case .he:    bytes = Bytes.he
        case .heIL:  bytes = Bytes.heIL
        case .hi:    bytes = Bytes.hi
        case .hiIN:  bytes = Bytes.hiIN
        case .hr:    bytes = Bytes.hr
        case .hrBA:  bytes = Bytes.hrBA
        case .hrHR:  bytes = Bytes.hrHR
        case .hu:    bytes = Bytes.hu
        case .huHU:  bytes = Bytes.huHU
        case .hy:    bytes = Bytes.hy
        case .hyAM:  bytes = Bytes.hyAM
        case .id:    bytes = Bytes.id
        case .idID:  bytes = Bytes.idID
        case .`is`:  bytes = Bytes.is
        case .isIS:  bytes = Bytes.isIS
        case .it:    bytes = Bytes.it
        case .itCH:  bytes = Bytes.itCH
        case .itIT:  bytes = Bytes.itIT
        case .ja:    bytes = Bytes.ja
        case .jaJP:  bytes = Bytes.jaJP
        case .ka:    bytes = Bytes.ka
        case .kaGE:  bytes = Bytes.kaGE
        case .kk:    bytes = Bytes.kk
        case .kkKZ:  bytes = Bytes.kkKZ
        case .kn:    bytes = Bytes.kn
        case .knIN:  bytes = Bytes.knIN
        case .ko:    bytes = Bytes.ko
        case .koKR:  bytes = Bytes.koKR
        case .kok:   bytes = Bytes.kok
        case .kokIN: bytes = Bytes.kokIN
        case .ky:    bytes = Bytes.ky
        case .kyKG:  bytes = Bytes.kyKG
        case .lt:    bytes = Bytes.lt
        case .ltLT:  bytes = Bytes.ltLT
        case .lv:    bytes = Bytes.lv
        case .lvLV:  bytes = Bytes.lvLV
        case .mi:    bytes = Bytes.mi
        case .miNZ:  bytes = Bytes.miNZ
        case .mk:    bytes = Bytes.mk
        case .mkMK:  bytes = Bytes.mkMK
        case .mn:    bytes = Bytes.mn
        case .mnMN:  bytes = Bytes.mnMN
        case .mr:    bytes = Bytes.mr
        case .mrIN:  bytes = Bytes.mrIN
        case .ms:    bytes = Bytes.ms
        case .msBN:  bytes = Bytes.msBN
        case .msMY:  bytes = Bytes.msMY
        case .mt:    bytes = Bytes.mt
        case .mtMT:  bytes = Bytes.mtMT
        case .nb:    bytes = Bytes.nb
        case .nbNO:  bytes = Bytes.nbNO
        case .nl:    bytes = Bytes.nl
        case .nlBE:  bytes = Bytes.nlBE
        case .nlNL:  bytes = Bytes.nlNL
        case .nnNO:  bytes = Bytes.nnNO
        case .ns:    bytes = Bytes.ns
        case .nsZA:  bytes = Bytes.nsZA
        case .pa:    bytes = Bytes.pa
        case .paIN:  bytes = Bytes.paIN
        case .pl:    bytes = Bytes.pl
        case .plPL:  bytes = Bytes.plPL
        case .ps:    bytes = Bytes.ps
        case .psAR:  bytes = Bytes.psAR
        case .pt:    bytes = Bytes.pt
        case .ptBR:  bytes = Bytes.ptBR
        case .ptPT:  bytes = Bytes.ptPT
        case .qu:    bytes = Bytes.qu
        case .quBO:  bytes = Bytes.quBO
        case .quEC:  bytes = Bytes.quEC
        case .quPE:  bytes = Bytes.quPE
        case .ro:    bytes = Bytes.ro
        case .roRO:  bytes = Bytes.roRO
        case .ru:    bytes = Bytes.ru
        case .ruRU:  bytes = Bytes.ruRU
        case .sa:    bytes = Bytes.sa
        case .saIN:  bytes = Bytes.saIN
        case .se:    bytes = Bytes.se
        case .seFI:  bytes = Bytes.seFI
        case .seNO:  bytes = Bytes.seNO
        case .seSE:  bytes = Bytes.seSE
        case .sk:    bytes = Bytes.sk
        case .skSK:  bytes = Bytes.skSK
        case .sl:    bytes = Bytes.sl
        case .slSI:  bytes = Bytes.slSI
        case .sq:    bytes = Bytes.sq
        case .sqAL:  bytes = Bytes.sqAL
        case .srBA:  bytes = Bytes.srBA
        case .srSP:  bytes = Bytes.srSP
        case .sv:    bytes = Bytes.sv
        case .svFI:  bytes = Bytes.svFI
        case .svSE:  bytes = Bytes.svSE
        case .sw:    bytes = Bytes.sw
        case .swKE:  bytes = Bytes.swKE
        case .syr:   bytes = Bytes.syr
        case .syrSY: bytes = Bytes.syrSY
        case .ta:    bytes = Bytes.ta
        case .taIN:  bytes = Bytes.taIN
        case .te:    bytes = Bytes.te
        case .teIN:  bytes = Bytes.teIN
        case .th:    bytes = Bytes.th
        case .thTH:  bytes = Bytes.thTH
        case .tl:    bytes = Bytes.tl
        case .tlPH:  bytes = Bytes.tlPH
        case .tn:    bytes = Bytes.tn
        case .tnZA:  bytes = Bytes.tnZA
        case .tr:    bytes = Bytes.tr
        case .trTR:  bytes = Bytes.trTR
        case .tt:    bytes = Bytes.tt
        case .ttRU:  bytes = Bytes.ttRU
        case .ts:    bytes = Bytes.ts
        case .uk:    bytes = Bytes.uk
        case .ukUA:  bytes = Bytes.ukUA
        case .ur:    bytes = Bytes.ur
        case .urPK:  bytes = Bytes.urPK
        case .uz:    bytes = Bytes.uz
        case .uzUZ:  bytes = Bytes.uzUZ
        case .vi:    bytes = Bytes.vi
        case .viVN:  bytes = Bytes.viVN
        case .xh:    bytes = Bytes.xh
        case .xhZA:  bytes = Bytes.xhZA
        case .zh:    bytes = Bytes.zh
        case .zhCN:  bytes = Bytes.zhCN
        case .zhHK:  bytes = Bytes.zhHK
        case .zhMO:  bytes = Bytes.zhMO
        case .zhSG:  bytes = Bytes.zhSG
        case .zhTW:  bytes = Bytes.zhTW
        case .zu:    bytes = Bytes.zu
        case .zuZA:  bytes = Bytes.zuZA
        case .any:   bytes = Bytes.any
        case .custom(let value): bytes = [UInt8](value)
        }
        try stream.write(bytes)
    }
}
