describe "Time#succ", ->
  it "returns a new time one second later than time", ->
    expect( R.Time.at(100).succ().eql(R.Time.at(101)) ).toEqual true

  it "returns a new instance", ->
    t1 = R.Time.at(100)
    t2 = t1.succ()
    expect( t1 ).toNotEqual t2
