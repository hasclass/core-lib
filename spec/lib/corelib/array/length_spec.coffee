xdescribe "Array#length", ->

  it "returns the number of elements", ->
    expect( R([]).length).toEqual R(0)
    expect( R([1, 2, 3]).length).toEqual R(3)

  it "properly handles recursive arrays", ->
    empty = R([])
    empty.push(empty)
    expect( empty.length ).toEqual R(1)
