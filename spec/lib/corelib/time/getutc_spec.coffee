describe "Time#getutc", ->
  it "returns a new time which is the utc representation of time", ->
    # Testing with America/Regina here because it doesn't have DST.
    t = R.Time.new(2007, 1, 9, 6, 0, 0, -6 * 3600)
    expect( t.getutc().equals(R.Time.gm(2007, 1, 9, 12, 0, 0)) ).toEqual true
