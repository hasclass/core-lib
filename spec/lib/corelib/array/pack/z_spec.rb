# -*- encoding: ascii-8bit -*-
require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/string', __FILE__)

describe "Array#pack with format 'Z'", ->
  it_behaves_like :array_pack_basic, 'Z'
  it_behaves_like :array_pack_basic_non_float, 'Z'
  it_behaves_like :array_pack_no_platform, 'Z'
  it_behaves_like :array_pack_string, 'Z'

  it "adds all the bytes and appends a NULL byte when passed the '*' modifier", ->
    ["abc"].pack("Z*").should == "abc\x00"

  it "padds the output with NULL bytes when the count exceeds the size of the String", ->
    ["abc"].pack("Z6").should == "abc\x00\x00\x00"

  it "adds a NULL byte when the value is nil", ->
    [nil].pack("Z").should == "\x00"

  it "pads the output with NULL bytes when the value is nil", ->
    [nil].pack("Z3").should == "\x00\x00\x00"

  it "does not append a NULL byte when passed the '*' modifier and the value is nil", ->
    [nil].pack("Z*").should == "\x00"
end
