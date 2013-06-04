describe "Fixnum#fdiv", ->
  it "performs floating-point division between self and a Fixnum", ->
    expect( R(8).fdiv(7).valueOf() ).toEqual(1.1428571428571428)

  xit "performs floating-point division between self and a Bignum", ->
    expect( R(8).fdiv(bignum_value) ).toEqual(8.673617379884035e-19)

  it "performs floating-point division between self and a Float", ->
    expect( R(8).fdiv(9.0).valueOf() ).toEqual(0.8888888888888888)

  xit "returns NaN when the argument is NaN", ->
  #   -1.fdiv(nan_value).nan?.should be_true
  #   1.fdiv(nan_value).nan?.should be_true

  xit "returns Infinity when the argument is 0", ->
  #   1.fdiv(0).infinite?.should == 1

  xit "returns -Infinity when the argument is 0 and self is negative", ->
  #   -1.fdiv(0).infinite?.should == -1

  xit "returns Infinity when the argument is 0.0", ->
  #   1.fdiv(0.0).infinite?.should == 1

  xit "returns -Infinity when the argument is 0.0 and self is negative", ->
  #   -1.fdiv(0.0).infinite?.should == -1

  it "raises a TypeError when argument isn't numeric", ->
    expect( -> R( 1 ).fdiv( new Object() ) ).toThrow("TypeError")

  it "raises an ArgumentError when passed multiple arguments", ->
    expect( -> R( 1 ).fdiv( 6, 1 ) ).toThrow("ArgumentError")

  xit "follows the coercion protocol", ->
    #(obj = mock('10')).should_receive(:coerce).with(1).and_return([1, 10])
    #1.fdiv(obj).should == 0.1
