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

