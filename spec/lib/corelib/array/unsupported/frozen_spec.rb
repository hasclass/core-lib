require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Array#frozen?", ->
  it "returns true if array is frozen", ->
    a = [1, 2, 3]
    a.frozen?.should == false
    a.freeze
    a.frozen?.should == true

  not_compliant_on :rubinius do
    ruby_version_is "" .. "1.9", ->
      it "returns true for an array being sorted by #sort!", ->
        a = [1, 2, 3]
        a.sort! { |x,y| a.frozen?.should == true; x <=> y }
      
    ruby_version_is "1.9", ->
      it "returns false for an array being sorted by #sort!", ->
        a = [1, 2, 3]
        a.sort! { |x,y| a.frozen?.should == false; x <=> y }
      
    it "returns false for an array being sorted by #sort", ->
      a = [1, 2, 3]
      a.sort { |x,y| a.frozen?.should == false; x <=> y }
