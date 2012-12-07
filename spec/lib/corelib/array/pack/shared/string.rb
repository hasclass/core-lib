describe :array_pack_string, :shared => true do
  it "adds count bytes of a String to the output", ->
    ["abc"].pack(pack_format(2)).should == "ab"

  it "implicitly has a count of one when no count is specified", ->
    ["abc"].pack(pack_format).should == "a"

  it "does not add any bytes when the count is zero", ->
    ["abc"].pack(pack_format(0)).should == ""

  it "is not affected by a previous count modifier", ->
    ["abcde", "defg"].pack(pack_format(3)+pack_format).should == "abcd"

  it "raises an ArgumentError when the Array is empty", ->
    expect( -> [].pack(pack_format) ).toThrow(ArgumentError)

  it "raises an ArgumentError when the Array has too few elements", ->
    expect( -> ["a"].pack(pack_format(nil, 2)) ).toThrow(ArgumentError)

  it "calls #to_str to convert the element to a String", ->
    obj = mock('pack string')
    obj.should_receive(:to_str).and_return("abc")

    [obj].pack(pack_format).should == "a"

  it "raises a TypeError when the object does not respond to #to_str", ->
    obj = mock("not a string")
    expect( -> [obj].pack(pack_format) ).toThrow(TypeError)

  it "returns a tainted string when a pack argument is tainted", ->
    ["abcd".taint, 0x20].pack(pack_format("3C")).tainted?.should be_true

  it "does not return a tainted string when the array is tainted", ->
    ["abcd", 0x20].taint.pack(pack_format("3C")).tainted?.should be_false

  ruby_version_is "1.8.8", ->
    it "returns a tainted string when the format is tainted", ->
      ["abcd", 0x20].pack(pack_format("3C").taint).tainted?.should be_true
  
    it "returns a tainted string when an empty format is tainted", ->
      ["abcd", 0x20].pack("".taint).tainted?.should be_true
  
  ruby_version_is "1.9", ->
    it "returns a untrusted string when the format is untrusted", ->
      ["abcd", 0x20].pack(pack_format("3C").untrust).untrusted?.should be_true
  
    it "returns a untrusted string when the empty format is untrusted", ->
      ["abcd", 0x20].pack("".untrust).untrusted?.should be_true
  
    it "returns a untrusted string when a pack argument is untrusted", ->
      ["abcd".untrust, 0x20].pack(pack_format("3C")).untrusted?.should be_true
  
    it "returns a trusted string when the array is untrusted", ->
      ["abcd", 0x20].untrust.pack(pack_format("3C")).untrusted?.should be_false
  
    it "returns a string in encoding of common to the concatenated results", ->
      f = pack_format("*")
      [ [["\u{3042 3044 3046 3048}", 0x2000B].pack(f+"U"),       Encoding::ASCII_8BIT],
        [["abcde\xd1", "\xFF\xFe\x81\x82"].pack(f+"u"),          Encoding::ASCII_8BIT],
        [[encode("a", "ascii"), "\xFF\xFe\x81\x82"].pack(f+"u"), Encoding::ASCII_8BIT],
        # under discussion [ruby-dev:37294]
        [["\u{3042 3044 3046 3048}", 1].pack(f+"N"),             Encoding::ASCII_8BIT]
      ].should be_computed_by(:encoding)
