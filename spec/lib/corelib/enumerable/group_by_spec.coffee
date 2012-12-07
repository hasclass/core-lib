describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#group_by", ->
    it "returns a hash with values grouped according to the block", ->
      en = EnumerableSpecs.Numerous.new('foo', 'bar', 'baz')
      expect( en.group_by (word) -> word.chr() ).toEqual {
        "f": R.$Array_r(["foo"]),
        'b': R.$Array_r(["bar", "baz"])
      }

    it "returns an empty hash for empty enumerables", ->
      expect( new EnumerableSpecs.Empty().group_by (x) -> x ).toEqual {}

    it "returns an Enumerator if called without a block", ->
      expect( EnumerableSpecs.Numerous.new().group_by() ).toBeInstanceOf R.Enumerator

    it "gathers whole arrays as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMulti()
      hsh = {}
      hsh[ [1, 2] ]       = R([[1, 2]])
      hsh[ [6, 7, 8, 9] ] = R([[6, 7, 8, 9]])
      hsh[ [3, 4, 5] ]    = R([[3, 4, 5]])
      expect( multi.group_by (e...) -> e).toEqual hsh
