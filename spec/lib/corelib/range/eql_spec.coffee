describe "Range#equal?", ->
  it "is an alias to #==", ->
    RangeProto = RubyJS.Range.prototype
    expect( RangeProto.eql ).toEqual RangeProto['==']