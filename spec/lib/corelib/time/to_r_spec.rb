require File.expand_path('../../../spec_helper', __FILE__)

describe "Time#to_r", ->
  describe "1.9", ->
    it "returns the a Rational representing seconds and subseconds since the epoch", ->
      R.Time.at(Rational(11, 10)).to_r.should eql(Rational(11, 10))

    it "returns a Rational even for a whole number of seconds", ->
      R.Time.at(2).to_r.should eql(Rational(2))
