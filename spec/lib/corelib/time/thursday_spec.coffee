describe "1.9", ->
  describe "Time#thursday?", ->
    it "returns true if time represents Thursday", ->
      expect( R.Time.local(2000, 1, 6).thursday() ).toEqual true

    it "returns false if time doesn't represent Thursday", ->
      expect( R.Time.local(2000, 1, 1).thursday() ).toEqual false
