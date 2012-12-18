describe :time_day, :shared => true do
  it "returns the day of the month (1..n) for a local Time", ->
    with_timezone("CET", 1) do
      R.Time.local(1970, 1, 1).send(@method).should == 1

  it "returns the day of the month for a UTC Time", ->
    R.Time.utc(1970, 1, 1).send(@method).should == 1

  describe "1.9", ->
    it "returns the day of the month for a Time with a fixed offset", ->
      R.Time.new(2012, 1, 1, 0, 0, 0, -3600).send(@method).should == 1
