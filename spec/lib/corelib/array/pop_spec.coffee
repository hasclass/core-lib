describe "Array#pop", ->
  it "removes and returns the last element of the array", ->
    a = R(["a", 1, null, true])

    expect( a.pop() ).toEqual true
    expect( a ).toEqual R(["a", 1, null])

    expect( a.pop() ).toEqual null
    expect( a ).toEqual R(["a", 1])

    expect( a.pop() ).toEqual 1
    expect( a ).toEqual R(["a"])

    expect( a.pop() ).toEqual "a"
    expect( a ).toEqual R([])

  it "returns null if there are no more elements", ->
    expect( R([]).pop() ).toEqual null

  xit "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # empty.pop.should == []

    # array = ArraySpecs.recursive_array
    # array.pop.should == [1, 'two', 3.0, array, array, array, array]

  # it "keeps taint status", ->
  #   a = [1, 2].taint
  #   a.pop
  #   a.tainted?.should be_true
  #   a.pop
  #   a.tainted?.should be_true

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.pop ).toThrow(TypeError)
  #     it "raises a TypeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.pop ).toThrow(TypeError)

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.pop ).toThrow(RuntimeError)

  #   it "raises a RuntimeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.pop ).toThrow(RuntimeError)

  #   it "keeps untrusted status", ->
  #     a = [1, 2].untrust
  #     a.pop
  #     a.untrusted?.should be_true
  #     a.pop
  #     a.untrusted?.should be_true

  # ruby_version_is '' ... '1.8.7' do
  #   it "raises an ArgumentError if passed an argument", ->
  #     lambda{ [1, 2].pop(1) ).toThrow(ArgumentError)

  describe "passed a number n as an argument", ->
    describe "ruby_version_is '1.8.7'", ->
      it "removes and returns an array with the last n elements of the array", ->
        a = R([1, 2, 3, 4, 5, 6])

        expect( a.pop(0) ).toEqual R([])
        expect( a ).toEqual R([1, 2, 3, 4, 5, 6])

        expect( a.pop(1) ).toEqual R([6])
        expect( a ).toEqual R([1, 2, 3, 4, 5])

        expect( a.pop(2) ).toEqual R([4, 5])
        expect( a ).toEqual R([1, 2, 3])

        expect( a.pop(3) ).toEqual R([1, 2, 3])
        expect( a ).toEqual R([])

      it "returns an array with the last n elements even if shift was invoked", ->
        a = R([1, 2, 3, 4])
        a.shift()
        expect( a.pop(3) ).toEqual R([2, 3, 4])

      it "returns a new empty array if there are no more elements", ->
        a = R([])
        popped1 = a.pop(1)
        expect( popped1 ).toEqual R([])
        expect( a       ).toEqual R([])

        popped2 = a.pop(2)
        expect( popped2 ).toEqual R([])
        expect( a       ).toEqual R([])

        expect( popped1 is popped2).toEqual false

      it "returns whole elements if n exceeds size of the array", ->
        a = R [1, 2, 3, 4, 5]
        expect( a.pop(6) ).toEqual R([1, 2, 3, 4, 5])
        expect( a ).toEqual R([])

      it "does not return self even when it returns whole elements", ->
        a = R [1, 2, 3, 4, 5]
        expect( a.pop(5) is a).toEqual false

        a = R [1, 2, 3, 4, 5]
        expect( a.pop(6) is a).toEqual false

      it "raises an ArgumentError if n is negative", ->
        expect( -> R([1, 2, 3]).pop(-1) ).toThrow('ArgumentError')

      it "tries to convert n to an Integer using #valueOf", ->
        a = R [1, 2, 3, 4]
        expect( a.pop(2.3) ).toEqual R([3, 4])

        obj =
          valueOf: -> 2
        expect( a ).toEqual R([1, 2])
        expect( a.pop(obj) ).toEqual R([1, 2])
        expect( a ).toEqual R([])

      it "raises a TypeError when the passed n can be coerced to Integer", ->
        expect( -> R([1, 2]).pop("cat") ).toThrow('TypeError')
        expect( -> R([1, 2]).pop(null) ).toThrow('TypeError')

      it "raises an ArgumentError if more arguments are passed", ->
        expect( -> R([1, 2]).pop(1, 2) ).toThrow('ArgumentError')

      xit "does not return subclass instances with Array subclass", ->
        # ArraySpecs.MyArray[1, 2, 3].pop(2).should be_kind_of(Array)

    #   it "returns an untainted array even if the array is tainted", ->
    #     ary = [1, 2].taint
    #     ary.pop(2).tainted?.should be_false
    #     ary.pop(0).tainted?.should be_false

    #   it "keeps taint status", ->
    #     a = [1, 2].taint
    #     a.pop(2)
    #     a.tainted?.should be_true
    #     a.pop(2)
    #     a.tainted?.should be_true

    #   ruby_version_is '' ... '1.9' do
    #     it "raises a TypeError on a frozen array", ->
    #       expect( -> ArraySpecs.frozen_array.pop(2) ).toThrow(TypeError)
    #       expect( -> ArraySpecs.frozen_array.pop(0) ).toThrow(TypeError)

    # ruby_version_is '1.9' do
    #   it "returns a trusted array even if the array is untrusted", ->
    #     ary = [1, 2].untrust
    #     ary.pop(2).untrusted?.should be_false
    #     ary.pop(0).untrusted?.should be_false

    #   it "raises a RuntimeError on a frozen array", ->
    #     expect( -> ArraySpecs.frozen_array.pop(2) ).toThrow(RuntimeError)
    #     expect( -> ArraySpecs.frozen_array.pop(0) ).toThrow(RuntimeError)

    #   it "keeps untrusted status", ->
    #     a = [1, 2].untrust
    #     a.pop(2)
    #     a.untrusted?.should be_true
    #     a.pop(2)
    #     a.untrusted?.should be_true
    #