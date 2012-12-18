require File.expand_path('../../../spec_helper', __FILE__)

describe "1.9", ->
  describe "Time#saturday?", ->
    it "returns true if time represents Saturday", ->
      expect( R.Time.local(2000, 1, 1).saturday() ).toEqual true

    it "returns false if time doesn't represent Saturday", ->
      expect( R.Time.local(2000, 1, 2).saturday() ).toEqual false
