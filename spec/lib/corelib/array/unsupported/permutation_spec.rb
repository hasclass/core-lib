describe "Array#permutation", ->
  beforeEach ->
    @numbers = R.$array_r([1,2,3])
    @yielded = []

  it "returns an Enumerator of all permutations when called without a block or arguments", ->
    en = @numbers.permutation()
    expect( en ).toBeInstanceOf(R.Enumerator)
    expect( en.to_a().unbox(true) ).toEqual R.$array_r([
      [1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]
    ]).unbox(true)

  it "returns an Enumerator of permutations of given length when called with an argument but no block", ->
    en = @numbers.permutation(1)
    expect( en ).toBeInstanceOf(R.Enumerator)
    expect( en.to_a().unbox(true) ).toEqual [[1],[2],[3]]

  # it "yields all permutations to the block then returns self when called with block but no arguments", ->
  #   array = @numbers.permutation {|n| @yielded << n}
  #   array.should be_an_instance_of(Array)
  #   array.sort.should == @numbers.sort
  #   @yielded.sort.should == [
  #     [1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]
  #   ].sort

  # it "yields all permutations of given length to the block then returns self when called with block and argument", ->
  #   array = @numbers.permutation(2) {|n| @yielded << n}
  #   array.should be_an_instance_of(Array)
  #   array.sort.should == @numbers.sort
  #   @yielded.sort.should == [[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]].sort

  # it "returns the empty permutation ([[]]) when the given length is 0", ->
  #   @numbers.permutation(0).to_a.should == [[]]
  #   @numbers.permutation(0) { |n| @yielded << n }
  #   @yielded.should == [[]]

  # it "returns the empty permutation([]) when called on an empty Array", ->
  #   [].permutation.to_a.should == [[]]
  #   [].permutation { |n| @yielded << n }
  #   @yielded.should == [[]]

  # it "returns no permutations when the given length has no permutations", ->
  #   @numbers.permutation(9).entries.size == 0
  #   @numbers.permutation(9) { |n| @yielded << n }
  #   @yielded.should == []

  # it "handles duplicate elements correctly", ->
  #   @numbers << 1
  #   @numbers.permutation(2).sort.should == [
  #     [1,1],[1,1],[1,2],[1,2],[1,3],[1,3],
  #     [2,1],[2,1],[2,3],
  #     [3,1],[3,1],[3,2]
  #   ].sort

  # it "handles nested Arrays correctly", ->
  #   # The ugliness is due to the order of permutations returned by
  #   # permutation being undefined combined with #sort croaking on Arrays of
  #   # Arrays.
  #   @numbers << [4,5]
  #   got = @numbers.permutation(2).to_a
  #   expected = [
  #      [1, 2],      [1, 3],      [1, [4, 5]],
  #      [2, 1],      [2, 3],      [2, [4, 5]],
  #      [3, 1],      [3, 2],      [3, [4, 5]],
  #     [[4, 5], 1], [[4, 5], 2], [[4, 5], 3]
  #   ]
  #   expected.each {|e| got.include?(e).should be_true}
  #   got.size.should == expected.size

  # it "truncates Float arguments", ->
  #   @numbers.permutation(3.7).to_a.sort.should ==
  #     @numbers.permutation(3).to_a.sort

  # it "returns an Enumerator which works as expected even when the array was modified", ->
  #   @numbers = [1, 2]
  #   en = @numbers.permutation
  #   @numbers << 3
  #   en.to_a.sort.should == [
  #     [1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]
  #   ].sort

  # it "generates from a defensive copy, ignoring mutations", ->
  #   accum = []
  #   ary = [1,2,3]
  #   ary.permutation(3) do |x|
  #     accum << x
  #     ary[0] = 5

  #   accum.should == [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
