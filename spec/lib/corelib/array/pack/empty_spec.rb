require File.expand_path('../../../../spec_helper', __FILE__)

describe "Array#pack with empty format", ->
  it "returns an empty String", ->
    [1, 2, 3].pack("").should == ""

  ruby_version_is "1.9", ->
    it "returns a String with US-ASCII encoding", ->
      [1, 2, 3].pack("").encoding.should == Encoding::US_ASCII
