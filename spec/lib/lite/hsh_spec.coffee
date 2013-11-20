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

describe "_h.flatten", ->
  it "returns an array", ->
    hsh = {one: 1, two: 2}
    expect( _h.flatten(hsh) ).toBeInstanceOf(Array)

  it "returns one-dimensional array", ->
    hsh = {one: 1, two: 2}
    expect( _h.flatten(hsh).length ).toEqual 4

  describe "with 0 as a second argument", ->
    it "returns array of arrays", ->
      hsh = {one: 1, two: 2}
      expect( _h.flatten(hsh, 0)[0] ).toBeInstanceOf(Array)
      expect( _h.flatten(hsh, 0)[1] ).toBeInstanceOf(Array)

describe "_h.get", ->
  it "returns value of the key in hsh", ->
    hsh = {one: 1, two: 2}
    expect( _h.get(hsh, 'two') ).toEqual 2

  it "returns undefined if the key is not in hsh", ->
    hsh = {one: 1, two: 2}
    expect( _h.get(hsh, 2) ).toBeUndefined()

describe "_h.has_value", ->
  it "returns true if a value was found in hsh", ->
    hsh = {one: 1, two: 2}
    expect( _h.has_value(hsh, 2) ).toBeTrue()

  it 'returns false if a value was not found or not provided', ->
    hsh = {one: 1, two: 2}
    expect( _h.has_value(hsh, 'three') ).toBeFalse()
    expect( _h.has_value(hsh) ).toBeFalse()

describe "_h.has_key", ->
  it "returns true if key was found in hsh", ->
    hsh = {one: 1, two: 2}
    expect( _h.has_key(hsh, 'one') ).toBeTrue()

  it  "returns false if key was not found in hsh", ->
    hsh = {one: 1, two: 2}
    expect( _h.has_key(hsh, 1) ).toBeFalse()

describe "_h.keep_if", ->
  it "removes key-value pairs if block evaluates to false", ->
    block = (k, v) -> return v == 1
    hsh = {one: 1, two: 2}
    expect( _h.keep_if(hsh, block)).toEqual {one: 1}

  it "throws TypeError if no block is passed", ->
    hsh = {one: 1, two: 2}
    expect( -> _h.keep_if(hsh) ).toThrow()

describe "_h.key", ->
  it "returns key from hsh for passed value", ->
    hsh = {one: 1, two: 2}
    expect( _h.key(hsh, 1) ).toEqual 'one'

  it "returns null if value was not found in hash or not passed", ->
    hsh = {one: 1, two: 2}
    expect( _h.key(hsh, 3) ).toEqual null
    expect( _h.key(hsh) ).toEqual null

describe "_h.invert", ->
  it "returns a new hash where keys and values are swaped", ->
    hsh = {one: 1, two: 2}
    expect( _h.invert(hsh) ).toEqual {'1': 'one', '2': 'two'}

  it "compares new keys with eql? semantics", ->
    hsh = {one: '1', two: '1.0'}
    expect( _h.invert(hsh)['1'] ).toEqual 'one'
    expect( _h.invert(hsh)['1.0'] ).toEqual 'two'

  it "handles collisions by overriding with keys coming later in keys()", ->
    hsh = {one: 1, two: 1}
    keys = Object.keys(hsh)
    overrideKey = keys[keys.length - 1]
    expect( _h.invert(hsh)[1] ).toEqual overrideKey

describe "_h.keys", ->
  it "returns array of keys in the same order as in hsh", ->
    hsh = {one: 1, two: 2, three: 3}
    expect( _h.keys(hsh) ).toEqual ["one", "two", "three"]

  it "returns empty array if hsh is empty", ->
    expect( _h.keys({}) ).toEqual []

describe "_h.merge", ->
  it "returns a new hash by combining hsh with other", ->
    hsh = {one: 1, two: 2}
    other = {three: 3}
    expect( _h.merge(hsh, other) ).toEqual {one: 1, two: 2, three: 3}

  it "sets any duplicate key to the value of block if passed a block", ->
    hsh = {one: 1, two: 2}
    other = {two: '5.0'}
    block = (key, a, b) -> ( a + b )
    expect( _h.merge(hsh, other, block) ).toEqual {one: 1, two: '25.0'}

describe "_h.merge$", ->
  describe "without block", ->
    it "returns hsh with contents of hsh and other", ->
      hsh = {one: 1, two: 2}
      other = {two: 22, three: 3}
      expect( _h.merge$(hsh, other) ).toEqual {one: 1, two: 22, three: 3}
      expect( hsh ).toEqual {one: 1, two: 22, three: 3}

  describe "with block", ->
    it "returns hsh with contents of hsh and other determined by executing a block", ->
      hsh = {one: 1, two: 2}
      other = {two: 22, three: 3}
      block = (key, v1, v2) -> ( v1 + v2 )
      expect( _h.merge$(hsh, other, block) ).toEqual {one: 1, two: 24, three: 3}
      expect( hsh ).toEqual {one: 1, two: 24, three: 3}

describe "_h.rassoc", ->
  it "returns an Array if there is a match", ->
    hsh = {one: 1, two: 2, three: 3}
    expect( _h.rassoc(hsh, 2) ).toBeInstanceOf(Array)

  it "returns 2-elements array if there is a match", ->
    hsh = {one: 1, two: 2, three: 3}
    expect( _h.rassoc(hsh, 2).length ).toEqual 2

  it "returns needle as the last element of the array", ->
    hsh = {one: 1, two: 2, three: 3}
    needle = 2
    result = _h.rassoc(hsh, needle)
    expect( result[result.length - 1] ).toEqual needle

  it "returns first matching key-value pair", ->
    hsh = {one: 1, two: 2, five: 2}
    expect( _h.rassoc(hsh, 2) ).toEqual ['two', 2]

  it "uses == to compare needle with values", ->
    hsh = {one: 1, two: 2.0}
    expect( _h.rassoc(hsh, 2) ).toEqual ['two', 2.0]

  it "returns null if there was no match", ->
    hsh = {one: 1, two: 2}
    expect( _h.rassoc(hsh, 3) ).toBeNull

describe "_h.reject", ->
  it "returns a hash with elements removed", ->
    hsh = {one: 1, two: 2, three: 3}
    block = (k, v) -> (v < 2)
    expect( _h.reject(hsh, block) ).toEqual {two: 2, three: 3}

  it "throws Error if block wasn't passed", ->
    expect( -> _h.reject({one: 1, two: 2}) ).toThrow("undefined is not a function")

  it "throws Error if block is not a fuction", ->
    expect( -> _h.reject({one: 1, two: 2}, {}) ).toThrow("object is not a function")