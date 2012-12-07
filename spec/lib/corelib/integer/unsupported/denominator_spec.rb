describe "Integer#denominator", ->
  describe 'ruby_version_is "1.9"', ->
    # The Numeric child classes override this method, so their behaviour is
    # specified in the appropriate place
    it "returns 1", ->
      expect( R(20).denominator() ).toEqual R(1)
      expect( R(-20).denominator() ).toEqual R(1)
