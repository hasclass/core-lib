describe 'ruby_version_is "1.8.8"', ->
  describe "Range#cover", ->

    it "raises an ArgumentError without exactly one argument", ->
      rng = RubyJS.Range.new(1,2)
      expect( -> rng.cover()    ).toThrow "ArgumentError"
      expect( -> rng.cover(1,2) ).toThrow "ArgumentError"

    it "returns true if argument is equal to the first value of the range", ->
      expect( RubyJS.Range.new(0, 5).cover(0)       ).toEqual true
      expect( RubyJS.Range.new('f', 's').cover('f') ).toEqual true

    it "returns true if argument is equal to the last value of the range", ->
      expect( RubyJS.Range.new(0, 5).cover(5)       ).toEqual true
      expect( RubyJS.Range.new(0, 5, true).cover(4)       ).toEqual true
      expect( RubyJS.Range.new('f', 's').cover('s') ).toEqual true

    it "returns true if argument is less than the last value of the range and greater than the first value", ->
      expect( RubyJS.Range.new(20, 30).cover(28)    ).toEqual true
      expect( RubyJS.Range.new('e', 'h').cover('g') ).toEqual true
      #RubyJS.Range.new("\u{999}", "\u{9999}").cover "\u{9995}"

    it "returns true if argument is sole element in the range", ->
      expect( RubyJS.Range.new(30, 30).cover(30)    ).toEqual true

    it "returns false if range is empty", ->
      expect( RubyJS.Range.new(30, 30, true).cover(30)    ).toEqual false
      expect( RubyJS.Range.new(30, 30, true).cover(null)  ).toEqual false

    it "returns false if the range does not contain the argument", ->
      expect( RubyJS.Range.new('A', 'C').cover(20.9)).toEqual false
      expect( RubyJS.Range.new('A', 'C', true).cover('C') ).toEqual false

    it "uses the range element's <=> to make the comparison", ->
      a = R('a')
      a['<=>'] = -> -1
      expect( RubyJS.Range.new(a, 'z').cover('b')   ).toEqual true

    it "uses a continuous inclusion test", ->
      expect( RubyJS.Range.new('a', 'f').cover('aa')   ).toEqual true
      expect( RubyJS.Range.new('a', 'f').cover('babe') ).toEqual true
      expect( RubyJS.Range.new('a', 'f').cover('baby') ).toEqual true
      expect( RubyJS.Range.new('a', 'f').cover('ga')   ).toEqual false
      expect( RubyJS.Range.new(-10, -2).cover(-2.5)    ).toEqual true
