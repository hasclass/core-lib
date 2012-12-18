describe :time_gm, :shared => true do
  describe ""..."1.9", ->
    it "creates a time based on given values, interpreted as UTC (GMT)", ->
      Time.send(@method, 2000,"jan",1,20,15,1).inspect.should == "Sat Jan 01 20:15:01 UTC 2000"

    it "creates a time based on given C-style gmtime arguments, interpreted as UTC (GMT)", ->
      time = Time.send(@method, 1, 15, 20, 1, 1, 2000, :ignored, :ignored, :ignored, :ignored)
      time.inspect.should == "Sat Jan 01 20:15:01 UTC 2000"

  describe "1.9", ->
    it "creates a time based on given values, interpreted as UTC (GMT)", ->
      Time.send(@method, 2000,"jan",1,20,15,1).inspect.should == "2000-01-01 20:15:01 UTC"

    it "creates a time based on given C-style gmtime arguments, interpreted as UTC (GMT)", ->
      time = Time.send(@method, 1, 15, 20, 1, 1, 2000, :ignored, :ignored, :ignored, :ignored)
      time.inspect.should == "2000-01-01 20:15:01 UTC"
