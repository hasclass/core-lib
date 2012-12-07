describe "Numeric#divmod", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()

  # ruby_version_is ""..."1.9", ->
  #   it "returns [quotient, modulus], with quotient being obtained as in Numeric#div and modulus being obtained by calling self#% with other", ->
  #     @obj.should_receive(:/).with(10).and_return(13 - TOLERANCE)
  #     @obj.should_receive(:%).with(10).and_return(3)

  #     @obj.divmod(10).should == [12, 3]

  # TODO: comply with real specs and use -,/ instead of minus, divide
  describe 'ruby_version_is "1.9"', ->
    it "returns [quotient, modulus], with quotient being obtained as in Numeric#div then #floor and modulus being obtained by calling self#- with quotient * other", ->
      @obj['minus'] = ->
      @obj['div'] = ->

      spy1 = spyOn(@obj, 'div').andReturn(R(13 - 0.000001))
      spy2 = spyOn(@obj, 'minus').andReturn(R(3))

      # @obj.should_receive(:/).twice.with(10).and_return(R(13 - 0.00001), R(13 - 0.00001))
      # @obj.should_receive(:-).with(120).and_return(3)

      expect( @obj.divmod(10) ).toEqual R.$Array_r([12, 3])
