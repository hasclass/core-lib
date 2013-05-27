describe 'RubyJS', ->
  it "auto pollutes global", ->
    for method in ['_str', '_arr', '_enum', '_num', '_proc', '_puts', '_truthy', '_falsey', '_inspect']
      expect( window[method]? ).toEqual true

  it "R()", ->
    expect( R( new String("foo") ) ).toEqual(R("foo"))

  xit "R.i_am_feeling_evil", ->
    R.i_am_feeling_evil()
    expect( ['foo', 'bar'].map((el) -> el.reverse()) ).toEqual ['oof', 'rab']

    expect( typeof 5.0.times(->) == 'number').toEqual true
