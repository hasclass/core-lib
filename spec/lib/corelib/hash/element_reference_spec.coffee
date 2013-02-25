describe "Hash#[]", ->
  it "returns the value for key", ->
    # obj = {}
    # h = R.hashify(1: 2, 3: 4, "foo": "bar", obj: obj, []: "baz")
    h = {}
    h = R.hashify({1: 2, 3: 4, "foo": "bar"})
    expect( h.get(1)     ).toEqual 2
    expect( h.get(3)     ).toEqual 4
    expect( h.get("foo") ).toEqual "bar"
    # expect( h.get(obj)   ).toEqual obj
    # expect( h.get([])    ).toEqual "baz"

  it "returns nil as default default value", ->
    expect( R.hashify(0: 0).get(5) ).toEqual null

  it "returns the default (immediate) value for missing keys", ->
    h = R.hashify {}, 5
    expect( h.get('a') ).toEqual 5
    h.set('a', 0)
    expect( h.get('a') ).toEqual 0
    expect( h.get('b') ).toEqual 5

  xit "calls subclass implementations of default", ->
    # h = HashSpecs::DefaultHash.new
    # h[:nothing].should == 100

  it "does not create copies of the immediate default value", ->
    str = R("foo")
    h = R.hashify({}, str)
    a = h.get("a")
    b = h.get("b")
    a.capitalize_bang()

    expect( a == b ).toEqual true
    expect( a.to_native() ).toEqual "Foo"
    expect( b.to_native() ).toEqual "Foo"

  it "returns the default (dynamic) value for missing keys", ->
    h = R.hashify {}, (hsh, k) -> hsh.set(k, k + 2)
    expect( h.get(1) ).toEqual 3
    # expect( h.get('this') ).toEqual 'this'

    # Debt: doesnt work because of default proc
    # expect( h ).toEqual R.hashify(1: 3)

    i = 0
    h = R.hashify {}, (hsh, key) -> i += 1
    expect( h.get('foo') ).toEqual 1
    expect( h.get('foo') ).toEqual 2
    expect( h.get('bar') ).toEqual 3

  it "does not return default values for keys with nil values", ->
    h = R.hashify {}, 5
    h.set 'a', null
    expect( h.get('a') ).toEqual null

    h = R.hashify {}, -> 5
    h.set 'a', null
    expect( h.get('a') ).toEqual null

#   it "compares keys with eql? semantics", ->
#     R.hashify(1.0 => "x")[1].should == nil
#     R.hashify(1.0 => "x")[1.0].should == "x"
#     R.hashify(1 => "x")[1.0].should == nil
#     R.hashify(1 => "x")[1].should == "x"

#   it "compares key via hash", ->
#     x = mock('0')
#     x.should_receive(:hash).and_return(0)

#     h = R.hashify
#     # 1.9 only calls #hash if the hash had at least one entry beforehand.
#     h[:foo] = :bar
#     h[x].should == nil

#   it "does not compare keys with different #hash values via #eql?", ->
#     x = mock('x')
#     x.should_not_receive(:eql?)
#     x.stub!(:hash).and_return(0)

#     y = mock('y')
#     y.should_not_receive(:eql?)
#     y.stub!(:hash).and_return(1)

#     R.hashify(y => 1)[x].should == nil

#   it "compares keys with the same #hash value via #eql?", ->
#     x = mock('x')
#     x.should_receive(:eql?).and_return(true)
#     x.stub!(:hash).and_return(42)

#     y = mock('y')
#     y.should_not_receive(:eql?)
#     y.stub!(:hash).and_return(42)

#     R.hashify(y => 1)[x].should == 1

#   it "finds a value via an identical key even when its #eql? isn't reflexive", ->
#     x = mock('x')
#     x.should_receive(:hash).any_number_of_times.and_return(42)
#     x.stub!(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

#     R.hashify(x => :x)[x].should == :x
# end

# describe "Hash.[]", ->
#   describe "passed zero arguments", ->
#     it "returns an empty hash", ->
#       expect( R.hashify({}).get() ).toEqual R.hashify({})

#   describe "passed an array", ->
#     it "treats elements that are 2 element arrays as key and value", ->
#       hash_class[[[:a, :b], [:c, :d]]].should == R.hashify(:a => :b, :c => :d)

#     it "treats elements that are 1 element arrays as keys with value nil", ->
#       hash_class[[[:a]]].should == R.hashify(:a => nil)

#     it "ignores elements that are arrays of more than 2 elements", ->
#       hash_class[[[:a, :b, :c]]].should == R.hashify

#     it "ignores elements that are not arrays", ->
#       hash_class[[:a]].should == R.hashify

#   describe "passed a single argument which responds to #to_hash", ->
#     it "coerces it and returns a copy", ->
#       h = R.hashify(:a => :b, :c => :d)
#       to_hash = mock('to_hash')
#       to_hash.should_receive(:to_hash).and_return(h)

#       result = hash_class[to_hash]
#       result.should == h
#       result.should_not equal(h)

#   ruby_version_is "1.9", ->
#     it "coerces a single argument which responds to #to_ary", ->
#       ary = mock('to_ary')
#       ary.should_receive(:to_ary).and_return([[:a, :b]])

#       hash_class[ary].should == R.hashify(:a => :b)

#   describe "passed an even number of arguments", ->
#     it "treats them as alternating key/value pairs", ->
#       hash_class[:a, :b, :c, :d].should == R.hashify(:a => :b, :c => :d)

#   describe "passed an odd number of arguments", ->
#     it "raises ArgumentError", ->
#       lambda { hash_class[:a, :b, :c] }.should raise_error(ArgumentError)

#   it "returns instances of subclasses", ->
#     HashSpecs::MyHash[].should be_an_instance_of(HashSpecs::MyHash)
# end
