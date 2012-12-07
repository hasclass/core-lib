describe "Integer#gcd", ->
  describe 'ruby_version_is "1.9"', ->
    it "returns self if equal to the argument", ->
      expect( R(1).gcd(1) ).toEqual R(1)
      expect( R(398).gcd(398) ).toEqual R(398)

    it "returns an Integer", ->
      expect( R(36).gcd(6) ).toBeInstanceOf(R.Integer)
      expect( R(4).gcd(20981) ).toBeInstanceOf(R.Integer)

    it "returns the greatest common divisor of self and argument", ->
      expect( R(10).gcd(5) ).toEqual R(5)
      expect( R(200).gcd(20) ).toEqual R(20)

    it "returns a positive integer even if self is negative", ->
      expect( R(-12).gcd(6) ).toEqual R(6)
      expect( R(-100).gcd(100) ).toEqual R(100)

    it "returns a positive integer even if the argument is negative", ->
      expect( R(12).gcd(-6) ).toEqual R(6)
      expect( R(100).gcd(-100) ).toEqual R(100)

    it "returns a positive integer even if both self and argument are negative", ->
      expect( R(-12).gcd(-6) ).toEqual R(6)
      expect( R(-100).gcd(-100) ).toEqual R(100)

    xit "accepts a Bignum argument", ->
      # bignum = 9999**99
      # bignum.should be_kind_of(Bignum)
      # expect( R(99).gcd(bignum) ).toEqual R(99)

    xit "works if self is a Bignum", ->
      # bignum = 9999**99
      # bignum.should be_kind_of(Bignum)
      # expect( R(bignum).gcd(99) ).toEqual R(99)

    it "raises an ArgumentError if not given an argument", ->
      expect( -> R(12).gcd() ).toThrow("ArgumentError")

    it "raises an ArgumentError if given more than one argument", ->
      expect( -> R(12).gcd(30, 20) ).toThrow("ArgumentError")

    it "raises a TypeError unless the argument is an Integer", ->
      expect( -> R(39).gcd(3.8)   ).toThrow("TypeError")
      expect( -> R(45872).gcd([]) ).toThrow("TypeError")
