describe "Hash#include?", ->
  it "returns true if argument is a key", ->
    h = R.hashify(a: 1, b: 2, c: 3, 4: 0)
    expect( h.include('a') ).toEqual true
    expect( h.include('b') ).toEqual true
    expect( h.include('b') ).toEqual true
    expect( h.include(2)   ).toEqual false
    expect( h.include(4)   ).toEqual true
    # expect( h.include(4.0) ).toEqual false

  it "returns true if the key's matching value was nil", ->
    expect( R.hashify(xyz: null).include('xyz') ).toEqual true

  it "returns true if the key's matching value was false", ->
    expect( R.hashify(xyz: false).include('xyz') ).toEqual true

  it "returns true if the key is nil", ->
    expect( R.hashify(null: 'b'  ).include(null) ).toEqual true
    expect( R.hashify(null: null ).include(null) ).toEqual true

  xit "compares keys with the same #hash value via #eql?", ->
    # x = mock('x')
    # x.stub!(:hash).and_return(42)

    # y = mock('y')
    # y.stub!(:hash).and_return(42)
    # y.should_receive(:eql?).and_return(false)

    # R.hashify(x: nil).include(y).should == false
