describe "Array#product", ->
  it "returns converted arguments using :to_ary", ->
    expect( -> R([1]).product(R.Range.new(2,3) ) ).toThrow('TypeError')

    # ar = ArraySpecs.ArrayConvertable.new(2,3)
    # [1].product(ar).should == [[1,2],[1,3]]
    # ar.called.should == :to_ary

  it "returns the expected result", ->
    expect( R([1,2]).product([3,4,5],[6,8]).unbox(true)).toEqual [
      [1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
      [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]

  it "has no required argument", ->
    expect( R([1,2]).product().unbox(true) ).toEqual [[1],[2]]

  it "returns an empty array when the argument is an empty array", ->
    expect( R([1, 2]).product([]).unbox(true) ).toEqual []

  xit "does not attempt to produce an unreasonable number of products", ->
  #   a = (0..100).to_a
  #   lambda do
  #     a.product(a, a, a, a, a, a, a, a, a, a)
  #   end.should raise_error(RangeError)

  describe "when given a block", ->
    it "yields all combinations in turn", ->
      acc = R []
      R([1,2]).product([3,4,5],[6,8], (ary) -> acc.push ary)
      expect( acc.unbox(true) ).toEqual [
        [1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
        [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]

      acc = R []
      R([1,2]).product([3,4,5],[],[6,8], (ary) -> acc.push ary)
      expect( acc.unbox(true) ).toEqual []

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
