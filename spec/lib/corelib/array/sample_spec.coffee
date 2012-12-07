describe "Array#sample", ->
  it "selects a random value from the array", ->
    a = R [1, 2, 3, 4]
    R(10).times ->
      expect( a.include(a.sample()) ).toEqual true

  it "returns nil for empty arrays", ->
    expect( R([]).sample() ).toEqual null

  describe "passed a number n as an argument", ->
    it "raises ArgumentError for a negative n", ->
      expect( -> R([1, 2]).sample(-1) ).toThrow('ArgumentError')

    it "returns different random values from the array", ->
      a   = R [1, 2, 3, 4]
      sum = R []
      R(42).times ->
        pair = a.sample(2)
        sum.concat(pair)
        expect(pair).toNotEqual a
        expect( pair.at(0) ).toNotEqual pair.at(1)

      expect( a ).toEqual R [1, 2, 3, 4]
      expect( a ).toNotEqual sum  # Might fail once every 2^40 times ...

    it "tries to convert n to an Integer using #to_int", ->
      a = R [1, 2, 3, 4]
      expect( a.sample(2.3).size() ).toEqual R(2)

      obj =
        to_int: -> R(2)
      expect( a.sample(obj).size() ).toEqual R(2)

    it "returns all values with n big enough", ->
      a = R [1, 2, 3, 4]
      expect( a.sample(4).sort() ).toEqual a
      expect( a.sample(5).sort() ).toEqual a

    it "returns [] for empty arrays or if n <= 0", ->
      expect( R([]).sample(1)         ).toEqual R([])
      expect( R([1, 2, 3]).sample(0)  ).toEqual R([])

    xit "does not return subclass instances with Array subclass", ->
      # ArraySpecs.MyArray[1, 2, 3].sample(2).should be_kind_of(Array)