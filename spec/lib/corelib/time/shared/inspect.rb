describe :inspect, :shared => true do
  describe ""..."1.9", ->
    it "formats the time following the pattern 'EEE MMM dd HH:mm:ss Z yyyy'", ->
      with_timezone("PST", +1) do
        R.Time.local(2000, 1, 1, 20, 15, 1).send(@method).should == "Sat Jan 01 20:15:01 +0100 2000"

    it "formats the UTC time following the pattern 'EEE MMM dd HH:mm:ss UTC yyyy'", ->
      R.Time.utc(2000, 1, 1, 20, 15, 1).send(@method).should == "Sat Jan 01 20:15:01 UTC 2000"

  describe "1.9", ->
    it "formats the local time following the pattern 'yyyy-MM-dd HH:mm:ss Z'", ->
      with_timezone("PST", +1) do
        R.Time.local(2000, 1, 1, 20, 15, 1).send(@method).should == "2000-01-01 20:15:01 +0100"

    it "formats the UTC time following the pattern 'yyyy-MM-dd HH:mm:ss UTC'", ->
      R.Time.utc(2000, 1, 1, 20, 15, 1).send(@method).should == "2000-01-01 20:15:01 UTC"

    it "formats the fixed offset time following the pattern 'yyyy-MM-dd HH:mm:ss +/-HHMM'", ->
      R.Time.new(2000, 1, 1, 20, 15, 01, 3600).send(@method).should == "2000-01-01 20:15:01 +0100"
