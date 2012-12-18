require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#usec", ->
  it "returns 0 for a Time constructed with a whole number of seconds", ->
    R.Time.at(100).usec.should == 0

  it "returns the microseconds part of a Time constructed with a Float number of seconds", ->
    R.Time.at(10.75).usec.should == 750_000

  it "returns the microseconds part of a Time constructed with an Integer number of microseconds", ->
    R.Time.at(0, 999_999).usec.should == 999_999

  it "returns the microseconds part of a Time constructed with an Float number of microseconds > 1", ->
    R.Time.at(0, 3.75).usec.should == 3

  it "returns 0 for a Time constructed with an Float number of microseconds < 1", ->
    R.Time.at(0, 0.75).usec.should == 0

  describe "1.9", ->
    it "returns the microseconds part of a Time constructed with a Rational number of seconds", ->
      R.Time.at(Rational(3, 2)).usec.should == 500_000

    it "returns the microseconds part of a Time constructed with an Rational number of microseconds > 1", ->
      R.Time.at(0, Rational(99, 10)).usec.should == 9

    it "returns 0 for a Time constructed with an Rational number of microseconds < 1", ->
      R.Time.at(0, Rational(9, 10)).usec.should == 0

    it "returns the microseconds for time created by Time#local", ->
      R.Time.local(1,2,3,4,5,Rational(6.78)).usec.should == 780000
