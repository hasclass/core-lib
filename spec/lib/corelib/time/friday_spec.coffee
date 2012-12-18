require File.expand_path('../../../spec_helper', __FILE__)

describe "1.9", ->
  describe "Time#friday?", ->
    it "returns true if time represents Friday", ->
      expect( R.Time.local(2000, 1, 7).friday() ).toEqual true

    it "returns false if time doesn't represent Friday", ->
      expect( R.Time.local(2000, 1, 1).friday() ).toEqual false
