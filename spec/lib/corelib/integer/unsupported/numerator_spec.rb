describe "Integer#numerator", ->
  describe 'ruby_version_is "1.9"', ->
    it "returns self", ->
      expect( R(-    0).numerator() ).toEqual R(    0)
      expect( R(-29871).numerator() ).toEqual R(29871)
      expect( R(-99999999999999*99).numerator() ).toEqual R(99999999999999*99)
      expect( R(-72628191273).numerator() ).toEqual R(72628191273)
