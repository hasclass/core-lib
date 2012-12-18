describe "Time#day", ->
  # it_behaves_like(:time_day, :day)

  it "returns the day of the month (1..n) for a local Time", ->
    with_timezone "CET", 1, ->
      expect( R.Time.local(1970, 1, 1).day() ).toEqual R(1)

  it "returns the day of the month for a UTC Time", ->
    expect( R.Time.utc(1970, 1, 1).day() ).toEqual R(1)

  describe "1.9", ->
    it "returns the day of the month for a Time with a fixed offset", ->
      expect( R.Time.new(2012, 1, 1, 0, 0, 0, -3600).day() ).toEqual R(1)
