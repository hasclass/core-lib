require File.expand_path('../../../spec_helper', __FILE__)

describe "Hash", ->
  it "includes Enumerable", ->
    hash_class.include?(Enumerable).should == true
end

describe "Hash#hash", ->
  # prior to 1.8.7, there were no sensible Hash#hash defined at all
  ruby_version_is "1.8.7", ->
    ruby_bug "#", "1.8.7.10", ->
      it "returns a value which doesn't depend on the hash order", ->
        new_hash(0=>2, 11=>1).hash.should == new_hash(11=>1, 0=>2).hash

  it "generates a hash for recursive hash structures", ->
    h = new_hash
    h[:a] = h
    (h.hash == h[:a].hash).should == true

  ruby_bug "redmine #1852", "1.9.1", ->
    it "returns the same hash for recursive hashes", ->
      h = {} ; h[:x] = h
      h.hash.should == {:x => h}.hash
      h.hash.should == {:x => {:x => h}}.hash
      # This is because h.eql?(:x => h)
      # Remember that if two objects are eql?
      # then the need to have the same hash.
      # Check the Hash#eql? specs!

    it "returns the same hash for recursive hashes through arrays", ->
      h = {} ; rec = [h] ; h[:x] = rec
      h.hash.should == {:x => rec}.hash
      h.hash.should == {:x => [h]}.hash
      # Like above, because h.eql?(:x => [h])

  ruby_version_is "" .. "1.8.6", ->
    it "computes recursive hash keys with identical hashes", ->
      h = new_hash
      h[h] = h
      (h.hash == h[h].hash).should == true
  end
