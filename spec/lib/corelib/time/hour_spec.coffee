describe "Time#hour", ->
  it "returns the number of the local time", ->
    # hour + (utc_offset - this_offset)
    expect( R.Time.new(2000,1,1,12,0,0).hour()         ).toEqual R(12)

  it "returns the number of the local time when given a utc_offset of 0", ->
    expect( R.Time.new(2012,1,1,12,0,0,0).hour()       ).toEqual R(12)

  it "returns the number of the local time when given a utc_offset of 1", ->
    expect( R.Time.new(2012,1,1,12,0,0,1*60*60).hour() ).toEqual R(12)

  it "returns the hour of the day (0..23) for a mocked local Time", ->
    expect( R.Time.local(1970, 1, 1, 1).hour() ).toEqual R(1)

  it "returns the hour of the day (0..23) for a local Time", ->
    expect( R.Time.local(1970, 1, 1, 1).hour() ).toEqual R(1)

  it "returns the hour of the day (0..23) for a mocked local Time", ->
    with_timezone "CET", 1, ->
      expect( R.Time.local(1970, 1, 1, 1).hour() ).toEqual R(1)

  it "returns the hour of the day for a UTC Time", ->
    expect( R.Time.utc(1970, 1, 1, 0).hour() ).toEqual R(0)

  describe "1.9", ->
    it "returns the hour of the day for a Time with a fixed offset", ->
      expect( R.Time.new(2012, 1, 1, 0, 0, 0, -3600).hour() ).toEqual R(0)
