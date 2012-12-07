class FooString extends RubyJS.String
  constructor: (@data) ->
    super(@data)
  valueOf:  ->  @data
  toString: -> @data


describe "RubyJS", ->
  it "R exists", ->
    expect(R).toBeDefined

  it "R exists", ->
    expect(R("hello")).toBeDefined

  it "R('hello') returns RubyJS.String", ->
    expect(R('hello')).toBeInstanceOf(RubyJS.String)
    expect(R('hello').capitalize().unbox()).toEqual "Hello"

  #it "__r exists", ->
  # expect(R("hello").capitalize()).toEqual "Hello"

  it "RubyJS.String has methods", ->
    _r_string = new RubyJS.String("hello")
    #expect(new FooString("hello")).toEqual "hello"
    #expect(_r_string).toEqual "hello"
    expect(_r_string.capitalize().unbox()).toEqual "Hello"
    expect(_r_string.capitalize).toBeDefined

  it "bla", ->
    expect(new String('foo')).toEqual 'foo'
    expect(new String('foo')+"").toEqual 'foo'
    expect(new FooString('foo')+"bar").toEqual 'foobar'
    expect(new FooString('foo').length).toEqual 3

describe "RubyJS.Integer", ->
  it "should convert", ->
    expect(R(1)).toBeInstanceOf(RubyJS.Integer)
    expect(R(1).unbox()).toEqual(1)
    expect(R(1.01)).toBeInstanceOf(RubyJS.Float)

    expect(R(5)['/'](3).unbox()).toEqual(1)
    expect(R(5)['%'](3).unbox()).toEqual(2)
    expect(R(5)['*'](3).unbox()).toEqual(15)
describe "Enumerable", ->
  it "should run", ->
