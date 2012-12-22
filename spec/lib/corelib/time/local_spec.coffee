describe "R.Time.local", ->
  # it_behaves_like(:time_local, :local)
  # it_behaves_like(:time_local_10_arg, :local)
  # it_behaves_like(:time_params, :local)
  # it_behaves_like(:time_params_10_arg, :local)
  # it_behaves_like(:time_params_microseconds, :local)

#   it "creates a time based on given values, interpreted in the local time zone", ->
#     with_timezone("PST", -8) do
#       R.Time.local(2000, "jan", 1, 20, 15, 1).to_a.should ==
#         [1, 15, 20, 1, 1, 2000, 6, 1, false, "PST"]

#   it "respects rare old timezones", ->
#     with_timezone("Europe/Amsterdam") do
#       R.Time.local(1910, 1, 1).to_a.should ==
#         [0, 0, 0, 1, 1, 1910, 6, 1, false, "AMT"]

# describe 'time_local_10_arg', ->
#   it "creates a time based on given C-style gmtime arguments, interpreted in the local time zone", ->
#     with_timezone("PST", -8) do
#       R.Time.local(1, 15, 20, 1, 1, 2000, 'ignored', 'ignored', 'ignored', 'ignored').to_a.should ==
#         [1, 15, 20, 1, 1, 2000, 6, 1, false, "PST"]

describe 'time_params', ->
  it "accepts 1 argument (year)", ->
    expect( R.Time.local(2000).eql(R.Time.local(2000, 1, 1, 0, 0, 0)) ).toEqual(true)

  it "accepts 2 arguments (year, month)", ->
    expect( R.Time.local(2000, 2).eql(R.Time.local(2000, 2, 1, 0, 0, 0)) ).toEqual(true)

  it "accepts 3 arguments (year, month, day)", ->
    expect( R.Time.local(2000, 2, 3).eql(R.Time.local(2000, 2, 3, 0, 0, 0)) ).toEqual(true)

  it "accepts 4 arguments (year, month, day, hour)", ->
    expect( R.Time.local(2000, 2, 3, 4).eql(R.Time.local(2000, 2, 3, 4, 0, 0)) ).toEqual(true)

  it "accepts 5 arguments (year, month, day, hour, minute)", ->
    expect( R.Time.local(2000, 2, 3, 4, 5).eql(R.Time.local(2000, 2, 3, 4, 5, 0)) ).toEqual(true)

  it "raises a TypeError if the year is null", ->
    expect( ->  R.Time.local(null) ).toThrow('TypeError')

  it "accepts null month, day, hour, minute, and second", ->
    expect( R.Time.local(2000, null, null, null, null, null).eql(R.Time.local(2000)) ).toEqual true

#   it "handles a String year", ->
#     R.Time.local("2000").should ==
#       R.Time.local(2000)

#   it "coerces the year with #to_int", ->
#     m = mock(:int)
#     m.should_receive(:to_int).and_return(1)
#     R.Time.local(m).should == R.Time.local(1)

#   it "handles a String month given as a numeral", ->
#     R.Time.local(2000, "12").should ==
#       R.Time.local(2000, 12)

#   it "handles a String month given as a short month name", ->
#     R.Time.local(2000, "dec").should ==
#       R.Time.local(2000, 12)

#   it "coerces the month with #to_str", ->
#     (obj = mock('12')).should_receive(:to_str).and_return("12")
#     R.Time.local(2008, obj).should ==
#       R.Time.local(2008, 12)

#   it "coerces the month with #to_int", ->
#     m = mock(:int)
#     m.should_receive(:to_int).and_return(1)
#     R.Time.local(2008, m).should == R.Time.local(2008, 1)

#   it "handles a String day", ->
#     R.Time.local(2000, 12, "15").should ==
#       R.Time.local(2000, 12, 15)

#   it "coerces the day with #to_int", ->
#     m = mock(:int)
#     m.should_receive(:to_int).and_return(1)
#     R.Time.local(2008, 1, m).should == R.Time.local(2008, 1, 1)

#   it "handles a String hour", ->
#     R.Time.local(2000, 12, 1, "5").should ==
#       R.Time.local(2000, 12, 1, 5)

#   it "coerces the hour with #to_int", ->
#     m = mock(:int)
#     m.should_receive(:to_int).and_return(1)
#     R.Time.local(2008, 1, 1, m).should == R.Time.local(2008, 1, 1, 1)

#   it "handles a String minute", ->
#     R.Time.local(2000, 12, 1, 1, "8").should ==
#       R.Time.local(2000, 12, 1, 1, 8)

#   it "coerces the minute with #to_int", ->
#     m = mock(:int)
#     m.should_receive(:to_int).and_return(1)
#     R.Time.local(2008, 1, 1, 0, m).should == R.Time.local(2008, 1, 1, 0, 1)

#   ruby_bug "6193", "2.0", ->
#     it "handles a String second", ->
#       R.Time.local(2000, 12, 1, 1, 1, "8").should ==
#         R.Time.local(2000, 12, 1, 1, 1, 8)

#   it "coerces the second with #to_int", ->
#     m = mock(:int)
#     m.should_receive(:to_int).and_return(1)
#     R.Time.local(2008, 1, 1, 0, 0, m).should == R.Time.local(2008, 1, 1, 0, 0, 1)

