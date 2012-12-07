describe 'ruby_version_is "1.9"', ->
  describe "Regexp.try_convert", ->
    it "returns the argument if given a Regexp", ->
      expect( R.Regexp.try_convert(/foo/i) ).toEqual R(/foo/i)

    it "returns nil if given an argument that can't be converted to a Regexp", ->
      expect( R.Regexp.try_convert('') ).toEqual null
      expect( R.Regexp.try_convert('glark') ).toEqual null
      expect( R.Regexp.try_convert([]) ).toEqual null
      expect( R.Regexp.try_convert({}) ).toEqual null
      expect( R.Regexp.try_convert(null) ).toEqual null

    it "tries to coerce the argument by calling #to_regexp", ->
      rex =
        to_regexp: -> R(/(p(a)t[e]rn)/)
      expect( R.Regexp.try_convert(rex) ).toEqual R(/(p(a)t[e]rn)/)

    # TODO: test for R.Regexp.try_convert() throws error