describe "Regexp.last_match", ->
  it "returns MatchData instance when not passed arguments", ->
    R(/c(.)t/)['=~']('cat')

    expect( R.Regexp.last_match() ).toBeInstanceOf(R.MatchData)

  it "returns the nth field in this MatchData when passed a Fixnum", ->
    R(/c(.)t/)['=~']('cat')
    expect( R.Regexp.last_match(1) ).toEqual 'a'

  it "returns null if $~ is null when passed a Fixnum", ->
    R['$~'] = null
    expect( R.Regexp.last_match(1) ).toEqual null