#   ruby_bug "6193", "2.0", ->
#     it "interprets all numerals as base 10", ->
#       R.Time.local("2000", "08", "08", "08", "08", "08").should ==
#         R.Time.local(2000, 8, 8, 8, 8, 8)
#       R.Time.local("2000", "09", "09", "09", "09", "09").should ==
#         R.Time.local(2000, 9, 9, 9, 9, 9)

#   describe "".."1.9", ->
#     it "ignores fractional seconds as a Float", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1.75)
#       t.sec.should == 1
#       t.usec.should == 0

#   describe "1.9", ->
#     it "handles fractional seconds as a Float", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1.75)
#       t.sec.should == 1
#       t.usec.should == 750000

#     it "handles fractional seconds as a Rational", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, Rational(99, 10))
#       t.sec.should == 9
#       t.usec.should == 900000

  describe "1.9", ->
    it "accepts various year ranges", ->
      expect( R.Time.local(1801, 12, 31, 23, 59, 59).wday() ).toEqual R(4)
      expect( R.Time.local(3000, 12, 31, 23, 59, 59).wday() ).toEqual R(3)

  it "raises an ArgumentError for out of range month", ->
    expect( ->
      R.Time.local(2008, 13, 31, 23, 59, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range day", ->
    expect( ->
      R.Time.local(2008, 12, 32, 23, 59, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range hour", ->
    expect( ->
      R.Time.local(2008, 12, 31, 25, 59, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range minute", ->
    expect( ->
      R.Time.local(2008, 12, 31, 23, 61, 59)
    ).toThrow('ArgumentError')

  it "raises an ArgumentError for out of range second", ->
    expect( ->
      R.Time.local(2008, 12, 31, 23, 59, 61)
    ).toThrow('ArgumentError')

#   it "raises ArgumentError when given 9 arguments", ->
#     expect( ->  R.Time.local(*[0]*9) ).toThrow('ArgumentError')

#   it "raises ArgumentError when given 11 arguments", ->
#     expect( ->  R.Time.local(*[0]*11) ).toThrow('ArgumentError')

#   it "returns subclass instances", ->
#     c = Class.new(Time)
#     c.send(@method, 2008, "12").should be_kind_of(c)

# describe :time_params_10_arg, :shared => true do
#   it "handles string arguments", ->
#     R.Time.local("1", "15", "20", "1", "1", "2000", 'ignored', 'ignored',
#               'ignored', 'ignored').should ==
#       R.Time.local(1, 15, 20, 1, 1, 2000, 'ignored', 'ignored', 'ignored', 'ignored')

#   it "handles float arguments", ->
#     R.Time.local(1.0, 15.0, 20.0, 1.0, 1.0, 2000.0, 'ignored', 'ignored',
#               'ignored', 'ignored').should ==
#       R.Time.local(1, 15, 20, 1, 1, 2000, 'ignored', 'ignored', 'ignored', 'ignored')


  # describe "1.9", ->
  #   it "raises an ArgumentError for out of range values", ->
  #     expect( ->
  #       R.Time.local(61, 59, 23, 31, 12, 2008, 'ignored', 'ignored', 'ignored', 'ignored')
  #     ).toThrow('ArgumentError') # sec

  #     expect( ->
  #       R.Time.local(59, 61, 23, 31, 12, 2008, 'ignored', 'ignored', 'ignored', 'ignored')
  #     ).toThrow('ArgumentError') # min

  #     expect( ->
  #       R.Time.local(59, 59, 25, 31, 12, 2008, 'ignored', 'ignored', 'ignored', 'ignored')
  #     ).toThrow('ArgumentError') # hour

  #     expect( ->
  #       R.Time.local(59, 59, 23, 32, 12, 2008, 'ignored', 'ignored', 'ignored', 'ignored')
  #     ).toThrow('ArgumentError') # day

  #     expect( ->
  #       R.Time.local(59, 59, 23, 31, 13, 2008, 'ignored', 'ignored', 'ignored', 'ignored')
  #     ).toThrow('ArgumentError') # month

# describe 'time_params_microseconds', ->
#   it "handles microseconds", ->
#     t = R.Time.local(2000, 1, 1, 20, 15, 1, 123)
#     t.usec.should == 123

#   describe "..1.9", ->
#     it "ignores fractional microseconds as a Float", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1, 1.75)
#       t.usec.should == 1

#   describe "1.9", ->
#     it "handles fractional microseconds as a Float", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1, 1.75)
#       t.usec.should == 1
#       t.nsec.should == 1750

#     it "handles fractional microseconds as a Rational", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1, Rational(99, 10))
#       t.usec.should == 9
#       t.nsec.should == 9900

#     it "ignores fractional seconds if a passed whole number of microseconds", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1.75, 2)
#       t.sec.should == 1
#       t.usec.should == 2
#       t.nsec.should == 2000

#     it "ignores fractional seconds if a passed fractional number of microseconds", ->
#       t = R.Time.local(2000, 1, 1, 20, 15, 1.75, Rational(99, 10))
#       t.sec.should == 1
#       t.usec.should == 9
#       t.nsec.should == 9900
