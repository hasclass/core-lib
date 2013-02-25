describe "Hash#update", ->
  it "adds the entries from other, overwriting duplicate keys. Returns self", ->
    h = R.hashify(_1: 'a', _2: '3')
    h2 = h.update(_1: '9', _9: 2)
    expect( h == h2 ).toEqual true
    expect( h ).toEqual R.hashify(_1: "9", _2: "3", _9: 2)

  it "sets any duplicate key to the value of block if passed a block", ->
    h1 = R.hashify(a: 2, b: -1)
    h2 = R.hashify(a: -2, c: 1)
    h2 = h1.update(h2, (k,x,y) -> 3.14)
    expect( h1 == h2 ).toEqual true
    expect( h1 ).toEqual R.hashify(c: 1, b: -1, a: 3.14)

    h1.update(h1, -> null)
    expect( h1 ).toEqual R.hashify(a: null, b: null, c: null)

  xit "tries to convert the passed argument to a hash using #to_hash", ->
    # obj = mock('{1=>2}')
    # obj.should_receive(:to_hash).and_return(R.hashify(1: 2))
    # R.hashify(3: 4).update(obj).should == R.hashify(1: 2, 3: 4)

  xit "does not call to_hash on hash subclasses", ->
    # R.hashify(3: 4).update(HashSpecs::ToHashHash[1: 2]).should == R.hashify(1: 2, 3: 4)

  # it "processes entries with same order as merge()", ->
  #   h = R.hashify(1: 2, 3: 4, 5: 6, "x": nil, nil: 5, []: [])
  #   merge_bang_pairs = []
  #   merge_pairs = []
  #   h.merge(h) { |*arg| merge_pairs << arg }
  #   h.update(h) { |*arg| merge_bang_pairs << arg }
  #   merge_bang_pairs.should == merge_pairs


  xit "raises a RuntimeError on a frozen instance that is modified", ->
    # lambda do
    #   HashSpecs.frozen_hash.update(1: 2)
    # end.should raise_error(RuntimeError)

  xit "checks frozen status before coercing an object with #to_hash", ->
    # obj = mock("to_hash frozen")
    # # This is necessary because mock cleanup code cannot run on the frozen
    # # object.
    # def obj.to_hash() raise Exception, "should not receive #to_hash" end
    # obj.freeze

    # lambda { HashSpecs.frozen_hash.update(obj) }.should raise_error(RuntimeError)

  #   # see redmine #1571
  xit "raises a RuntimeError on a frozen instance that would not be modified", ->
    # lambda do
    #   HashSpecs.frozen_hash.update(HashSpecs.empty_frozen_hash)
    # end.should raise_error(RuntimeError)
