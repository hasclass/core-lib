describe "Array#size", ->

  it "returns the number of elements", ->
    expect( R([]).size()).toEqual R(0)
    expect( R([1, 2, 3]).size()).toEqual R(3)

  it "properly handles recursive arrays", ->
    empty = R([])
    empty.push(empty)
    expect( empty.size() ).toEqual R(1)
