require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "1.9", ->
  describe "Hash.try_convert", ->
    it "returns the argument if it's a Hash", ->
      x = Hash.new
      Hash.try_convert(x).should equal(x)

    it "returns the argument if it's a kind of Hash", ->
      x = HashSpecs::MyHash.new
      Hash.try_convert(x).should equal(x)

    it "returns nil when the argument does not respond to #to_hash", ->
      Hash.try_convert(Object.new).should be_nil

    it "sends #to_hash to the argument and returns the result if it's nil", ->
      obj = mock("to_hash")
      obj.should_receive(:to_hash).and_return(nil)
      Hash.try_convert(obj).should be_nil

    it "sends #to_hash to the argument and returns the result if it's a Hash", ->
      x = Hash.new
      obj = mock("to_hash")
      obj.should_receive(:to_hash).and_return(x)
      Hash.try_convert(obj).should equal(x)

    it "sends #to_hash to the argument and returns the result if it's a kind of Hash", ->
      x = HashSpecs::MyHash.new
      obj = mock("to_hash")
      obj.should_receive(:to_hash).and_return(x)
      Hash.try_convert(obj).should equal(x)

    it "sends #to_hash to the argument and raises TypeError if it's not a kind of Hash", ->
      obj = mock("to_hash")
      obj.should_receive(:to_hash).and_return(Object.new)
      lambda { Hash.try_convert obj }.should raise_error(TypeError)

    it "does not rescue exceptions raised by #to_hash", ->
      obj = mock("to_hash")
      obj.should_receive(:to_hash).and_raise(RuntimeError)
      lambda { Hash.try_convert obj }.should raise_error(RuntimeError)
  end
