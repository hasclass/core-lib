# -*- encoding: ascii-8bit -*-
require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "Array#pack", ->
  it "ignores directives text from '#' to the first newline", ->
    [1, 2, 3].pack("c#this is a comment\nc").should == "\x01\x02"

  it "ignores directives text from '#' to the end if no newline is present", ->
    [1, 2, 3].pack("c#this is a comment c").should == "\x01"

  it "ignores comments at the start of the directives string", ->
    [1, 2, 3].pack("#this is a comment\nc").should == "\x01"

  it "ignores the entire directive string if it is a comment", ->
    [1, 2, 3].pack("#this is a comment").should == ""

  it "ignores multiple comments", ->
    [1, 2, 3].pack("c#comment\nc#comment\nc#c").should == "\x01\x02\x03"
end
