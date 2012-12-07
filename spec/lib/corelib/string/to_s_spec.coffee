describe "String#to_s", ->
  it "returns self when self.class == String", ->
    a = R "a string"
    expect( a.to_s() is a).toEqual true

  xit "returns a new instance of String when called on a subclass", ->
    # a = StringSpecs::MyString.new("a string")
    # s = a.send(@method)
    # s.should == "a string"
    # s.should be_kind_of(String)

  xit "taints the result when self is tainted", ->
    # "x".taint.send(@method).tainted?.should == true
    # StringSpecs::MyString.new("x").taint.send(@method).tainted?.should == true
