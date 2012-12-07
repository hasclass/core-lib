#describe "Fixnum#==", ->
#  it_behaves_like :fixnum_equal, :==
#end

describe "Fixnum#==", ->
  it "returns true if self has the same value as other", ->
    expect( R(1)['=='](1)).toEqual true
    expect( R(9)['=='](5)).toEqual false

    # Actually, these call Float#==, Bignum#== etc.
    expect( R(9)['=='](R.$Float(9.0))  ).toEqual true
    expect( R(9)['=='](R.$Float(9.01)) ).toEqual false

    #expect(R(10)['=='] bignum_value)).toEqual false


  it "calls 'other == self' if the given argument is not a Fixnum", ->
    obj =
      '==': (other) -> false
    expect( R(1)['=='](obj) ).toEqual false

    obj['=='] = -> true
    expect( R(2)['=='](obj)).toEqual true
