# ruby_version_is "1.9", ->
#   describe "Numeric#rect", ->
#     it_behaves_like(:numeric_rect, :rect)

describe "Numeric#rect", ->
  beforeEach ->
    @numbers = R.$Array_r [
      20,             # Integer
      398.72,         # Float
      # Rational(3, 4), # Rational
      # 99999999**99, # Bignum
      # infinity_value,
      # nan_value
    ]

  it "returns an Array", ->
    @numbers.each (number) ->
      expect( number.rect().is_array? ).toEqual true

  it "returns a two-element Array", ->
    @numbers.each (number) ->
      expect( number.rect().size() ).toEqual R(2)

  it "returns self as the first element", ->
   @numbers.each (number) ->
     # expect( if number.to_f.nan?
       # number.rect().first.nan?.should be_true
     # else
     expect( number.rect().first() ).toEqual number

  it "returns 0 as the last element", ->
   @numbers.each (number) ->
     expect( number.rect().unbox()[1] ).toEqual R(0)

  it "raises an ArgumentError if given any arguments", ->
   @numbers.each (number) ->
     expect( -> number.rect(number) ).toThrow('ArgumentError')
