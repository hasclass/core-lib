describe "Array#transpose", ->
  it "assumes an array of arrays and returns the result of transposing rows and columns", ->
    expect( R.$Array_r( [[1, 'a'], [2, 'b'], [3, 'c']] ).transpose().unbox(true) ).toEqual [[1, 2, 3], ["a", "b", "c"]]
    expect( R.$Array_r( [[1, 2, 3], ["a", "b", "c"]]   ).transpose().unbox(true) ).toEqual [[1, 'a'], [2, 'b'], [3, 'c']]
    expect( R.$Array_r( []                             ).transpose().unbox(true) ).toEqual []
    expect( R.$Array_r( [[]]                           ).transpose().unbox(true) ).toEqual []
    expect( R.$Array_r( [[], []]                       ).transpose().unbox(true) ).toEqual []
    expect( R.$Array_r( [[0]]                          ).transpose().unbox(true) ).toEqual [[0]]
    expect( R.$Array_r( [[0], [1]]                     ).transpose().unbox(true) ).toEqual [[0, 1]]

  it "tries to convert the passed argument to an Array using #to_ary", ->
    obj =
      to_ary: -> R([1, 2])
    expect( R( [obj, ['a', 'b']] ).transpose().unbox(true) ).toEqual [[1, 'a'], [2, 'b']]

  # it "properly handles recursive arrays", ->
  #   empty = ArraySpecs.empty_recursive_array
  #   empty.transpose.should == empty

  #   a = []; a << a
  #   b = []; b << b
  #   [a, b].transpose.should == [[a, b]]

  #   a = [1]; a << a
  #   b = [2]; b << b
  #   [a, b].transpose == [ [1, 2], [a, b] ]

  # it "raises a TypeError if the passed Argument does not respond to #to_ary", ->
  #   expect( -> [Object.new, [:a, :b]].transpose ).toThrow(TypeError)

  # it "does not call to_ary on array subclass elements", ->
  #   ary = [ArraySpecs.ToAryArray[1, 2], ArraySpecs.ToAryArray[4, 6]]
  #   ary.transpose.should == [[1, 4], [2, 6]]

  # it "raises an IndexError if the arrays are not of the same length", ->
  #   expect( -> [[1, 2], [:a]].transpose ).toThrow(IndexError)

  # it "does not return subclass instance on Array subclasses", ->
  #   result = ArraySpecs.MyArray[ArraySpecs.MyArray[1, 2, 3], ArraySpecs.MyArray[4, 5, 6]].transpose
  #   result.should be_kind_of(Array)
  #   result[0].should be_kind_of(Array)
  #   result[1].should be_kind_of(Array)
