describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#find_index", ->
    beforeEach ->
      @elements = [2, 4, 6, 8, 10]
      @numerous = EnumerableSpecs.Numerous.new(2, 4, 6, 8, 10)

    it "passes each entry in enum to block while block when block is false", ->
      visited_elements = R []
      @numerous.find_index (element) ->
        visited_elements.append element
        false
      expect( visited_elements.unbox(true) ).toEqual @elements

    it "returns nil when the block is false", ->
      expect( @numerous.find_index -> false ).toEqual null

    it "returns the first index for which the block is not false", ->
      numerous = @numerous
      R(@elements).each_with_index (element, index) ->
        expect( numerous.find_index((e) -> e.gt(element - 1) )).toEqual R(index)

    it "returns the first index found", ->
      repeated = R [10, 11, 11, 13, 11, 13, 10, 10, 13, 11]
      expect( repeated.find_index(11) ).toEqual R(1)
      expect( repeated.find_index(13) ).toEqual R(3)

    it "returns nil when the element not found", ->
      expect( @numerous.find_index(-1) ).toEqual null

    it "ignores the block if an argument is given", ->
      expect( @numerous.find_index(-1, (e) -> true ) ).toEqual null

    it "returns an Enumerator if no block given", ->
      expect( @numerous.find_index() ).toBeInstanceOf R.Enumerator

    # ruby_version_is ""..."1.9", ->
    #   it "gathers whole arrays as elements when each yields multiple", ->
    #     multi = EnumerableSpecs.YieldsMulti.new
    #     multi.find_index {|e| e == [1, 2] }.should == 0

    # ruby_version_is "1.9", ->
    #   it "gathers initial args as elements when each yields multiple", ->
    #     multi = EnumerableSpecs.YieldsMulti.new
    #     multi.find_index {|e| e == 1 }.should == 0
