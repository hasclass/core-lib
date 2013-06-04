require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Hash#shift", ->
  it "removes a pair from hash and return it", ->
    h = new_hash(:a => 1, :b => 2, "c" => 3, nil => 4, [] => 5)
    h2 = h.dup

    h.size.times do |i|
      r = h.shift
      r.should be_kind_of(Array)
      h2[r.first].should == r.last
      h.size.should == h2.size - i - 1

    h.should == new_hash

  it "returns nil from an empty hash ", ->
    new_hash.shift.should == nil

  it "returns (computed) default for empty hashes", ->
    new_hash(5).shift.should == 5
    h = new_hash { |*args| args }
    h.shift.should == [h, nil]

  ruby_version_is "" ... "1.9", ->
    it "raises a TypeError if called on a frozen instance", ->
      lambda { HashSpecs.frozen_hash.shift  }.should raise_error(TypeError)
      lambda { HashSpecs.empty_frozen_hash.shift }.should raise_error(TypeError)

  ruby_version_is "1.9", ->
    it "raises a RuntimeError if called on a frozen instance", ->
      lambda { HashSpecs.frozen_hash.shift  }.should raise_error(RuntimeError)
      lambda { HashSpecs.empty_frozen_hash.shift }.should raise_error(RuntimeError)
  end
