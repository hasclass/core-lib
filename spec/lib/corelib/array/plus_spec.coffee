describe "Array#+", ->
  it "concatenates two arrays", ->
    expect( R([ 1, 2, 3 ]).plus [ 3, 4, 5 ] ).toEqual R([1, 2, 3, 3, 4, 5])
    expect( R([ 1, 2, 3 ]).plus []          ).toEqual R([1, 2, 3])
    expect( R([]         ).plus [ 1, 2, 3 ] ).toEqual R([1, 2, 3])
    expect( R([]         ).plus []          ).toEqual R([])

  it "can concatenate an array with itself", ->
    ary = R([1, 2, 3])
    expect(ary.plus ary).toEqual R([1, 2, 3, 1, 2, 3])

  it "tries to convert the passed argument to an Array using #to_ary", ->
    obj =
      to_ary: -> R(["x", "y"])
    expect( R([1, 2, 3]).plus obj).toEqual R([1, 2, 3, "x", "y"])

  it "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # (empty + empty).toEqual R([empty, empty])

    # array = ArraySpecs.recursive_array
    # (empty + array).toEqual R([empty, 1, 'two', 3.0, array, array, array, array, array])
    # (array + array).toEqual R([
    #   1, 'two', 3.0, array, array, array, array, array,
    #   1, 'two', 3.0, array, array, array, array, array])

  xit "does return subclass instances with Array subclasses", ->
    # (ArraySpecs.MyArray[1, 2, 3] + []).should be_kind_of(Array)
    # (ArraySpecs.MyArray[1, 2, 3] + ArraySpecs.MyArray[]).should be_kind_of(Array)
    # ([1, 2, 3] + ArraySpecs.MyArray[]).should be_kind_of(Array)

  xit "does not call to_ary on array subclasses", ->
    # ([5, 6] + ArraySpecs.ToAryArray[1, 2]).should == [5, 6, 1, 2]

  # it "does not get infected even if an original array is tainted", ->
  #   ([1, 2] + [3, 4]).tainted?.should be_false
  #   ([1, 2].taint + [3, 4]).tainted?.should be_false
  #   ([1, 2] + [3, 4].taint).tainted?.should be_false
  #   ([1, 2].taint + [3, 4].taint).tainted?.should be_false

  # ruby_version_is '1.9' do
  #   it "does not infected even if an original array is untrusted", ->
  #     ([1, 2] + [3, 4]).untrusted?.should be_false
  #     ([1, 2].untrust + [3, 4]).untrusted?.should be_false
  #     ([1, 2] + [3, 4].untrust).untrusted?.should be_false
  #     ([1, 2].untrust + [3, 4].untrust).untrusted?.should be_false
