describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#max_by", ->
    it "returns an enumerator if no block", ->
      expect( EnumerableSpecs.Numerous.new(42).max_by() ).toBeInstanceOf R.Enumerator

    it "returns nil if #each yields no objects", ->
      expect( EnumerableSpecs.Empty.new().max_by (o) -> o.nonesuch ).toEqual null

    it "returns the object for whom the value returned by block is the largest", ->
      expect( EnumerableSpecs.Numerous.new('1', '2', '3').max_by (obj) -> obj.to_i() ).toEqual R('3')
      expect( EnumerableSpecs.Numerous.new('three', 'five').max_by (obj) -> obj.size() ).toEqual R('three')

    it "returns the object that appears first in #each in case of a tie", ->
      expect( EnumerableSpecs.Numerous.new('1', '2', '2').max_by (obj) -> obj.to_i() ).toEqual R('2')

    it "uses max.<=>(current) to determine order", ->
      # a, b, c = (1..3).map(n) -> EnumerableSpecs.ReverseComparable.new(n)

      # # Just using self here to avoid additional complexity
      # expect( EnumerableSpecs.Numerous.new(a, b, c).max_by (obj) -> obj ).toEqual a

    it "is able to return the maximum for enums that contain nils", ->
      en = EnumerableSpecs.Numerous.new(null, null, true)
      expect( en.max_by (o) -> if o is null then R(0) else R(1) ).toEqual true
      expect( en.max_by (o) -> if o is null then R(1) else R(0) ).toEqual null

    xit "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs.YieldsMulti.new
      # multi.max_by {|e| e.size}.should == [6, 7, 8, 9]
