describe "Enumerable#sort_by", ->
  it "returns an array of elements ordered by the result of block", ->
    a = EnumerableSpecs.Numerous.new("once", "upon", "a", "time")
    expect( a.sort_by((i) -> i.chr() ) ).toEqual R.$Array_r(["a", "once", "time", "upon"])

  xit "sorts the object by the given attribute", ->
    # a = EnumerableSpecs.SortByDummy.new("fooo")
    # b = EnumerableSpecs.SortByDummy.new("bar")

    # ar = [a, b].sort_by { |d| d.s }
    # ar.should == [b, a]

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an Enumerator when a block is not supplied", ->
      a = EnumerableSpecs.Numerous.new("a","b")
      expect( a.sort_by() ).toBeInstanceOf R.Enumerator
      expect( a.sort_by().to_a() ).toEqual R.$Array_r(["a", "b"])

  xit "gathers whole arrays as elements when each yields multiple", ->
    multi = EnumerableSpecs.YieldsMulti.new()
    expect( multi.sort_by (e) e.size() ).toEqual [[1, 2], [3, 4, 5], [6, 7, 8, 9]]
