describe "_n.times", ->
  it "returns array when passed no block", ->
    expect( _n.times(0) ).toEqual []
    expect( _n.times(2) ).toEqual [0,1]

  it "returns array when passed non-block argument for block", ->
    expect( _n.times(2, 1) ).toEqual [0,1]


describe "_n.upto", ->
  it "returns array when passed no block", ->
    expect( _n.upto(0,2) ).toEqual [0,1,2]
    expect( _n.upto(2,2) ).toEqual [2]
    expect( _n.upto(2,1) ).toEqual []

  it "returns array when passed non-block argument for block", ->
    expect( _n.upto(2, 3, 1) ).toEqual [2,3]


describe "_n.downto", ->
  it "returns array when passed no block", ->
    expect( _n.downto(3,2) ).toEqual [3,2]
    expect( _n.downto(3,3) ).toEqual [3]
    expect( _n.downto(3,4) ).toEqual []

  it "returns array when passed non-block argument for block", ->
    expect( _n.downto(3, 2, 1) ).toEqual [3,2]

