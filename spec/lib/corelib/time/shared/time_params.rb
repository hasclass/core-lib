describe :time_params, :shared => true do
  it "accepts 1 argument (year)", ->
    Time.send(@method, 2000).should ==
      Time.send(@method, 2000, 1, 1, 0, 0, 0)

  it "accepts 2 arguments (year, month)", ->
    Time.send(@method, 2000, 2).should ==
      Time.send(@method, 2000, 2, 1, 0, 0, 0)

  it "accepts 3 arguments (year, month, day)", ->
    Time.send(@method, 2000, 2, 3).should ==
      Time.send(@method, 2000, 2, 3, 0, 0, 0)

  it "accepts 4 arguments (year, month, day, hour)", ->
    Time.send(@method, 2000, 2, 3, 4).should ==
      Time.send(@method, 2000, 2, 3, 4, 0, 0)

  it "accepts 5 arguments (year, month, day, hour, minute)", ->
    Time.send(@method, 2000, 2, 3, 4, 5).should ==
      Time.send(@method, 2000, 2, 3, 4, 5, 0)

  it "raises a TypeError if the year is nil", ->
    expect( ->  Time.send(@method, nil) ).toThrow('TypeError')

  it "accepts nil month, day, hour, minute, and second", ->
    Time.send(@method, 2000, nil, nil, nil, nil, nil).should ==
      Time.send(@method, 2000)

  it "handles a String year", ->
    Time.send(@method, "2000").should ==
      Time.send(@method, 2000)

  it "coerces the year with #to_int", ->
    m = mock(:int)
    m.should_receive(:to_int).and_return(1)
    Time.send(@method, m).should == Time.send(@method, 1)

  it "handles a String month given as a numeral", ->
    Time.send(@method, 2000, "12").should ==
      Time.send(@method, 2000, 12)

  it "handles a String month given as a short month name", ->
    Time.send(@method, 2000, "dec").should ==
      Time.send(@method, 2000, 12)

  it "coerces the month with #to_str", ->
    (obj = mock('12')).should_receive(:to_str).and_return("12")
    Time.send(@method, 2008, obj).should ==
      Time.send(@method, 2008, 12)

  it "coerces the month with #to_int", ->
    m = mock(:int)
    m.should_receive(:to_int).and_return(1)
    Time.send(@method, 2008, m).should == Time.send(@method, 2008, 1)

  it "handles a String day", ->
    Time.send(@method, 2000, 12, "15").should ==
      Time.send(@method, 2000, 12, 15)

  it "coerces the day with #to_int", ->
    m = mock(:int)
    m.should_receive(:to_int).and_return(1)
    Time.send(@method, 2008, 1, m).should == Time.send(@method, 2008, 1, 1)

  it "handles a String hour", ->
    Time.send(@method, 2000, 12, 1, "5").should ==
      Time.send(@method, 2000, 12, 1, 5)

  it "coerces the hour with #to_int", ->
    m = mock(:int)
    m.should_receive(:to_int).and_return(1)
    Time.send(@method, 2008, 1, 1, m).should == Time.send(@method, 2008, 1, 1, 1)

  it "handles a String minute", ->
    Time.send(@method, 2000, 12, 1, 1, "8").should ==
      Time.send(@method, 2000, 12, 1, 1, 8)

  it "coerces the minute with #to_int", ->
    m = mock(:int)
    m.should_receive(:to_int).and_return(1)
    Time.send(@method, 2008, 1, 1, 0, m).should == Time.send(@method, 2008, 1, 1, 0, 1)

  ruby_bug "6193", "2.0", ->
    it "handles a String second", ->
      Time.send(@method, 2000, 12, 1, 1, 1, "8").should ==
        Time.send(@method, 2000, 12, 1, 1, 1, 8)

  it "coerces the second with #to_int", ->
    m = mock(:int)
    m.should_receive(:to_int).and_return(1)
    Time.send(@method, 2008, 1, 1, 0, 0, m).should == Time.send(@method, 2008, 1, 1, 0, 0, 1)

  ruby_bug "6193", "2.0", ->
    it "interprets all numerals as base 10", ->
      Time.send(@method, "2000", "08", "08", "08", "08", "08").should ==
        Time.send(@method, 2000, 8, 8, 8, 8, 8)
      Time.send(@method, "2000", "09", "09", "09", "09", "09").should ==
        Time.send(@method, 2000, 9, 9, 9, 9, 9)

  describe "".."1.9", ->
    it "ignores fractional seconds as a Float", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1.75)
      t.sec.should == 1
      t.usec.should == 0

  describe "1.9", ->
    it "handles fractional seconds as a Float", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1.75)
      t.sec.should == 1
      t.usec.should == 750000

    it "handles fractional seconds as a Rational", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, Rational(99, 10))
      t.sec.should == 9
      t.usec.should == 900000

  describe ""..."1.9.1", ->
    it "accepts various year ranges", ->
      Time.send(@method, 1901, 12, 31, 23, 59, 59, 0).wday.should == 2
      Time.send(@method, 2037, 12, 31, 23, 59, 59, 0).wday.should == 4

      platform_is :wordsize => 32 do
        expect( ->
          Time.send(@method, 1900, 12, 31, 23, 59, 59, 0)
        ).toThrow('ArgumentError') # mon

        expect( ->
          Time.send(@method, 2038, 12, 31, 23, 59, 59, 0)
        ).toThrow('ArgumentError') # mon

      platform_is :wordsize => 64 do
        Time.send(@method, 1900, 12, 31, 23, 59, 59, 0).wday.should == 1
        Time.send(@method, 2038, 12, 31, 23, 59, 59, 0).wday.should == 5

    platform_is :wordsize => 32 do
      it "raises an ArgumentError for out of range year", ->
        expect( ->
          Time.send(@method, 1111, 12, 31, 23, 59, 59)
        ).toThrow('ArgumentError')

  describe "1.9", ->
    it "accepts various year ranges", ->
      Time.send(@method, 1801, 12, 31, 23, 59, 59).wday.should == 4
      Time.send(@method, 3000, 12, 31, 23, 59, 59).wday.should == 3

  it "raises an ArgumentError for out of range month", ->
    expect( ->
      Time.send(@method, 2008, 13, 31, 23, 59, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range day", ->
    expect( ->
      Time.send(@method, 2008, 12, 32, 23, 59, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range hour", ->
    expect( ->
      Time.send(@method, 2008, 12, 31, 25, 59, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range minute", ->
    expect( ->
      Time.send(@method, 2008, 12, 31, 23, 61, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range second", ->
    expect( ->
      Time.send(@method, 2008, 12, 31, 23, 59, 61)
    ).toThrow('ArgumentError')

  it "raises ArgumentError when given 9 arguments", ->
    expect( ->  Time.send(@method, *[0]*9) ).toThrow('ArgumentError')

  it "raises ArgumentError when given 11 arguments", ->
    expect( ->  Time.send(@method, *[0]*11) ).toThrow('ArgumentError')

  it "returns subclass instances", ->
    c = Class.new(Time)
    c.send(@method, 2008, "12").should be_kind_of(c)

describe :time_params_10_arg, :shared => true do
  it "handles string arguments", ->
    Time.send(@method, "1", "15", "20", "1", "1", "2000", :ignored, :ignored,
              :ignored, :ignored).should ==
      Time.send(@method, 1, 15, 20, 1, 1, 2000, :ignored, :ignored, :ignored, :ignored)

  it "handles float arguments", ->
    Time.send(@method, 1.0, 15.0, 20.0, 1.0, 1.0, 2000.0, :ignored, :ignored,
              :ignored, :ignored).should ==
      Time.send(@method, 1, 15, 20, 1, 1, 2000, :ignored, :ignored, :ignored, :ignored)

  describe ""..."1.9.1", ->
    it "raises an ArgumentError for out of range values", ->
      expect( ->
        Time.send(@method, 61, 59, 23, 31, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # sec

      expect( ->
        Time.send(@method, 59, 61, 23, 31, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # min

      expect( ->
        Time.send(@method, 59, 59, 25, 31, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # hour

      expect( ->
        Time.send(@method, 59, 59, 23, 32, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # day

      expect( ->
        Time.send(@method, 59, 59, 23, 31, 13, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # month

      # Year range only fails on 32 bit archs
      platform_is :wordsize => 32 do
        expect( ->
          Time.send(@method, 59, 59, 23, 31, 12, 1111, :ignored, :ignored, :ignored, :ignored)
        ).toThrow('ArgumentError') # year

  describe "1.9", ->
    it "raises an ArgumentError for out of range values", ->
      expect( ->
        Time.send(@method, 61, 59, 23, 31, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # sec

      expect( ->
        Time.send(@method, 59, 61, 23, 31, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # min

      expect( ->
        Time.send(@method, 59, 59, 25, 31, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # hour

      expect( ->
        Time.send(@method, 59, 59, 23, 32, 12, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # day

      expect( ->
        Time.send(@method, 59, 59, 23, 31, 13, 2008, :ignored, :ignored, :ignored, :ignored)
      ).toThrow('ArgumentError') # month

describe :time_params_microseconds, :shared => true do
  it "handles microseconds", ->
    t = Time.send(@method, 2000, 1, 1, 20, 15, 1, 123)
    t.usec.should == 123

  describe "".."1.9", ->
    it "ignores fractional microseconds as a Float", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1, 1.75)
      t.usec.should == 1

  describe "1.9", ->
    it "handles fractional microseconds as a Float", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1, 1.75)
      t.usec.should == 1
      t.nsec.should == 1750

    it "handles fractional microseconds as a Rational", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1, Rational(99, 10))
      t.usec.should == 9
      t.nsec.should == 9900

    it "ignores fractional seconds if a passed whole number of microseconds", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1.75, 2)
      t.sec.should == 1
      t.usec.should == 2
      t.nsec.should == 2000

    it "ignores fractional seconds if a passed fractional number of microseconds", ->
      t = Time.send(@method, 2000, 1, 1, 20, 15, 1.75, Rational(99, 10))
      t.sec.should == 1
      t.usec.should == 9
      t.nsec.should == 9900
