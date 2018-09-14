import Stream

struct Constants {
    static let lineEnd: [UInt8] = [.cr, .lf]
    static let minimumHeaderLength = ASCII("a:a\r\n").count
    static let minimumChunkLength = ASCII("0\r\n").count
}

extension Set where Element == UInt8 {
    init(_ string: String) {
        self = Set<UInt8>(ASCII(string))
    }

    static let letters = Set<UInt8>(
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

    static let digits = Set<UInt8>(
        "0123456789")

    static let idnAllowed = letters.union(digits).union(Set<UInt8>(
        "-."))

    static let cookieAllowed =
        letters.union(digits).union(Set<UInt8>(
        "!#$%&'()*+,-./:<>?@[]^_`{|}~- "))

    static let pathAllowed =
        letters.union(digits).union(Set<UInt8>(
        "%!$&'()*+,-./:=@_~"))

    static let queryAllowed = pathAllowed.union(Set<UInt8>(";?"))
    static let queryPartAllowed = queryAllowed.subtracting(Set<UInt8>("=&"))
    static let fragmentAllowed = queryAllowed
}

import Stream

extension AllowedBytes {
    static let digits = AllowedBytes(byteSet: [
        .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine
    ])
    static let domain = AllowedBytes(byteSet: .idnAllowed)
    static let cookie = AllowedBytes(byteSet: .cookieAllowed)

    static let path = AllowedBytes(byteSet: .pathAllowed)
    static let query = AllowedBytes(byteSet: .queryAllowed)
    static let queryPart = AllowedBytes(byteSet: .queryPartAllowed)
    static let fragment = AllowedBytes(byteSet: .fragmentAllowed)
}

extension AllowedBytes {
    // token          = 1*<any CHAR except CTLs or separators>
    // separators     = "(" | ")" | "<" | ">" | "@"
    //                | "," | ";" | ":" | "\" | <">
    //                | "/" | "[" | "]" | "?" | "="
    //                | "{" | "}" | SP  | HT
    static let token = AllowedBytes(asciiTable: (
        /* nul   soh   stx    etx    eot    enq    ack    bel */
        false, false, false, false, false, false, false, false,
        /* bs    ht     nl    vt     np     cr     so     si  */
        false, false, false, false, false, false, false, false,
        /* dle   dc    dc     dc     dc     nak    syn    etb */
        false, false, false, false, false, false, false, false,
        /* can   em    sub    esc    fs     gs     rs     us  */
        false, false, false, false, false, false, false, false,
        /* sp    !      "      #      $      %      &      '  */
        false, true,  false, true,  true,  true,  true,  true,
        /* (     )      *      +      ,      -      .      /  */
        false, false, true,  true,  false, true,  true,  false,
        /* 0     1      2      3      4      5      6      7  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* 8     9      :      ;      <      =      >      ?  */
        true,  true,  false, false, false, false, false, false,
        /* @     A      B      C      D      E      F      G  */
        false, true,  true,  true,  true,  true,  true,  true,
        /* H     I      J      K      L      M      N      O  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* P     Q      R      S      T      U      V      W  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* X     Y      Z      [      \      ]      ^      _  */
        true,  true,  true,  false, false, false, true,  true,
        /* `     a      b      c      d      e      f      g  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* h     i      j      k      l      m      n      o  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* p     q      r      s      t      u      v      w  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* x     y      z      {      |      }      ~     del */
        true,  true,  true,  false, true,  false, true,  false))

    // <any OCTET except CTLs, but including LWS>
    static let text = AllowedBytes(asciiTable: (
        /* nul   soh   stx    etx    eot    enq    ack    bel */
        false, false, false, false, false, false, false, false,
        /* bs    ht     nl    vt     np     cr     so     si  */
        false, true,  false, false, false, false, false, false,
        /* dle   dc    dc     dc     dc     nak    syn    etb */
        false, false, false, false, false, false, false, false,
        /* can   em    sub    esc    fs     gs     rs     us  */
        false, false, false, false, false, false, false, false,
        /* sp    !      "      #      $      %      &      '  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* (     )      *      +      ,      -      .      /  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* 0     1      2      3      4      5      6      7  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* 8     9      :      ;      <      =      >      ?  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* @     A      B      C      D      E      F      G  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* H     I      J      K      L      M      N      O  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* P     Q      R      S      T      U      V      W  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* X     Y      Z      [      \      ]      ^      _  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* `     a      b      c      d      e      f      g  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* h     i      j      k      l      m      n      o  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* p     q      r      s      t      u      v      w  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* x     y      z      {      |      }      ~     del */
        true,  true,  true,  true,  true,  true,  true,  false))

    // <any OCTET except CTLs, but including LWS and CRLF>
    public static let ascii = AllowedBytes(asciiTable: (
        /* nul   soh   stx    etx    eot    enq    ack    bel */
        false, false, false, false, false, false, false, false,
        /* bs    ht     nl    vt     np     cr     so     si  */
        false, true,  true, false, false, true,  false, false,
        /* dle   dc    dc     dc     dc     nak    syn    etb */
        false, false, false, false, false, false, false, false,
        /* can   em    sub    esc    fs     gs     rs     us  */
        false, false, false, false, false, false, false, false,
        /* sp    !      "      #      $      %      &      '  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* (     )      *      +      ,      -      .      /  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* 0     1      2      3      4      5      6      7  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* 8     9      :      ;      <      =      >      ?  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* @     A      B      C      D      E      F      G  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* H     I      J      K      L      M      N      O  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* P     Q      R      S      T      U      V      W  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* X     Y      Z      [      \      ]      ^      _  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* `     a      b      c      d      e      f      g  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* h     i      j      k      l      m      n      o  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* p     q      r      s      t      u      v      w  */
        true,  true,  true,  true,  true,  true,  true,  true,
        /* x     y      z      {      |      }      ~     del */
        true,  true,  true,  true,  true,  true,  true,  false))
}
