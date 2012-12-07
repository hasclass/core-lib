# -*- encoding: ascii-8bit -*-
require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/string', __FILE__)

describe "Array#pack with format 'A'", ->
  it_behaves_like :array_pack_basic, 'A'
  it_behaves_like :array_pack_basic_non_float, 'A'
  it_behaves_like :array_pack_no_platform, 'A'
  it_behaves_like :array_pack_string, 'A'

  it "adds all the bytes to the output when passed the '*' modifier", ->
    ["abc"].pack("A*").should == "abc"

  it "padds the output with spaces when the count exceeds the size of the String", ->
    ["abc"].pack("A6").should == "abc   "

  it "adds a space when the value is nil", ->
    [nil].pack("A").should == " "

  it "pads the output with spaces when the value is nil", ->
    [nil].pack("A3").should == "   "

  it "does not pad with spaces when passed the '*' modifier and the value is nil", ->
    [nil].pack("A*").should == ""
end

describe "Array#pack with format 'a'", ->
  it_behaves_like :array_pack_basic, 'a'
  it_behaves_like :array_pack_basic_non_float, 'a'
  it_behaves_like :array_pack_no_platform, 'a'
  it_behaves_like :array_pack_string, 'a'

  it "adds all the bytes to the output when passed the '*' modifier", ->
    ["abc"].pack("a*").should == "abc"

  it "padds the output with NULL bytes when the count exceeds the size of the String", ->
    ["abc"].pack("a6").should == "abc\x00\x00\x00"

  it "adds a NULL byte when the value is nil", ->
    [nil].pack("a").should == "\x00"

  it "pads the output with NULL bytes when the value is nil", ->
    [nil].pack("a3").should == "\x00\x00\x00"

  it "does not pad with NULL bytes when passed the '*' modifier and the value is nil", ->
    [nil].pack("a*").should == ""
end
