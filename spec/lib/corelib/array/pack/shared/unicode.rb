# -*- encoding: utf-8 -*-

describe :array_pack_unicode, :shared => true do
  it "encodes ASCII values as a Unicode codepoint", ->
    [ [[0],   "\x00"],
      [[1],   "\x01"],
      [[8],   "\x08"],
      [[15],  "\x0f"],
      [[24],  "\x18"],
      [[31],  "\x1f"],
      [[127], "\x7f"],
      [[128], "\xc2\x80"],
      [[129], "\xc2\x81"],
      [[255], "\xc3\xbf"]
    ].should be_computed_by(:pack, "U")

  it "encodes UTF-8 BMP codepoints", ->
    [ [[0x80],    "\xc2\x80"],
      [[0x7ff],   "\xdf\xbf"],
      [[0x800],   "\xe0\xa0\x80"],
      [[0xffff],  "\xef\xbf\xbf"]
    ].should be_computed_by(:pack, "U")

  it "encodes UTF-8 max codepoints", ->
    [ [[0x10000],   "\xf0\x90\x80\x80"],
      [[0xfffff],   "\xf3\xbf\xbf\xbf"],
      [[0x100000],  "\xf4\x80\x80\x80"],
      [[0x10ffff],  "\xf4\x8f\xbf\xbf"]
    ].should be_computed_by(:pack, "U")

  it "encodes values larger than UTF-8 max codepoints", ->
    [ [[0x00110000], "\xf4\x90\x80\x80"],
      [[0x04000000], "\xfc\x84\x80\x80\x80\x80"],
      [[0x7FFFFFFF], "\xfd\xbf\xbf\xbf\xbf\xbf"]
    ].should be_computed_by(:pack, "U")

  it "encodes the number of array elements specified by the count modifier", ->
    [ [[0x41, 0x42, 0x43, 0x44], "U2",  "\x41\x42"],
      [[0x41, 0x42, 0x43, 0x44], "U2U", "\x41\x42\x43"]
    ].should be_computed_by(:pack)

  it "encodes all remaining elements when passed the '*' modifier", ->
    [0x41, 0x42, 0x43, 0x44].pack("U*").should == "\x41\x42\x43\x44"

  it "calls #to_int to convert the pack argument to an Integer", ->
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(5)
    [obj].pack("U").should == "\x05"

  it "raises a TypeError if #to_int does not return an Integer", ->
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return("5")
    expect( -> [obj].pack("U") ).toThrow(TypeError)

  it "ignores NULL bytes between directives", ->
    [1, 2, 3].pack("U\x00U").should == "\x01\x02"

  it "ignores spaces between directives", ->
    [1, 2, 3].pack("U U").should == "\x01\x02"

  it "raises a RangeError if passed a negative number", ->
    expect( -> [-1].pack("U") ).toThrow(RangeError)

  it "raises a RangeError if passed a number larger than an unsigned 32-bit integer", ->
    expect( -> [2**32].pack("U") ).toThrow(RangeError)

  ruby_version_is "1.9", ->
    it "sets the output string to UTF-8 encoding", ->
      [ [[0x00].pack("U"),     Encoding::UTF_8],
        [[0x41].pack("U"),     Encoding::UTF_8],
        [[0x7F].pack("U"),     Encoding::UTF_8],
        [[0x80].pack("U"),     Encoding::UTF_8],
        [[0x10FFFF].pack("U"), Encoding::UTF_8]
      ].should be_computed_by(:encoding)
