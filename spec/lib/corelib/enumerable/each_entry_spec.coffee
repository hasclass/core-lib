describe "ruby_version_is '1.9'", ->
  describe "Enumerable#each_entry", ->
    beforeEach ->
      @en = new EnumerableSpecs.YieldsMixed()
      @entries = [1, [2], [3,4], [5,6,7], [8,9], null, []]

    it "yields multiple arguments as an array", ->
      acc = []
      expect( @en.each_entry((g) -> acc.push g) is @en).toEqual true
      expect( acc ).toEqual @entries

    it "returns an enerator if no block", ->
      e = @en.each_entry()
      expect( e ).toBeInstanceOf R.Enumerator
      expect( e.to_a() ).toEqual R(@entries)

    it "passes through the values yielded by #each_with_index", ->
      arr = R []
      R(['a', 'b']).each_with_index().each_entry (e_idx) -> arr.push [e_idx[0], e_idx[1]]
      expect( arr.inspect() ).toEqual R([['a', 0], ['b', 1]]).inspect()

    it "raises an Argument error when extra arguments", ->
      en = @en
      expect( -> en.each_entry("one", ->).to_a() ).toThrow('ArgumentError')
    xit "TODO", ->
      expect( -> en.each_entry("one").to_a()   ).toThrow('ArgumentError')

    xit "passes extra arguments to #each", ->
      # en = EnumerableSpecs.EachCounter.new(1, 2)
      # en.each_entry(:foo, "bar").to_a.should == [1,2]
      # en.arguments_passed.should == [:foo, "bar"]
