describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#minmax", ->
    beforeEach ->
      @enum = EnumerableSpecs.Numerous.new(6, 4, 5, 10, 8)
      @strs = EnumerableSpecs.Numerous.new("333", "2", "60", "55555", "1010", "111")

    it "min should return the minimum element", ->
      expect( @enum.minmax() ).toEqual R.$Array_r([4, 10])
      expect( @strs.minmax() ).toEqual R.$Array_r(["1010", "60" ])

    it "returns [nil, nil] for an empty Enumerable", ->
      expect( EnumerableSpecs.Empty.new().minmax() ).toEqual R.$Array_r([null, null])

    it "raises an ArgumentError when elements are incomparable", ->
      expect( ->
        EnumerableSpecs.Numerous.new(11,"22").minmax()
      ).toThrow('ArgumentError')
      expect( ->
        EnumerableSpecs.Numerous.new(11,12,22,33).minmax (a, b) -> null
      ).toThrow('ArgumentError')

    # ruby_version_is ""..."1.9", ->
    #   it "raises a NoMethodError for elements without #cmp", ->
    #     lambda do
    #       EnumerableSpecs.Numerous.new(Object.new, Object.new).minmax
    #     end.should raise_error(NoMethodError)

    describe 'ruby_version_is "1.9"', ->
      it "raises a NoMethodError for elements without #cmp", ->
        expect( ->
          EnumerableSpecs.Numerous.new(new Object(), new Object()).minmax()
        # TODO: should throw NoMethodError
        # ).toThrow('NoMethodError')
        ).toThrow()

    it "return the minimun when using a block rule", ->
      expect( @enum.minmax( (a,b) -> b.cmp a )               ).toEqual R.$Array_r([10, 4])
      expect( @strs.minmax( (a,b) -> a.size().cmp b.size() ) ).toEqual R.$Array_r(["2", "55555"])

    it "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs.YieldsMulti.new
      # multi.minmax().should == [[1, 2], [6, 7, 8, 9]]
