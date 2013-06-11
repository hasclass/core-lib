describe "Array#|", ->
  it "returns an array of elements that appear in either array (union)", ->
    expect( R([]).union []).toEqual R([])
    expect( R([1, 2]).union []).toEqual R([1, 2])
    expect( R([]).union [1, 2]).toEqual R([1, 2])
    expect( R([ 1, 2, 3, 4 ]).union [ 3, 4, 5 ]).toEqual R([1, 2, 3, 4, 5])

  it "creates an array with no duplicates", ->
    expect( R([ 1, 2, 3, 1, 4, 5 ]).union [ 1, 3, 4, 5, 3, 6 ]).toEqual R([1, 2, 3, 4, 5, 6])

  it "creates an array with elements in order they are first encountered", ->
    expect( R([ 1, 2, 3, 1 ]).union [ 1, 3, 4, 5 ]).toEqual R([1, 2, 3, 4, 5])

  # ruby_bug "#", "1.8.6.277", ->
  #   it "properly handles recursive arrays", ->
  #     empty = ArraySpecs.empty_recursive_array
  #     (empty | empty).should == empty

  #     array = ArraySpecs.recursive_array
  #     (array | []).should == [1, 'two', 3.0, array]
  #     ([] | array).should == [1, 'two', 3.0, array]
  #     (array | array).should == [1, 'two', 3.0, array]
  #     (array | empty).should == [1, 'two', 3.0, array, empty]

  it "tries to convert the passed argument to an Array using #valueOf", ->
    obj =
      valueOf: -> [1, 2, 3]
    expect(R([0]).union obj).toEqual R([0]).union([1, 2, 3])

  # MRI follows hashing semantics here, so doesn't actually call eql?/hash for Fixnum/Symbol
#   it "acts as if using an intermediate hash to collect values", ->
#     ([5.0, 4.0] | [5, 4]).should == [5.0, 4.0, 5, 4]
#     str = "x"
#     ([str] | [str.dup]).should == [str]

#     obj1 = mock('1')
#     obj2 = mock('2')
#     def obj1.hash; 0; end
#     def obj2.hash; 0; end
#     def obj1.eql? a; true; end
#     def obj2.eql? a; true; end

#     ([obj1] | [obj2]).should == [obj1]

#     def obj1.eql? a; false; end
#     def obj2.eql? a; false; end

#     ([obj1] | [obj2]).should == [obj1, obj2]

#   it "does not return subclass instances for Array subclasses", ->
#     (ArraySpecs.MyArray[1, 2, 3] | []).should be_kind_of(Array)
#     (ArraySpecs.MyArray[1, 2, 3] | ArraySpecs.MyArray[1, 2, 3]).should be_kind_of(Array)
#     ([] | ArraySpecs.MyArray[1, 2, 3]).should be_kind_of(Array)

#   it "does not call to_ary on array subclasses", ->
#     ([1, 2] | ArraySpecs.ToAryArray[5, 6]).should == [1, 2, 5, 6]
