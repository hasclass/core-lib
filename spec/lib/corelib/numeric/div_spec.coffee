describe "Numeric#div", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()

  # ruby_version_is ""..."1.9", ->
  #   it "calls self#/ with other, converts the result to a Float (using #to_f) and returns the #floor'ed result", ->
  #     result = mock("Numeric#div result")
  #     result.should_receive(:to_f).and_return(13 - TOLERANCE)
  #     @obj.should_receive(:/).with(10).and_return(result)

  #     @obj.div(10).should == 12
  
  describe 'ruby_version_is "1.9"', ->

    it "calls self#/ with other, then returns the #floor'ed result", ->
      result = 
        floor: -> 12
      @obj.divide = ->
      spy_1 = spyOn(result, 'floor').andReturn(12)
      spy_2 = spyOn(@obj, 'divide').andReturn(result)
      expect( @obj.div(10) ).toEqual 12
      expect( spy_1 ).wasCalled()
      expect( spy_2 ).wasCalled()

    it "raises ZeroDivisionError for 0", ->
      obj = NumericSpecs.Subclass.new()

      expect( -> obj.div(0) ).toThrow('ZeroDivisionError')
      expect( -> obj.div(0.0) ).toThrow('ZeroDivisionError')
      
    xit 'Complex unsupported', ->
      obj = NumericSpecs.Subclass.new()
      # expect( -> @obj.div(Complex(0,0)) ).toThrow('ZeroDivisionError')
