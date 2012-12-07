describe "Kernel#box", ->
  it "converts recursively with second argument true", ->
    expect( R([1], true) ).toEqual R([R(1)])

  it "does not convert recursively with second argument not true", ->
    expect( R([1], 1) ).toEqual R([1])
    expect( R([1], false) ).toEqual R([1])
    expect( R([1], null) ).toEqual R([1])
    expect( R([1], undefined) ).toEqual R([1])

  it "supports an inline function", ->
    expect( R('foo', -> R("bar")) ).toEqual 'bar'
    expect( R('foo', false, -> R("bar")) ).toEqual 'bar'

  it "inline function converts to native", ->
    expect( R('foo', false, -> R("bar")) ).toEqual 'bar'

  it "inline function recursively converts to native", ->
    expect( R('foo', false, -> R.w("foo bar")) ).toEqual ['foo', 'bar']

  it "inline function returns object if already", ->
    expect( R('foo', false, -> "bar") ).toEqual 'bar'

  it "inline function returns nothing or null return null", ->
    expect( R('foo', false, -> )          ).toEqual null
    expect( R('foo', false, -> null)      ).toEqual null
    expect( R('foo', false, -> undefined) ).toEqual null

  it "inline function returns false it should return false", ->
    expect( R('foo', false, -> 0)         ).toEqual 0
    expect( R('foo', false, -> false)     ).toEqual false

  it "RubyJS objects are returned (not cloned)", ->
    obj = R('foo')
    expect( obj is R(obj)).toEqual true

