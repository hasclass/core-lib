describe "MatchData#pre_match", ->
  it "returns the string before the match, equiv. special var $`", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138: The Movie").pre_match() ).toEqual 'T'
    # TODO: add $`
    # expect( R['$`'] ).toEqual 'T'
