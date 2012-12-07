describe "Array#each_index", ->
  it "passes the index of each element to the block", ->
    a = R(['a', 'b', 'c', 'd'])
    acc = []
    a.each_index (i) -> acc.push i
    expect( acc ).toEqual [0, 1, 2, 3]

  it "returns self", ->
    a = R(['a', 'b', 'c'])
    acc = []
    expect( a.each_index( (i) -> acc.push) is a).toEqual true

  it "is not confused by removing elements from the front", ->
    a = R([1, 2, 3])

    a.shift()
    acc = []
    a.each_index (i) -> acc.push i
    expect( acc ).toEqual [0, 1]

    a.shift()
    acc = []
    a.each_index (i) -> acc.push i
    expect( acc ).toEqual [0]

 # it_behaves_like :enumeratorize, :each_index