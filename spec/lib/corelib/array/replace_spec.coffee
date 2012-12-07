describe "Array#replace", ->
  it "replaces the elements with elements from other array", ->
    a = R([1, 2, 3, 4, 5])
    b = R(['a', 'b', 'c'])
    expect( a.replace(b) is a).toEqual true
    expect( a ).toEqual R(b)
    expect( a is b).toEqual false

    a.replace([4,4,4,4,4])
    expect( a ).toEqual R([4,4,4,4,4])

    a.replace([])
    expect( a ).toEqual R([])

  it "properly handles recursive arrays", ->
    # orig = R([1, 2, 3])
    # empty = ArraySpecs.empty_recursive_array
    # orig.replace(empty)
    # expect( orig ).toEqual R(empty)

    # array = ArraySpecs.recursive_array
    # orig.replace(array)
    # expect( orig ).toEqual R(array)

  it "returns self", ->
    ary   = R([1, 2, 3])
    other = R(['a', 'b', 'c'])
    expect( ary.replace(other) is ary).toEqual true

  it "does not make self dependent to the original array", ->
    ary   = R([1, 2, 3])
    other = ['a', 'b', 'c']
    ary.replace(other)
    expect( ary ).toEqual R(['a', 'b', 'c'])
    ary.append 'd'
    expect( ary ).toEqual R(['a', 'b', 'c', 'd'])
    expect( other ).toEqual ['a', 'b', 'c']

  it "tries to convert the passed argument to an Array using #to_ary", ->
    obj =
      to_ary: -> R([1, 2, 3])
    expect( R([]).replace(obj) ).toEqual R([1, 2, 3])

  xit "does not call #to_ary on Array subclasses", ->
    # obj = ArraySpecs.ToAryArray[5, 6, 7]
    # obj.should_not_receive(:to_ary)
    # [].replace(ArraySpecs.ToAryArray[5, 6, 7]) ).toEqual R([5, 6, 7])

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     expect( ->
  #       ArraySpecs.frozen_array.replace(ArraySpecs.frozen_array)
  #     ).toThrow(TypeError)

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( ->
  #       ArraySpecs.frozen_array.replace(ArraySpecs.frozen_array)
  #     ).toThrow(RuntimeError)
