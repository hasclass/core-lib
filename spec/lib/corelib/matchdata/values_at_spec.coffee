describe "MatchData#values_at", ->
  it "returns an array of the matching value", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138: The Movie").values_at(0, 2, -2) ).toEqual R(["HX1138", "X", "113"])
