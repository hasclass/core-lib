require File.expand_path('../../../spec_helper', __FILE__)

describe "1.9", ->
  describe "Time#nsec", ->
    it "returns 0 for a Time constructed with a whole number of seconds", ->
      R.Time.at(100).nsec.should == 0

    it "returns the nanoseconds part of a Time constructed with a Float number of seconds", ->
      R.Time.at(10.75).nsec.should == 750_000_000

    it "returns the nanoseconds part of a Time constructed with an Integer number of microseconds", ->
      R.Time.at(0, 999_999).nsec.should == 999_999_000

    it "returns the nanoseconds part of a Time constructed with an Float number of microseconds", ->
      R.Time.at(0, 3.75).nsec.should == 3750

    it "returns the nanoseconds part of a Time constructed with a Rational number of seconds", ->
      R.Time.at(Rational(3, 2)).nsec.should == 500_000_000

    it "returns the nanoseconds part of a Time constructed with an Rational number of microseconds", ->
      R.Time.at(0, Rational(99, 10)).nsec.should == 9900
