# -*- encoding: ascii-8bit -*-

describe :array_pack_float_le, :shared => true do
  it "encodes a positive Float", ->
    [1.42].pack(pack_format).should == "\x8f\xc2\xb5?"

  it "encodes a negative Float", ->
    [-34.2].pack(pack_format).should == "\xcd\xcc\x08\xc2"

  it "converts an Integer to a Float", ->
    [8].pack(pack_format).should == "\x00\x00\x00A"

  ruby_version_is ""..."1.9", ->
    it "converts a String representation of a floating point number to a Float", ->
      ["13"].pack(pack_format).should == "\x00\x00PA"
  
    it "calls #to_f to convert an object to a float", ->
      obj = mock("pack float")
      obj.should_receive(:to_f).and_return(7.2)

      [obj].pack(pack_format).should == "ff\xe6@"
  
  ruby_version_is "1.9", ->
    it "raises a TypeError if passed a String representation of a floating point number", ->
      expect( -> ["13"].pack(pack_format) ).toThrow(TypeError)
  
  it "encodes the number of array elements specified by the count modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format(nil, 2)).should == "\x9a\x999@33\xb3?"

  it "encodes all remaining elements when passed the '*' modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format("*")).should == "\x9a\x999@33\xb3?33\x03A"

  it "ignores NULL bytes between directives", ->
    [5.3, 9.2].pack(pack_format("\000", 2)).should == "\x9a\x99\xa9@33\x13A"

  it "ignores spaces between directives", ->
    [5.3, 9.2].pack(pack_format(" ", 2)).should == "\x9a\x99\xa9@33\x13A"

  it "encodes positive Infinity", ->
    [infinity_value].pack(pack_format).should == "\x00\x00\x80\x7f"

  it "encodes negative Infinity", ->
    [-infinity_value].pack(pack_format).should == "\x00\x00\x80\xff"

  it "encodes NaN", ->
    [nan_value].pack(pack_format).should == "\x00\x00\xc0\xff"

  it "encodes a positive Float outside the range of a single precision float", ->
    [1e150].pack(pack_format).should == "\x00\x00\x80\x7f"

  it "encodes a negative Float outside the range of a single precision float", ->
    [-1e150].pack(pack_format).should == "\x00\x00\x80\xff"
end

describe :array_pack_float_be, :shared => true do
  it "encodes a positive Float", ->
    [1.42].pack(pack_format).should == "?\xb5\xc2\x8f"

  it "encodes a negative Float", ->
    [-34.2].pack(pack_format).should == "\xc2\x08\xcc\xcd"

  it "converts an Integer to a Float", ->
    [8].pack(pack_format).should == "A\x00\x00\x00"

  ruby_version_is ""..."1.9", ->
    it "converts a String representation of a floating point number to a Float", ->
      ["13"].pack(pack_format).should == "AP\x00\x00"
  
    it "calls #to_f to convert an object to a float", ->
      obj = mock("pack float")
      obj.should_receive(:to_f).and_return(7.2)

      [obj].pack(pack_format).should == "@\xe6ff"
  
  ruby_version_is "1.9", ->
    it "raises a TypeError if passed a String representation of a floating point number", ->
      expect( -> ["13"].pack(pack_format) ).toThrow(TypeError)
  
  it "encodes the number of array elements specified by the count modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format(nil, 2)).should == "@9\x99\x9a?\xb333"

  it "encodes all remaining elements when passed the '*' modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format("*")).should == "@9\x99\x9a?\xb333A\x0333"

  it "ignores NULL bytes between directives", ->
    [5.3, 9.2].pack(pack_format("\000", 2)).should == "@\xa9\x99\x9aA\x1333"

  it "ignores spaces between directives", ->
    [5.3, 9.2].pack(pack_format(" ", 2)).should == "@\xa9\x99\x9aA\x1333"

  it "encodes positive Infinity", ->
    [infinity_value].pack(pack_format).should == "\x7f\x80\x00\x00"

  it "encodes negative Infinity", ->
    [-infinity_value].pack(pack_format).should == "\xff\x80\x00\x00"

  it "encodes NaN", ->
    [nan_value].pack(pack_format).should == "\xff\xc0\x00\x00"

  it "encodes a positive Float outside the range of a single precision float", ->
    [1e150].pack(pack_format).should == "\x7f\x80\x00\x00"

  it "encodes a negative Float outside the range of a single precision float", ->
    [-1e150].pack(pack_format).should == "\xff\x80\x00\x00"
end

