class MyString extends String
  my_string_method: ->

describe "String#capitalize", ->

  it "returns a copy of self with the first character converted to uppercase and the remainder to lowercase", ->
    expect(R("").capitalize().valueOf()      ).toEqual ""
    expect(R("h").capitalize().valueOf()     ).toEqual "H"
    expect(R("H").capitalize().valueOf()     ).toEqual "H"
    expect(R("hello").capitalize().valueOf() ).toEqual "Hello"
    expect(R("HELLO").capitalize().valueOf() ).toEqual "Hello"
    expect(R("123ABC").capitalize().valueOf()).toEqual "123abc"

  it "is locale insensitive (only upcases a-z and only downcases A-Z)", ->
    expect(R("ÄÖÜ").capitalize().valueOf()  ).toEqual "ÄÖÜ"
    expect(R("ärger").capitalize().valueOf()).toEqual "ärger"
    expect(R("BÄR").capitalize().valueOf()  ).toEqual "BÄr"

  #it "taints resulting string when self is tainted", ->
  #  expect("".taint.capitalize().tainted?).toEqual true
  #  expect("hello".taint.capitalize().tainted?).toEqual true

#  it "returns subclass instances when called on a subclass", ->
#    expect(new MyString("hello").capitalize().my_string_method).toBeDefined()
#    expect(new MyString("Hello").capitalize().my_string_method).toBeDefined()

describe "String#capitalize_bang", ->
  it "returns null if already capitalized", ->
    expect(R("Hello world").capitalize_bang()).toEqual null

