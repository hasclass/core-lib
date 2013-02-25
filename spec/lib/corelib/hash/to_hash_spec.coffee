describe "Hash#to_hash", ->
  it "returns self for Hash instances", ->
    h = R.hashify({})
    expect( h.to_hash() == h).toEqual true

  xit "returns self for instances of subclasses of Hash", ->
    # h = HashSpecs::MyHash.new
    # h.to_hash.should equal(h)
