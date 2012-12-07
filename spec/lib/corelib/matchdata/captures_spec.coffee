describe "MatchData#captures", ->
  it "returns an array of the match captures", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").captures() ).toEqual R(["H","X","113","8"])

  it "docs", ->
    expect( R(/foo/).match("foo").captures() ).toEqual R([])
