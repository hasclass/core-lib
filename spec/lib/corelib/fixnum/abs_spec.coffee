# describe :fixnum_abs, :shared => true do
#   it "returns self's absolute value" do
#     { 0 => [0, -0, +0], 2 => [2, -2, +2], 100 => [100, -100, +100] }.each do |key, values|
#       values.each do |value|
#         value.send(@method).should == key
#       end
#     end
#   end
# end

describe "Fixnum#abs", ->
  it "returns self's absolute value", ->
    expect( R(0).abs().valueOf() ).toEqual 0
    expect( R(-0).abs().valueOf() ).toEqual 0
    expect( R(+0).abs().valueOf() ).toEqual 0

    expect( R( 2).abs().valueOf() ).toEqual 2
    expect( R(-2).abs().valueOf() ).toEqual 2
    expect( R(+2).abs().valueOf() ).toEqual 2

    expect( R( 100).abs().valueOf() ).toEqual 100
    expect( R(-100).abs().valueOf() ).toEqual 100
    expect( R(+100).abs().valueOf() ).toEqual 100