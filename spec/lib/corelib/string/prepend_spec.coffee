describe "String#prepend", ->
  it "prepends the given argument to self and returns self", ->
    str = R("world")
    expect( str.prepend("hello ") == str).toEqual true
    expect( str ).toEqual R("hello world")

  it "converts the given argument to a String using to_str", ->
    obj =
      to_str: -> R("hello")
    a = R(" world!").prepend(obj)
    expect(a).toEqual R("hello world!")

  it "raises a TypeError if the given argument can't be converted to a String", ->
    expect( -> R("hello ").prepend [] ).toThrow('TypeError')
    # expect( -> R('hello ').prepend mock('x') }.should raise_error(TypeError)

  xit "raises a RuntimeError when self if frozen", ->
    # a = "hello"
    # a.freeze

    # lambda { a.prepend "" }.should raise_error(RuntimeError)
    # lambda { a.prepend "test" }.should raise_error(RuntimeError)

  xit "works when given a subclass instance", ->
    # a = " world"
    # a.prepend StringSpecs::MyString.new("hello")
    # a.should == "hello world"

  xit "taints self if other is tainted", ->
    # x = "x"
    # x.prepend("".taint).tainted?.should be_true

    # x = "x"
    # x.prepend("y".taint).tainted?.should be_true
