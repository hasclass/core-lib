# describe "Hash#each", ->
  # it_behaves_like(:hash_each, :each)
  # it_behaves_like(:hash_iteration_no_block, :each)
# end

describe "Hash#each", ->
  # it "yields a [[key, value]] Array for each pair to a block expecting |*args|", ->
  #   all_args = []
  #   new_hash(1 => 2, 3 => 4).send(@method) { |*args| all_args << args }
  #   all_args.sort.should == [[[1, 2]], [[3, 4]]]

  it "yields the key and value of each pair to a block expecting |key, value|", ->
    r = R.hashify({})
    h = R.hashify({'a': 1, 'b': 2, 'c': 3, 'd': 5})
    result = h.each (k,v) -> r.set(k, v+"")
    expect( result == h ).toEqual true
    expect( r.to_native() ).toEqual({"a": "1", "b": "2", "c": "3", "d": "5"})

  # it "yields the key only to a block expecting |key,|", ->
  #   ary = []
  #   h = new_hash("a" => 1, "b" => 2, "c" => 3)
  #   h.send(@method) { |k,| ary << k }
  #   ary.sort.should == ["a", "b", "c"]

#   it "uses the same order as keys() and values()", ->
#     h = new_hash(:a => 1, :b => 2, :c => 3, :d => 5)
#     keys = []
#     values = []

#     h.send(@method) do |k, v|
#       keys << k
#       values << v

#     keys.should == h.keys
#     values.should == h.values

#   # Confirming the argument-splatting works from child class for both k, v and [k, v]
#   it "properly expands (or not) child class's 'each'-yielded args", ->
#     cls1 = Class.new(Hash) do
#       attr_accessor :k_v
#       def each
#         super do |k, v|
#           @k_v = [k, v]
#           yield k, v

#     cls2 = Class.new(Hash) do
#       attr_accessor :k_v
#       def each
#         super do |k, v|
#           @k_v = [k, v]
#           yield([k, v])

#     obj1 = cls1.new
#     obj1['a'] = 'b'
#     obj1.map {|k, v| [k, v]}.should == [['a', 'b']]
#     obj1.k_v.should == ['a', 'b']

#     obj2 = cls2.new
#     obj2['a'] = 'b'
#     obj2.map {|k, v| [k, v]}.should == [['a', 'b']]
#     obj2.k_v.should == ['a', 'b']
# end

describe "Hash#each_value no block", ->
  beforeEach ->
    @hsh   = R.hashify({1: 2, 3: 4, 5: 6})
    @empty = R.hashify({})

  describe "1.8.7", ->
    it "returns an Enumerator if called on a non-empty hash without a block", ->
      expect( @hsh.each() ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator if called on an empty hash without a block", ->
      expect( @empty.each() ).toBeInstanceOf(R.Enumerator)

    xit "returns an Enumerator if called on a frozen instance", ->
      @hsh.freeze()
      expect( @hsh.each() ).toBeInstanceOf(R.Enumerator)
