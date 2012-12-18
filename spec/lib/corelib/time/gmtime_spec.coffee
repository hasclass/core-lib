describe "Time#gmtime", ->
  # it_behaves_like(:time_gmtime, :gmtime)

  it "returns the utc representation of time", ->
    # Testing with America/Regina here because it doesn't have DST.
    t = R.Time.new(2007, 1, 9, 6, 0, 0, -6 * 3600)
    t.gmtime()
    expect( t.to_i() ).toEqual R.Time.gm(2007, 1, 9, 12, 0, 0).to_i()
