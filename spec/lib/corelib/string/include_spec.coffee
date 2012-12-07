describe "String#include? with String", ->
  it "returns true if self contains other_str", ->
    expect( R("hello").include("lo") ).toEqual true
    expect( R("hello").include("ol") ).toEqual false

  xit "ignores subclass differences", ->
    # "hello".include?(StringSpecs::MyString.new("lo")).should == true
    # StringSpecs::MyString.new("hello").include?("lo").should == true
    # StringSpecs::MyString.new("hello").include?(StringSpecs::MyString.new("lo")).should == true

  it "tries to convert other to string using to_str", ->
    other =
      to_str: -> R('lo')
    # spy = spyOn(other, 'to_str').andReturn(R("lo"))
    expect( R("hello").include(other) ).toEqual true
    # expect( spy ).wasCalled()

  it "raises a TypeError if other can't be converted to string", ->
    expect( -> R("hello").include([])       ).toThrow('TypeError')
    # expect( R("hello").include(mock('x')) }.should raise_error(TypeError)

# ruby_version_is ""..."1.9", ->
#   describe "String#include? with Fixnum", ->
#     it "returns true if self contains the given char", ->
#       "hello".include?(?h).should == true
#       "hello".include?(?z).should == false
#       "hello".include?(0).should == false
#
#     it "uses fixnum % 256", ->
#       "hello".include?(?h + 256 * 3).should == true
#
#     it "doesn't try to convert fixnum to an Integer using to_int", ->
#       obj = mock('x')
#       obj.should_not_receive(:to_int)
#       lambda { "hello".include?(obj) }.should raise_error(TypeError)
#   # # end
