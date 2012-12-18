describe "Time#year", ->
  it "returns the four digit year for a local Time as an Integer", ->
    with_timezone "CET", 1, ->
      expect( R.Time.local(1970).year() ).toEqual R(1970)

  it "returns the four digit year for a UTC Time as an Integer", ->
    expect( R.Time.utc(1970).year() ).toEqual R(1970)

  describe "1.9", ->
    it "returns the four digit year for a Time with a fixed offset", ->
      expect( R.Time.new(2012, 1, 1, 0, 0, 0, -3600).year() ).toEqual R(2012)
