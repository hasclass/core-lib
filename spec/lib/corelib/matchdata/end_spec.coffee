describe "MatchData#end", ->
  it "returns the offset of the end of the nth element", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").end(0) ).toEqual R(7)
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").end(2) ).toEqual R(3)
