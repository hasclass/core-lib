describe "Array#push", ->
  it "appends the arguments to the array", ->
    a = R [ "a", "b", "c" ]
    expect( a.push("d", "e", "f") == a).toEqual true
    expect( a.push().valueOf() ).toEqual ["a", "b", "c", "d", "e", "f"]
    a.push(5)
    expect( a.valueOf() ).toEqual ["a", "b", "c", "d", "e", "f", 5]

  it "isn't confused by previous shift", ->
    a = R [ "a", "b", "c" ]
    a.shift()
    a.push("foo")
    expect( a ).toEqual R(["b", "c", "foo"])

  xit "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # empty.push(:last).should == [empty, :last]

    # array = ArraySpecs.recursive_array
    # array.push(:last).should == [1, 'two', 3.0, array, array, array, array, array, :last]

  xdescribe 'unsupported', ->
  # ruby_version_is "" ... "1.9", ->
  #   it "raises a TypeError on a frozen array if modification takes place", ->
  #     lambda { ArraySpecs.frozen_array.push(1) }.should raise_error(TypeError)


  #   it "does not raise on a frozen array if no modification is made", ->
  #     ArraySpecs.frozen_array.push.should == [1, 2, 3]


  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError on a frozen array", ->
  #     lambda { ArraySpecs.frozen_array.push(1) }.should raise_error(RuntimeError)
  #     lambda { ArraySpecs.frozen_array.push }.should raise_error(RuntimeError)
