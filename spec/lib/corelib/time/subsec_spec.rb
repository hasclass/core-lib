require File.expand_path('../../../spec_helper', __FILE__)

describe "1.9", ->
  describe "Time#subsec", ->
    it "returns 0 as a Fixnum for a Time with a whole number of seconds", ->
      R.Time.at(100).subsec.should eql(0)

    it "returns the fractional seconds as a Rational for a Time constructed with a Rational number of seconds", ->
      R.Time.at(Rational(3, 2)).subsec.should eql(Rational(1, 2))

    it "returns the fractional seconds as a Rational for a Time constructed with a Float number of seconds", ->
      R.Time.at(10.75).subsec.should eql(Rational(3, 4))

    it "returns the fractional seconds as a Rational for a Time constructed with an Integer number of microseconds", ->
      R.Time.at(0, 999999).subsec.should eql(Rational(999999, 1000000))

    it "returns the fractional seconds as a Rational for a Time constructed with an Rational number of microseconds", ->
      R.Time.at(0, Rational(9, 10)).subsec.should eql(Rational(9, 10000000))

    it "returns the fractional seconds as a Rational for a Time constructed with an Float number of microseconds", ->
      R.Time.at(0, 0.75).subsec.should eql(Rational(3, 4000000))
