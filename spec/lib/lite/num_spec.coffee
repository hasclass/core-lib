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

describe "_n.divmod", ->
  it "returns array with two numbers when passed two numbers as arguments", ->
    expect( _n.divmod(8,4)      ).toEqual [2, 0]
    expect( _n.divmod(13, 4)    ).toEqual [3, 1]
    expect( _n.divmod(-8.5, -4) ).toEqual [2, -0.5]

describe "_n.eql", ->
  it "returns true when passed arguments are the same type (or can be converted)
        and have equal values", ->
    expect( _n.eql(1.0, 1)  ).toBeTrue
    expect( _n.eql(2, 2)    ).toBeTrue

  it "returns false when passed arguments cannot be converted to the same type
        or their values are not equal", ->
    expect( _n.eql(8,4)     ).toBeFalse
    expect( _n.eql(1, 'a')  ).toBeFalse
