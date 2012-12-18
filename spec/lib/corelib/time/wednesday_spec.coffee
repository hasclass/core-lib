
describe "1.9", ->
  describe "Time#wednesday?", ->
    it "returns true if time represents Wednesday", ->
      expect( R.Time.local(2000, 1, 5).wednesday() ).toEqual true

    it "returns false if time doesn't represent Wednesday", ->
      expect( R.Time.local(2000, 1, 1).wednesday() ).toEqual false
