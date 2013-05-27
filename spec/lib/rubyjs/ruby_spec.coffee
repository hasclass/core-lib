describe 'RubyJS', ->
  it "auto pollutes global", ->
    for method in ['_str', '_arr', '_enum', '_num', 'proc', 'puts', 'truthy', 'falsey', 'inspect']
      expect( window[method] ).toEqual R[method]

  it "R()", ->
    expect( R( new String("foo") ) ).toEqual(R("foo"))