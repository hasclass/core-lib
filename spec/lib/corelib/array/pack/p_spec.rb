require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)

describe "Array#pack with format 'P'", ->
  it_behaves_like :array_pack_basic_non_float, 'P'

  it "returns a String whose size is the number of bytes in a machine word", ->
    [nil].pack("P").size.should == 1.size
end

describe "Array#pack with format 'p'", ->
  it_behaves_like :array_pack_basic_non_float, 'p'

  it "returns a String whose size is the number of bytes in a machine word", ->
    [nil].pack("p").size.should == 1.size
end
