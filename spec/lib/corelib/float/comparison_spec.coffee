describe "Float#<=>", ->
  it "returns -1, 0, 1 when self is less than, equal, or greater than other", ->
    expect( R(1.5).cmp 5).toEqual -1
    expect( R(2.45).cmp 2.45).toEqual 0

  xit 'bignum unsupported', ->
    # ((bignum_value*1.1) <=> bignum_value).toEqual 1

  it "returns nil when either argument is NaN", ->
    nan_value = R.$Float(R.Float.NAN)
    expect( nan_value.cmp 71.2).toEqual null
    expect( R(1771.176).cmp nan_value).toEqual null

  it "returns nil when the given argument is not a Float", ->
    expect( R.$Float(1.0).cmp "1").toEqual null

  # # TODO: Remove duplicate ruby_bug guards when ruby_bug is fixed.
  xdescribe 'ruby_bug "[ruby-dev:38672] [Bug #1645]", "1.8.7"', ->
  #   # The 4 tests below are taken from matz's revision 23730 for Ruby trunk
  #   #
  #   it "returns 1 when self is Infinity and other is a Bignum", ->
  #     (infinity_value <=> Float::MAX.to_i*2).toEqual 1

    # it "returns -1 when self is negative and other is Infinty", ->
    #   (-Float::MAX.to_i*2 <=> infinity_value).toEqual -1

  #   it "returns -1 when self is -Infinity and other is negative", ->
  #     (-infinity_value <=> -Float::MAX.to_i*2).toEqual -1

  #   it "returns 1 when self is negative and other is -Infinity", ->
  #     (-Float::MAX.to_i*2 <=> -infinity_value).toEqual 1

  # ruby_bug "[ruby-dev:38672] [Bug #1645]", "1.8.7.302", ->
  #   # The 4 tests below are taken from matz's revision 23730 for Ruby trunk
  #   #
  #   it "returns 1 when self is Infinity and other is a Bignum", ->
  #     (infinity_value <=> Float::MAX.to_i*2).toEqual 1

  #   it "returns -1 when self is negative and other is Infinty", ->
  #     (-Float::MAX.to_i*2 <=> infinity_value).toEqual -1

  #   it "returns -1 when self is -Infinity and other is negative", ->
  #     (-infinity_value <=> -Float::MAX.to_i*2).toEqual -1

  #   it "returns 1 when self is negative and other is -Infinity", ->
  #     (-Float::MAX.to_i*2 <=> -infinity_value).toEqual 1
