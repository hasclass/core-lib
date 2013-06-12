describe "String#<=> with String", ->
  xit "compares individual characters based on their ascii value", ->
    # TODO
    # ascii_order = Array.new(256) { |x| x.chr }
    # sort_order = ascii_order.sort
    # sort_order.should == ascii_order

  it "returns -1 when self is less than other", ->
    expect( R("this").cmp "those").toEqual -1

  it "returns 0 when self is equal to other", ->
    expect( R("yep").cmp "yep").toEqual 0

  it "returns 1 when self is greater than other", ->
    expect( R("yoddle").cmp "griddle").toEqual 1

  it "considers string that comes lexicographically first to be less if strings have same size", ->
    expect( R("aba").cmp "abc").toEqual -1
    expect( R("abc").cmp "aba").toEqual 1

  it "doesn't consider shorter string to be less if longer string starts with shorter one", ->
    expect( R("abc").cmp "abcd").toEqual -1
    expect( R("abcd").cmp "abc").toEqual 1

  it "compares shorter string with corresponding number of first chars of longer string", ->
    expect( R("abx").cmp "abcd").toEqual 1
    expect( R("abcd").cmp "abx").toEqual -1

  xit "ignores subclass differences", ->
    # a = "hello"
    # b = StringSpecs::MyString.new("hello")

    # (a <=> b).should == 0
    # (b <=> a).should == 0

# Note: This is inconsistent with Array#<=> which calls #to_ary instead of
# just using it as an indicator.
describe "String#<=>", ->
  it "returns nil if its argument does not provide #to_str", ->
    expect( R("abc").cmp 1).toEqual null
    expect( R("abc").cmp( new Object())).toEqual null
    # ("abc" <=> :abc).should == nil
    # ("abc" <=> mock('x')).should == nil

  it "returns nil if its argument does not provide #<=>", ->
    # CHECK this has no effect because obj has no to_str either
    obj =
      to_str: -> {}
    expect(R("abc").cmp obj).toEqual null

  it "calls #to_str to convert the argument to a String and calls #<=> to compare with self", ->
    obj =
      to_str: -> throw 'do not call this'
      cmp: -> 1
    # String#<=> merely checks if #to_str is defined on the object. It
    # does not call the method.

    # obj.stub!(:to_str)

    spy = spyOn(obj, 'cmp').andReturn(1)
    expect( R("abc").cmp(obj) ).toEqual -1
    expect( spy ).wasCalled()
