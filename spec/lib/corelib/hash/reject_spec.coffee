describe "Hash#reject", ->
  it "returns a new hash removing keys for which the block yields true", ->
    h = R.hashify(1: false, 2: true, 3: false, 4: true)
    expect( h.reject((k,v) -> v ).keys().sort() ).toEqual R(['1', '3'])

  xit "is equivalent to hsh.dup.delete_if", ->
    h = R.hashify(a: 'a', b: 'b', c: 'd')
    expect( h.reject (k,v) -> k == 'd' ).toEqual (h.dup().delete_if (k, v) -> k == 'd')

    # all_args_reject = []
    # all_args_delete_if = []
    # h = R.hashify(1 => 2, 3 => 4)
    # h.reject { |*args| all_args_reject << args }
    # h.delete_if { |*args| all_args_delete_if << args }
    # all_args_reject.should == all_args_delete_if

    # h = R.hashify(1 => 2)
    # # dup doesn't copy singleton methods
    # def h.to_a() end
    # h.reject { false }.to_a.should == [[1, 2]]

  xit "returns subclass instance for subclasses", ->
    # HashSpecs::MyHash[1 => 2, 3 => 4].reject { false }.should be_kind_of(HashSpecs::MyHash)
    # HashSpecs::MyHash[1 => 2, 3 => 4].reject { true }.should be_kind_of(HashSpecs::MyHash)

  xit "taints the resulting hash", ->
    # h = R.hashify(:a => 1).taint
    # h.reject {false}.tainted?.should == true

  xit "processes entries with the same order as reject!", ->
    h = R.hashify(a: 1, b: 2, c: 3, d: 4)

    # reject_pairs = []
    # reject_bang_pairs = []
    # h.dup.reject { |*pair| reject_pairs << pair }
    # h.reject! { |*pair| reject_bang_pairs << pair }

    # reject_pairs.should == reject_bang_pairs


  # it_behaves_like(:hash_iteration_no_block, :reject)

# describe "Hash#reject!", ->
#   before(:each) do
#     @hsh = R.hashify
#     (1 .. 10).each { |k| @hsh[k] = k.even? }
#     @empty = R.hashify

#   it "removes keys from self for which the block yields true", ->
#     @hsh.reject! { |k,v| v }
#     @hsh.keys.sort.should == [1,3,5,7,9]

#   it "is equivalent to delete_if if changes are made", ->
#     @hsh.reject! { |k,v| v }.should == @hsh.delete_if { |k, v| v }

#     h = R.hashify(1 => 2, 3 => 4)
#     all_args_reject = []
#     all_args_delete_if = []
#     h.dup.reject! { |*args| all_args_reject << args }
#     h.dup.delete_if { |*args| all_args_delete_if << args }
#     all_args_reject.should == all_args_delete_if

#   it "returns nil if no changes were made", ->
#     R.hashify(:a => 1).reject! { |k,v| v > 1 }.should == nil

#   it "processes entries with the same order as delete_if", ->
#     h = R.hashify(:a => 1, :b => 2, :c => 3, :d => 4)

#     reject_bang_pairs = []
#     delete_if_pairs = []
#     h.dup.reject! { |*pair| reject_bang_pairs << pair }
#     h.dup.delete_if { |*pair| delete_if_pairs << pair }

#     reject_bang_pairs.should == delete_if_pairs

#   ruby_version_is ""..."1.9", ->
#     it "raises a TypeError if called on a frozen instance", ->
#       lambda { HashSpecs.frozen_hash.reject! { false } }.should raise_error(TypeError)
#       lambda { HashSpecs.empty_frozen_hash.reject! { true } }.should raise_error(TypeError)

#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError if called on a frozen instance that is modified", ->
#       lambda { HashSpecs.empty_frozen_hash.reject! { true } }.should raise_error(RuntimeError)

#     it "raises a RuntimeError if called on a frozen instance that would not be modified", ->
#       lambda { HashSpecs.frozen_hash.reject! { false } }.should raise_error(RuntimeError)

#   ruby_version_is "" ... "1.8.7", ->
#     it "raises a LocalJumpError when called on a non-empty hash without a block", ->
#       lambda { @hsh.reject! }.should raise_error(LocalJumpError)

#     it "does not raise a LocalJumpError when called on an empty hash without a block", ->
#       @empty.reject!.should == nil

#   ruby_version_is "1.8.7", ->
#     it "returns an Enumerator when called on a non-empty hash without a block", ->
#       @hsh.reject!.should be_an_instance_of(enumerator_class)

#     it "returns an Enumerator when called on an empty hash without a block", ->
#       @empty.reject!.should be_an_instance_of(enumerator_class)

# end
