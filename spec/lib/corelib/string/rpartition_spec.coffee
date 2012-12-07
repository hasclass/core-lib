describe "ruby_version_is '1.8.7'", ->
  describe "String#rpartition with String", ->
    it "returns an array of substrings based on splitting on the given string", ->
      expect( R("hello world").rpartition("o").unbox(true) ).toEqual ["hello w", "o", "rld"]

    it "always returns 3 elements", ->
      expect( R("hello").rpartition("x").unbox(true) ).toEqual ["", "", "hello"]
      expect( R("hello").rpartition("hello").unbox(true) ).toEqual ["", "hello", ""]

    # TODO:
    xit "accepts regexp", ->
      expect( R("hello!").rpartition(/l./).unbox(true) ).toEqual ["hel", "lo", "!"]

    # TODO:
    xit "affects $~", ->
      matched_string = R("hello!").rpartition(/l./).to_native()[1]
      expect( R(matched_string).unbox(true) ).toEqual R['$~'][0]

    describe 'ruby_bug "redmine #1510", "1.9.1"', ->
      it "converts its argument using :to_str", ->
        find =
          to_str: -> R("l")
        expect( R("hello").rpartition(find).unbox(true) ).toEqual ["hel","l","o"]

    it "raises error if not convertible to string", ->
      expect( -> R("hello").rpartition(5)    ).toThrow('TypeError')
      expect( -> R("hello").rpartition(null) ).toThrow('TypeError')
