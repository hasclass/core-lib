
describe "Array#each", ->
  it "checks array hasn't changed", ->
    a = []
    x = R([1, 2, 3])
    x.each((item) -> a.push item; x.clear())
    expect( a ).toEqual [1]

  it "checks array hasn't changed from outside", ->
    # For now unsupported
    a = []
    b = [1, 2, 3]
    x = R(b)
    x.each((item) -> a.push item; b.length = 0)
    expect( a ).toEqual [1]

  it "yields each element to the block", ->
    a = []
    x = R([1, 2, 3])
    expect( x.each((item) -> a.push item) is x).toEqual true
    expect( a ).toEqual [1, 2, 3]

  it "yields each element to a block that takes multiple arguments", ->
    # TODO that does not work now...
    a = R([[1, 2], 'a', [3, 4]])
    b = []

    a.each (x, y) -> b.push x
    expect( b ).toEqual [1, 'a', 3]

    b = []
    a.each (x, y) -> b.push y
    # TODO: convert to null?
    # expect( b ).toEqual [2, null, 4]
    expect( b ).toEqual [2, undefined, 4]

  # it_behaves_like :enumeratorize, :each
