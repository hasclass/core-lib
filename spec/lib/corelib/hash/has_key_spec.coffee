describe "Hash#has_key?", ->
  it "returns true if argument is a key", ->
    h = R.hashify(a: 1, b: 2, c: 3, 4: 0)
    expect( h.has_key('a') ).toEqual true
    expect( h.has_key('b') ).toEqual true
    expect( h.has_key('b') ).toEqual true
    expect( h.has_key(2)   ).toEqual false
    expect( h.has_key(4)   ).toEqual true
    # expect( h.has_key(4.0) ).toEqual false

  it "returns true if the key's matching value was nil", ->
    expect( R.hashify(xyz: null).has_key('xyz') ).toEqual true

  it "returns true if the key's matching value was false", ->
    expect( R.hashify(xyz: false).has_key('xyz') ).toEqual true

  it "returns true if the key is nil", ->
    expect( R.hashify(null: 'b'  ).has_key(null) ).toEqual true
    expect( R.hashify(null: null ).has_key(null) ).toEqual true

  xit "compares keys with the same #hash value via #eql?", ->
    # x = mock('x')
    # x.stub!(:hash).and_return(42)

    # y = mock('y')
    # y.stub!(:hash).and_return(42)
    # y.should_receive(:eql?).and_return(false)

    # R.hashify(x: nil).has_key(y).should == false
