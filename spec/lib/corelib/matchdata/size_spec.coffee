describe "MatchData#size", ->
  # it_behaves_like(:matchdata_length, :size)
  it "length should return the number of elements in the match array", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").size() ).toEqual R(5)
