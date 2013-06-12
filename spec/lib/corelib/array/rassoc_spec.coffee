describe "Array#rassoc", ->
  it "returns the first contained array whose second element is == object", ->
    ary = R.$Array_r([[1, "a", 0.5], [2, "b"], [3, "b"], [4, "c"], [], [5], [6, "d"]])
    expect( ary.rassoc("a") ).toEqual R([1, "a", 0.5])
    expect( ary.rassoc("b") ).toEqual R([2, "b"])
    expect( ary.rassoc("d") ).toEqual R([6, "d"])
    expect( ary.rassoc("z") ).toEqual null

  xit "properly handles recursive arrays", ->
  #   empty = ArraySpecs.empty_recursive_array
  #   empty.rassoc([]).should be_nil
  #   [[empty, empty]].rassoc(empty).should == [empty, empty]

  #   array = ArraySpecs.recursive_array
  #   array.rassoc(array).should be_nil
  #   [[empty, array]].rassoc(array).should == [empty, array]

  it "calls elem == obj on the second element of each contained array", ->
    key = R('foobar')
    o =
      equals: (other) -> other.equals('foobar')

    expect( R.$Array_r([[1, "foobars"], [2, o], [3, 'foo']]).rassoc(key) ).toEqual R([2, o])

  it "does not check the last element in each contained but speficically the second", ->
    key = R('foobar')
    o =
      equals: (other) -> other.equals 'foobar'

    expect( R.$Array_r( [[1, "foobars", o], [2, o, 1], [3, 'foo']] ).rassoc(key) ).toEqual R([2, o, 1])
