describe "Hash#default", ->
  it "returns the default value", ->
    h = R.hashify({}, 5)
    expect( h.default()              ).toEqual 5
    expect( h.default(4)             ).toEqual 5
    expect( R.hashify({}).default()  ).toEqual null
    expect( R.hashify({}).default(4) ).toEqual null

  it "uses the default proc to compute a default value, passing given key", ->
    h = R.hashify {}, (args...) -> args
    expect( h.default(null) ).toEqual [h, null]
    expect( h.default(5) ).toEqual [h, 5]

  it "calls default proc with null arg if passed a default proc but no arg", ->
    h = R.hashify {}, (args...) -> args
    expect( h.default() ).toEqual null

xdescribe "Hash#default=", ->
  # it "sets the default value", ->
  #   h = R.hashify
  #   h.default = 99
  #   h.default.should == 99

  # it "unsets the default proc", ->
  #   [99, null, lambda { 6 }].each do |default|
  #     h = R.hashify { 5 }
  #     h.default_proc.should_not == null
  #     h.default = default
  #     h.default.should == default
  #     h.default_proc.should == null

  # describe "1.9", ->
  #   xit "raises a RuntimeError if called on a frozen instance", ->
  #     # lambda { HashSpecs.frozen_hash.default = null }.should raise_error(RuntimeError)
  #     # lambda { HashSpecs.empty_frozen_hash.default = null }.should raise_error(RuntimeError)
