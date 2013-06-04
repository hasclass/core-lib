require File.expand_path('../../../spec_helper', __FILE__)

describe "Hash.allocate", ->
  it "returns an instance of Hash", ->
    hsh = hash_class.allocate
    hsh.should be_kind_of(Hash)

  it "returns a fully-formed instance of Hash", ->
    hsh = hash_class.allocate
    hsh.size.should == 0
    hsh[:a] = 1
    hsh.should == { :a => 1 }
end
