describe "Array#fetch", ->
  it "returns the element at the passed index", ->
    expect( R( [1, 2, 3] ).fetch(1)                 ).toEqual 2
    expect( R( [null] ).fetch(0)                    ).toEqual null

  it "counts negative indices backwards from end", ->
    expect( R( [1, 2, 3, 4] ).fetch(-1)             ).toEqual 4

  it "raises an IndexError if there is no element at index", ->
    expect( -> R([1, 2, 3]).fetch(3)                ).toThrow('IndexError')
    expect( -> R([1, 2, 3]).fetch(-4)               ).toThrow('IndexError')
    expect( -> R([]).fetch(0)                       ).toThrow('IndexError')

  it "returns default if there is no element at index if passed a default value", ->
    expect( R( [1, 2, 3] ).fetch(5, 'not_found')    ).toEqual 'not_found'
    expect( R( [1, 2, 3] ).fetch(5, null)           ).toEqual null
    expect( R( [1, 2, 3] ).fetch(-4, 'not_found')   ).toEqual 'not_found'
    expect( R( [null] ).fetch(0, 'not_found')       ).toEqual null

  it "returns the value of block if there is no element at index if passed a block", ->
    expect( R( [1, 2, 3] ).fetch( 9, (i) -> i * i ) ).toEqual 81
    expect( R( [1, 2, 3] ).fetch(-9, (i) -> i * i ) ).toEqual 81

  it "passes the original index argument object to the block, not the converted Integer", ->
    o =
      to_int: -> R( 5)
    expect( R( [1, 2, 3] ).fetch(o, (i) -> i )      ).toEqual o

  it "gives precedence to the default block over the default argument", ->
    expect( R( [1, 2, 3] ).fetch(9, 'foo', (i) -> i * i ) ).toEqual 81

  it "tries to convert the passed argument to an Integer using #to_int", ->
    obj =
      to_int: -> R 2
    expect( R( ["a", "b", "c"] ).fetch(obj) ).toEqual "c"

  it "raises a TypeError when the passed argument can't be coerced to Integer", ->
    expect( -> R( [] ).fetch("cat") ).toThrow('TypeError')
