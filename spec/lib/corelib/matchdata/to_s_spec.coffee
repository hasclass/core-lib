describe "MatchData#to_s", ->
  it "returns the entire matched string", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").to_s() ).toEqual R("HX1138")