describe :array_pack_double_le, :shared => true do
  it "encodes a positive Float", ->
    [1.42].pack(pack_format).should == "\xb8\x1e\x85\xebQ\xb8\xf6?"

  it "encodes a negative Float", ->
    [-34.2].pack(pack_format).should == "\x9a\x99\x99\x99\x99\x19A\xc0"

  it "converts an Integer to a Float", ->
    [8].pack(pack_format).should == "\x00\x00\x00\x00\x00\x00\x20@"

  ruby_version_is ""..."1.9", ->
    it "converts a String representation of a floating point number to a Float", ->
      ["13"].pack(pack_format).should == "\x00\x00\x00\x00\x00\x00\x2a@"
  
    it "calls #to_f to convert an object to a float", ->
      obj = mock("pack float")
      obj.should_receive(:to_f).and_return(7.2)

      [obj].pack(pack_format).should == "\xcd\xcc\xcc\xcc\xcc\xcc\x1c@"
  
  ruby_version_is "1.9", ->
    it "raises a TypeError if passed a String representation of a floating point number", ->
      expect( -> ["13"].pack(pack_format) ).toThrow(TypeError)
  
  it "encodes the number of array elements specified by the count modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format(nil, 2)).should == "333333\x07@ffffff\xf6?"

  it "encodes all remaining elements when passed the '*' modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format("*")).should == "333333\x07@ffffff\xf6?ffffff\x20@"

  it "ignores NULL bytes between directives", ->
    [5.3, 9.2].pack(pack_format("\000", 2)).should == "333333\x15@ffffff\x22@"

  it "ignores spaces between directives", ->
    [5.3, 9.2].pack(pack_format(" ", 2)).should == "333333\x15@ffffff\x22@"

  it "encodes positive Infinity", ->
    [infinity_value].pack(pack_format).should == "\x00\x00\x00\x00\x00\x00\xf0\x7f"

  it "encodes negative Infinity", ->
    [-infinity_value].pack(pack_format).should == "\x00\x00\x00\x00\x00\x00\xf0\xff"

  it "encodes NaN", ->
    [nan_value].pack(pack_format).should == "\x00\x00\x00\x00\x00\x00\xf8\xff"

  it "encodes a positive Float outside the range of a single precision float", ->
    [1e150].pack(pack_format).should == "\xaf\x96P\x2e5\x8d\x13_"

  it "encodes a negative Float outside the range of a single precision float", ->
    [-1e150].pack(pack_format).should == "\xaf\x96P\x2e5\x8d\x13\xdf"
end

describe :array_pack_double_be, :shared => true do
  it "encodes a positive Float", ->
    [1.42].pack(pack_format).should == "?\xf6\xb8Q\xeb\x85\x1e\xb8"

  it "encodes a negative Float", ->
    [-34.2].pack(pack_format).should == "\xc0A\x19\x99\x99\x99\x99\x9a"

  it "converts an Integer to a Float", ->
    [8].pack(pack_format).should == "@\x20\x00\x00\x00\x00\x00\x00"

  ruby_version_is ""..."1.9", ->
    it "converts a String representation of a floating point number to a Float", ->
      ["13"].pack(pack_format).should == "@\x2a\x00\x00\x00\x00\x00\x00"
  
    it "calls #to_f to convert an object to a float", ->
      obj = mock("pack float")
      obj.should_receive(:to_f).and_return(7.2)

      [obj].pack(pack_format).should == "@\x1c\xcc\xcc\xcc\xcc\xcc\xcd"
  
  ruby_version_is "1.9", ->
    it "raises a TypeError if passed a String representation of a floating point number", ->
      expect( -> ["13"].pack(pack_format) ).toThrow(TypeError)
  
  it "encodes the number of array elements specified by the count modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format(nil, 2)).should == "@\x07333333?\xf6ffffff"

  it "encodes all remaining elements when passed the '*' modifier", ->
    [2.9, 1.4, 8.2].pack(pack_format("*")).should == "@\x07333333?\xf6ffffff@\x20ffffff"

  it "ignores NULL bytes between directives", ->
    [5.3, 9.2].pack(pack_format("\000", 2)).should == "@\x15333333@\x22ffffff"

  it "ignores spaces between directives", ->
    [5.3, 9.2].pack(pack_format(" ", 2)).should == "@\x15333333@\x22ffffff"

  it "encodes positive Infinity", ->
    [infinity_value].pack(pack_format).should == "\x7f\xf0\x00\x00\x00\x00\x00\x00"

  it "encodes negative Infinity", ->
    [-infinity_value].pack(pack_format).should == "\xff\xf0\x00\x00\x00\x00\x00\x00"

  it "encodes NaN", ->
    [nan_value].pack(pack_format).should == "\xff\xf8\x00\x00\x00\x00\x00\x00"

  it "encodes a positive Float outside the range of a single precision float", ->
    [1e150].pack(pack_format).should == "_\x13\x8d5\x2eP\x96\xaf"

  it "encodes a negative Float outside the range of a single precision float", ->
    [-1e150].pack(pack_format).should == "\xdf\x13\x8d5\x2eP\x96\xaf"
end
