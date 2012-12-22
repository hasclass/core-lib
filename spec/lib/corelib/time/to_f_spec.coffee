describe "Time#to_f", ->
  it "returns the float number of seconds + usecs since the epoch", ->
    expect( R.Time.at(100, 1000).to_f() ).toEqual R(100.001)
