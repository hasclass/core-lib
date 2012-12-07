describe :array_pack_arguments, :shared => true do
  it "raises an ArgumentError if there are fewer elements than the format requires", ->
    expect( -> [].pack(pack_format(1)) ).toThrow(ArgumentError)
end

describe :array_pack_basic, :shared => true do
  before :each do
    @obj = ArraySpecs.universal_pack_object

  it "raises a TypeError when passed nil", ->
    expect( -> [@obj].pack(nil) ).toThrow(TypeError)

  it "raises a TypeError when passed an Integer", ->
    expect( -> [@obj].pack(1) ).toThrow(TypeError)
end

describe :array_pack_basic_non_float, :shared => true do
  before :each do
    @obj = ArraySpecs.universal_pack_object

  it "ignores whitespace in the format string", ->
    [@obj, @obj].pack("a \t\n\v\f\r"+pack_format).should be_an_instance_of(String)

  it "calls #to_str to coerce the directives string", ->
    d = mock("pack directive")
    d.should_receive(:to_str).and_return("x"+pack_format)
    [@obj, @obj].pack(d).should be_an_instance_of(String)

  it "taints the output string if the format string is tainted", ->
    [@obj, @obj].pack("x"+pack_format.taint).tainted?.should be_true
end

describe :array_pack_basic_float, :shared => true do
  it "ignores whitespace in the format string", ->
    [9.3, 4.7].pack(" \t\n\v\f\r"+pack_format).should be_an_instance_of(String)

  it "calls #to_str to coerce the directives string", ->
    d = mock("pack directive")
    d.should_receive(:to_str).and_return("x"+pack_format)
    [1.2, 4.7].pack(d).should be_an_instance_of(String)

  it "taints the output string if the format string is tainted", ->
    [3.2, 2.8].pack("x"+pack_format.taint).tainted?.should be_true
end

describe :array_pack_no_platform, :shared => true do
  it "raises ArgumentError when the format modifier is '_'", ->
    lambda{ [1].pack(pack_format("_")) ).toThrow(ArgumentError)

  it "raises ArgumentError when the format modifier is '!'", ->
    lambda{ [1].pack(pack_format("!")) ).toThrow(ArgumentError)
end
