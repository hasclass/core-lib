describe 'Range', ->
  it "should create range", ->
    range = RubyJS.Range.new(1,5)
    expect( range.to_a().valueOf() ).toEqual([1,2,3,4,5])

    range = RubyJS.Range.new('a', 'e')
    expect( range.to_a().valueOf() ).toEqual(['a', 'b', 'c', 'd', 'e'])

    expect( (i.valueOf() for i in RubyJS.Range.new(1,3).iterator()) ).toEqual [1,2,3]