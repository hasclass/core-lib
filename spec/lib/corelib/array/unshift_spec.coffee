describe "Array#unshift", ->
  it "prepends object to the original array", ->
    a = R [1, 2, 3]
    expect( a.unshift("a") is a).toEqual true
    expect( a ).toEqual R(['a', 1, 2, 3])
    expect( a.unshift() is a).toEqual true
    expect( a ).toEqual R(['a', 1, 2, 3])
    a.unshift(5, 4, 3)
    expect( a ).toEqual R([5, 4, 3, 'a', 1, 2, 3])

    # shift all but one element
    a = R [1, 2]
    a.shift()
    a.unshift(3, 4)
    expect( a ).toEqual R([3, 4, 2])

    # now shift all elements
    a.shift()
    a.shift()
    a.shift()
    a.unshift(3, 4)
    expect( a ).toEqual R([3, 4])

  it "quietly ignores unshifting nothing", ->
    expect( R([]).unshift() ).toEqual R([])

  xit "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # empty.unshift(:new).should == [:new, empty]

    # array = ArraySpecs.recursive_array
    # array.unshift(:new)
    # array[0..5].should == [:new, 1, 'two', 3.0, array, array]

  # ruby_version_is "" ... "1.9", ->
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.unshift(1) ).toThrow(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError on a frozen array when the array is modified", ->
  #     expect( -> ArraySpecs.frozen_array.unshift(1) ).toThrow(RuntimeError)

  #   # see [ruby-core:23666]
  #   it "raises a RuntimeError on a frozen array when the array would not be modified", ->
  #     expect( -> ArraySpecs.frozen_array.unshift    ).toThrow(RuntimeError)

  # ruby_version_is ""..."1.9", ->
  #   it "does not raise an exception on a frozen array if no modification takes place", ->
  #     ArraySpecs.frozen_array.unshift.should == [1, 2, 3]
