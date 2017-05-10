struct Character {
    static let whitespace = ASCII(" ").first!
    static let cr = ASCII("\r").first!
    static let lf = ASCII("\n").first!
    static let colon = ASCII(":").first!
    static let semicolon = ASCII(";").first!
    static let comma = ASCII(",").first!
    static let questionMark = ASCII("?").first!
}

struct Constants {
    static let httpSlash = ASCII("HTTP/")
    static let oneOne = ASCII("1.1")

    static let lineEnd = [Character.cr, Character.lf]

    static let versionLength = httpSlash.count + oneOne.count
    static let minimumHeaderLength = ASCII("a:a\r\n").count

    static let chunked = ASCII("chunked")
    static let minimumChunkLength = ASCII("0\r\n").count

    static let qEqual = ASCII("q=")

    struct Encoding {
        static let isoLatin1 = ASCII("ISO-8859-1")
        static let utf8 = ASCII("utf-8")
        static let any = ASCII("*")
    }
}

let tokens: [Bool] = [
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
    true,  true,  true,  false, true,  false, true,  false ]
