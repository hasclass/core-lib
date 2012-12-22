require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#hash", ->
  it "returns a Fixnum", ->
    R.Time.at(100).hash.should be_kind_of(R.Fixnum)

  it "is stable", ->
    R.Time.at(1234).hash.should == R.Time.at(1234).hash
