describe "String#downcase", ->
  it "returns a copy of self with all uppercase letters downcased", ->
    expect( R("hELLO").downcase() ).toEqual R("hello")
    expect( R("hello").downcase() ).toEqual R("hello")

  it "is locale insensitive (only replaces A-Z)", ->
    expect( R("ÄÖÜ"  ).downcase() ).toEqual R("ÄÖÜ")

  xit "TODO", ->
    # str = Array.new(256) { |c| c.chr }.join
    # expected = Array.new(256) do |i|
    #   c = i.chr
    #   c.between?("A", "Z") ? c.downcase : c
    # end.join

    # str.downcase.should == expected

  xit "taints result when self is tainted", ->
    # "".taint.downcase.tainted?.should == true
    # "x".taint.downcase.tainted?.should == true
    # "X".taint.downcase.tainted?.should == true

  xit "returns a subclass instance for subclasses", ->
    # StringSpecs::MyString.new("FOObar").downcase.should be_kind_of(StringSpecs::MyString)

describe "String#downcase!", ->
  it "modifies self in place", ->
    a = R "HeLlO"
    expect( a.downcase_bang() == a).toEqual true
    expect( a ).toEqual R("hello")

  it "returns nil if no modifications were made", ->
    a = R "hello"
    expect( a.downcase_bang() ).toEqual null
    expect( a ).toEqual R("hello")

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError when self is frozen", ->
  #     lambda { "HeLlo".freeze.downcase! }.should raise_error(TypeError)
  #     lambda { "hello".freeze.downcase! }.should raise_error(TypeError)

  describe 'ruby_version_is "1.9"', ->
    xit "raises a RuntimeError when self is frozen", ->
      # lambda { "HeLlo".freeze.downcase! }.should raise_error(RuntimeError)
      # lambda { "hello".freeze.downcase! }.should raise_error(RuntimeError)
