describe "Enumerable#drop", ->
  describe "ruby_version_is '1.8.7'", ->
    beforeEach ->
      @en = EnumerableSpecs.Numerous.new(3, 2, 1, 'go')

    it "requires exactly one argument", ->
      en = @en
      expect( -> en.drop()     ).toThrow('ArgumentError')
      expect( -> en.drop(1, 2) ).toThrow('ArgumentError')

    describe "passed a number n as an argument", ->
      it "raise ArgumentError if n < 0", ->
        en = @en
        expect( -> en.drop(-1) ).toThrow('ArgumentError')

      it "tries to convert n to an Integer using #to_int", ->
        expect( @en.drop(2.3) ).toEqual R.$Array_r([1, 'go'])

        obj =
          to_int: -> R(2)
        spy = spyOn(obj, 'to_int').andReturn(R(2))

        expect( @en.drop(obj) ).toEqual R.$Array_r([1, 'go'])
        expect( spy ).wasCalled()

      it "returns [] for empty enerables", ->
        expect( EnumerableSpecs.Empty.new().drop(0) ).toEqual R([])
        expect( EnumerableSpecs.Empty.new().drop(2) ).toEqual R([])

      it "returns [] if dropping all", ->
        expect( @en.drop(5) ).toEqual R([])
        expect( EnumerableSpecs.Numerous.new(3, 2, 1, 'go').drop(4) ).toEqual R([])

      it "raises a TypeError when the passed n can be coerced to Integer", ->
        en = @en
        expect( -> en.drop("hat") ).toThrow('TypeError')
        expect( -> en.drop(null) ).toThrow('TypeError')

