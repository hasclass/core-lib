require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#-", ->
  it "decrements the time by the specified amount", ->
    (R.Time.at(100) - 100).should == R.Time.at(0)
    (R.Time.at(100) - R.Time.at(99)).should == 1.0

  it "understands negative subtractions", ->
    t = R.Time.at(100) - -1.3
    t.usec.should == 300000
    t.to_i.should == 101

  describe ""..."1.9", ->
    it "accepts arguments that can be coerced into Float", ->
      (obj = mock('9.5')).should_receive(:to_f).and_return(9.5)
      (R.Time.at(100) - obj).should == R.Time.at(90.5)

  describe "1.9", ->
    #see [ruby-dev:38446]
    it "accepts arguments that can be coerced into Rational", ->
      (obj = mock('10')).should_receive(:to_r).and_return(Rational(10))
      (R.Time.at(100) - obj).should == R.Time.at(90)

  it "raises TypeError on argument that can't be coerced", ->
    expect( ->  R.Time.now - Object.new ).toThrow('TypeError')
    expect( ->  R.Time.now - "stuff" ).toThrow('TypeError')

  it "raises TypeError on nil argument", ->
    expect( ->  R.Time.now - nil ).toThrow('TypeError')

  it "tracks microseconds", ->
    time = R.Time.at(0.777777)
    time -= 0.654321
    time.usec.should == 123456
    time -= 1
    time.usec.should == 123456

  describe "1.9", ->
    it "tracks microseconds", ->
      time = R.Time.at(Rational(777_777, 1_000_000))
      time -= Rational(654_321, 1_000_000)
      time.usec.should == 123_456
      time -= Rational(123_456, 1_000_000)
      time.usec.should == 0

    it "tracks nanoseconds", ->
      time = R.Time.at(Rational(999_999_999, 1_000_000_000))
      time -= Rational(876_543_210, 1_000_000_000)
      time.nsec.should == 123_456_789
      time -= Rational(123_456_789, 1_000_000_000)
      time.nsec.should == 0

    it "maintains precision", ->
      time = R.Time.at(10) - Rational(1_000_000_000_000_001, 1_000_000_000_000_000)
      time.should_not == R.Time.at(9)

    it "maintains microseconds precision", ->
      time = R.Time.at(10) - Rational(1_000_000_000_000_001, 1_000_000_000_000_000)
      time.usec.should == 999_999

    it "maintains nanoseconds precision", ->
      time = R.Time.at(10) - Rational(1_000_000_000_000_001, 1_000_000_000_000_000)
      time.nsec.should == 999_999_999

    it "maintains subseconds precision", ->
      time = R.Time.at(0) - Rational(1_000_000_000_000_001, 1_000_000_000_000_000)
      time.subsec.should == Rational(999_999_999_999_999, 1_000_000_000_000_000)

  it "returns a UTC time if self is UTC", ->
    (Time.utc(2012) - 10).utc() ).toEqual true

  it "returns a non-UTC time if self is non-UTC", ->
    (R.Time.local(2012) - 10).utc() ).toEqual false

  describe "1.9", ->
    it "returns a time with the same fixed offset as self", ->
      (Time.new(2012, 1, 1, 0, 0, 0, 3600) - 10).utc_offset.should == 3600

  it "does not returns a subclass instance", ->
    c = Class.new(Time)
    x = c.now + 1
    x.should be_kind_of(Time)
