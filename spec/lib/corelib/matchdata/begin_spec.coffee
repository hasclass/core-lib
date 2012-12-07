describe "MatchData#begin", ->
  xit "returns the offset of the start of the nth element", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").begin(0) ).toEqual R(1)
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").begin(2) ).toEqual R(2)
