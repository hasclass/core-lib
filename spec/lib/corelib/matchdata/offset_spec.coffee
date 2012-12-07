describe "MatchData#offset", ->
  it "returns a two element array with the begin and end of the nth match", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").offset(0) ).toEqual R([1, 7])
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").offset(4) ).toEqual R([6, 7])
