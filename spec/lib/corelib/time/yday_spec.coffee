describe "Time#yday", ->

  it "returns an integer representing the day of the year, 1..366", ->
    expect( R.Time.at(9999999).yday() ).toEqual R(117)
    # with_timezone "UTC", 0, ->
    #   expect( R.Time.at(9999999).yday() ).toEqual R(116)
    #   expect( R.Time.at(9999999).utc_offset() ).toEqual R(0)
    expect( R.Time.new(2012,1,1,0,0,0,'-08:00').yday() ).toEqual R(1)
    expect( R.Time.new(2012,1,1,0,0,0,'+08:00').yday() ).toEqual R(1)
    expect( R.Time.new(2012,1,1,0,0,0).yday() ).toEqual R(1)
    expect( R.Time.new(2012,1,1).yday() ).toEqual R(1)
    expect( R.Time.new(2012,12,31).yday() ).toEqual R(366)
