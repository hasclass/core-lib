describe "Range#to_s", ->
  it "is an alias to #inspect", ->
    expect( R.Range.prototype.to_s ).toEqual R.Range.prototype.inspect