describe "Fixnum#div with a Fixnum", ->
  it "returns self divided by the given argument as an Integer", ->
    expect( R(2).div(2)       ).toEqual R(1)
    expect( R(1).div(2)       ).toEqual R(0)
    expect( R(5).div(2)       ).toEqual R(2)

describe "Fixnum#div", ->
  it "rounds towards -inf", ->
    expect( R(8192).div(10)   ).toEqual R( 819)
    expect( R(8192).div(-10)  ).toEqual R(-820)
    expect( R(-8192).div(10)  ).toEqual R(-820)
    expect( R(-8192).div(-10) ).toEqual R( 819)

  it "coerces self and the given argument to Floats and returns self divided by other as Fixnum", ->
    expect( R(1).div(0.2)     ).toEqual R( 5)
    expect( R(1).div(0.16)    ).toEqual R( 6)
    expect( R(1).div(0.169)   ).toEqual R( 5)
    expect( R(-1).div(50.4)   ).toEqual R(-1)

  xit "bignums", ->
    expect( R(1).div(bignum_value).unbox()   ).toEqual 0

  xdescribe 'ruby_version_is "...1.9"', ->
    it "raises a FloatDomainError when the given argument is 0 and a Float", ->
      # lambda { 0.div(0.0)   }.should raise_error(FloatDomainError)
      # lambda { 10.div(0.0)  }.should raise_error(FloatDomainError)
      # lambda { -10.div(0.0) }.should raise_error(FloatDomainError)


  describe 'ruby_version_is "1.9"', ->
    it "raises a ZeroDivisionError when the given argument is 0 and a Float", ->
      expect(-> R(  0).div(R.$Float(0.0)) ).toThrow "ZeroDivisionError"
      expect(-> R( 10).div(R.$Float(0.0)) ).toThrow "ZeroDivisionError"
      expect(-> R(-10).div(R.$Float(0.0)) ).toThrow "ZeroDivisionError"


  it "raises a ZeroDivisionError when the given argument is 0", ->
    expect(-> R(13).div(R.$Integer(0)) ).toThrow "ZeroDivisionError"

  it "raises a TypeError when given a non-Integer", ->
    expect( -> R(5).div(R("2")) ).toThrow "TypeError"
