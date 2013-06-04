require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Hash.new", ->
  it "creates an empty Hash if passed no arguments", ->
    hash_class.new.should == {}
    hash_class.new.size.should == 0

  it "creates a new Hash with default object if passed a default argument ", ->
    hash_class.new(5).default.should == 5
    hash_class.new(new_hash).default.should == new_hash

  it "does not create a copy of the default argument", ->
    str = "foo"
    hash_class.new(str).default.should equal(str)

  it "creates a Hash with a default_proc if passed a block", ->
    hash_class.new.default_proc.should == nil

    h = hash_class.new { |x| "Answer to #{x}" }
    h.default_proc.call(5).should == "Answer to 5"
    h.default_proc.call("x").should == "Answer to x"

  it "raises an ArgumentError if more than one argument is passed", ->
    lambda { hash_class.new(5,6) }.should raise_error(ArgumentError)

  it "raises an ArgumentError if passed both default argument and default block", ->
    lambda { hash_class.new(5) { 0 }   }.should raise_error(ArgumentError)
    lambda { hash_class.new(nil) { 0 } }.should raise_error(ArgumentError)
end
