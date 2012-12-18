describe "1.9", ->
  describe "Time#monday?", ->
    it "returns true if time represents Monday", ->
      expect( R.Time.local(2000, 1, 3).monday() ).toEqual true

    it "returns false if time doesn't represent Monday", ->
      expect( R.Time.local(2000, 1, 1).monday() ).toEqual false
