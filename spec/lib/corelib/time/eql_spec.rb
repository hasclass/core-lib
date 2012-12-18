require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#eql?", ->
  it "returns true if self and other have the same whole number of seconds", ->
    R.Time.at(100).should eql(R.Time.at(100))

  it "returns false if self and other have differing whole numbers of seconds", ->
    R.Time.at(100).should_not eql(R.Time.at(99))

  it "returns true if self and other have the same number of microseconds", ->
    R.Time.at(100, 100).should eql(R.Time.at(100, 100))

  it "returns false if self and other have differing numbers of microseconds", ->
    R.Time.at(100, 100).should_not eql(R.Time.at(100, 99))

  describe "1.9", ->
    it "returns false if self and other have differing fractional microseconds", ->
      R.Time.at(100, Rational(100,1000)).should_not eql(R.Time.at(100, Rational(99,1000)))

  it "returns false when given a non-time value", ->
    R.Time.at(100, 100).should_not eql("100")
    R.Time.at(100, 100).should_not eql(100)
    R.Time.at(100, 100).should_not eql(100.1)
