require File.expand_path('../../../../spec_helper', __FILE__)

describe "Array#pack with format '%'", ->
  it "raises an Argument Error", ->
    expect( -> [1].pack("%") ).toThrow(ArgumentError)
end
