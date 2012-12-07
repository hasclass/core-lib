describe "MatchData#inspect", ->

  it "returns a String", ->
    match_data = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
    expect( match_data.inspect() ).toBeInstanceOf(R.String)

  describe "ruby_version_is '1.8.7'", ->
    it "returns a human readable representation that contains entire matched string and the captures", ->
      # yeah, hardcoding the inspect output is not ideal, but in this case
      # it makes perfect sense. See JRUBY-4558 for example.
      match_data = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
      expect( match_data.inspect() ).toEqual R('#<MatchData "HX1138" 1:"H" 2:"X" 3:"113" 4:"8">')

      match_data = R(/foo/).match("foo")
      expect( match_data.inspect() ).toEqual R('#<MatchData "foo">')

  it "docs", ->
    expect( R(/.$/).match("foo").inspect() ).toEqual R('#<MatchData "o">')
    expect( R(/(.)(.)(.)/).match("foo").inspect() ).toEqual R('#<MatchData "foo" 1:"f" 2:"o" 3:"o">')
    # TODO
    # expect( R(/(.)(.)?(.)/).match("fo").inspect() ).toEqual R('#<MatchData "fo" 1:"f" 2:nil 3:"o">')