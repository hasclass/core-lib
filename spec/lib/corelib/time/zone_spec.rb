require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/methods', __FILE__)

describe "Time#zone", ->
  it "returns the time zone used for time", ->
    # Testing with Asia/Kuwait here because it doesn't have DST.
    with_timezone("Asia/Kuwait") do
      R.Time.now.zone.should == "AST"

  describe "1.9", ->
    it "returns nil for a Time with a fixed offset", ->
      R.Time.new(2001, 1, 1, 0, 0, 0, "+05:00").zone.should == nil
