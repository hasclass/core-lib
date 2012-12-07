describe "String#succ", ->
  it "returns an empty string for empty strings", ->
    expect(R("").succ().unbox()).toEqual ""

  it "returns the successor by increasing the rightmost alphanumeric (digit => digit, letter => letter with same case)", ->
    expect(R("abcd").succ().unbox()).toEqual "abce"
    expect(R("THX1138").succ().unbox()).toEqual "THX1139"

    expect(R("<<koala>>").succ().unbox()).toEqual "<<koalb>>"
    expect(R("==A??").succ().unbox()).toEqual "==B??"

  it "increases non-alphanumerics (via ascii rules) if there are no alphanumerics", ->
    expect(R("***").succ().unbox()).toEqual "**+"
    expect(R("**`").succ().unbox()).toEqual "**a"

  it "increases the next best alphanumeric (jumping over non-alphanumerics) if there is a carry", ->
    expect(R("dz").succ().unbox()).toEqual "ea"
    expect(R("HZ").succ().unbox()).toEqual "IA"
    expect(R("49").succ().unbox()).toEqual "50"

    expect(R("izz").succ().unbox()).toEqual "jaa"
    expect(R("IZZ").succ().unbox()).toEqual "JAA"
    expect(R("699").succ().unbox()).toEqual "700"

    expect(R("6Z99z99Z").succ().unbox()).toEqual "7A00a00A"

    expect(R("1999zzz").succ().unbox()).toEqual "2000aaa"
    expect(R("NZ/[]ZZZ9999").succ().unbox()).toEqual "OA/[]AAA0000"

  it "increases the next best character if there is a carry for non-alphanumerics", ->
    expect(R("(\xFF").succ().unbox()).toEqual ")\x00"
    expect(R("`\xFF").succ().unbox()).toEqual "a\x00"
    expect(R("<\xFF\xFF").succ().unbox()).toEqual "=\x00\x00"

  it "adds an additional character (just left to the last increased one) if there is a carry and no character left to increase", ->
    expect(R("z").succ().unbox()).toEqual "aa"
    expect(R("Z").succ().unbox()).toEqual "AA"
    expect(R("9").succ().unbox()).toEqual "10"

    expect(R("zz").succ().unbox()).toEqual "aaa"
    expect(R("ZZ").succ().unbox()).toEqual "AAA"
    expect(R("99").succ().unbox()).toEqual "100"

    expect(R("9Z99z99Z").succ().unbox()).toEqual "10A00a00A"

    expect(R("ZZZ9999").succ().unbox()).toEqual "AAAA0000"
    expect(R("/[]ZZZ9999").succ().unbox()).toEqual "/[]AAAA0000"
    expect(R("Z/[]ZZZ9999").succ().unbox()).toEqual "AA/[]AAA0000"

    # non-alphanumeric cases
    expect(R("\xFF").succ().unbox()).toEqual "\x01\x00"
    expect(R("\xFF\xFF").succ().unbox()).toEqual "\x01\x00\x00"

  #it "returns subclass instances when called on a subclass", ->
  #  expect(StringSpecs::MyString.new("").succ().unbox()).toEqual(StringSpecs::MyString)
  #  expect(StringSpecs::MyString.new("a").succ().unbox()).toEqual(StringSpecs::MyString)
  #  expect(StringSpecs::MyString.new("z").succ().unbox()).toEqual(StringSpecs::MyString)

  #it "taints the result if self is tainted", ->
  #  ["", "a", "z", "Z", "9", "\xFF", "\xFF\xFF"].each, -> |s|
  #    expect(s.taint.succ().tainted?.unbox()).toEqual true
