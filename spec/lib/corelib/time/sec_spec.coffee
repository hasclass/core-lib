
describe "Time#sec", ->
  it "returns the second of the minute(0..60) for time", ->
    expect( R.Time.at(0).sec() ).toEqual R(0)
    expect( R.Time.new(2012,12,1,12,30,45).sec() ).toEqual R(45)
