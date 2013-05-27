describe "Hash#fetch", ->
  it "returns the value for key", ->
    expect( R.hashify(a: 1, b: -1).fetch('b') ).toEqual -1

  describe "1.9", ->
    it "raises an KeyError if key is not found", ->
      expect( -> R.hashify({}    ).fetch('a') ).toThrow('KeyError')
      expect( -> R.hashify({}, 5 ).fetch('a') ).toThrow('KeyError')
      expect( -> R.hashify({5: 1}).fetch('a') ).toThrow('KeyError')

  it "returns default if key is not found when passed a default", ->
    expect( R.hashify({}).fetch('a', null) ).toEqual null
    expect( R.hashify({}, 5).fetch('a', 'not here!') ).toEqual "not here!"
    expect( R.hashify({a: null}).fetch('a', 'not here!') ).toEqual null
    # expect( R.hashify({a: undefined}).fetch('a', 'not here!') ).toEqual undefined

  it "returns value of block if key is not found when passed a block", ->
    expect( R.hashify({}).fetch('a', (k) -> k+"!") ).toEqual "a!"

  it "gives precedence to the default block over the default argument when passed both", ->
    expect( R.hashify({}).fetch(9, 'foo', (i) -> i*i) ).toEqual 81

  it "raises an ArgumentError when not passed one or two arguments", ->
    expect( -> R.hashify({}).fetch()        ).toThrow('ArgumentError')
    # expect( -> R.hashify({}).fetch(1, 2, 3) ).toThrow('ArgumentError')
