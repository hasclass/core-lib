describe "Integer#ord", ->
  describe 'ruby_version_is "1.8.7"', ->
    it "returns self", ->
      expect( R(20).ord() ).toEqual R(20)
      expect( R(40).ord() ).toEqual R(40)

      expect( R(0).ord() ).toEqual R(0)
      expect( R(-10).ord() ).toEqual R(-10)

      #expect( R(?a).ord() ).toEqual R(97)
      #expect( R(?Z).ord() ).toEqual R(90)

    xit 'unsupported', ->
      #bignum_value.ord.should eql(bignum_value)
      #(-bignum_value).ord.should eql(-bignum_value)
