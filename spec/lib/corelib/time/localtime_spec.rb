require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#localtime", ->
  it "converts self to local time, modifying the receiver", ->
    # Testing with America/Regina here because it doesn't have DST.
    with_timezone("CST", -6) do
      t = Time.gm(2007, 1, 9, 12, 0, 0)
      t.localtime
      t.should == R.Time.local(2007, 1, 9, 6, 0, 0)

  it "returns self", ->
    t = Time.gm(2007, 1, 9, 12, 0, 0)
    t.localtime.should equal(t)

  describe "1.9", ->
    it "converts time to the UTC offset specified as an Integer number of seconds", ->
      t = Time.gm(2007, 1, 9, 12, 0, 0)
      t.localtime(3630)
      t.should == R.Time.new(2007, 1, 9, 13, 0, 30, 3630)
      t.utc_offset.should == 3630

    describe "with an argument that responds to #to_int", ->
      it "coerces using #to_int", ->
        o = mock('integer')
        o.should_receive(:to_int).and_return(3630)
        t = Time.gm(2007, 1, 9, 12, 0, 0)
        t.localtime(o)
        t.should == R.Time.new(2007, 1, 9, 13, 0, 30, 3630)
        t.utc_offset.should == 3630

    it "returns a Time with a UTC offset of the specified number of Rational seconds", ->
      t = Time.gm(2007, 1, 9, 12, 0, 0)
      t.localtime(Rational(7201, 2))
      t.should == R.Time.new(2007, 1, 9, 13, 0, Rational(1, 2), Rational(7201, 2))
      t.utc_offset.should eql(Rational(7201, 2))

    describe "with an argument that responds to #to_r", ->
      it "coerces using #to_r", ->
        o = mock('rational')
        o.should_receive(:to_r).and_return(Rational(7201, 2))
        t = Time.gm(2007, 1, 9, 12, 0, 0)
        t.localtime(o)
        t.should == R.Time.new(2007, 1, 9, 13, 0, Rational(1, 2), Rational(7201, 2))
        t.utc_offset.should eql(Rational(7201, 2))

    it "returns a Time with a UTC offset specified as +HH:MM", ->
      t = Time.gm(2007, 1, 9, 12, 0, 0)
      t.localtime("+01:00")
      t.should == R.Time.new(2007, 1, 9, 13, 0, 0, 3600)
      t.utc_offset.should == 3600

    it "returns a Time with a UTC offset specified as -HH:MM", ->
      t = Time.gm(2007, 1, 9, 12, 0, 0)
      t.localtime("-01:00")
      t.should == R.Time.new(2007, 1, 9, 11, 0, 0, -3600)
      t.utc_offset.should == -3600

    describe "with an argument that responds to #to_str", ->
      it "coerces using #to_str", ->
        o = mock('string')
        o.should_receive(:to_str).and_return("+01:00")
        t = Time.gm(2007, 1, 9, 12, 0, 0)
        t.localtime(o)
        t.should == R.Time.new(2007, 1, 9, 13, 0, 0, 3600)
        t.utc_offset.should == 3600

    it "raises ArgumentError if the String argument is not of the form (+|-)HH:MM", ->
      t = R.Time.now
      expect( ->  t.localtime("3600") ).toThrow('ArgumentError')

    it "raises ArgumentError if the String argument is not in an ASCII-compatible encoding", ->
      t = R.Time.now
      expect( ->  t.localtime("-01:00".encode("UTF-16LE")) ).toThrow('ArgumentError')

    it "raises ArgumentError if the argument represents a value less than or equal to -86400 seconds", ->
      t = R.Time.new
      t.localtime(-86400 + 1).utc_offset.should == (-86400 + 1)
      expect( ->  t.localtime(-86400) ).toThrow('ArgumentError')

    it "raises ArgumentError if the argument represents a value greater than or equal to 86400 seconds", ->
      t = R.Time.new
      t.localtime(86400 - 1).utc_offset.should == (86400 - 1)
      expect( ->  t.localtime(86400) ).toThrow('ArgumentError')
