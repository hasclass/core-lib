require File.expand_path('../../../spec_helper', __FILE__)

describe "Hash#clone", ->
  it "copies instance variable but not the objects they refer to", ->
    hash = new_hash('key' => 'value')

    clone = hash.clone

    clone.should == hash
    clone.object_id.should_not == hash.object_id
end

