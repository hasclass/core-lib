describe "Array#keep_if", ->
  it "returns the same array if no changes were made", ->
    ary = R [1, 2, 3]
    expect( ary.keep_if( -> true ) is ary ).toEqual true
    expect( ary.keep_if( -> true ) ).toEqual ary
    # check for falsey values
    expect( ary.keep_if( -> false) ).toEqual R([])
    expect( ary.keep_if( -> 0    ) ).toEqual R([])
    expect( ary.keep_if( -> 1    ) ).toEqual R([])
    expect( ary.keep_if( -> null ) ).toEqual R([])
    expect( ary.keep_if( -> undefined ) ).toEqual R([])

  it "deletes elements for which the block returns a false value", ->
    ary = R [1, 2, 3, 4, 5]
    expect( ary.keep_if((item) -> item > 3) is ary ).toEqual true
    expect( ary ).toEqual R([4, 5])

  it "returns an enumerator if no block is given", ->
    expect( R([1, 2, 3]).keep_if() ).toBeInstanceOf R.Enumerator
