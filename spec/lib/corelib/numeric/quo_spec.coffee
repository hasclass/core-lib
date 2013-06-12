describe "Numeric#quo", ->
  # ruby_version_is ""..."1.9", ->
  #   it_behaves_like :numeric_quo_18, :quo

  describe 'ruby_version_is "1.9"', ->
    xit "returns the result of self divided by the given Integer as a Rational", ->
      # 5.quo(2).should eql(Rational(5,2))

    it "returns the result of self divided by the given Float as a Float", ->
      expect( R(2).quo(2.5) ).toEqual R(0.8)

    xit "returns the result of self divided by the given Bignum as a Float", ->
      # 45.quo(bignum_value).should be_close(1.04773789668636e-08, TOLERANCE)

    it "raises a ZeroDivisionError when the given Integer is 0", ->
      expect( -> R(0).quo(0) ).toThrow('ZeroDivisionError')
      expect( -> R(10).quo(0) ).toThrow('ZeroDivisionError')
      expect( -> R(-10).quo(0) ).toThrow('ZeroDivisionError')
      # expect( -> R(bignum_value.quo(0) }.should raise_error(ZeroDivisionError)
      # expect( -> R(-bignum_value.quo(0) }.should raise_error(ZeroDivisionError)

    it "returns the result of calling self#/ with other", ->
      obj = NumericSpecs.Subclass.new()
      obj['cmp'] = ->
      obj['/'] = ->
      spy1 = spyOn(obj, 'coerce').andReturn(R [19, 19])
      spy2 = spyOn(obj, 'cmp').andReturn(1)
      spy3 = spyOn(obj, '/').andReturn(20)

      # obj.should_receive(:coerce).twice.and_return([19,19])
      # obj.should_receive(:<=>).any_number_of_times.and_return(1)
      # obj.should_receive(:/).and_return(20)

      expect( obj.quo(19) ).toEqual 20
      expect( spy1 ).wasCalled()
      # expect( spy2 ).wasCalled()
      expect( spy3 ).wasCalled()

    it "raises a TypeError when given a non-Integer", ->
      # lambda {
      #   (obj = mock('x')).should_not_receive(:to_int)
      #   13.quo(obj)
      # }.should raise_error(TypeError)
      # lambda { 13.quo("10")    }.should raise_error(TypeError)
      # lambda { 13.quo(:symbol) }.should raise_error(TypeError)
