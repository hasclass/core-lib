describe "Time#gmt?", ->
  it "returns true if time represents a time in UTC (GMT)", ->
    R.Time.__local_timezone__ = 3600
    expect( R.Time.now().gmt() ).toEqual false
    expect( R.Time.now().gmtime().gmt() ).toEqual true
    R.Time.__reset_local_timezone__()