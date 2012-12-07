describe "Array#shift", ->
  it "removes and returns the first element", ->
    a = R [5, 1, 1, 5, 4]
    expect( a.shift() ).toEqual 5
    expect(a).toEqual R([1, 1, 5, 4])
    expect( a.shift() ).toEqual 1
    expect(a).toEqual R([1, 5, 4])
    expect( a.shift() ).toEqual 1
    expect(a).toEqual R([5, 4])
    expect( a.shift() ).toEqual 5
    expect(a).toEqual R([4])
    expect( a.shift() ).toEqual 4
    expect(a).toEqual R([])

  it "returns nil when the array is empty", ->
    expect( R([]).shift() ).toEqual null

  it "properly handles recursive arrays", ->
    empty = R([])
    empty.push empty
    expect( empty.shift() ).toEqual R([])
    expect( empty ).toEqual R([])

    # array = ArraySpecs.recursive_array
    # expect( array.shift() ).toEqual 1
    # expect( array[0..2] ).toEqual R(['two', 3.0, array])

  # ruby_version_is "" ... "1.9", ->
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.shift ).toThrow(TypeError)
  #     it "raises a TypeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.shift ).toThrow(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.shift ).toThrow(RuntimeError)
  #     it "raises a RuntimeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.shift ).toThrow(RuntimeError)

  # ruby_version_is '' ... '1.8.7' do
  #   it "raises an ArgumentError if passed an argument", ->
  #     lambda{ [1, 2].shift(1) ).toThrow(ArgumentError)

  describe "passed a number n as an argument", ->
    describe "ruby_version_is '1.8.7'", ->
      it "removes and returns an array with the first n element of the array", ->
        a = R([1, 2, 3, 4, 5, 6])

        expect( a.shift(0) ).toEqual R([])
        expect( a ).toEqual R([1, 2, 3, 4, 5, 6])

        expect( a.shift(1) ).toEqual R([1])
        expect( a ).toEqual R([2, 3, 4, 5, 6])

        expect( a.shift(2) ).toEqual R([2, 3])
        expect( a ).toEqual R([4, 5, 6])

        expect( a.shift(3) ).toEqual R([4, 5, 6])
        expect( a ).toEqual R([])

      it "does not corrupt the array when shift without arguments is followed by shift with an argument", ->
        a = R([1, 2, 3, 4, 5])

        expect( a.shift() ).toEqual 1
        expect( a.shift(3) ).toEqual R([2, 3, 4])
        expect( a ).toEqual R([5])

      it "returns a new empty array if there are no more elements", ->
        a = R([])
        popped1 = a.shift(1)
        expect( popped1 ).toEqual R([])
        expect( a ).toEqual R([])

        popped2 = a.shift(2)
        expect( popped2 ).toEqual R([])
        expect( a ).toEqual R([])

        expect(popped1 is popped2).toEqual false

      it "returns whole elements if n exceeds size of the array", ->
        a = R([1, 2, 3, 4, 5])
        expect( a.shift(6) ).toEqual R([1, 2, 3, 4, 5])
        expect( a ).toEqual R([])

      it "does not return self even when it returns whole elements", ->
        a = R([1, 2, 3, 4, 5])
        expect(a.shift(5) is a).toEqual false

        a = R([1, 2, 3, 4, 5])
        expect(a.shift(6) is a).toEqual false


      it "raises an ArgumentError if n is negative", ->
        expect( -> R([1, 2, 3]).shift(-1) ).toThrow('ArgumentError')

      it "tries to convert n to an Integer using #to_int", ->
        a = R([1, 2, 3, 4])
        expect( a.shift(2.3) ).toEqual R([1, 2])

        obj =
          to_int: -> R(2)
        expect( a ).toEqual R([3, 4])
        expect( a.shift(obj) ).toEqual R([3, 4])
        expect( a ).toEqual R([])

      it "raises a TypeError when the passed n can be coerced to Integer", ->
        expect( -> R([1, 2]).shift("cat") ).toThrow('TypeError')
        expect( -> R([1, 2]).shift(null) ).toThrow('TypeError')

      it "raises an ArgumentError if more arguments are passed", ->
        expect( -> R([1, 2]).shift(1, 2) ).toThrow('ArgumentError')

      xit "does not return subclass instances with Array subclass", ->
        # ArraySpecs.MyArray[1, 2, 3].shift(2).should be_kind_of(Array)

      # it "returns an untainted array even if the array is tainted", ->
      #   ary = [1, 2].taint
      #   ary.shift(2).tainted?.should be_false
      #   ary.shift(0).tainted?.should be_false

      # it "keeps taint status", ->
      #   a = R([1, 2].taint)
      #   a.shift(2)
      #   a.tainted?.should be_true
      #   a.shift(2)
      #   a.tainted?.should be_true

      # ruby_version_is '' ... '1.9' do
      #   it "raises a TypeError on a frozen array", ->
      #     expect( -> ArraySpecs.frozen_array.shift(2) ).toThrow('TypeError')
      #     expect( -> ArraySpecs.frozen_array.shift(0) ).toThrow(TypeError)
      #