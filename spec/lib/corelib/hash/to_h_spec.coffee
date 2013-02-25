describe "Hash#to_h", ->
  it "returns self for Hash instances", ->
    h = R.hashify({})
    expect( h.to_hash() == h).toEqual true

  describe "when called on a subclass of Hash", ->
    # before :each do
    #   @h = HashSpecs::MyHash.new
    #   @h[:foo] = :bar

    # it "returns a new Hash instance", ->
    #   @h.to_h.should be_an_instance_of(Hash)
    #   @h.to_h.should == @h
    #   @h[:foo].should == :bar

    # it "copies the default", ->
    #   @h.default = 42
    #   @h.to_h.default.should == 42
    #   @h[:hello].should == 42

    # it "copies the default_proc", ->
    #   @h.default_proc = prc = Proc.new{ |h, k| h[k] = 2 * k }
    #   @h.to_h.default_proc.should == prc
    #   @h[42].should == 84
    # end
