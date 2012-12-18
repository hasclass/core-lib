require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#to_f", ->
  it "returns the float number of seconds + usecs since the epoch", ->
    R.Time.at(100, 100).to_f.should == 100.0001
