describe "Array#index", ->
  # it_behaves_like(:array_index, :index)
  it "returns the index of the first element == to object", ->
    x =
      '==': (obj) -> R(3).equals(obj)

    expect( R([2, x, 3, 1, 3, 1]).index(3) ).toEqual R(1)
    expect( R([2, 3.0, 3, x, 1, 3, 1]).index(x) ).toEqual R(1)

  it "returns 0 if first element == to object", ->
    expect( R([2, 1, 3, 2, 5]).index(2) ).toEqual R(0)

  it "returns size-1 if only last element == to object", ->
    expect( R([2, 1, 3, 1, 5]).index(5) ).toEqual R(4)

  it "returns nil if no element == to object", ->
    expect( R([2, 1, 1, 1, 1]).index(3) ).toEqual null

  describe 'ruby_version_is "1.8.7"', ->
    it "accepts a block instead of an argument", ->
      expect( R([4, 2, 1, 5, 1, 3]).index((x) -> x < 2) ).toEqual R(2)

    it "ignore the block if there is an argument", ->
      expect( R([4, 2, 1, 5, 1, 3]).index(5, (x) -> x < 2) ).toEqual R(3)
