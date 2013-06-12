describe "Time#cmp", ->
  it "returns 1 if the first argument is a point in time after the second argument", ->
    expect(R.Time.now().cmp(R.Time.at(0))).toEqual 1
    expect(R.Time.at(0, 1000).cmp(R.Time.at(0, 0))).toEqual 1
    expect(R.Time.at(1202778512, 10000).cmp(R.Time.at(1202778512, 9900))).toEqual 1

  it "returns 0 if time is the same as other", ->
    expect(R.Time.at(1202778513).cmp(R.Time.at(1202778513))).toEqual 0
    expect(R.Time.at(100, 100).cmp(R.Time.at(100, 100))).toEqual 0

  it "returns -1 if the first argument is a point in time before the second argument", ->
    expect(R.Time.at(0).cmp(R.Time.now())).toEqual -1
    expect(R.Time.at(0, 0).cmp(R.Time.at(0, 1000))).toEqual -1
    expect(R.Time.at(100, 10000).cmp(R.Time.at(101, 10000))).toEqual -1

  xdescribe "1.9", ->
    # it "returns 1 if the first argument is a fraction of a microsecond after the second argument", ->
    #   (R.Time.at(100, Rational(1,1000)).cmp R.Time.at(100, 0)).should == 1

    # it "returns 0 if time is the same as other, including fractional microseconds", ->
    #   (R.Time.at(100, Rational(1,1000)).cmp R.Time.at(100, Rational(1,1000))).should == 0

    # it "returns -1 if the first argument is a fraction of a microsecond before the second argument", ->
    #   (R.Time.at(100, 0).cmp R.Time.at(100, Rational(1,1000))).should == -1

  xdescribe "given a non-Time argument", ->
    describe "...1.9", ->
      it "returns nil", ->
        expect(R.Time.now().cmp({})).toEqual null

    describe "1.9", ->
      it "returns nil if argument <=> self returns nil", ->
        t = R.Time.now()
        obj =
          cmp: -> null
        expect(t.cmp(obj)).toEqual null


      it "returns -1 if argument <=> self is greater than 0", ->
        t = R.Time.now()
        r =
          gt: -> true
        obj =
          cmp: -> r
        expect(t.cmp(obj)).toEqual -1

      it "returns 1 if argument <=> self is not greater than 0 and is less than 0", ->
        t = R.Time.now()
        r =
          gt: -> false
          lt: -> true
        obj =
          cmp: -> r
        expect(t.cmp(obj)).toEqual 1

      it "returns 0 if argument <=> self is neither greater than 0 nor less than 0", ->
        t = R.Time.now()
        r =
          gt: -> false
          lt: -> false
        obj =
          cmp: -> r
        expect(t.cmp(obj)).toEqual 0
