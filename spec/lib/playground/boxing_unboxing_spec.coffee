describe "Kernel#box", ->

  it "does not box a R object again", ->
    str = R("hello")
    expect( R(str) == str).toEqual true

  xit "does not box an object with a box method", ->
    obj = new String()
    obj.box = () ->
    expect( R(obj) == obj ).toEqual true

  it "returns the object itself if it cannot be boxed", ->
    obj = new Object()
    expect( R(obj) == obj).toEqual true

  it "should box strings", ->
    expect( R("") ).toBeInstanceOf RubyJS.String
    expect( R("hello") ).toBeInstanceOf RubyJS.String
    expect( R(new String("hello")) ).toBeInstanceOf RubyJS.String

  it "should box arrays", ->
    expect( R([1,2]) ).toBeInstanceOf RubyJS.Array
    expect( R(new Array()) ).toBeInstanceOf RubyJS.Array

  it "should box arrays, but leave elements unboxed", ->
    expect( R(["hello"]).first() ).toEqual "hello"

  it "should box Fixnums", ->
    expect( R(1) ).toBeInstanceOf RubyJS.Fixnum
    expect( R(new Number(1)) ).toBeInstanceOf RubyJS.Fixnum
    expect( R(0) ).toBeInstanceOf RubyJS.Fixnum
    expect( R(-10) ).toBeInstanceOf RubyJS.Fixnum

  it "should box Floats", ->
    expect( R(1.01) ).toBeInstanceOf RubyJS.Float
    expect( R(new Number(1.01)) ).toBeInstanceOf RubyJS.Float

  it "boxes (unfortunately) numbers ending with .0 to Fixnum", ->
    expect( R(1.0) ).toBeInstanceOf RubyJS.Fixnum
    expect( R(new Number(1.0)) ).toBeInstanceOf RubyJS.Fixnum
