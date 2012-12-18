describe "Time#ctime", ->
  # it_behaves_like(:time_asctime, :ctime)

  it "returns a canonical string representation of time", ->
    t = R.Time.now()
    expect( t.ctime() ).toEqual t.strftime("%a %b %e %H:%M:%S %Y")
