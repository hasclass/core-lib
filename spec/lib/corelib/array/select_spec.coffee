describe "Array#select", ->
  # it_behaves_like :enumeratorize, :select

  it "returns a new array of elements for which block is true", ->
    expect( R([1, 3, 4, 5, 6, 9]).select (i) -> i >= 5 ).toEqual R([5,6,9])

  xit "does not return subclass instance on Array subclasses", ->
    # ArraySpecs.MyArray[1, 2, 3].select { true }.should be_kind_of(Array)

  it "properly handles recursive arrays", ->
    empty = R []
    empty.push(empty)
    expect( empty.select( -> true  ) ).toEqual empty
    expect( empty.select( -> false ) ).toEqual R([])

    # array = ArraySpecs.recursive_array
    # array.select { true }.should == [1, 'two', 3.0, array, array, array, array, array]
    # array.select { false }.should == []

describe "Array#select!", ->
  it "returns nil if no changes were made in the array", ->
    expect( R([1, 2, 3]).select_bang -> true ).toEqual null

  # it_behaves_like :keep_if, :select!
