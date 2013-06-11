describe "Array#-", ->
  it "creates an array minus any items from other array", ->
    expect( R([]).minus [ 1, 2, 4 ]).toEqual R([])
    expect( R([1, 2, 4]).minus []).toEqual R([1, 2, 4])
    expect( R([ 1, 2, 3, 4, 5 ]).minus [ 1, 2, 4 ]).toEqual R([3, 5])

  it "removes multiple items on the lhs equal to one on the rhs", ->
    expect( R([1, 1, 2, 2, 3, 3, 4, 5]).minus [1, 2, 4]).toEqual R([3, 3, 5])

  # ruby_bug "#", "1.8.6.277", ->
  #   it "properly handles recursive arrays", ->
  #     empty = ArraySpecs.empty_recursive_array
  #     (empty - empty).should == []

  #     ([] - ArraySpecs.recursive_array).should == []

  #     array = ArraySpecs.recursive_array
  #     (array - array).should == []

  it "tries to convert the passed arguments to Arrays using #valueOf", ->
    obj =
      valueOf: -> [2, 3, 3, 4]
    expect( R([1, 1, 2, 2, 3, 4]).minus obj).toEqual R([1, 1])

  it "raises a TypeError if the argument cannot be coerced to an Array by calling #valueOf", ->
    obj = 'not an array'
    expect( -> R([1, 2, 3]).minus obj ).toThrow('TypeError')

#   it "does not return subclass instance for Array subclasses", ->
#     (ArraySpecs.MyArray[1, 2, 3] - []).should be_kind_of(Array)
#     (ArraySpecs.MyArray[1, 2, 3] - ArraySpecs.MyArray[]).should be_kind_of(Array)
#     ([1, 2, 3] - ArraySpecs.MyArray[]).should be_kind_of(Array)

  xit "does not call valueOf on array subclasses", ->
    # ([5, 6, 7] - ArraySpecs.ToAryArray[7]).should == [5, 6]

#   it "removes an item identified as equivalent via #hash and #eql?", ->
#     obj1 = mock('1')
#     obj2 = mock('2')
#     obj1.should_receive(:hash).and_return(0)
#     obj2.should_receive(:hash).and_return(0)
#     obj1.should_receive(:eql?).with(obj2).and_return(true)

#     ([obj1] - [obj2]).should == []

#   it "doesn't remove an item with the same hash but not #eql?", ->
#     obj1 = mock('1')
#     obj2 = mock('2')
#     obj1.should_receive(:hash).and_return(0)
#     obj2.should_receive(:hash).and_return(0)
#     obj1.should_receive(:eql?).with(obj2).and_return(false)

#     ([obj1] - [obj2]).should == [obj1]

#   it "removes an identical item even when its #eql? isn't reflexive", ->
#     x = mock('x')
#     x.should_receive(:hash).any_number_of_times.and_return(42)
#     x.stub!(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

#     ([x] - [x]).should == []

  it "is not destructive", ->
    a = R [1, 2, 3]
    a.minus []
    expect(a).toEqual R([1, 2, 3])
    a.minus [1]
    expect(a).toEqual R([1, 2, 3])
    a.minus [1,2,3]
    expect(a).toEqual R([1, 2, 3])
    a.minus ['a', 'b', 'c']
    expect(a).toEqual R([1, 2, 3])
