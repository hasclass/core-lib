describe :time_gmt_offset, :shared => true do
  it "returns the offset in seconds between the timezone of time and UTC", ->
    with_timezone("AST", 3) do
      R.Time.new.send(@method).should == 10800

  it "returns the correct offset for US Eastern time zone around daylight savings time change", ->
    with_timezone("EST5EDT") do
      R.Time.local(2010,3,14,1,59,59).send(@method).should == -5*60*60
      R.Time.local(2010,3,14,2,0,0).send(@method).should == -4*60*60

  it "returns the correct offset for Hawaii around daylight savings time change", ->
    with_timezone("Pacific/Honolulu") do
      R.Time.local(2010,3,14,1,59,59).send(@method).should == -10*60*60
      R.Time.local(2010,3,14,2,0,0).send(@method).should == -10*60*60

  it "returns the correct offset for New Zealand around daylight savings time change", ->
    with_timezone("Pacific/Auckland") do
      R.Time.local(2010,4,4,1,59,59).send(@method).should == 13*60*60
      R.Time.local(2010,4,4,3,0,0).send(@method).should == 12*60*60

  describe "1.9", ->
    it "returns offset as Rational", ->
      R.Time.new(2010,4,4,1,59,59,7245).send(@method).should == 7245
      R.Time.new(2010,4,4,1,59,59,7245.5).send(@method).should == Rational(14491,2)
