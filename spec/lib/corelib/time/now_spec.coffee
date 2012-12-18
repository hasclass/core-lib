describe "R.Time.now", ->
  it "returns a date close to now", ->
    d = new Date()
    expect( R.Time.now() - d < 1000 ).toEqual true