describe "Array#reverse_each", ->
  it "traverses array in reverse order and pass each element to block", ->
    acc = []
    R([1, 3, 4, 6]).reverse_each (i) -> acc.push i
    expect( acc ).toEqual [6, 4, 3, 1]

  it "returns self", ->
    a = R ['a', 'b', 'c']
    expect( a.reverse_each(->) is a ).toEqual true

  it "returns Enumerator without Block", ->
    a = R ['a', 'b', 'c']
    expect( a.reverse_each() ).toBeInstanceOf(R.Enumerator)

  xit "yields only the top level element of an empty recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # empty.reverse_each { |i| ScratchPad << i }
    # ScratchPad.recorded.should == [empty]

  xit "yields only the top level element of a recursive array", ->
    # array = ArraySpecs.recursive_array
    # array.reverse_each { |i| ScratchPad << i }
    # ScratchPad.recorded.should == [array, array, array, array, array, 3.0, 'two', 1]
