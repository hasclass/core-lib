describe 'ruby_version_is "1.9"', ->
  describe "R.String.try_convert", ->
    it "returns the argument if it's a String", ->
      x = R.String.new()
      expect( R.String.try_convert(x) ).toEqual(x)

    it "returns the argument if it's a kind of String", ->
      x = StringSpecs.MyString.new()
      expect( R.String.try_convert(x) ).toEqual(x)

    it "returns nil when the argument does not respond to #to_str", ->
      expect( R.String.try_convert({}) ).toEqual null

    it "sends #to_str to the argument and returns the result if it's nil", ->
      obj = {to_str: -> null}
      expect( R.String.try_convert(obj) ).toEqual null
      obj = {to_str: ->}
      expect( R.String.try_convert(obj) ).toEqual null

    it "sends #to_str to the argument and returns the result if it's a String", ->
      x = R.String.new()
      obj = {to_str: -> x}
      expect( R.String.try_convert(obj) ).toEqual(x)

    it "sends #to_str to the argument and returns the result if it's a kind of String", ->
      x = StringSpecs.MyString.new()
      obj = {to_str: -> x}
      expect( R.String.try_convert(obj) ).toEqual(x)

    it "sends #to_str to the argument and raises TypeError if it's not a kind of String", ->
      obj = {to_str: -> {}}
      expect( -> R.String.try_convert obj ).toThrow('TypeError')

    it "does not rescue exceptions raised by #to_str", ->
      obj = {to_str: -> throw 'RuntimeError'}
      expect( -> R.String.try_convert obj ).toThrow('RuntimeError')
