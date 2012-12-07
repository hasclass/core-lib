describe "new R.Range()", ->
  xit "does not typecast", ->
    range = new R.Range('a', 'c')
    expect( range.first() ).toEqual 'a'
    expect( range.last() ).toEqual 'c'

    range = new R.Range(1, 5)
    expect( range.first() ).toEqual 1
    expect( range.last() ).toEqual 5


describe "Range.new", ->
  it "typecasts arguments", ->
    range = R.Range.new('a', 'c')
    expect( range.first() ).toEqual R('a')
    expect( range.last() ).toEqual R('c')

    range = R.Range.new(R('a'), R('c'))
    expect( range.first() ).toEqual R('a')
    expect( range.last() ).toEqual R('c')

  it "constructs a range using the given start and end", ->
    range = R.Range.new('a', 'c')
    # expect( range ).toEqual  ('a'..'c')
    expect( range.first() ).toEqual R('a')
    expect( range.last() ).toEqual R('c')

  it "includes the end object when the third parameter is omitted or false", ->
    expect( R.Range.new('a', 'c').to_a().unbox(true) ).toEqual  ['a', 'b', 'c']
    expect( R.Range.new(1, 3).to_a().unbox(true) ).toEqual  [1, 2, 3]

    expect( R.Range.new('a', 'c', false).to_a().unbox(true) ).toEqual  ['a', 'b', 'c']
    expect( R.Range.new(1, 3, false).to_a().unbox(true) ).toEqual  [1, 2, 3]

    expect( R.Range.new('a', 'c', true).to_a().unbox(true) ).toEqual  ['a', 'b']
    expect( R.Range.new(1, 3, 1).to_a().unbox(true) ).toEqual  [1, 2]

    # expect( R.Range.new(1, 3, mock('[1,2]')).to_a().unbox(true) ).toEqual  [1, 2]
    expect( R.Range.new(1, 3, 'test').to_a().unbox(true) ).toEqual  [1, 2]

  it "raises an ArgumentError when the given start and end can't be compared by using #<=>", ->
    expect( -> R.Range.new(1, {} ) ).toThrow('ArgumentError')
    expect( -> R.Range.new({}, {}) ).toThrow('ArgumentError')

    b = {}
    a =
      '<=>': -> null
    expect( -> R.Range.new(a, b) ).toThrow('ArgumentError')
