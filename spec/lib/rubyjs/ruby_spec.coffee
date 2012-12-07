describe 'RubyJS', ->
  it "registers type handlers", ->
    # expect( Array.prototype.__rubyjs_typecast__  ).toEqual RubyJS.Array.typecast
    # expect( String.prototype.__rubyjs_typecast__ ).toEqual RubyJS.String.new
    # expect( Number.prototype.__rubyjs_typecast__ ).toEqual RubyJS.Numeric.typecast

  it "R()", ->
    expect( R( new String("foo") ) ).toEqual(R("foo"))