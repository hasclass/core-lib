describe "Enumerable#each_with_index", ->

  beforeEach ->
    @b = EnumerableSpecs.Numerous.new(2, 5, 3, 6, 1, 4)

  it "passes each element and its index to block", ->
    a = R []
    @b.each_with_index( (o, i) -> a.push R([o, i]) )
    expect(a.unbox(true)).toEqual [[2, 0], [5, 1], [3, 2], [6, 3], [1, 4], [4, 5]]

  # it "provides each element to the block", ->
  #   acc = []
  #   obj = EnumerableSpecs::EachDefiner.new()
  #   res = obj.each_with_index( (a,i) -> acc << [a,i] )
  #   acc.should == []
  #   obj.should == res

  it "provides each element to the block and its index", ->
    acc = R []
    res = @b.each_with_index( (a,i) -> acc.push R([a, i]) )
    expect( acc.unbox(true) ).toEqual [[2, 0], [5, 1], [3, 2], [6, 3], [1, 4], [4, 5]]
    expect( res).toEqual @b

  it "binds splat arguments properly", ->
    acc = R []
    res = @b.each_with_index (b...) ->
      c = b[0]
      d = b[1]
      acc.push(c)
      acc.push(d)
    expect( acc.unbox(true) ).toEqual [2, 0, 5, 1, 3, 2, 6, 3, 1, 4, 4, 5]
    expect( res).toEqual @b

  xdescribe "ruby_version_is '1.8.7'", ->
    it "returns an enumerator if no block", ->
      e = @b.each_with_index()
      #e.should be_an_instance_of(enumerator_class)
      expect( e.to_a().unbox(true) ).toEqual [[2, 0], [5, 1], [3, 2], [6, 3], [1, 4], [4, 5]]


  # describe "ruby_version_is '1.9'", ->
  #   it "passes extra parameters to each", ->
  #     count = EnumerableSpecs::EachCounter.new(:apple)
  #     e = count.each_with_index(:foo, :bar)
  #     e.to_a.should == [[:apple, 0]]
  #     count.arguments_passed.should == [:foo, :bar]
