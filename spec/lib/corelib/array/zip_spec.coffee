describe "Array#zip", ->
  it "returns an array of arrays containing corresponding elements of each array", ->
    expect( R([1, 2, 3, 4]).zip(["a", "b", "c", "d", "e"]).valueOf() ).toEqual [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]

  it "fills in missing values with nil", ->
    expect( R([1, 2, 3, 4, 5]).zip(["a", "b", "c", "d"]).valueOf() ).toEqual [[1, "a"], [2, "b"], [3, "c"], [4, "d"], [5, null]]

  it "does not get confused with false", ->
    expect( R([1, 2, 3, 4, 5]).zip(["a", "b", "c", false]).valueOf() ).toEqual [[1, "a"], [2, "b"], [3, "c"], [4, false], [5, null]]

  xit "properly handles recursive arrays", ->
    # a = []; a << a
    # b = [1]; b << b

    # a.zip(a).should == [ [a[0], a[0]] ]
    # a.zip(b).should == [ [a[0], b[0]] ]
    # b.zip(a).should == [ [b[0], a[0]], [b[1], a[1]] ]
    # b.zip(b).should == [ [b[0], b[0]], [b[1], b[1]] ]

  it "calls #valueOf to convert the argument to an Array", ->
    obj =
      valueOf: -> [3, 4]
    expect( R([1, 2]).zip(obj).valueOf() ).toEqual [[1, 3], [2, 4]]

  # ruby_version_is "1.9.2", ->
  #   it "uses #each to extract arguments' elements when #to_ary fails", ->
  #     obj = Class.new do
  #       def each(&b)
  #         [3,4].each(&b)
  #           end.new

  #     [1, 2].zip(obj).should == [[1, 3], [2, 4]]

  it "calls block if supplied", ->
    values = R []
    ret = R([1, 2, 3, 4]).zip ["a", "b", "c", "d", "e"], (value) ->
      values.push value
    expect( ret ).toEqual null

    expect( values.valueOf() ).toEqual [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]

  # xit "does not return subclass instance on Array subclasses", ->
  #   # ArraySpecs.MyArray[1, 2, 3].zip(["a", "b"]).should be_kind_of(Array)
