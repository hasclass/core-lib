describe "MatchData#length", ->
  # it_behaves_like(:matchdata_length, :length)
  it "length should return the number of elements in the match array", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").length() ).toEqual R(5)
