describe "String#chr", ->
  it "returns a copy of self", ->
    s = R 'e'
    expect( s.chr() is s).toEqual false

  it "returns a String", ->
    expect( R('glark').chr().is_string? ).toEqual true

  it "returns an empty String if self is an empty String", ->
    expect( R("").chr() ).toEqual R("")

  it "returns a 1-character String", ->
    expect( R("glark").chr().size() ).toEqual R(1)

  it "returns the character at the start of the String", ->
    expect( R("Goodbye, world").chr() ).toEqual R("G")

  xit "returns a String in the same encoding as self", ->
    # "\x24".encode(Encoding::US_ASCII).chr.encoding.should == Encoding::US_ASCII

  xit "understands multi-byte characters", ->
    # s = "\u{9879}"
    # s.bytesize.should == 3
    # s.chr.should == s

  xit "understands Strings that contain a mixture of character widths", ->
    # three = "\u{8082}"
    # three.bytesize.should == 3
    # four = "\u{77082}"
    # four.bytesize.should == 4
    # "#{three}#{four}".chr.should == three
