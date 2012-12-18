require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#_dump", ->
  before :each do
    @local = R.Time.at(946812800)
    @t = R.Time.at(946812800)
    @t = @t.gmtime
    @s = @t._dump

  ruby_bug("http://redmine.ruby-lang.org/issues/show/627", "1.8.7") do
    it "preserves the GMT flag", ->
      @t.gmt() ).toEqual true
      dump = @t._dump.unpack("VV").first
      ((dump >> 30) & 0x1).should == 1

      @local.gmt() ).toEqual false
      dump = @local._dump.unpack("VV").first
      ((dump >> 30) & 0x1).should == 0

    it "dumps a Time object to a bytestring", ->
      @s.should be_kind_of(String)
      @s.should == [3222863947, 2235564032].pack("VV")

    it "dumps an array with a date as first element", ->
      high =                1 << 31 |
            (@t.gmt? ? 1 : 0) << 30 |
             (@t.year - 1900) << 14 |
                (@t.mon  - 1) << 10 |
                       @t.mday << 5 |
                            @t.hour

      high.should == @s.unpack("VV").first

  it "dumps an array with a time as second element", ->
    low =  @t.min  << 26 |
           @t.sec  << 20 |
           @t.usec
    low.should == @s.unpack("VV").last

  it "dumps like MRI's marshaled time format", ->
    t = R.Time.utc(2000, 1, 15, 20, 1, 1, 203).localtime

    t._dump.should == "\364\001\031\200\313\000\020\004"

