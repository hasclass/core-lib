describe "Array#partition", ->
  it "returns two arrays", ->
    expect( R([]).partition(->).unbox(true) ).toEqual [[], []]

  it "returns in the left array values for which the block evaluates to true", ->
    ary = R [0, 1, 2, 3, 4, 5]

    expect( ary.partition( (i) -> true       ).unbox(true) ).toEqual [[0, 1, 2, 3, 4, 5], []]
    expect( ary.partition( (i) -> 5          ).unbox(true) ).toEqual [[0, 1, 2, 3, 4, 5], []]
    expect( ary.partition( (i) -> false      ).unbox(true) ).toEqual [[], [0, 1, 2, 3, 4, 5]]
    expect( ary.partition( (i) -> null       ).unbox(true) ).toEqual [[], [0, 1, 2, 3, 4, 5]]
    expect( ary.partition( (i) -> i % 2 == 0 ).unbox(true) ).toEqual [[0, 2, 4], [1, 3, 5]]
    expect( ary.partition( (i) -> R(i).div(3).equals(0) ).unbox(true) ).toEqual [[0, 1, 2], [3, 4, 5]]

  it "properly handles recursive arrays", ->
    empty = R []
    empty.push empty
    expect( empty.partition( -> true  ).first()  ).toEqual R([empty])
    expect( empty.partition( -> false ).last()   ).toEqual R([empty])

  #   array = ArraySpecs.recursive_array
  #   array.partition { true }.should == [
  #     [1, 'two', 3.0, array, array, array, array, array],
  #     []
  #   ]
  #   condition = true
  #   array.partition { condition = !condition }.should == [
  #     ['two', array, array, array],
  #     [1, 3.0, array, array]
  #   ]

  xit "does not return subclass instances on Array subclasses", ->
    # result = ArraySpecs.MyArray[1, 2, 3].partition { |x| x % 2 == 0 }
    # result.should be_kind_of(Array)
    # result[0].should be_kind_of(Array)
    # result[1].should be_kind_of(Array)
