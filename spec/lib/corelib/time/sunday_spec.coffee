
describe "1.9", ->
  describe "Time#sunday?", ->
    it "returns true if time represents Sunday", ->
      expect( R.Time.local(2000, 1, 2).sunday() ).toEqual true

    it "returns false if time doesn't represent Sunday", ->
      expect( R.Time.local(2000, 1, 1).sunday() ).toEqual false
