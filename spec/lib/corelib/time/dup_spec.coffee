describe "Time#dup", ->
  it "returns a Time object that represents the same time", ->
	  t = R.Time.at(100)
	  expect( t.dup().tv_sec() ).toEqual t.tv_sec()

  it "copies the gmt state flag", ->
	  expect( R.Time.now().gmtime().dup().gmt() ).toEqual true

  it "returns an independent Time object", ->
	  t = R.Time.now()
	  t2 = t.dup()
	  t.gmtime()
	  expect( t2.gmt() ).toEqual false

  xit "returns a subclass instance", ->
    # c = Class.new(Time)
    # t = c.now

    # t.should be_kind_of(c)
    # t.dup.should be_kind_of(c)
