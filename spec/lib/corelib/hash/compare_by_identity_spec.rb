ruby_version_is "1.9", ->
  describe "Hash#compare_by_identity", ->
    before(:each) do
      @h = new_hash
      @idh = new_hash.compare_by_identity

    it "causes future comparisons on the receiver to be made by identity", ->
      @h["a"] = :a
      @h["a"].should == :a
      @h.compare_by_identity
      @h["a"].should be_nil

    it "causes #compare_by_identity? to return true", ->
      @idh.compare_by_identity?.should be_true

    it "returns self", ->
      h = new_hash
      h[:foo] = :bar
      h.compare_by_identity.should == h

    it "uses the semantics of BasicObject#equal? to determine key identity", ->
      1.1.should_not equal(1.1)
      @idh[1.1] = :a
      @idh[1.1] = :b
      [1].should_not equal([1])
      @idh[[1]] = :c
      @idh[[1]] = :d
      :bar.should equal(:bar)
      @idh[:bar] = :e
      @idh[:bar] = :f
      "bar".should_not equal('bar')
      @idh["bar"] = :g
      @idh["bar"] = :h
      @idh.values.should == [:a, :b, :c, :d, :f, :g, :h]

    it "uses #equal? semantics, but doesn't actually call #equal? to determine identity", ->
      obj = mock('equal')
      obj.should_not_receive(:equal?)
      @idh[:foo] = :glark
      @idh[obj] = :a
      @idh[obj].should == :a

    it "regards #dup'd objects as having different identities", ->
      str = 'foo'
      @idh[str.dup] = :str
      @idh[str].should be_nil

    it "regards #clone'd objects as having different identities", ->
      str = 'foo'
      @idh[str.clone] = :str
      @idh[str].should be_nil

    it "regards references to the same object as having the same identity", ->
      o = Object.new
      @h[o] = :o
      @h[:a] = :a
      @h[o].should == :o

    it "raises a RuntimeError on frozen hashes", ->
      @h = @h.freeze
      lambda { @h.compare_by_identity }.should raise_error(RuntimeError)

    # Behaviour confirmed in bug #1871
    it "perists over #dups", ->
      @idh['foo'] = :bar
      @idh['foo'] = :glark
      @idh.dup.should == @idh
      @idh.dup.size.should == @idh.size

    it "persists over #clones", ->
      @idh['foo'] = :bar
      @idh['foo'] = :glark
      @idh.clone.should == @idh
      @idh.clone.size.should == @idh.size

  describe "Hash#compare_by_identity?", ->
    it "returns false by default", ->
      h = new_hash
      h.compare_by_identity?.should be_false

    it "returns true once #compare_by_identity has been invoked on self", ->
      h = new_hash
      h.compare_by_identity
      h.compare_by_identity?.should be_true

    it "returns true when called multiple times on the same ident hash", ->
      h = new_hash
      h.compare_by_identity
      h.compare_by_identity?.should be_true
      h.compare_by_identity?.should be_true
      h.compare_by_identity?.should be_true
  end
