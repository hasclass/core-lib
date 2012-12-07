describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#min_by", ->
    it "returns an enumerator if no block", ->
      expect( EnumerableSpecs.Numerous.new(42).min_by() ).toBeInstanceOf R.Enumerator

    it "returns nil if #each yields no objects", ->
      expect( EnumerableSpecs.Empty.new().min_by (o) -> o.nonesuch ).toEqual null

    it "returns the object for whom the value returned by block is the largest", ->
      expect( EnumerableSpecs.Numerous.new('1', '2', '3').min_by (obj) -> obj.to_i() ).toEqual R('1')
      expect( EnumerableSpecs.Numerous.new('three', 'five').min_by (obj) -> obj.size() ).toEqual R('five')

    it "returns the object that appears first in #each in case of a tie", ->
      expect( EnumerableSpecs.Numerous.new('1', '2', '2').min_by (obj) -> obj.to_i() ).toEqual R('1')

    it "uses min.<=>(current) to determine order", ->
      # a, b, c = (1..3).map(n) -> EnumerableSpecs.ReverseComparable.new(n)

      # # Just using self here to avoid additional complexity
      # expect( EnumerableSpecs.Numerous.new(a, b, c).min_by (obj) -> obj ).toEqual a

    it "is able to return the minimum for enums that contain nils", ->
      en = EnumerableSpecs.Numerous.new(null, null, true)
      expect( en.min_by (o) -> if o is null then R(0) else R(1) ).toEqual null
      expect( en.min_by (o) -> if o is null then R(1) else R(0) ).toEqual true

    xit "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs.YieldsMulti.new
      # multi.min_by {|e| e.size}.should == [6, 7, 8, 9]
