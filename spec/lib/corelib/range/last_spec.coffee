describe "Range#last", ->
  it "is an alias to end", ->
    r = RubyJS.Range.new(1,2)
    expect( r.last() ).toEqual r.end()
    expect( r.last() ).toEqual R(2)
