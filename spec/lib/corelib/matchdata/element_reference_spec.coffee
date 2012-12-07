describe "MatchData#[]", ->
  it "acts as normal array indexing [index]", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").get(0) ).toEqual 'HX1138'
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").get(1) ).toEqual 'H'
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").get(2) ).toEqual 'X'

  it "supports accessors [start, length]", ->
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").get(1, 2) ).toEqual R(['H', 'X'])
    expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").get(-3, 2) ).toEqual R(['X', '113'])

  xit "supports ranges [start..end]", ->
    # expect( R(/(.)(.)(\d+)(\d)/).match("THX1138.").get(1..3) ).toEqual R(['H', 'X', '113'])

# language_version __FILE__, "element_reference"
