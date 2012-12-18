describe "Time#asctime", ->
  # it_behaves_like(:time_asctime, :asctime)
  it "returns a canonical string representation of time", ->
    t = R.Time.now()
    expect( t.asctime() ).toEqual t.strftime("%a %b %e %H:%M:%S %Y")
