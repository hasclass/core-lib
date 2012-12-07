describe 'ruby_version_is "1.9"', ->
  describe "Array.try_convert", ->
    it "returns the argument if it's an Array", ->
      x = R.Array.new()
      expect( R.Array.try_convert(x) is x).toEqual true

    xit "returns the argument if it's a kind of Array", ->
    #   x = ArraySpecs.MyArray[]
    #   Array.try_convert(x).should equal(x)

    it "returns nil when the argument does not respond to #to_ary", ->
      expect( R.Array.try_convert(new Object()) ).toEqual null

    it "sends #to_ary to the argument and returns the result if it's nil", ->
      obj =
        to_ary: -> null
      expect( R.Array.try_convert(obj) ).toEqual null

    it "sends #to_ary to the argument and returns the result if it's an Array", ->
      x   = R.Array.new()
      obj =
        to_ary: -> x
      expect( R.Array.try_convert(obj) is x).toEqual true

    xit "sends #to_ary to the argument and returns the result if it's a kind of Array", ->
    #   x = ArraySpecs.MyArray[]
    #   obj = mock("to_ary")
    #   obj.should_receive(:to_ary).and_return(x)
    #   R.Array.try_convert(obj).should equal(x)

    xit "sends #to_ary to the argument and raises TypeError if it's not a kind of Array", ->
      obj =
        to_ary: -> new Object.new()
      expect( -> R.Array.try_convert obj ).toThrow('TypeError')

    it "does not rescue exceptions raised by #to_ary", ->
      obj =
        to_ary: -> throw R.ArgumentError.new()
      expect( -> R.Array.try_convert obj ).toThrow('ArgumentError')
