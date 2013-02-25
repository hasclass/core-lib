# most of these methods don't apply to RubyJS, as JS stores keys as JS strings
describe "Hash#store", ->
  it "associates the key with the value and return the value", ->
    h = R.hashify(a: 1)
    expect( h.store('b', 2) ).toEqual 2
    expect( h ).toEqual R.hashify(b: 2, a: 1)

  xit "duplicates string keys using dup semantics", ->
    # # dup doesn't copy singleton methods
    # key = "foo"
    # def key.reverse() "bar" end
    # h = R.hashify
    # h.store(key, 0)
    # h.keys[0].reverse.should == "oof"

  xit "stores unequal keys that hash to the same value", ->
    # h = R.hashify
    # k1 = ["x"]
    # k2 = ["y"]
    # # So they end up in the same bucket
    # k1.should_receive(:hash).and_return(0)
    # k2.should_receive(:hash).and_return(0)

    # h[k1] = 1
    # h[k2] = 2
    # h.size.should == 2

  xit "duplicates and freezes string keys", ->
    # key = "foo"
    # h = R.hashify
    # h.store(key, 0)
    # key << "bar"

    # h.should == R.hashify("foo": 0)
    # h.keys[0].frozen?.should == true

  xit "doesn't duplicate and freeze already frozen string keys", ->
    # key = "foo".freeze
    # h = R.hashify
    # h.store(key, 0)
    # h.keys[0].should equal(key)


  xit "raises a RuntimeError if called on a frozen instance", ->
    # lambda { HashSpecs.frozen_hash.store(1, 2) }.should raise_error(RuntimeError)

  xit "does not raise an exception if changing the value of an existing key during iteration", ->
    # hash = {1: 2, 3: 4, 5: 6}
    # hash.each { hash.store(1, :foo) }
    # hash.should == {1: :foo, 3: 4, 5: 6}
