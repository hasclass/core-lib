describe :hash_iteration_no_block, :shared => true do
  before(:each) do
    @hsh = new_hash(1 => 2, 3 => 4, 5 => 6)
    @empty = new_hash

  ruby_version_is "" ... "1.8.7", ->
    it "raises a LocalJumpError when called on a non-empty hash without a block", ->
      lambda { @hsh.send(@method) }.should raise_error(LocalJumpError)

    it "does not raise a LocalJumpError when called on an empty hash without a block", ->
      @empty.send(@method).should == @empty

  ruby_version_is "1.8.7", ->
    it "returns an Enumerator if called on a non-empty hash without a block", ->
      @hsh.send(@method).should be_an_instance_of(enumerator_class)

    it "returns an Enumerator if called on an empty hash without a block", ->
      @empty.send(@method).should be_an_instance_of(enumerator_class)

    it "returns an Enumerator if called on a frozen instance", ->
      @hsh.freeze
      @hsh.send(@method).should be_an_instance_of(enumerator_class)
  end
