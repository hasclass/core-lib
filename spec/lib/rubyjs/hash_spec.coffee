describe "Hash#eql", ->
  it "compares primitives", ->
    expect( R.h(foo: 1).eql(R.h({foo: 1})) ).toEqual true
    expect( R.h(foo: 1).eql(R.h({foo: 2})) ).toEqual false

  it "compares RubyJS objects", ->
    expect( R.h(foo: R(1)).eql(R.h({foo: 1    })) ).toEqual true
    expect( R.h(foo: R(1)).eql(R.h({foo: R(1) })) ).toEqual true
    expect( R.h(foo:   1 ).eql(R.h({foo: R(1) })) ).toEqual true
    expect( R.h(foo: R(1)).eql(R.h({foo: 2    })) ).toEqual false
    expect( R.h(foo:   1 ).eql(R.h({foo: R(2) })) ).toEqual false
    expect( R.h(foo: R(1)).eql(R.h({foo: R(2) })) ).toEqual false

  it "compares RubyJS objects with eql?", ->
    expect( R.h(foo: R(1)).eql(R.h({foo: R.f(1) })) ).toEqual false

describe "Hash#key", ->
  it "should work with RubyJS objects", ->
    hsh = R.h(foo: 1)
    expect( hsh.key(1)      ).toEqual 'foo'
    expect( hsh.key(R(1))   ).toEqual 'foo'
    expect( hsh.key(R.f(1)) ).toEqual 'foo'

    hsh = R.h(foo: R(1))
    # expect( hsh.key(1)      ).toEqual 'foo'
    expect( hsh.key(R(1))   ).toEqual 'foo'
    expect( hsh.key(R.f(1)) ).toEqual 'foo'

