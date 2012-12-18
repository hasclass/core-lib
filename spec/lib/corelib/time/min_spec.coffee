describe "Time#min", ->
  it "returns the minute of the hour (0..59) for a local Time", ->
    with_timezone "CET", 1, ->
      expect( R.Time.local(1970, 1, 1, 0, 0).min() ).toEqual R(0)

  it "returns the minute of the hour for a UTC Time", ->
    expect( R.Time.utc(1970, 1, 1, 0, 0).min() ).toEqual R(0)

  describe "1.9", ->
    it "returns the minute of the hour for a Time with a fixed offset", ->
      expect( R.Time.new(2012, 1, 1, 0, 0, 0, -3600).min() ).toEqual R(0)
