describe "Enumerable#collect", ->
  it "returns a new array with the results of passing each element to block", ->
    entries = [0, 1, 3, 4, 5, 6]
    numerous = EnumerableSpecs.Numerous.new(0, 1, 3, 4, 5, 6)
    expect( numerous.collect( (i) -> i.modulo(2) ) ).toEqual R.$Array_r([0, 1, 1, 0, 1, 0])
    expect( numerous.collect( (i) -> i           ) ).toEqual R.$Array_r(entries)

  describe 'ruby_version_is "1.8.7"', ->
    it "passes through the values yielded by #each_with_index", ->
      arr = []
      res = R(["a", "b"]).each_with_index().collect (x, i) -> arr.push [x, +i]; null
      expect( arr ).toEqual [['a', 0], ["b", 1]]

  # ruby_version_is ""..."1.9", ->
    # it "gathers whole arrays as elements when each yields multiple", ->
    #   multi = EnumerableSpecs.YieldsMulti.new
    #   multi.collect {|e| e}.should == [[1,2],[3,4,5],[6,7,8,9]]
    # it "returns to_a when no block given", ->
    #   expect(
    #     EnumerableSpecs.Numerous.new().collect()
    #   ).toEqual R.$Array_r([2, 5, 3, 6, 1, 4])

  describe 'ruby_version_is "1.9"', ->
    it "gathers initial args as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMulti()
      expect( multi.collect (e) -> e ).toEqual R([1,3,6])


    it "returns an enumerator when no block given", ->
      en = EnumerableSpecs.Numerous.new().collect()
      expect( en ).toBeInstanceOf R.Enumerator
      expect( en.each((i) -> -i ) ).toEqual R([-2, -5, -3, -6, -1, -4])

    # it "().map (x...) => x: [a, 0]", ->
    #   expect( @en.map((x...) -> x     ).to_native() ).toEqual [['a', R(0)]]


  describe 'block arguments with enumerators', ->
    beforeEach ->
      @en  = R(['a'])

    it "().map (x,i) => x: a, i: 0", ->
      expect( @en.each_with_index().map().to_a().to_native() ).toEqual [['a', 0]]
      expect( R(['a']).map().each_with_index().to_a().to_native() ).toEqual [['a', 0]]

    it "().map (x,i) => x: a, i: 0", ->
      en = R(['a'])
      expect( en.map((x) -> x          ).to_native() ).toEqual ['a']
      expect( en.map((x, z) -> [x, z]  ).to_native() ).toEqual [['a', undefined]]

    it "().map (x,i) => x: a, i: 0", ->
      expect( @en.each_with_index().map((x, i) -> [i,x]  ).to_native() ).toEqual [[0, 'a']]

    it "().map (x) => x: a", ->
      expect( @en.each_with_index().map((x) -> x     ).to_native() ).toEqual ['a']

    it "().map (x...) => x: [a, 0]", ->
      expect( @en.each_with_index().map((x...) -> x     ).to_native() ).toEqual [['a', 0]]

    # TODO FIX
    it "reversed does not work!", ->
      expect( @en.map().each_with_index((x,i) -> "#{x} #{i}"    ) ).toEqual R(['a 0'])

