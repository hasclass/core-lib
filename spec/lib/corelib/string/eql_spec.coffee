describe "String#eql?", ->
  # it_behaves_like(:string_equal_value, :eql?)
  it "returns true if self <=> string returns 0", ->
    expect( R('hello').eql('hello')  ).toEqual true
    # RubyJS specific
    expect( R('hello').eql(R('hello'))  ).toEqual true

  it "returns false if self <=> string does not return 0", ->
    expect( R("more").eql("MORE")    ).toEqual false
    expect( R("less").eql("greater") ).toEqual false
    # RubyJS specific:
    # expect( R("more").eql(R("MORE"))    ).toEqual false
    # expect( R("less").eql(R("greater")) ).toEqual false

  it "ignores subclass differences", ->
    a = R("hello")
    b = new StringSpecs.MyString("hello")

    expect( R(a).eql(b) ).toEqual true
    expect( R(b).eql(a) ).toEqual true

describe "String#eql? when given a non-String", ->
  it "returns false", ->
    expect( R('hello').eql(5)         ).toEqual false
    # expect( R('hello') ).eql(:hello)    ).toEqual false
    expect( R('hello').eql({})        ).toEqual false

  it "does not try to call #to_str on the given argument", ->
    obj =
      to_str: -> throw "should not be called"
    expect( R('hello').eql(obj) ).toEqual false

