

xdescribe "R.Time.at", ->
  describe "passed Numeric", ->
    it "returns a Time object representing the given number of Integer seconds since 1970-01-01 00:00:00 UTC", ->
      expect( R.Time.at(1184027924).getgm().asctime() ).toEqual R("Tue Jul 10 00:38:44 2007")

    it "returns a Time object representing the given number of Float seconds since 1970-01-01 00:00:00 UTC", ->
      t = R.Time.at(10.5)
      expect( t.usec() ).toEqual R(500000.0)
      expect( t.to_i() ).toNotEqual R.Time.at(10).to_i()

    it "returns a non-UTC Time", ->
      expect( R.Time.at(1184027924).utc() ).toEqual false

    xit "returns a subclass instance on a Time subclass", ->
      # c = Class.new(Time)
      # t = c.at(0)
      # t.should be_kind_of(c)

  describe "passed Time", ->
    it "creates a new time object with the value given by time", ->
      t = R.Time.now()
      expect( R.Time.at(t).inspect() ).toEqual R(t.inspect())

    it "creates a dup time object with the value given by time", ->
      t1 = R.Time.new()
      t2 = R.Time.at(t1)
      expect( t1 is t2).toEqual false

    it "returns a UTC time if the argument is UTC", ->
      t = R.Time.now().getgm()
      expect( R.Time.at(t).utc() ).toEqual true

    it "returns a non-UTC time if the argument is non-UTC", ->
      t = R.Time.now()
      expect( R.Time.at(t).utc() ).toEqual false

    xit "returns a subclass instance", ->
      # c = Class.new(Time)
      # t = c.at(R.Time.now)
      # t.should be_kind_of(c)

  describe "passed non-Time, non-Numeric", ->
    it "raises a TypeError with a String argument", ->
      expect( ->  R.Time.at("0") ).toThrow('TypeError')

    it "raises a TypeError with a nil argument", ->
      expect( ->  R.Time.at(null) ).toThrow('TypeError')

    describe "with an argument that responds to #to_int", ->
      # describe ""..."1.9", ->
      #   it "raises a TypeError", ->
      #     o = mock('integer')
      #     o.should_not_receive(:to_int)
      #     expect( ->  R.Time.at(o) ).toThrow('TypeError')

      describe "1.9", ->
        it "coerces using #to_int", ->
          o =
            to_int: -> R(0)
          expect( R.Time.at(o) ).toEqual R(R.Time.at(0))

    describe "with an argument that responds to #to_r", ->
      # describe ""..."1.9", ->
      #   it "raises a TypeError", ->
      #     o = mock('rational')
      #     o.should_not_receive(:to_r)
      #     expect( ->  R.Time.at(o) ).toThrow('TypeError')

      describe "1.9", ->
        xit "coerces using #to_r", ->
          # o =
          #   to_r: -> R.Rational(5, 2)
          # expect( R.Time.at(o) ).toEqual R(R.Time.at(Rational(5, 2)))

  describe "passed [Integer, Numeric]", ->
    it "returns a Time object representing the given number of seconds and Integer microseconds since 1970-01-01 00:00:00 UTC", ->
      t = R.Time.at(10, 500000)
      expect( t.tv_sec() ).toEqual R(10)
      expect( t.tv_usec() ).toEqual R(500000)

    describe "1.9", ->
      it "returns a Time object representing the given number of seconds and Float microseconds since 1970-01-01 00:00:00 UTC", ->
        t = R.Time.at(10, 500.500)
        expect( t.tv_sec() ).toEqual R(10)
        expect( t.tv_nsec ).toEqual R(500500)

  describe "with a second argument that responds to #to_int", ->
    it "coerces using #to_int", ->
      o =
        to_int: -> R(10)
      expect( R.Time.at(0, o) ).toEqual R(R.Time.at(0, 10))

  describe "with a second argument that responds to #to_r", ->
    # describe ""..."1.9", ->
    #   it "raises a TypeError", ->
    #     o = mock('rational')
    #     o.should_not_receive(:to_r)
    #     expect( ->  R.Time.at(0, o) ).toThrow('TypeError')

    describe "1.9", ->
      # it "coerces using #to_r", ->
      #   o =
      #     to_r: -> (R.Rational(5, 2))
      #   expect( R.Time.at(0, o) ).toEqual R(R.Time.at(0, Rational(5, 2)))

  describe "passed [Integer, nil]", ->
    it "raises a TypeError", ->
      expect( ->  R.Time.at(0, null) ).toThrow('TypeError')

  describe "passed [Integer, String]", ->
    it "raises a TypeError", ->
      expect( ->  R.Time.at(0, "0") ).toThrow('TypeError')

  describe "passed [Time, Integer]", ->
    # describe ""..."1.9", ->
    #   it "raises a TypeError", ->
    #     expect( ->  R.Time.at(R.Time.now, 500000) ).toThrow('TypeError')

    describe "1.9", ->
      it "returns a Time object equal to the specified time plus the number of microseconds", ->
        t1 = R.Time.at(10)
        t2 = R.Time.at(t1, 500000)
        expect( t2.tv_sec()  ).toEqual R(10)
        expect( t2.tv_usec() ).toEqual R(500000)
