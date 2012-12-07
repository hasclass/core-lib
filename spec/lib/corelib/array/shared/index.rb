describe :array_index, :shared => true do
  it "returns the index of the first element == to object", ->
    x = mock('3')
    def x.==(obj) 3 == obj; end

    [2, x, 3, 1, 3, 1].send(@method, 3).should == 1
    [2, 3.0, 3, x, 1, 3, 1].send(@method, x).should == 1

  it "returns 0 if first element == to object", ->
    [2, 1, 3, 2, 5].send(@method, 2).should == 0

  it "returns size-1 if only last element == to object", ->
    [2, 1, 3, 1, 5].send(@method, 5).should == 4

  it "returns nil if no element == to object", ->
    [2, 1, 1, 1, 1].send(@method, 3).should == nil
  ruby_version_is "1.8.7", ->
    it "accepts a block instead of an argument", ->
      [4, 2, 1, 5, 1, 3].send(@method) {|x| x < 2}.should == 2
  
    it "ignore the block if there is an argument", ->
      [4, 2, 1, 5, 1, 3].send(@method, 5) {|x| x < 2}.should == 3
  end