describe "Enumerable#inject", ->
  # it_behaves_like :enumerable_inject, :inject

  it "with argument takes a block with an accumulator (with argument as initial value) and the current element. Value of block becomes new accumulator", ->
    a = R []
    EnumerableSpecs.Numerous.new().inject(0, (memo, i) -> (a.push [memo, i]; i) )
    expect( a.inspect() ).toEqual R('[[0,2], [2,5], [5,3], [3,6], [6,1], [1,4]]')
    # EnumerableSpecs.EachDefiner.new(true, true, true).inject(nil) {|result, i| i && result}.should == nil

  it "produces an array of the accumulator and the argument when given a block with a *arg", ->
    a = R []
    R([1,2]).inject(0, (args...) -> a.push args; args[0] + args[1] )
    expect( a.inspect() ).toEqual R('[[0,1], [1,2]]')

#   ruby_version_is ''...'1.8.7' do
#     it "takes only one argument", ->
#       expect( ->  EnumerableSpecs.Numerous.new().inject(0, 1) { |memo, i| i } ).toThrow(ArgumentError)

  describe "ruby_version_is '1.8.7'", ->
    it "can take two argument", ->
      expect( EnumerableSpecs.Numerous.new(1, 2, 3).inject(R(10), "-") ).toEqual R(4)

    it "ignores the block if two arguments", ->
      expect( EnumerableSpecs.Numerous.new(1, 2, 3).inject(R(10), "-", -> throw "we never get here") ).toEqual R(4)

    it "can take a symbol argument", ->
      expect( EnumerableSpecs.Numerous.new(10, 1, 2, 3).inject("-") ).toEqual R(4)

  it "without argument takes a block with an accumulator (with first element as initial value) and the current element. Value of block becomes new accumulator", ->
    a = R []
    EnumerableSpecs.Numerous.new().inject (memo, i) -> a.push [memo, i]; i
    expect( a.inspect() ).toEqual R('[[2,5], [5,3], [3,6], [6,1], [1,4]]')

#    it "gathers whole arrays as elements when each yields multiple", ->
#      multi = EnumerableSpecs.YieldsMulti.new
#      multi.inject([]) {|acc, e| acc << e }.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]

#   it "with inject arguments(legacy rubycon)", ->
#     # with inject argument
#     EnumerableSpecs.EachDefiner.new().inject(1) {|acc,x| 999 }.should == 1
#     EnumerableSpecs.EachDefiner.new(2).inject(1) {|acc,x| 999 }.should ==  999
#     EnumerableSpecs.EachDefiner.new(2).inject(1) {|acc,x| acc }.should == 1
#     EnumerableSpecs.EachDefiner.new(2).inject(1) {|acc,x| x }.should == 2

#     EnumerableSpecs.EachDefiner.new(1,2,3,4).inject(100) {|acc,x| acc + x }.should == 110
#     EnumerableSpecs.EachDefiner.new(1,2,3,4).inject(100) {|acc,x| acc * x }.should == 2400

#     EnumerableSpecs.EachDefiner.new('a','b','c').inject("z") {|result, i| i+result}.should == "cbaz"

#   it "without inject arguments(legacy rubycon)", ->
#     # no inject argument
#     EnumerableSpecs.EachDefiner.new(2).send(@method) {|acc,x| 999 } .should == 2
#     EnumerableSpecs.EachDefiner.new(2).send(@method) {|acc,x| acc }.should == 2
#     EnumerableSpecs.EachDefiner.new(2).send(@method) {|acc,x| x }.should == 2

#     EnumerableSpecs.EachDefiner.new(1,2,3,4).send(@method) {|acc,x| acc + x }.should == 10
#     EnumerableSpecs.EachDefiner.new(1,2,3,4).send(@method) {|acc,x| acc * x }.should == 24

#     EnumerableSpecs.EachDefiner.new('a','b','c').send(@method) {|result, i| i+result}.should == "cba"
#     EnumerableSpecs.EachDefiner.new(3, 4, 5).send(@method) {|result, i| result*i}.should == 60
#     EnumerableSpecs.EachDefiner.new([1], 2, 'a','b').send(@method){|r,i| r<<i}.should == [1, 2, 'a', 'b']


#   it "returns nil when fails(legacy rubycon)", ->
#     EnumerableSpecs.EachDefiner.new().send(@method) {|acc,x| 999 }.should == nil
# end
