describe "Hash#sort", ->
  it "converts self to a nested array of [key, value] arrays and sort with Array#sort", ->
    hsh = R.h(a: 'b', 1: '2', b: 'a')
    expect( hsh.sort() ).toEqual R([["1", "2"], ["a", "b"], ["b", "a"]])

  xit "works when some of the keys are themselves arrays", ->
    # R.h([1,2]: 5, [1,1]: 5).sort.should == [[[1,1],5], [[1,2],5]]

  it "uses block to sort array if passed a block", ->
    expect( R.h(1: 2, 2: 9, 3: 4).sort( (a,b) -> R(b).cmp(a) ) ).toEqual R([['3', 4], ['2', 9], ['1', 2]])
