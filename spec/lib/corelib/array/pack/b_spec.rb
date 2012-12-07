# -*- encoding: ascii-8bit -*-
require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/encodings', __FILE__)

describe "Array#pack with format 'B'", ->
  it_behaves_like :array_pack_basic, 'B'
  it_behaves_like :array_pack_basic_non_float, 'B'
  it_behaves_like :array_pack_arguments, 'B'
  it_behaves_like :array_pack_hex, 'B'

  it "calls #to_str to convert an Object to a String", ->
    obj = mock("pack H string")
    obj.should_receive(:to_str).and_return("``abcdef")
    [obj].pack("B*").should == "\x2a"

  it "encodes one bit for each character starting with the most significant bit", ->
    [ [["0"], "\x00"],
      [["1"], "\x80"]
    ].should be_computed_by(:pack, "B")

  it "implicitly has a count of one when not passed a count modifier", ->
    ["1"].pack("B").should == "\x80"

  it "implicitly has count equal to the string length when passed the '*' modifier", ->
    [ [["00101010"], "\x2a"],
      [["00000000"], "\x00"],
      [["11111111"], "\xff"],
      [["10000000"], "\x80"],
      [["00000001"], "\x01"]
    ].should be_computed_by(:pack, "B*")

  it "encodes the least significant bit of a character other than 0 or 1", ->
    [ [["bbababab"], "\x2a"],
      [["^&#&#^#^"], "\x2a"],
      [["(()()()("], "\x2a"],
      [["@@%@%@%@"], "\x2a"],
      [["ppqrstuv"], "\x2a"],
      [["rqtvtrqp"], "\x42"]
    ].should be_computed_by(:pack, "B*")

  ruby_version_is "1.9", ->
    it "returns an ASCII-8BIT string", ->
      ["1"].pack("B").encoding.should == Encoding::ASCII_8BIT
  
    it "encodes the string as a sequence of bytes", ->
      ["ああああああああ"].pack("B*").should == "\xdbm\xb6"

describe "Array#pack with format 'b'", ->
  it_behaves_like :array_pack_basic, 'b'
  it_behaves_like :array_pack_basic_non_float, 'b'
  it_behaves_like :array_pack_arguments, 'b'
  it_behaves_like :array_pack_hex, 'b'

  it "calls #to_str to convert an Object to a String", ->
    obj = mock("pack H string")
    obj.should_receive(:to_str).and_return("`abcdef`")
    [obj].pack("b*").should == "\x2a"

  it "encodes one bit for each character starting with the least significant bit", ->
    [ [["0"], "\x00"],
      [["1"], "\x01"]
    ].should be_computed_by(:pack, "b")

  it "implicitly has a count of one when not passed a count modifier", ->
    ["1"].pack("b").should == "\x01"

  it "implicitly has count equal to the string length when passed the '*' modifier", ->
    [ [["0101010"],  "\x2a"],
      [["00000000"], "\x00"],
      [["11111111"], "\xff"],
      [["10000000"], "\x01"],
      [["00000001"], "\x80"]
    ].should be_computed_by(:pack, "b*")

  it "encodes the least significant bit of a character other than 0 or 1", ->
    [ [["bababab"], "\x2a"],
      [["&#&#^#^"], "\x2a"],
      [["()()()("], "\x2a"],
      [["@%@%@%@"], "\x2a"],
      [["pqrstuv"], "\x2a"],
      [["qrtrtvs"], "\x41"]
    ].should be_computed_by(:pack, "b*")

  ruby_version_is "1.9", ->
    it "returns an ASCII-8BIT string", ->
      ["1"].pack("b").encoding.should == Encoding::ASCII_8BIT
  
    it "encodes the string as a sequence of bytes", ->
      ["ああああああああ"].pack("b*").should == "\xdb\xb6m"
