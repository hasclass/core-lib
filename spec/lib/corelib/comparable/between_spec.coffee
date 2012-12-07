describe "Comparable#between?", ->
  it "returns true if self is greater than or equal to the first and less than or equal to the second argument", ->
    # a = ComparableSpecs::Weird.new(-1)
    # b = ComparableSpecs::Weird.new(0)
    # c = ComparableSpecs::Weird.new(1)
    # d = ComparableSpecs::Weird.new(2)

    a = R(-1)
    b = R(0)
    c = R(1)
    d = R(2)

    expect( a.between(a, a) ).toEqual true
    expect( a.between(a, b) ).toEqual true
    expect( a.between(a, c) ).toEqual true
    expect( a.between(a, d) ).toEqual true
    expect( c.between(c, d) ).toEqual true
    expect( d.between(d, d) ).toEqual true
    expect( c.between(a, d) ).toEqual true

    expect( a.between(b, b) ).toEqual false
    expect( a.between(b, c) ).toEqual false
    expect( a.between(b, d) ).toEqual false
    expect( c.between(a, a) ).toEqual false
    expect( c.between(a, b) ).toEqual false
