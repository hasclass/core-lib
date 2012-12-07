require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/replace', __FILE__)

describe "Array#initialize_copy", ->
  it "is private", ->
    Array.should have_private_instance_method("initialize_copy")

  it_behaves_like(:array_replace, :initialize_copy)
end
