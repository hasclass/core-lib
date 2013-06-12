describe "Fixnum#cmp", ->
  it "returns -1 when self is less than the given argument", ->
    expect( R(-3).cmp(-1) ).toEqual -1
    expect( R(-5).cmp(10) ).toEqual -1
    expect( R(-5).cmp(-4.5)     ).toEqual -1

  it "returns 0 when self is equal to the given argument", ->
    expect( R(0).cmp(0)      ).toEqual 0
    expect( R(954).cmp(954)  ).toEqual 0
    expect( R(954).cmp(954.0)).toEqual 0

  it "returns 1 when self is greater than the given argument", ->
    expect( R(496).cmp(5)    ).toEqual 1
    expect( R(200).cmp(100)  ).toEqual 1
    expect( R(51).cmp(50.5)  ).toEqual 1

  it "returns nil when the given argument is not an Integer", ->
    expect( R(3).cmp('mock') ).toEqual null
    expect( R(3).cmp([])     ).toEqual null
