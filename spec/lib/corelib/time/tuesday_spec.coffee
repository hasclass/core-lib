require File.expand_path('../../../spec_helper', __FILE__)

describe "1.9", ->
  describe "Time#tuesday?", ->
    it "returns true if time represents Tuesday", ->
      expect( R.Time.local(2000, 1, 4).tuesday() ).toEqual true

    it "returns false if time doesn't represent Tuesday", ->
      expect( R.Time.local(2000, 1, 1).tuesday() ).toEqual false
