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

describe "_n.floor", ->
  it "returns the largest integer less than or equal to passed argument", ->
    expect( _n.floor(2)    ).toEqual 2
    expect( _n.floor(-1.5) ).toEqual -2

  it "returns NaN if no argument is passed or passed argument is not a Number", ->
    expect( _n.floor() ).toBeNaN
    expect( _n.floor('test')).toBeNaN

describe "_n.nonzero", ->
  it "returns argument if argument is not 0", ->
    expect( _n.nonzero(2)  ).toEqual 2
    expect( _n.nonzero(-5) ).toEqual -5

  it 'returns null if argument is 0', ->
    expect( _n.nonzero(0) ).toEqual null

describe "_n.zero", ->
  it "returns false if argument is not zero", ->
    expect( _n.zero(2) ).toBeFalse

  it "returns true if argument is zero", ->
    expect( _n.zero(0) ).toBeTrue

describe "_n.even", ->
  it "returns true if argument is even number", ->
    expect( _n.even(4) ).toBeTrue

  it "returns false if argument is not even number", ->
    expect( _n.even(3) ).toBeFalse

describe "_n.gcd", ->
  it "returns greatest common divisor as number", ->
    expect( _n.gcd(4, 2)   ).toEqual 2
    expect( _n.gcd(11, 2)  ).toEqual 1
    expect( _n.gcd(21, 14) ).toEqual 7

describe "_n.next", ->
  it "returns number equal to argument + 1", ->
    expect( _n.next(0)   ).toEqual 1
    expect( _n.next(5)   ).toEqual 6
    expect( _n.next(-3)  ).toEqual -2
    expect( _n.next(2.5) ).toEqual 3.5

describe "_n.pred", ->
  it "returns number equal to argument - 1", ->
    expect( _n.pred(0)    ).toEqual -1
    expect( _n.pred(9)    ).toEqual 8
    expect( _n.pred(-3)   ).toEqual -4
    expect( _n.pred(-5.5) ).toEqual -6.5

describe "_n.round", ->
  it "returns rounded argument when precision is >= 0", ->
    expect( _n.round(3, 2)     ).toEqual 3
    expect( _n.round(3.12, 0)  ).toEqual 3
    expect( _n.round(3.123, 2) ).toEqual 3.12
    expect( _n.round(-3.12, 1) ).toEqual -3.1

  it "returns zero if precision is negative", ->
    expect( _n.round(3.12, -2) ).toEqual 0


describe "_n.numerator", ->
  it "returns positive number", ->
    expect( _n.numerator(2)   ).toEqual 2
    expect( _n.numerator(-22) ).toEqual 22


describe "_n.step", ->
  it "decrements numbers from num to limit", ->
    expect( _n.step(5, 3, -1) ).toEqual [5, 4, 3]

  it "increments numbers from num to limit", ->
    expect( _n.step(3, 5) ).toEqual [3, 4, 5]

  it "returns an array with floating point numbers", ->
    expect( _n.step(3, 5, 0.5) ).toEqual [3, 3.5, 4, 4.5, 5]

