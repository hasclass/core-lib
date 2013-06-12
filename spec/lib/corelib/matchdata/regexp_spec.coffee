describe 'ruby_version_is "1.8.8"', ->
  describe "MatchData#regexp from String#match", ->
    xit "returns a Regexp object", ->
      m = R('haystack').match(/hay/)
      expect( m.regexp() ).toBeInstanceOf(R.Regexp)

    xit "returns the pattern used in the match", ->
      m = R('haystack').match(/hay/)
      expect( m.regexp().equals(/hay/) ).toEqual true

  describe "MatchData#regexp", ->
    it "returns a Regexp object", ->
      m = R(/hay/).match('haystack')
      expect( m.regexp() ).toBeInstanceOf(R.Regexp)

    it "returns the pattern used in the match", ->
      m = R(/hay/).match('haystack')
      expect( m.regexp().equals(/hay/) ).toEqual true

