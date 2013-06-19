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

describe "_n.abs", ->
  it "returns absolute numeric value of argument", ->
    expect( _n.abs(2)  ).toEqual 2
    expect( _n.abs(-3) ).toEqual 3

describe "_n.abs2", ->
  it "returns square numeric value of argument", ->
    expect( _n.abs2(2)  ).toEqual 4
    expect( _n.abs2(-6) ).toEqual 36

  it "returns NaN if passed argument is not Numeric", ->
    expect( _n.abs2('str')  ).toBeNaN
    expect( _n.abs2([2, 4]) ).toBeNaN

describe "_n.ceil", ->
  it "returns integer greater than or equal to passed argument", ->
    expect( _n.ceil(1)    ).toEqual 1
    expect( _n.ceil(1.55) ).toEqual 2
    expect( _n.ceil(-5.1) ).toEqual -5