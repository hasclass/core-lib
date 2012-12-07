describe "Range#member?", ->
  it "is an alias to #member", ->
    RangeProto = RubyJS.Range.prototype
    expect( RangeProto.include ).toEqual RangeProto.member