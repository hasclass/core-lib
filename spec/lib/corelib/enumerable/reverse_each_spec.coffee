describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#reverse_each", ->
    it "traverses enum in reverse order and pass each element to block", ->
      acc = []
      EnumerableSpecs.NumerousLiteral.new().reverse_each (i) -> acc.push i
      expect( acc ).toEqual [4, 1, 6, 3, 5, 2]

    it "returns an Enumerator if no block given", ->
      en = EnumerableSpecs.NumerousLiteral.new().reverse_each()
      expect( en         ).toBeInstanceOf R.Enumerator
      expect( en.to_a().to_native() ).toEqual [4, 1, 6, 3, 5, 2]

    it "gathers whole arrays as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMulti()
      yielded = []
      multi.reverse_each (e) -> yielded.push e
      expect( yielded ).toEqual [[6, 7, 8, 9], [3, 4, 5], [1, 2]]
