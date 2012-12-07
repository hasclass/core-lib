describe :array_pack_hex, :shared => true do
  it "encodes no bytes when passed zero as the count modifier", ->
    ["abc"].pack(pack_format(0)).should == ""

  it "raises a TypeError if the object does not respond to #to_str", ->
    obj = mock("pack hex non-string")
    expect( -> [obj].pack(pack_format) ).toThrow(TypeError)

  it "raises a TypeError if #to_str does not return a String", ->
    obj = mock("pack hex non-string")
    obj.should_receive(:to_str).and_return(1)
    expect( -> [obj].pack(pack_format) ).toThrow(TypeError)
end
