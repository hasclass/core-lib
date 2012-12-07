describe 'ruby_version_is "1.9"', ->
  describe "Numeric#abs2", ->
    beforeEach ->
      @numbers = R.$Array_r([
        0,
        R.$Float(0.0),
        1,
        20,
        # bignum_value,
        278202.292871,
        72829,
        3.333333333333,
        0.1,
        # infinity_value
      ]).map((n) -> [n.uminus(), n]).flatten()

    it "returns the square of the absolute value of self", ->
      @numbers.each (number) ->
        expect( number.abs2().equals(number.abs().multiply(number.abs())) ).toEqual true

    it "calls #* on self", ->
      # number = mock_numeric('numeric')
      # number.should_receive(:*).and_return(:result)
      # number.abs2.should == :result

    it "returns NaN when self is NaN", ->
      expect( R.$Float( 0.0/0.0).abs2().nan()).toEqual true
