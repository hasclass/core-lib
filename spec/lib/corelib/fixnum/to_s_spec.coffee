describe "Fixnum#to_s when given a base", ->
  it "returns self converted to a String in the given base", ->
    expect( R(12345).to_s(2)  ).toEqual R("11000000111001")
    expect( R(12345).to_s(8)  ).toEqual R("30071")
    expect( R(12345).to_s(10) ).toEqual R("12345")
    expect( R(12345).to_s(16) ).toEqual R("3039")
    expect( R(95).to_s(16)    ).toEqual R("5f")
    expect( R(12345).to_s(36) ).toEqual R("9ix")

  it "raises an ArgumentError if the base is less than 2 or higher than 36", ->
    expect( -> R(123).to_s(-1) ).toThrow "ArgumentError"
    expect( -> R(123).to_s(0)  ).toThrow "ArgumentError"
    expect( -> R(123).to_s(1)  ).toThrow "ArgumentError"
    expect( -> R(123).to_s(37) ).toThrow "ArgumentError"

describe "Fixnum#to_s when no base given", ->
  it "returns self converted to a String using base 10", ->
    expect( R(255).to_s()  ).toEqual R('255')
    expect( R(3).to_s()    ).toEqual R('3')
    expect( R(0).to_s()    ).toEqual R('0')
    expect( R(-9002).to_s()).toEqual R('-9002')
