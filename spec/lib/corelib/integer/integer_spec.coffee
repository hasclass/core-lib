describe "Integer#integer? / is_integer", ->
  # use is_integer? instead
  # wacky implementation...
  it "returns true", ->
    expect( R(0).is_integer? ).toEqual true
    expect( R(-1).is_integer? ).toEqual true
    expect( R(1.23).is_integer? ).toNotEqual true

#   it "returns true" do
#     0.integer?.should == true
#     -1.integer?.should == true
#     bignum_value.integer?.should == true
#   end
# end
