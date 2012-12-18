describe "Time#to_i", ->
  it "returns the value of time as an integer number of seconds since epoch", ->
    expect( R.Time.at(0).to_i() ).toEqual R(0)
    with_timezone "UTC", 0, ->
      expect( R.Time.at(9999999).to_i() ).toEqual R(9999999)