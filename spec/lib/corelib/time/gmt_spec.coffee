describe "Time#gmt?", ->
  it "returns true if time represents a time in UTC (GMT)", ->
    expect( R.Time.now().gmt() ).toEqual false
    expect( R.Time.now().gmtime().gmt() ).toEqual true
