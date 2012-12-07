describe "Fixnum#<=>", ->
  it "returns -1 when self is less than the given argument", ->
    expect( R(-3)['<=>'](-1) ).toEqual -1
    expect( R(-5)['<=>'](10) ).toEqual -1
    expect( R(-5)['<=>'](-4.5)     ).toEqual -1

  it "returns 0 when self is equal to the given argument", ->
    expect( R(0)['<=>'](0)      ).toEqual 0
    expect( R(954)['<=>'](954)  ).toEqual 0
    expect( R(954)['<=>'](954.0)).toEqual 0

  it "returns 1 when self is greater than the given argument", ->
    expect( R(496)['<=>'](5)    ).toEqual 1
    expect( R(200)['<=>'](100)  ).toEqual 1
    expect( R(51)['<=>'](50.5)  ).toEqual 1

  it "returns nil when the given argument is not an Integer", ->
    expect( R(3)['<=>']('mock') ).toEqual null
    expect( R(3)['<=>']([])     ).toEqual null
