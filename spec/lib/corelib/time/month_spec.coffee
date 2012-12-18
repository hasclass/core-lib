describe "Time#month", ->
  # it_behaves_like(:time_month, :month)
  it "returns the month of the year for a local Time", ->
    with_timezone "CET", 1, ->
      expect( R.Time.local(1970, 1).month() ).toEqual R(1)

  it "returns the month of the year for a UTC Time", ->
    expect( R.Time.utc(1970, 1).month() ).toEqual R(1)

  describe "1.9", ->
    it "returns the four digit year for a Time with a fixed offset", ->
      expect( R.Time.new(2012, 1, 1, 0, 0, 0, -3600).month() ).toEqual R(1)
