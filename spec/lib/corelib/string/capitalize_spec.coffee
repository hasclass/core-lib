class MyString extends String
  my_string_method: ->

describe "String#capitalize", ->

  it "returns a copy of self with the first character converted to uppercase and the remainder to lowercase", ->
    expect(R("").capitalize().unbox()      ).toEqual ""
    expect(R("h").capitalize().unbox()     ).toEqual "H"
    expect(R("H").capitalize().unbox()     ).toEqual "H"
    expect(R("hello").capitalize().unbox() ).toEqual "Hello"
    expect(R("HELLO").capitalize().unbox() ).toEqual "Hello"
    expect(R("123ABC").capitalize().unbox()).toEqual "123abc"

  it "is locale insensitive (only upcases a-z and only downcases A-Z)", ->
    expect(R("ÄÖÜ").capitalize().unbox()  ).toEqual "ÄÖÜ"
    expect(R("ärger").capitalize().unbox()).toEqual "ärger"
    expect(R("BÄR").capitalize().unbox()  ).toEqual "BÄr"

  #it "taints resulting string when self is tainted", ->
  #  expect("".taint.capitalize().tainted?).toEqual true
  #  expect("hello".taint.capitalize().tainted?).toEqual true

#  it "returns subclass instances when called on a subclass", ->
#    expect(new MyString("hello").capitalize().my_string_method).toBeDefined()
#    expect(new MyString("Hello").capitalize().my_string_method).toBeDefined()

describe "String#capitalize_bang", ->
  it "returns null if already capitalized", ->
    expect(R("Hello world").capitalize_bang()).toEqual null

