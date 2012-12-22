describe "Time#eql?", ->
  it "returns true if self and other have the same whole number of seconds", ->
    expect( R.Time.at(100).eql(R.Time.at(100)) ).toEqual true

  it "returns false if self and other have differing whole numbers of seconds", ->
    expect( R.Time.at(100).eql(R.Time.at(99)) ).toEqual false

  it "returns true if self and other have the same number of microseconds", ->
    expect( R.Time.at(100, 1000).eql(R.Time.at(100, 1000)) ).toEqual true

  it "returns false if self and other have differing numbers of microseconds", ->
    expect( R.Time.at(100, 10000).eql(R.Time.at(100, 9900)) ).toEqual false

  describe "1.9", ->
    xit "returns false if self and other have differing fractional microseconds", ->
      # expect( R.Time.at(100, Rational(100,1000)).should_not eql(R.Time.at(100, Rational(99,1000)))

  it "returns false when given a non-time value", ->
    expect( R.Time.at(100, 10000).eql("100") ).toEqual false
    expect( R.Time.at(100, 10000).eql(100100)   ).toEqual false
    expect( R.Time.at(100, 10000).eql(100.1) ).toEqual false
