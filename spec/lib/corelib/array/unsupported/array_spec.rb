require File.expand_path('../../../spec_helper', __FILE__)

describe "Array", ->
  it "includes Enumerable", ->
    Array.ancestors.include?(Enumerable).should == true
end
