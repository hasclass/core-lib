describe "String#==", ->
  it "returns true if self <=> string returns 0", ->
    expect(R('hello').equals('hello')).toBeTrue

  it "returns false if self <=> string does not return 0", ->
    expect(R("more").equals("MORE")).toEqual false
    expect(R("less").equals("greater")).toEqual false

  xit "ignores subclass differences", ->
    a = "hello"
    b = new StringSpecs.MyString("hello")

    expect(R(a).equals(b)).toEqual true
    expect(R(b).equals(a)).toEqual true

describe "String#==", ->
  it "returns false if obj does not respond to to_str", ->
    expect(R('hello').equals(5)).toEqual false
    expect(R('hello').equals([])).toEqual false

  it "returns obj == self if obj responds to to_str", ->
    obj =
      to_str: -> 'hello'
      equals: -> true
    # String#== merely checks if #to_str is defined. It does
    # not call it.
    expect(R('hello').equals(obj)).toEqual  true

  xit "is not fooled by NUL characters", ->
    expect(R("abc\0def").equals( "abc\0xyz")).toEqual true
