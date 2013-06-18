describe 'RubyJS', ->
  root = global ? window

  it "auto pollutes global", ->
    for method in ['_proc', '_puts', '_truthy', '_falsey', '_inspect']
      expect( root[method]? ).toEqual true

  it "R()", ->
    expect( R( new String("foo") ) ).toEqual(R("foo"))

  xit "R.i_am_feeling_evil", ->
    R.i_am_feeling_evil()
    expect( ['foo', 'bar'].map((el) -> el.reverse()) ).toEqual ['oof', 'rab']

    expect( typeof 5.0.times(->) == 'number').toEqual true


  it "R.proc", ->
    expect( _a.map(['foo'], R.proc('length')) ).toEqual [3]
    expect( _a.map([R('foo')], R.proc('size')) ).toEqual [R(3)]

    expect( _a.map([R('foo')], R.proc('multiply', 2)) ).toEqual [R('foofoo')]


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


  it "compares arrays", ->
    expect( R.is_equal([1], [1]) ).toEqual true
    expect( R.is_equal([2], [1]) ).toEqual false
    expect( R.is_equal([[1]], [[1]]) ).toEqual true
    expect( R.is_equal([[1]], [[2]]) ).toEqual false


describe "R.Support.extract_block", ->
  beforeEach ->
    @fn   = ->
    @args = (args...) -> return args

  it "returns the block/function if it finds one", ->
    expect( R.Support.extract_block(@args(@fn)) ).toEqual @fn
    expect( R.Support.extract_block(@args 1,2, @fn) ).toEqual @fn

  it "returns the last block/function", ->
    fn1 = ->
    expect( R.Support.extract_block(@args(fn1, @fn)) ).toEqual @fn

  it "returns null if it does not find a block", ->
    expect( R.Support.extract_block(@args null) ).toEqual null
    expect( R.Support.extract_block(@args 1,2) ).toEqual null

  it "removes function if it finds one", ->
    args = @args( @fn )
    expect( args.length ).toEqual 1
    R.Support.extract_block(args)
    expect( args.length ).toEqual 0

