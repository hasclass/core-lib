#describe "Fixnum#==", ->
#  it_behaves_like :fixnum_equal, :==
#end

describe "Fixnum#==", ->
  it "returns true if self has the same value as other", ->
    expect( R(1).equals(1)).toEqual true
    expect( R(9).equals(5)).toEqual false

    # Actually, these call Float#==, Bignum#== etc.
    expect( R(9).equals(R.$Float(9.0))  ).toEqual true
    expect( R(9).equals(R.$Float(9.01)) ).toEqual false

    #expect(R(10).equals bignum_value)).toEqual false


  it "calls 'other == self' if the given argument is not a Fixnum", ->
    obj =
      equals: (other) -> false
    expect( R(1).equals(obj) ).toEqual false

    obj.equals = -> true
    expect( R(2).equals(obj)).toEqual true
