describe "Hash#invert", ->
  it "returns a new hash where keys are values and vice versa", ->
    h = R.hashify(1: 'a', 2: 'b', 3: 'c')
    expect( h.invert() ).toEqual R.hashify(a: '1', b: '2', c: '3')

  it "handles collisions by overriding with the key coming later in keys()", ->
    h = R.hashify(a: 1, b: 1)
    override_key = h.keys().last()
    expect( h.invert().get(1) ).toEqual override_key

  xit "compares new keys with eql? semantics", ->
    # h = R.hashify(a: 1.0, b: 1)
    # i = h.invert()
    # i[1.0].should == :a
    # i[1].should == :b

  xit "does not return subclass instances for subclasses", ->
    # HashSpecs::MyHash[1 => 2, 3 => 4].invert.class.should == hash_class
    # HashSpecs::MyHash[].invert.class.should == hash_class
