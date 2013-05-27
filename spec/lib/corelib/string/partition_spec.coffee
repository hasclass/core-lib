  describe "String#partition with String", ->
    it "returns an array of substrings based on splitting on the given string", ->
      expect( R("hello world").partition("o").unbox() ).toEqual ["hell", "o", " world"]

    it "always returns 3 elements", ->
      expect( R("hello").partition("x").unbox()     ).toEqual(["hello", "", ""])
      expect( R("hello").partition("hello").unbox() ).toEqual(["", "hello", ""])

    xit "accepts regexp", ->
      expect( R("hello!").partition(/l./).unbox() ).toEqual(["he", "ll", "o!"])

    xit "sets global vars if regexp used", ->
      R("hello!").partition(/(.l)(.o)/)
      expect( R( $1 ) ).toEqual R("el")
      expect( R( $2 ) ).toEqual R("lo")

    describe "ruby_bug redmine #1510, '1.9.1'", ->
      it "converts its argument using :to_str", ->
        find =
          to_str: -> R("l")
        expect( R("hello").partition(find).unbox() ).toEqual(["he","l","lo"])

    it "raises error if not convertible to string", ->
      expect( -> R("hello").partition(5)   ).toThrow('TypeError')
      expect( -> R("hello").partition(null) ).toThrow('TypeError')

    it "takes precedence over a given block", ->
      expect( R("hello world").partition("o", -> true ).unbox() ).toEqual(["hell", "o", " world"])

# ruby_version_is ''...'1.9' do
#   describe "String#partition with a block", ->
#     it "is still available" do
#       "hello\nworld".partition{|w| w < 'k' }.should == [["hello\n"], ["world"]]
#   # # end