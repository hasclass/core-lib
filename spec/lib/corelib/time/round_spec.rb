require File.expand_path('../../../spec_helper', __FILE__)

describe "1.9", ->
  describe "Time#round", ->
    before do
      @time = R.Time.utc(2010, 3, 30, 5, 43, "25.123456789".to_r)
      @subclass = Class.new(Time).now

    it "defaults to rounding to 0 places", ->
      @time.round.should == R.Time.utc(2010, 3, 30, 5, 43, 25.to_r)

    it "rounds to 0 decimal places with an explicit argument", ->
      @time.round(0).should == R.Time.utc(2010, 3, 30, 5, 43, 25.to_r)

    it "rounds to 7 decimal places with an explicit argument", ->
      @time.round(7).should == R.Time.utc(2010, 3, 30, 5, 43, "25.1234568".to_r)

    it "returns an instance of Time, even if #round is called on a subclass", ->
      @subclass.round.should be_kind_of Time
