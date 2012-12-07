describe "Numeric#fdiv", ->
  # ruby_version_is ""..."1.9", ->
  #   it_behaves_like :numeric_quo_18, :fdiv
  # end

  describe 'ruby_version_is "1.9"', ->
    it "coerces self with #to_f", ->
      numeric = NumericSpecs.Subclass.new()
      numeric.to_f = -> R.$Float(3.0)
      # numeric.should_receive(:to_f).and_return(3.0)
      expect( numeric.fdiv(0.5).equals(6.0) ).toEqual true

    it "coerces other with #to_f", ->
      numeric = NumericSpecs.Subclass.new()
      numeric.to_f = -> new R.Float(3.0)
      # numeric.unbox = -> 3.0
      # numeric.should_receive(:to_f).and_return(3.0)
      expect( R(6).fdiv(numeric) ).toEqual new R.Float(2.0)

    it "performs floating-point division", ->
      expect( R(3).fdiv(2).equals(1.5) ).toEqual true

    xit "returns a Float", ->
    #   bignum_value.fdiv(Float::MAX).should be_an_instance_of(Float)

    it "returns Infinity if other is 0", ->
      expect( R(8121.92821).fdiv(0).infinite() ).toEqual 1

    it "returns NaN if other is NaN", ->
      expect( R(3334).fdiv(0.0/0.0).nan() ).toEqual true
