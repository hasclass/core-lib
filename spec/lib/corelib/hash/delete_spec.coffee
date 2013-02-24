describe "Hash#delete", ->
  it "removes the entry and returns the deleted value", ->
    h = R.hashify(a: 5, b: 2)
    expect( h.delete('b') ).toEqual 2
    expect( h ).toEqual R.hashify(a: 5)

  it "calls supplied block if the key is not found", ->
    expect( R.hashify(a: 1, b: 10, c: 100).delete('d', -> 5) ).toEqual 5
    # expect( R.hashify(:default).delete('d') { 5 } ).toEqual 5
    # expect( R.hashify { :defualt }.delete('d') { 5 } ).toEqual 5

  it "returns nil if the key is not found when no block is given", ->
    expect( R.hashify(a: 1, b: 10, c: 100).delete('d') ).toEqual null
    # expect( R.hashify(:default).delete(:d) ).toEqual nil
    # expect( R.hashify { :defualt }.delete(:d) ).toEqual nil


  describe "1.9", ->
    xit "raises a RuntimeError if called on a frozen instance", ->
      # lambda { HashSpecs.frozen_hash.delete("foo")  }.should raise_error(RuntimeError)
      # lambda { HashSpecs.empty_frozen_hash.delete("foo") }.should raise_error(RuntimeError)
