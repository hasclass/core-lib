describe "Time#gmt_offset", ->
  it "returns the offset in seconds between the timezone of time and UTC", ->
    with_timezone "AST", 3, ->
      expect( R.Time.new().gmt_offset() ).toEqual R(10800)

  it "returns the correct offset for US Eastern time zone around daylight savings time change", ->
    # with_timezone("EST5EDT") do
    #   expect( R.Time.local(2010,3,14,1,59,59).gmt_offset() ).toEqual R(-5*60*60)
    #   expect( R.Time.local(2010,3,14,2,0,0).gmt_offset() ).toEqual R(-4*60*60)

  it "returns the correct offset for Hawaii around daylight savings time change", ->
    # with_timezone "Pacific/Honolulu", ->
    #   expect( R.Time.local(2010,3,14,1,59,59).gmt_offset() ).toEqual R(-10*60*60)
    #   expect( R.Time.local(2010,3,14,2,0,0).gmt_offset() ).toEqual R(-10*60*60)

  it "returns the correct offset for New Zealand around daylight savings time change", ->
    # with_timezone "Pacific/Auckland", ->
    #   expect( R.Time.local(2010,4,4,1,59,59).gmt_offset() ).toEqual R(13*60*60)
    #   expect( R.Time.local(2010,4,4,3,0,0).gmt_offset() ).toEqual R(12*60*60)

  xdescribe "1.9", ->
    it "returns offset as Rational", ->
      # expect( R.Time.new(2010,4,4,1,59,59,7245).gmt_offset() ).toEqual R(7245)
      # expect( R.Time.new(2010,4,4,1,59,59,7245.5).gmt_offset() ).toEqual R(Rational(14491,2))
