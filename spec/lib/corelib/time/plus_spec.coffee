describe "Time#+", ->
  it "increments the time by the specified amount", ->
    expect( R.Time.at(0).plus(100) ).toEqual R.Time.at(100)

  it "is a commutative operator", ->
    expect( R.Time.at(1.1).plus(0.9) ).toEqual R.Time.at(0.9).plus(1.1)

  xdescribe " ... 1.9", ->
    it "rounds micro seconds rather than truncates", ->
      # The use of 8.9999999 is intentional. This is because
      # Time treats the fractional part as the number of micro seconds.
      # Thusly it multiplies the result by 1_000_000 to go from
      # seconds to microseconds. That conversion should be rounded
      # properly. In this case, it's rounded up to 1,000,000, and thus
      # contributes a full extra second to the Time object.
      t = R.Time.at(0).plus(8.9999999)
      expect( t        ) .toEqual R.Time.at(9)
      expect( t.usec() ).toEqual R(0)

      # Check the non-edge case works properly, that the fractional part
      # contributes to #usec() )s
      t2 = R.Time.at(0).plus(8.9)
      expect( t2.usec() ).toEqual R(900000)

    it "adds a negative Float", ->
      t = R.Time.at(100).plus(-1.3)
      expect( t.usec() ).toEqual R(700000)
      expect( t.to_i() ).toEqual R(98)

  describe "1.9", ->
    it "adds a negative Float", ->
      t = R.Time.at(100).plus(-1.3)
      # TODO: check this
      # expect( t.usec() ).toEqual R(699999)
      expect( t.to_i() ).toEqual R(98)

  describe "...1.9", ->
    it "increments the time by the specified amount as float numbers", ->
      expect( R.Time.at(1.1).plus(0.9) ).toEqual R.Time.at(2)

    it "accepts arguments that can be coerced into Float", ->
      obj =
        to_f: -> R(10.5)
      expect( R.Time.at(100).plus(obj)).toEqual R.Time.at(110.5)

    it "raises TypeError on argument that can't be coerced into Float", ->
      expect( -> R.Time.now().plus({})      ).toThrow('TypeError')
      expect( -> R.Time.now().plus("stuff") ).toThrow('TypeError')

  describe "1.9", ->
    # it "increments the time by the specified amount as rational numbers", ->
    #   expect( (R.Time.at(Rational(11, 10)) + Rational(9, 10)).toEqual R.Time.at(2)

    # it "accepts arguments that can be coerced into Rational", ->
    #   (obj = mock('10')).should_receive(:to_r).and_return(Rational(10))
    #   expect( (R.Time.at(100) + obj).toEqual R.Time.at(110)

    # it "raises TypeError on argument that can't be coerced into Rational", ->
    #   expect( ->  R.Time.now + Object.new ).toThrow('TypeError')
    #   expect( ->  R.Time.now + "stuff" ).toThrow('TypeError')

  it "returns a UTC time if self is UTC", ->
    expect( R.Time.utc(2012).plus(10).gmt() ).toEqual true

  it "returns a non-UTC time if self is non-UTC", ->
    expect( R.Time.local(2012).plus(10).gmt() ).toEqual false

  describe "1.9", ->
    it "returns a time with the same fixed offset as self", ->
      expect( R.Time.new(2012, 1, 1, 0, 0, 0, 3600).plus(10).utc_offset() ).toEqual R(3600)

  xit "does not returns a subclass instance", ->
    # c = Class.new(Time)
    # x = c.now + 1
    # x.should be_kind_of(Time)

  it "raises TypeError on Time argument", ->
    expect( ->  R.Time.now().plus(R.Time.now()) ).toThrow('TypeError')

  it "raises TypeError on nil argument", ->
    expect( ->  R.Time.now().plus(null) ).toThrow('TypeError')

  xdescribe "1.9", ->
    #see [ruby-dev:38446]
    # it "tracks microseconds", ->
    #   time = R.Time.at(0)
    #   time += Rational(123_456, 1_000_000)
    #   time.usec.should == 123_456
    #   time += Rational(654_321, 1_000_000)
    #   time.usec.should == 777_777

    # it "tracks nanoseconds", ->
    #   time = R.Time.at(0)
    #   time += Rational(123_456_789, 1_000_000_000)
    #   time.nsec.should == 123_456_789
    #   time += Rational(876_543_210, 1_000_000_000)
    #   time.nsec.should == 999_999_999

    # it "maintains precision", ->
    #   t = R.Time.at(0) + Rational(8_999_999_999_999_999, 1_000_000_000_000_000)
    #   t.should_not == R.Time.at(9)

    # it "maintains microseconds precision", ->
    #   time = R.Time.at(0) + Rational(8_999_999_999_999_999, 1_000_000_000_000_000)
    #   time.usec.should == 999_999

    # it "maintains nanoseconds precision", ->
    #   time = R.Time.at(0) + Rational(8_999_999_999_999_999, 1_000_000_000_000_000)
    #   time.nsec.should == 999_999_999

    # it "maintains subseconds precision", ->
    #   time = R.Time.at(0) + Rational(8_999_999_999_999_999, 1_000_000_000_000_000)
    #   time.subsec.should == Rational(999_999_999_999_999, 1_000_000_000_000_000)
