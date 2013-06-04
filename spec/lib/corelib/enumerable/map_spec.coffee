xdescribe "Enumerable#map", ->
  # it_behaves_like(:enumerable_map , :map)
  it "returns a new array with the results of passing each element to block", ->
    entries = [0, 1, 3, 4, 5, 6]
    numerous = EnumerableSpecs.Numerous.new(0, 1, 3, 4, 5, 6)
    expect( numerous.map( (i) -> i.modulo(2) ) ).toEqual R.$Array_r([0, 1, 1, 0, 1, 0])
    expect( numerous.map( (i) -> i           ) ).toEqual R.$Array_r(entries)

  describe 'ruby_version_is "1.8.7"', ->
    it "passes through the values yielded by #each_with_index", ->
      arr = []
      res = R(["a", "b"]).each_with_index().map (x, i) -> arr.push [x, i.valueOf()]; null
      expect( arr ).toEqual [['a', 0], ["b", 1]]


  # ruby_version_is ""..."1.9", ->
    # it "gathers whole arrays as elements when each yields multiple", ->
    #   multi = EnumerableSpecs.YieldsMulti.new
    #   multi.map {|e| e}.should == [[1,2],[3,4,5],[6,7,8,9]]
    # it "returns to_a when no block given", ->
    #   expect(
    #     EnumerableSpecs.Numerous.new().map()
    #   ).toEqual R.$Array_r([2, 5, 3, 6, 1, 4])


  describe 'ruby_version_is "1.9"', ->
    # it "gathers initial args as elements when each yields multiple", ->
    #   multi = EnumerableSpecs.YieldsMulti.new
    #   multi.map {|e| e}.should == [1,3,6]


    it "returns an enumerator when no block given", ->
      en = EnumerableSpecs.Numerous.new().map()
      expect( en).toBeInstanceOf R.Enumerator
      expect( en.each((i) -> -i ) ).toEqual [-2, -5, -3, -6, -1, -4]
