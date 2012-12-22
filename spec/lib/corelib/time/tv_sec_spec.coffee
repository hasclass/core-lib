describe "Time#tv_sec", ->
  # it_behaves_like(:time_to_i, :tv_sec)
  it "returns the value of time as an integer number of seconds since epoch", ->
    expect( R.Time.at(0).tv_sec() ).toEqual R(0)
    with_timezone "UTC", 0, ->
      expect( R.Time.at(9999999).tv_sec() ).toEqual R(9999999)