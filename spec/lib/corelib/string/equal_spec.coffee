describe "String#==", ->
  # it_behaves_like(:string_equal_value, :eql?)
  it "returns true if self <=> string returns 0", ->
    expect( R('hello').equals('hello')  ).toEqual true
    # RubyJS specific
    expect( R('hello').equals(R('hello'))  ).toEqual true

  it "returns false if self <=> string does not return 0", ->
    expect( R("more").equals("MORE")    ).toEqual false
    expect( R("less").equals("greater") ).toEqual false
    # RubyJS specific:
    # expect( R("more").equals(R("MORE"))    ).toEqual false
    # expect( R("less").equals(R("greater")) ).toEqual false

  it "ignores subclass differences", ->
    a = R("hello")
    b = new StringSpecs.MyString("hello")

    expect( R(a).equals(b) ).toEqual true
    expect( R(b).equals(a) ).toEqual true

describe "String#==", ->
  it "returns false if obj does not respond to to_str", ->
    expect( R('hello').eql(5)         ).toEqual false
    # expect( R('hello') ).eql(:hello)    ).toEqual false
    expect( R('hello').eql({})        ).toEqual false

  it "returns obj == self if obj responds to to_str", ->
    obj =
      to_str: -> throw 'should not be called'
      equals: -> true

    # String#== merely checks if #to_str is defined. It does
    # not call it.
    expect( R('hello').equals(obj) ).toEqual true

  it "is not fooled by NUL characters", ->
    expect( R("abc\0def").equals("abc\0xyz") ).toEqual false
