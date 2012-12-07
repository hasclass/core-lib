describe "String#swapcase", ->
  it "returns a new string with all uppercase chars from self converted to lowercase and vice versa", ->
   expect( R("Hello").swapcase() ).toEqual R("hELLO")
   expect( R("cYbEr_PuNk11").swapcase() ).toEqual R("CyBeR_pUnK11")
   expect( R("+++---111222???").swapcase() ).toEqual R("+++---111222???")


  it "is locale insensitive (only upcases a-z and only downcases A-Z)", ->
    expect( R("ÄÖÜ").swapcase() ).toEqual R("ÄÖÜ")
    expect( R("ärger").swapcase() ).toEqual R("äRGER")
    expect( R("BÄR").swapcase() ).toEqual R("bÄr")

  xit "taints resulting string when self is tainted", ->
    # "".taint.swapcase.tainted?.should == true
    # "hello".taint.swapcase.tainted?.should == true

  xit "returns subclass instances when called on a subclass", ->
    # StringSpecs::MyString.new("").swapcase.should be_kind_of(StringSpecs::MyString)
    # StringSpecs::MyString.new("hello").swapcase.should be_kind_of(StringSpecs::MyString)

describe "String#swapcase!", ->
  it "modifies self in place", ->
    a = R "cYbEr_PuNk11"
    expect( a.swapcase_bang() is a).toEqual true
    expect( a ).toEqual R("CyBeR_pUnK11")

  it "returns nil if no modifications were made", ->
    a = R "+++---111222???"
    expect( a.swapcase_bang() ).toEqual null
    expect( a ).toEqual R("+++---111222???")

    expect( R("").swapcase_bang() ).toEqual null

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError when self is frozen", ->
  #     ["", "hello"].each do |a|
  #       a.freeze
  #       lambda { a.swapcase! }.should raise_error(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError when self is frozen", ->
  #     ["", "hello"].each do |a|
  #       a.freeze
  #       lambda { a.swapcase! }.should raise_error(RuntimeError)
