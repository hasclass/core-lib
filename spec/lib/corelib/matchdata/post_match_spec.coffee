describe "MatchData#post_match", ->
  it "returns the string after the match equiv. special var $'", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138: The Movie").post_match() ).toEqual ': The Movie'

    # TODO: add $'
    # expect( R["$'"] ).toEqual ': The Movie'
