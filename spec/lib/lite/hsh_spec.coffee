describe "_h.assoc", ->
  it "returns array of [key, value] if needle equals to a key", ->
    expect( _h.assoc( {one: 1, two: 2}, 'two') ).toEqual ['two', 2]

  it "returns null if there is no key that equals to needle", ->
    expect( _h.assoc( {one: 1, two: 2}, 2) ).toEqual null

describe "_h.delete", ->
  it "deletes key from hash and returns key's value", ->
    expect( _h.delete({one: 1, two: 2}, 'one') ).toEqual 1

  it "returns null if key was not found", ->
    expect( _h.delete({one: 1, two: 2}, 4) ).toEqual null

describe "_h.each_key", ->
  it "invokes block for each key and returns hash", ->
    print = (i) -> console.log(i + '..')
    hsh = {one: 1, two: 2}
    expect( _h.each_key(hsh, print) ).toEqual hsh

describe "_h.each_value", ->
  it "invokes block for each value and returns hash", ->
    print = (i) -> console.log(i + '..')
    hsh = {one: 1, two: 2}
    expect( _h.each_value(hsh, print) ).toEqual hsh

describe "_h.empty", ->
  it "returns false if hash contains any keys and values", ->
    hsh = {one: 1, two: 2}
    expect( _h.empty(hsh) ).toEqual false

  it "returns true if hash does not contain any keys and values", ->
    expect( _h.empty({}) ).toEqual true

describe "_h.fetch", ->
  it "throws error if only one or no arguments were passed", ->
    expect( -> _h.fetch({one: 1, two: 2})).toThrow("ArgumentError")

  describe "the key is present in the hash", ->
    it "returns value of the key", ->
      expect( _h.fetch({one: 1, two: 2}, 'one')).toEqual 1

  describe "the key is not present in the hash", ->
    it "returns the value of default_value if it is passed", ->
      expect( _h.fetch({one: 1, two: 2}, 'four', 4) ).toEqual 4

    it "returns undefined if default_value is a function", ->
      print = (i) -> console.log(i + '..')
      expect( _h.fetch({one: 1, two: 2}, 'four', print) ).toEqual undefined

    it "throws KeyError if default_value wasn't passed", ->
      expect( -> _h.fetch({one: 1, two: 2}, 'four') ).toThrow("KeyError")


