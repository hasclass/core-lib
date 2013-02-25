describe "Hash#merge", ->
  it "returns a new hash by combining self with the contents of other", ->
    h = R.hashify(1: 'a', 2: 'b', 3: 'c').merge(a: 1, c: 2)
    expect( h ).toEqual R.hashify(c: 2, 1: 'a', 2: 'b', a: 1, 3: 'c')

  it "sets any duplicate key to the value of block if passed a block", ->
    h1 = R.hashify(a: 2, b: 1, d: 5)
    h2 = R.hashify(a: -2, b: 4, c: -3)
    r = h1.merge(h2, (k,x,y) -> null )
    expect( r ).toEqual R.hashify(a: null, b: null, c: -3, d: 5)

    r = h1.merge(h2, (k,x,y) -> "#{k}:#{x+2*y}")
    expect( r ).toEqual R.hashify(a: "a:-2", b: "b:9", c: -3, d: 5)

    expect( -> h1.merge(h2, -> throw(R.IndexError.new())) ).toThrow("IndexError")

    r = h1.merge(h1, -> 'x')
    expect( r ).toEqual R.hashify(a: 'x', b: 'x', d: 'x')

  xit "tries to convert the passed argument to a hash using #to_hash", ->
    # obj = mock('{1=>2}')
    # obj.should_receive(:to_hash).and_return(R.hashify(1 => 2))
    # R.hashify(3 => 4).merge(obj).should == R.hashify(1 => 2, 3 => 4)

  xit "does not call to_hash on hash subclasses", ->
    # R.hashify(3 => 4).merge(HashSpecs::ToHashHash[1 => 2]).should == R.hashify(1 => 2, 3 => 4)

  xit "returns subclass instance for subclasses", ->
    # HashSpecs::MyHash[1 => 2, 3 => 4].merge(R.hashify(1 => 2)).should be_kind_of(HashSpecs::MyHash)
    # HashSpecs::MyHash[].merge(R.hashify(1 => 2)).should be_kind_of(HashSpecs::MyHash)

    # R.hashify(1 => 2, 3 => 4).merge(HashSpecs::MyHash[1 => 2]).class.should == hash_class
    # R.hashify.merge(HashSpecs::MyHash[1 => 2]).class.should == hash_class

  it "processes entries with same order as each()", ->
    # h = R.hashify(1: 2, 3: 4, 5: 6, "x": null, null: 5, []: [])
    h = R.hashify(1: 2, 3: 4, 5: 6, x: null)
    merge_pairs = []
    each_pairs = []
    h.each_pair (k, v) -> each_pairs.push([k, v])
    h.merge h, (k, v1, v2) -> merge_pairs.push([k, v1])
    expect( merge_pairs ).toEqual each_pairs

# describe "Hash#merge!", ->
#   it_behaves_like(:hash_update, :merge!)

#   it "does not raise an exception if changing the value of an existing key during iteration", ->
#       hash = {1 => 2, 3 => 4, 5 => 6}
#       hash2 = {1 => :foo, 3 => :bar}
#       hash.each { hash.merge!(hash2) }
#       hash.should == {1 => :foo, 3 => :bar, 5 => 6}
# end
