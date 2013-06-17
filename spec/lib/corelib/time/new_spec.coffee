nowtz = new Date().getTimezoneOffset() * 60

describe "1.9", ->


  it "assigns the _tzdate as a mock date with wrong timezone info", ->
    expect( R.Time.new(2000,1,1,12,0,0)._tzdate).toEqual new Date(2000,0,1,12,0,0,0)
    expect( R.Time.new(2000,1,1,12,0,0, 0)._tzdate).toEqual new Date(2000,0,1,12,0,0,0)
    expect( R.Time.new(2000,1,1,12,0,0, -3600)._tzdate).toEqual new Date(2000,0,1,12,0,0,0)
    expect( R.Time.new(2000,1,1,12,0,0, "+06:00")._tzdate).toEqual new Date(2000,0,1,12,0,0,0)

  it "Time.new without a utc_offset", ->
    R.Time.__local_timezone__ = 420 * 60
    expect( R.Time.new(2000,1,1,12,30,0).__utc_offset__ ).toEqual( 420*60)
    expect( R.Time._local_timezone() ).toEqual( 420*60)
    R.Time.__reset_local_timezone__()

  it "Time.new with a utc_offset of local zone", ->
    expect( R.Time.new(2000,1,1,12,30,0, nowtz).__utc_offset__.valueOf() ).toEqual( nowtz )

  it "Time.new with a utc_offset -3600", ->
    expect( R.Time.new(2000,1,1,12,0,0, -3600).__utc_offset__.valueOf() ).toEqual( -3600)
    expect( R.Time.new(2000,1,1,12,0,0, -3600).__native__     ).toEqual new Date(Date.UTC(2000,0,1,13,0,0,0))
    expect( R.Time.new(2000,1,1,12,0,0, -3600)._tzdate        ).toEqual new Date(2000,0,1,12,0,0,0)

  it "Time.new with a utc_offset 0", ->
    expect( R.Time.new(2000,1,1,12,0,0, 0).__utc_offset__.valueOf() ).toEqual 0
    expect( R.Time.new(2000,1,1,12,0,0,0).__native__ ).toEqual new Date(Date.UTC(2000,0,1,12,0,0,0))

  describe "Time.new with a utc_offset argument", ->
    # TODO: R.Time.new with utc_offset 0 should not be utc.
    xit "returns a non-UTC time", ->
      expect( R.Time.new(2000,1,1,0,0,0,0).is_utc() ).toEqual false

    it "returns a Time with a UTC offset of the specified number of Integer seconds", ->
      expect( R.Time.new(2000,1,1,0,0,0,123).utc_offset() ).toEqual R(123)

    describe "with an argument that responds to #to_int", ->
      it "coerces using #to_int", ->
        o =
          to_int: -> R(123)
        expect( R.Time.new(2000, 1, 1, 0, 0, 0, o).utc_offset() ).toEqual R(123)

    xit "returns a Time with a UTC offset of the specified number of Rational seconds", ->
      # R.Time.new(2000, 1, 1, 0, 0, 0, Rational(5, 2)).utc_offset().should eql(Rational(5, 2))

    describe "with an argument that responds to #to_r", ->
      xit "coerces using #to_r", ->
        o =
          to_r: -> R.Rational(5, 2)
        expect( R.Time.new(2000, 1, 1, 0, 0, 0, o).utc_offset() ).toEqual Rational(5, 2)

    it "returns a Time with a UTC offset specified as +HH:MM", ->
      expect( R.Time.new(2000, 1, 1, 0, 0, 0, "+05:30").utc_offset() ).toEqual R(19800)

    it "returns a Time with a UTC offset specified as -HH:MM", ->
      expect( R.Time.new(2000, 1, 1, 0, 0, 0, "-04:10").utc_offset() ).toEqual R(-15000)

    describe "with an argument that responds to #to_str", ->
      it "coerces using #to_str", ->
        o =
          to_str: -> R("+05:30")
        expect( R.Time.new(2000, 1, 1, 0, 0, 0, o).utc_offset() ).toEqual R(19800)

    xit "returns a local Time if the argument is nil", ->
      # with_timezone("PST", -8) do
      #   t = R.Time.new(2000, 1, 1, 0, 0, 0, nil)
      #   expect( t.utc_offset() ).toEqual -28800
      #   expect( t.zone() ).toEqual "PST"

    it "raises ArgumentError if the String argument is not of the form (+|-)HH:MM", ->
      expect( ->  R.Time.new(2000, 1, 1, 0, 0, 0, "3600") ).toThrow('ArgumentError')

    xit "raises ArgumentError if the String argument is not in an ASCII-compatible encoding", ->
      # expect( ->  R.Time.new(2000, 1, 1, 0, 0, 0, "-04:10".encode("UTF-16LE")) ).toThrow('ArgumentError')

    it "raises ArgumentError if the argument represents a value less than or equal to -86400 seconds", ->
      expect( R.Time.new(2000, 1, 1, 0, 0, 0, -86400 + 1  ).utc_offset() ).toEqual R(-86400 + 1)
      expect( ->  R.Time.new(2000, 1, 1, 0, 0, 0, -86400) ).toThrow('ArgumentError')

    it "raises ArgumentError if the argument represents a value greater than or equal to 86400 seconds", ->
      expect( R.Time.new(2000, 1, 1, 0, 0, 0, 86400 - 1  ).utc_offset() ).toEqual R(86400 - 1)
      expect( ->  R.Time.new(2000, 1, 1, 0, 0, 0, 86400) ).toThrow('ArgumentError')
