describe "Array#at", ->
  it "returns the (n+1)'th element for the passed index n", ->
    a = R([1, 2, 3, 4, 5, 6])
    expect( a.at ).toBeDefined()
    expect( a.at(0) ).toEqual 1
    expect( a.at(1) ).toEqual 2
    expect( a.at(5) ).toEqual 6

  it "returns nil if the given index is greater than or equal to the array's length", ->
    a = R [1, 2, 3, 4, 5, 6]
    expect( a.at(6) ).toEqual null
    expect( a.at(7) ).toEqual null

  it "returns the (-n)'th elemet from the last, for the given negative index n", ->
    a = R [1, 2, 3, 4, 5, 6]
    expect( a.at(-1) ).toEqual 6
    expect( a.at(-2) ).toEqual 5
    expect( a.at(-6) ).toEqual 1

  it "returns nil if the given index is less than -len, where len is length of the array", ->
    a = R [1, 2, 3, 4, 5, 6]
    expect( a.at(-7) ).toEqual null
    expect( a.at(-8) ).toEqual null

  it "does not extend the array unless the given index is out of range", ->
    a = R [1, 2, 3, 4, 5, 6]
    expect( +a.size() ).toEqual 6
    a.at(100)
    expect( +a.size() ).toEqual 6
    a.at(-100)
    expect( +a.size() ).toEqual 6

  xit "tries to convert the passed argument to an Integer using #to_int", ->
    a = R ["a", "b", "c"]
    expect( a.at(0.5) ).toEqual "a"

    obj =
      to_int: -> R(2)
    expect( a.at(obj) ).toEqual "c"

  xit "raises a TypeError when the passed argument can't be coerced to Integer", ->
    expect( -> R([]).at("cat") ).toThrow("TypeError")

  xit "raises an ArgumentError when 2 or more arguments is passed", ->
    expect( -> R(['a', 'b']).at(0,1) ).toThrow("ArgumentError")
