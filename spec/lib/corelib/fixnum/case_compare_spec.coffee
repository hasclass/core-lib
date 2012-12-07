describe "Fixnum#===", ->
  it "is an alias for Fixnum#==", ->
    FixnumProto = RubyJS.Fixnum.prototype
    expect( FixnumProto['==='] ).toEqual FixnumProto['==']