describe "Array#product", ->
  it "returns converted arguments using valueOf", ->
    expect( -> R([1]).product( {} ) ).toThrow('TypeError')

    obj =
      valueOf: -> [2,3]
    expect( R([1]).product(obj).valueOf()).toEqual [[1, 2], [1, 3]]


  it "returns the expected result", ->
    expect( R([1,2]).product([3,4,5],[6,8]).valueOf()).toEqual [
      [1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
      [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]

  it "has no required argument", ->
    expect( R([1,2]).product().valueOf() ).toEqual [[1],[2]]

  it "returns an empty array when the argument is an empty array", ->
    expect( R([1, 2]).product([]).valueOf() ).toEqual []

  xit "does not attempt to produce an unreasonable number of products", ->
  #   a = (0..100).to_a
  #   lambda do
  #     a.product(a, a, a, a, a, a, a, a, a, a)
  #   end.should raise_error(RangeError)

  describe "when given a block", ->
    it "yields all combinations in turn", ->
      acc = []
      R([1,2]).product([3,4,5],[6,8], (ary) -> acc.push ary)
      expect( acc ).toEqual [
        [1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
        [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]

      acc = []
      R([1,2]).product([3,4,5],[],[6,8], (ary) -> acc.push ary)
      expect( acc ).toEqual []

    it "will ignore unreasonable numbers of products and yield anyway", ->
      # a = (0..100).to_a
      # lambda do
      #   a.product(a, a, a, a, a, a, a, a, a, a)
      # end.should raise_error(RangeError)

  describe "when given an empty block", ->
    it "returns self", ->
      arr = R([1,2])
      expect( arr.product([3,4,5],[6,8], ->) is arr).toEqual true
      arr = R([])
      expect( arr.product([3,4,5],[6,8], ->) is arr).toEqual true
      arr = R([1,2])
      expect( arr.product([], ->) is arr).toEqual true
