describe "Enumerable#find_all", ->

  beforeEach ->
    #ScratchPad.record []
    #@elements = (1..10).to_a
    @elements = [1,2,3,4,5,6,7,8,9,10]
    @numerous = EnumerableSpecs.NumerousLiteral.new(1,2,3,4,5,6,7,8,9,10)

  it "returns all elements for which the block is not false", ->
    expect( @numerous.find_all( (i) -> i % 3 == 0 ).valueOf()).toEqual [3, 6, 9]
    expect( @numerous.find_all( (i) -> true ).valueOf()      ).toEqual @elements
    expect( @numerous.find_all( (i) -> false ).valueOf()     ).toEqual []

#   ruby_version_is ""..."1.8.7" do
#     it "raises a LocalJumpError if no block given" do
#       lambda { @numerous.send(@method) }.should raise_error(LocalJumpError)
#     end
#   end

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an enumerator when no block given", ->
      expect( @numerous.find_all() ).toBeInstanceOf R.Enumerator

    it "passes through the values yielded by #each_with_index", ->
      # [:a, :b].each_with_index.send(@method) { |x, i| ScratchPad << [x, i] }
      # ScratchPad.recorded.should == [[:a, 0], [:b, 1]]

    xit "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs::YieldsMulti.new
      # multi.send(@method) {|e| e == [3, 4, 5] }.should == [[3, 4, 5]]
