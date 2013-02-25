describe "Hash#select", ->
  beforeEach ->
    @hsh   = R.hashify(1: 2, 3: 4, 5: 6)
    @empty = R.hashify({})

  it "yields two arguments: key and value", ->
    all_args = []
    R.hashify(1: 2, 3: 4).select (args...) -> all_args.push(args)
    expect( R(all_args).sort() ).toEqual R([['1', 2], ['3', 4]])


  it "returns a Hash of entries for which block is true", ->
    a_pairs = R.hashify(a: 9, c: 4, b: 5, d: 2).select (k,v) -> v % 2 == 0
    expect( a_pairs ).toBeInstanceOf(R.Hash)
    expect( a_pairs.sort() ).toEqual R([['c', 4], ['d', 2]])

#   it "processes entries with the same order as reject", ->
#     h = R.hashify(:a: 9, :c: 4, :b: 5, :d: 2)

#     select_pairs = []
#     reject_pairs = []
#     h.dup.select { |*pair| select_pairs << pair }
#     h.reject { |*pair| reject_pairs << pair }

#     select_pairs.should == reject_pairs

#   ruby_version_is "" ... "1.8.7", ->
#     it "raises a LocalJumpError when called on a non-empty hash without a block", ->
#       lambda { @hsh.select }.should raise_error(LocalJumpError)

#     it "does not raise a LocalJumpError when called on an empty hash without a block", ->
#       @empty.select.should == []

#   ruby_version_is "1.8.7", ->
#     it "returns an Enumerator when called on a non-empty hash without a block", ->
#       @hsh.select.should be_an_instance_of(enumerator_class)

#     it "returns an Enumerator when called on an empty hash without a block", ->
#       @empty.select.should be_an_instance_of(enumerator_class)

# end

# ruby_version_is "1.9", ->
#   describe "Hash#select!", ->
#     before(:each) do
#       @hsh = R.hashify(1: 2, 3: 4, 5: 6)
#       @empty = R.hashify

#     it "is equivalent to keep_if if changes are made", ->
#       R.hashify(:a: 2).select! { |k,v| v <= 1 }.should ==
#         R.hashify(:a: 2).keep_if { |k, v| v <= 1 }

#       h = R.hashify(1: 2, 3: 4)
#       all_args_select = []
#       all_args_keep_if = []
#       h.dup.select! { |*args| all_args_select << args }
#       h.dup.keep_if { |*args| all_args_keep_if << args }
#       all_args_select.should == all_args_keep_if

#     it "returns nil if no changes were made", ->
#       R.hashify(:a: 1).select! { |k,v| v <= 1 }.should == nil

#     it "raises a RuntimeError if called on a frozen instance that is modified", ->
#       lambda { HashSpecs.empty_frozen_hash.select! { false } }.should raise_error(RuntimeError)

#     it "raises a RuntimeError if called on a frozen instance that would not be modified", ->
#       lambda { HashSpecs.frozen_hash.select! { true } }.should raise_error(RuntimeError)
#   end
