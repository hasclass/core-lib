describe "Array#reverse", ->
  it "returns a new array with the elements in reverse order", ->
    expect( R([          ]).reverse().inspect() ).toEqual R('[]')
    expect( R([1, 3, 5, 2]).reverse().inspect() ).toEqual R('[2, 5, 3, 1]')

  it "rubyjs: should not reverse in place", ->
    arr = R([1, 3, 5, 2])
    arr.reverse()
    expect( arr.inspect() ).toEqual R('[1, 3, 5, 2]')

  it "properly handles recursive arrays", ->
    empty = R []
    empty.push empty
    expect( empty.reverse() ).toEqual empty

  #   array = ArraySpecs.recursive_array
  #   array.reverse.should == [array, array, array, array, array, 3.0, 'two', 1]

  # ruby_version_is "" ... "1.9.3", ->
  #   it "returns subclass instance on Array subclasses", ->
  #     ArraySpecs::MyArray[1, 2, 3].reverse.should be_kind_of(ArraySpecs::MyArray)


  # ruby_version_is "1.9.3", ->
  #   it "does not return subclass instance on Array subclasses", ->
  #     ArraySpecs::MyArray[1, 2, 3].reverse.should be_kind_of(Array)


describe "Array#reverse!", ->
  it "reverses the elements in place", ->
    a = R [6, 3, 4, 2, 1]
    expect( a.reverse_bang() ).toEqual(a)
    expect( a.inspect() ).toEqual R('[1, 2, 4, 3, 6]')
    expect( R([]).reverse_bang().inspect() ).toEqual R('[]')

#   it "properly handles recursive arrays", ->
#     empty = ArraySpecs.empty_recursive_array
#     empty.reverse!.should == [empty]

#     array = ArraySpecs.recursive_array
#     array.reverse!.should == [array, array, array, array, array, 3.0, 'two', 1]

#   ruby_version_is "" ... "1.9", ->
#     it "raises a TypeError on a frozen array", ->
#       lambda { ArraySpecs.frozen_array.reverse! }.should raise_error(TypeError)

#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError on a frozen array", ->
#       lambda { ArraySpecs.frozen_array.reverse! }.should raise_error(RuntimeError)

