describe "Array#reject", ->
  it "returns a new array without elements for which block is true", ->
    ary = R([1, 2, 3, 4, 5])
    expect( ary.reject -> true ).toEqual R([])
    expect( ary.reject -> false ).toEqual ary
    expect( ary is ary.reject -> false ).toEqual false
    expect( ary.reject -> null ).toEqual ary
    expect( ary is ary.reject -> null ).toEqual false
    expect( ary.reject -> 5 ).toEqual R([])
    expect( ary.reject (i) -> i < 3 ).toEqual R([3, 4, 5])
    expect( ary.reject (i) -> i % 2 == 0 ).toEqual R([1, 3, 5])

  it "returns self when called on an Array emptied with #shift", ->
    array = R([1])
    array.shift()
    expect( array.reject -> true ).toEqual R([])

  it "properly handles recursive arrays", ->
    empty = R []
    empty.push(empty)
    expect( empty.reject -> false ).toEqual R([empty])
    expect( empty.reject -> true ).toEqual R([])

    # array = ArraySpecs.recursive_array
    # expect( array.reject { false ).toEqual [1, 'two', 3.0, array, array, array, array, array]
    # expect( array.reject { true ).toEqual []

  # ruby_version_is "" ... "1.9.3", ->
  #   not_compliant_on :ironruby do
  #     it "returns subclass instance on Array subclasses", ->
  # expect(       ArraySpecs.MyArray[1, 2, 3].reject { |x| x % 2 == 0 ).toEqual(ArraySpecs.MyArray)

  #   deviates_on :ironruby do
  #     it "does not return subclass instance on Array subclasses", ->
  # expect(       ArraySpecs.MyArray[1, 2, 3].reject { |x| x % 2 == 0 ).toEqual(Array)

  # ruby_version_is "1.9.3", ->
  #   it "does not return subclass instance on Array subclasses", ->
  # expect(     ArraySpecs.MyArray[1, 2, 3].reject { |x| x % 2 == 0 ).toEqual(Array)

  #   it "does not retain instance variables", ->
  #     array = []
  #     array.instance_variable_set("@variable", "value")
  #     array.reject { false }.instance_variable_get("@variable").should == null

  # it_behaves_like :enumeratorize, :reject

describe "Array#reject!", ->
  it "removes elements for which block is true", ->
    a = R [3, 4, 5, 6, 7, 8, 9, 10, 11]
    expect( a.reject_bang (i) -> i % 2 == 0 ).toEqual(a)
    expect( a).toEqual R([3, 5, 7, 9, 11])
    a.reject_bang (i) -> i > 8
    expect( a).toEqual R([3, 5, 7])
    a.reject_bang (i) -> i < 4
    expect( a).toEqual R([5, 7])
    a.reject_bang (i) -> i == 5
    expect( a).toEqual R([7])
    a.reject_bang -> true
    expect( a).toEqual R([])
    a.reject_bang -> true
    expect( a).toEqual R([])

  xit "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # empty_dup = empty.dup
    # expect( empty.reject_bang -> false ).toEqual null
    # empty.should == empty_dup

    # empty = ArraySpecs.empty_recursive_array
    # expect( empty.reject_bang -> true ).toEqual []
    # expect( empty).toEqual R([])

    # array = ArraySpecs.recursive_array
    # array_dup = array.dup
    # expect( array.reject_bang -> false ).toEqual null
    # array.should == array_dup

    # array = ArraySpecs.recursive_array
    # expect( array.reject_bang -> true ).toEqual []
    # expect( array).toEqual R([])

  it "returns null when called on an Array emptied with #shift", ->
    array = R [1]
    array.shift()
    expect( array.reject_bang (x) -> true ).toEqual null

  it "returns null if no changes are made", ->
    a = R [1, 2, 3]
    expect( a.reject_bang (i) -> i < 0 ).toEqual null
    a.reject_bang -> true
    expect( a.reject_bang -> true ).toEqual null

  # ruby_version_is "" ... "1.9", ->
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.reject_bang ->} ).toThrow(TypeError)
  #     it "raises a TypeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.reject_bang ->} ).toThrow(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.reject_bang ->} ).toThrow(RuntimeError)
  #     it "raises a RuntimeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.reject_bang ->} ).toThrow(RuntimeError)

