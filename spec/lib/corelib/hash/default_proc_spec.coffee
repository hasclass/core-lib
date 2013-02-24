describe "Hash#default_proc", ->
  it "returns the block passed to Hash.new", ->
    h = new R.Hash({}, (i) -> 'Paris')
    p = h.default_proc()
    expect( p.call() ).toEqual 'Paris'

  it "returns nil if no block was passed to proc", ->
    expect( new R.Hash({}).default_proc() ).toEqual null

# describe "Hash#default_proc=", ->
#   ruby_version_is "1.9", ->
#     it "replaces the block passed to Hash.new", ->
#       h = new_hash { |i| 'Paris' }
#       h.default_proc = Proc.new { 'Montreal' }
#       p = h.default_proc
#       p.call(1).should == 'Montreal'

#     it "uses :to_proc on its argument", ->
#       h = new_hash { |i| 'Paris' }
#       obj = mock('to_proc')
#       obj.should_receive(:to_proc).and_return(Proc.new { 'Montreal' })
#       (h.default_proc = obj).should equal(obj)
#       h[:cool_city].should == 'Montreal'

#     it "overrides the static default", ->
#       h = new_hash(42)
#       h.default_proc = Proc.new { 6 }
#       h.default.should be_nil
#       h.default_proc.call.should == 6

#     it "raises an error if passed stuff not convertible to procs", ->
#       lambda{new_hash.default_proc = 42}.should raise_error(TypeError)

#     ruby_version_is "1.9"..."2.0", ->
#       it "raises an error if passed nil", ->
#         lambda{new_hash.default_proc = nil}.should raise_error(TypeError)

#     ruby_version_is "2.0", ->
#       it "clears the default proc if passed nil", ->
#         h = new_hash { |i| 'Paris' }
#         h.default_proc = nil
#         h.default_proc.should == nil
#         h[:city].should == nil

#     it "accepts a lambda with an arity of 2", ->
#       h = new_hash
#       lambda do
#         h.default_proc = lambda {|a,b| }
#       end.should_not raise_error(TypeError)

#     it "raises a TypeError if passed a lambda with an arity other than 2", ->
#       h = new_hash
#       lambda do
#         h.default_proc = lambda {|a| }
#       end.should raise_error(TypeError)
#       lambda do
#         h.default_proc = lambda {|a,b,c| }
#       end.should raise_error(TypeError)
#   end
