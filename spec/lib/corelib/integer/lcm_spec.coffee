describe "Integer#lcm", ->
  describe 'ruby_version_is "1.9"', ->
    it "returns self if equal to the argument", ->
      expect( R(1).lcm(1) ).toEqual R(1)
      expect( R(398).lcm(398) ).toEqual R(398)

    it "returns an Integer", ->
      expect( R(36).lcm(6) ).toBeInstanceOf(R.Integer)
      expect( R(4).lcm(20981) ).toBeInstanceOf(R.Integer)

    it "returns the least common multiple of self and argument", ->
      expect( R(200).lcm(2001) ).toEqual R(400200)
      expect( R(99).lcm(90) ).toEqual R(990)

    it "returns a positive integer even if self is negative", ->
      expect( R(-12).lcm(6) ).toEqual R(12)
      expect( R(-100).lcm(100) ).toEqual R(100)

    it "returns a positive integer even if the argument is negative", ->
      expect( R(12).lcm(-6) ).toEqual R(12)
      expect( R(100).lcm(-100) ).toEqual R(100)

    it "returns a positive integer even if both self and argument are negative", ->
      expect( R(-12).lcm(-6) ).toEqual R(12)
      expect( R(-100).lcm(-100) ).toEqual R(100)

    xit "accepts a Bignum argument", ->
      # bignum = 9999**99
      # bignum.should be_kind_of(Bignum)
      # expect( R(99).lcm(bignum) ).toEqual R(bignum)

    xit "works if self is a Bignum", ->
      # bignum = 9999**99
      # bignum.should be_kind_of(Bignum)
      # expect( R(bignum).lcm(99) ).toEqual R(bignum)

    it "raises an ArgumentError if not given an argument", ->
      expect( -> R(12).lcm() ).toThrow("ArgumentError")

    it "raises an ArgumentError if given more than one argument", ->
      expect( -> R(12).lcm(30, 20) ).toThrow("ArgumentError")

    it "raises an TypeError unless the argument is an Integer", ->
      expect( -> R(39).lcm(3.8)   ).toThrow("TypeError")
      expect( -> R(45872).lcm([]) ).toThrow("TypeError")
