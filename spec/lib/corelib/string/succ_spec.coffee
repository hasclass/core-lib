describe "String#succ", ->
  it "returns an empty string for empty strings", ->
    expect(R("").succ().valueOf()).toEqual ""

  it "returns the successor by increasing the rightmost alphanumeric (digit => digit, letter => letter with same case)", ->
    expect(R("abcd").succ().valueOf()).toEqual "abce"
    expect(R("THX1138").succ().valueOf()).toEqual "THX1139"

    expect(R("<<koala>>").succ().valueOf()).toEqual "<<koalb>>"
    expect(R("==A??").succ().valueOf()).toEqual "==B??"

  it "increases non-alphanumerics (via ascii rules) if there are no alphanumerics", ->
    expect(R("***").succ().valueOf()).toEqual "**+"
    expect(R("**`").succ().valueOf()).toEqual "**a"

  it "increases the next best alphanumeric (jumping over non-alphanumerics) if there is a carry", ->
    expect(R("dz").succ().valueOf()).toEqual "ea"
    expect(R("HZ").succ().valueOf()).toEqual "IA"
    expect(R("49").succ().valueOf()).toEqual "50"

    expect(R("izz").succ().valueOf()).toEqual "jaa"
    expect(R("IZZ").succ().valueOf()).toEqual "JAA"
    expect(R("699").succ().valueOf()).toEqual "700"

    expect(R("6Z99z99Z").succ().valueOf()).toEqual "7A00a00A"

    expect(R("1999zzz").succ().valueOf()).toEqual "2000aaa"
    expect(R("NZ/[]ZZZ9999").succ().valueOf()).toEqual "OA/[]AAA0000"

  it "increases the next best character if there is a carry for non-alphanumerics", ->
    expect(R("(\xFF").succ().valueOf()).toEqual ")\x00"
    expect(R("`\xFF").succ().valueOf()).toEqual "a\x00"
    expect(R("<\xFF\xFF").succ().valueOf()).toEqual "=\x00\x00"

  it "adds an additional character (just left to the last increased one) if there is a carry and no character left to increase", ->
    expect(R("z").succ().valueOf()).toEqual "aa"
    expect(R("Z").succ().valueOf()).toEqual "AA"
    expect(R("9").succ().valueOf()).toEqual "10"

    expect(R("zz").succ().valueOf()).toEqual "aaa"
    expect(R("ZZ").succ().valueOf()).toEqual "AAA"
    expect(R("99").succ().valueOf()).toEqual "100"

    expect(R("9Z99z99Z").succ().valueOf()).toEqual "10A00a00A"

    expect(R("ZZZ9999").succ().valueOf()).toEqual "AAAA0000"
    expect(R("/[]ZZZ9999").succ().valueOf()).toEqual "/[]AAAA0000"
    expect(R("Z/[]ZZZ9999").succ().valueOf()).toEqual "AA/[]AAA0000"

    # non-alphanumeric cases
    expect(R("\xFF").succ().valueOf()).toEqual "\x01\x00"
    expect(R("\xFF\xFF").succ().valueOf()).toEqual "\x01\x00\x00"

  #it "returns subclass instances when called on a subclass", ->
  #  expect(StringSpecs::MyString.new("").succ().valueOf()).toEqual(StringSpecs::MyString)
  #  expect(StringSpecs::MyString.new("a").succ().valueOf()).toEqual(StringSpecs::MyString)
  #  expect(StringSpecs::MyString.new("z").succ().valueOf()).toEqual(StringSpecs::MyString)

  #it "taints the result if self is tainted", ->
  #  ["", "a", "z", "Z", "9", "\xFF", "\xFF\xFF"].each, -> |s|
  #    expect(s.taint.succ().tainted?.valueOf()).toEqual true
