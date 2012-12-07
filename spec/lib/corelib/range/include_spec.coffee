describe "Range#include?", ->
  it "is an alias to #===", ->
    RangeProto = RubyJS.Range.prototype
    expect( RangeProto.include ).toEqual RangeProto['===']