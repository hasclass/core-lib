describe "Array#to_a", ->
  it "returns self", ->
    a = R([1, 2, 3])
    expect( a.to_a() ).toEqual R([1, 2, 3])
    expect( a ).toEqual a.to_a()

  xit "does not return subclass instance on Array subclasses", ->
    # e = ArraySpecs.MyArray.new(1, 2)
    # e.to_a.should be_an_instance_of(Array)
    # e.to_a.should == [1, 2]

  it "properly handles recursive arrays", ->
    empty = R([])
    empty.push(empty)
    expect(empty.to_a()).toEqual empty
