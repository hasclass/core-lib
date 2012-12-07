describe "Range#first", ->
  it "is an alias to begin", ->
    r = RubyJS.Range.new(1,2)
    expect( r.first() ).toEqual r.begin()
    expect( r.first() ).toEqual R(1)
