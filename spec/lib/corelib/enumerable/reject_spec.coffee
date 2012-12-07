describe "Enumerable#reject", ->
  it "returns an array of the elements for which block is false", ->
    expect( EnumerableSpecs.Numerous.new().reject((i) -> i.gt(3)) ).toEqual R.$Array_r([2, 3, 1])

    entries  = [1,2,3,4,5,6,7,8,9,10]
    numerous = EnumerableSpecs.Numerous.new(1,2,3,4,5,6,7,8,9,10)
    expect( numerous.reject((i) -> i % 2 == 0 )).toEqual R.$Array_r([1,3,5,7,9])
    expect( numerous.reject((i) -> true       )).toEqual R.$Array_r([])
    expect( numerous.reject((i) -> false      )).toEqual R.$Array_r(entries)

  # ruby_version_is "" ... "1.8.7", ->
  #   it "raises a LocalJumpError if no block is given", ->
  #     expect( ->  EnumerableSpecs.Numerous.new.reject ).toThrow(LocalJumpError)

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an Enumerator if called without a block", ->
      expect( EnumerableSpecs.Numerous.new().reject() ).toBeInstanceOf(R.Enumerator)

  # it "gathers whole arrays as elements when each yields multiple", ->
  #   multi = EnumerableSpecs.YieldsMulti.new
  #   multi.reject {|e| e == [3, 4, 5] }.should == [[1, 2], [6, 7, 8, 9]]