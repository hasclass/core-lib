describe "Integer#gcdlcm", ->
  describe 'ruby_version_is "1.9"', ->
    it "returns [self, self] if self is equal to the argument", ->
      expect( R(1).gcdlcm(1).unbox(true) ).toEqual [1, 1]
      expect( R(398).gcdlcm(398).unbox(true) ).toEqual [398, 398]

    it "returns an Array", ->
      expect( R(36).gcdlcm(6) ).toBeInstanceOf(R.Array)
      expect( R(4).gcdlcm(20981) ).toBeInstanceOf(R.Array)

    it "returns a two-element Array", ->
      expect( R(36).gcdlcm(876).size() ).toEqual R(2)
      expect( R(29).gcdlcm(17).size() ).toEqual R(2)

    it "returns the greatest common divisor of self and argument as the first element", ->
      expect( R(10).gcdlcm(5).at(0) ).toEqual R(10).gcd(5)
      expect( R(200).gcdlcm(20).at(0) ).toEqual R(200).gcd(20)

    it "returns the least common multiple of self and argument as the last element", ->
      expect( R(10).gcdlcm(5).at(1)   ).toEqual R(10).lcm(5)
      expect( R(200).gcdlcm(20).at(1) ).toEqual R(200).lcm(20)

    xit "accepts a Bignum argument", ->
      # bignum = 91999**99
      # bignum.should be_kind_of(Bignum)
      # expect( R(99).gcdlcm(bignum) ).toEqual [99.gcd(bignum), 99.lcm(bignum)]

    xit "works if self is a Bignum", ->
      # bignum = 9999**89
      # bignum.should be_kind_of(Bignum)
      # expect( R(bignum).gcdlcm(99) ).toEqual [bignum.gcd(99), bignum.lcm(99)]

    it "raises an ArgumentError if not given an argument", ->
      expect( -> R(12).gcdlcm() ).toThrow("ArgumentError")

    it "raises an ArgumentError if given more than one argument", ->
      expect( -> R(12).gcdlcm(30, 20) ).toThrow("ArgumentError")

    it "raises an TypeError unless the argument is an Integer", ->
      expect( -> R(39).gcdlcm(3.8)   ).toThrow("TypeError")
      expect( -> R(45872).gcdlcm([]) ).toThrow("TypeError")
