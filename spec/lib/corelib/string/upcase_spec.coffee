describe "String#upcase", ->
  it "returns a copy of self with all lowercase letters upcased", ->
    expect( R("Hello").upcase() ).toEqual R("HELLO")
    expect( R("hello").upcase() ).toEqual R("HELLO")

  it "is locale insensitive (only replaces a-z)", ->
    expect( R("äöü").upcase() ).toEqual R("äöü")

  xit "TODO", ->
    # str = Array.new(256) { |c| c.chr }.join
    # expected = Array.new(256) do |i|
    #   c = i.chr
    #   c.between?("a", "z") ? c.upcase : c
    # end.join

    # str.upcase.should == expected

  xit "taints result when self is tainted", ->
    # "".taint.upcase.tainted?.should == true
    # "X".taint.upcase.tainted?.should == true
    # "x".taint.upcase.tainted?.should == true

  xit "returns a subclass instance for subclasses", ->
    # StringSpecs::MyString.new("fooBAR").upcase.should be_kind_of(StringSpecs::MyString)

describe "String#upcase!", ->
  it "modifies self in place", ->
    a = R "HeLlO"
    expect( a.upcase_bang() is a ).toEqual true
    expect( a ).toEqual R("HELLO")

  it "returns nil if no modifications were made", ->
    a = R "HELLO"
    expect( a.upcase_bang() ).toEqual null
    expect( a ).toEqual R("HELLO")

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError when self is frozen", ->
  #     lambda { "HeLlo".freeze.upcase! }.should raise_error(TypeError)
  #     lambda { "HELLO".freeze.upcase! }.should raise_error(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError when self is frozen", ->
  #     lambda { "HeLlo".freeze.upcase! }.should raise_error(RuntimeError)
  #     lambda { "HELLO".freeze.upcase! }.should raise_error(RuntimeError)