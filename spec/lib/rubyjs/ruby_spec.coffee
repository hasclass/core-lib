describe 'RubyJS', ->
  root = global ? window

  it "auto pollutes global", ->
    for method in ['_str', '_arr', '_itr', '_num', '_proc', '_puts', '_truthy', '_falsey', '_inspect']
      expect( root[method]? ).toEqual true

  it "R()", ->
    expect( R( new String("foo") ) ).toEqual(R("foo"))

  xit "R.i_am_feeling_evil", ->
    R.i_am_feeling_evil()
    expect( ['foo', 'bar'].map((el) -> el.reverse()) ).toEqual ['oof', 'rab']

    expect( typeof 5.0.times(->) == 'number').toEqual true


  it "R.proc", ->
    expect( _arr.map(['foo'], R.proc('length')) ).toEqual [3]
    expect( _arr.map([R('foo')], R.proc('size')) ).toEqual [R(3)]

    expect( _arr.map([R('foo')], R.proc('multiply', 2)) ).toEqual [R('foofoo')]


describe "R.is_equal", ->

  it "compares native, native", ->
    expect( R.is_equal(1, 1) ).toEqual true
    expect( R.is_equal(1, 2) ).toEqual false
    expect( R.is_equal("foo", "foo") ).toEqual true
    expect( R.is_equal("foo", "bar") ).toEqual false

  it "is false for native, JS Object", ->
    expect( R.is_equal(1, new Number(1)) ).toEqual true
    expect( R.is_equal(1, new Number(2)) ).toEqual false
    expect( R.is_equal("foo", new String("foo")) ).toEqual true
    expect( R.is_equal("foo", new String("bar")) ).toEqual false

  it "compares with valueOf if present", ->
    obj = {valueOf: (n) -> 1}
    expect( R.is_equal(1, obj) ).toEqual true
    expect( R.is_equal(2, obj) ).toEqual false


  it "compares with equals if present", ->
    obj = {equals: (n) -> n is 1}
    expect( R.is_equal(1, obj) ).toEqual true
    expect( R.is_equal(2, obj) ).toEqual false
    expect( R.is_equal(obj, 1) ).toEqual true
    expect( R.is_equal(obj, 2) ).toEqual false