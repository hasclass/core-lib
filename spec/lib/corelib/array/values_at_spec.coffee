describe "Array#values_at", ->
  it "returns an array of elements at the indexes when passed indexes", ->
    expect( R([1, 2, 3, 4, 5]).values_at() ).toEqual R([])
    expect( R([1, 2, 3, 4, 5]).values_at(1, 0, 5, -1, -8, 10) ).toEqual R([2, 1, null, 5, null, null])

  it "calls valueOf on its indices", ->
    obj =
      valueOf: -> (1)
    expect( R([1, 2]).values_at(obj, obj, obj) ).toEqual R([2, 2, 2])

  it "returns an array of elements in the ranges when passes ranges", ->
    # [1, 2, 3, 4, 5].values_at(0..2, 1...3, 2..-2).should == [1, 2, 3, 2, 3, 3, 4]
    # [1, 2, 3, 4, 5].values_at(6..4).should == []

  xit "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # empty.values_at(0, 1, 2).should == [empty, null, null]

    # array = ArraySpecs.recursive_array
    # array.values_at(0, 1, 2, 3).should == [1, 'two', 3.0, array]

  xit "calls to_int on arguments of ranges when passes ranges", ->
    # from = mock('from')
    # to = mock('to')

    # # So we can construct a range out of them...
    # def from.<=>(o) 0 end
    # def to.<=>(o) 0 end

    # def from.to_int() 1 end
    # def to.to_int() -2 end

    # ary = [1, 2, 3, 4, 5]
    # ary.values_at(from .. to, from ... to, to .. from).should == [2, 3, 4, 2, 3]

  xit "does not return subclass instance on Array subclasses", ->
    # ArraySpecs.MyArray[1, 2, 3].values_at(0, 1..2, 1).should be_an_instance_of(Array)
