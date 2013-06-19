describe "_s", ->
  describe 'camel_case', ->

   it 'should leave non-dashed strings alone', ->
     expect( _s.camel_case('foo')   ).toEqual('foo')
     expect( _s.camel_case('')      ).toEqual('')
     expect( _s.camel_case('fooBar')).toEqual('fooBar')


   it 'should covert dash-separated strings to camelCase', ->
     expect( _s.camel_case('foo-bar')    ).toEqual('fooBar')
     expect( _s.camel_case('foo-bar-baz')).toEqual('fooBarBaz')
     expect( _s.camel_case('foo:bar_baz')).toEqual('fooBarBaz')


   xit 'should covert browser specific css properties', ->
     expect( _s.camel_case('-moz-foo-bar')   ).toEqual('MozFooBar')
     expect( _s.camel_case('-webkit-foo-bar')).toEqual('webkitFooBar')
     expect( _s.camel_case('-webkit-foo-bar')).toEqual('webkitFooBar')

  describe "_s.swap_case", ->
    expect( _s.swapcase("Hello")        ).toEqual "hELLO"
    expect( _s.swapcase("cYbEr_PuNk11") ).toEqual "CyBeR_pUnK11"
