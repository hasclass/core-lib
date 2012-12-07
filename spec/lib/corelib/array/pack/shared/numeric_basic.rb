describe :array_pack_numeric_basic, :shared => true do
  it "returns an empty String if count is zero", ->
    [1].pack(pack_format(0)).should == ""

  it "raises a TypeError when passed nil", ->
    expect( -> [nil].pack(pack_format) ).toThrow(TypeError)

  it "raises a TypeError when passed true", ->
    expect( -> [true].pack(pack_format) ).toThrow(TypeError)

  it "raises a TypeError when passed false", ->
    expect( -> [false].pack(pack_format) ).toThrow(TypeError)

  ruby_version_is '1.9' do
    it "returns an ASCII-8BIT string", ->
      [0xFF].pack(pack_format).encoding.should == Encoding::ASCII_8BIT
      [0xE3, 0x81, 0x82].pack(pack_format(3)).encoding.should == Encoding::ASCII_8BIT

describe :array_pack_integer, :shared => true do
  it "raises a TypeError when the object does not respond to #to_int", ->
    obj = mock('not an integer')
    expect( -> [obj].pack(pack_format) ).toThrow(TypeError)

  it "raises a TypeError when passed a String", ->
    expect( -> ["5"].pack(pack_format) ).toThrow(TypeError)
end

describe :array_pack_float, :shared => true do
  ruby_version_is ""..."1.9", ->
    it "raises a ArgumentError if a String does not represent a floating point number", ->
      expect( -> ["a"].pack(pack_format) ).toThrow(ArgumentError)
  
  ruby_version_is "1.9", ->
    it "raises a TypeError if a String does not represent a floating point number", ->
      expect( -> ["a"].pack(pack_format) ).toThrow(TypeError)
  
  it "raises a TypeError when the object does not respond to #to_f", ->
    obj = mock('not an float')
    expect( -> [obj].pack(pack_format) ).toThrow(TypeError)
end
