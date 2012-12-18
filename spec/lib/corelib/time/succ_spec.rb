require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#succ", ->
  it "returns a new time one second later than time", ->
    R.Time.at(100).succ.should == R.Time.at(101)

  it "returns a new instance", ->
    t1 = R.Time.at(100)
    t2 = t1.succ
    t1.object_id.should_not == t2.object_id
