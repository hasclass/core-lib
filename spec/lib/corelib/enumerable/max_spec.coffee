describe "Enumerable#max", ->
  beforeEach ->
    @a = EnumerableSpecs.Numerous.new( 2, 4, 6, 8, 10 )

    @e_strs = EnumerableSpecs.Numerous.new("333", "22", "666666", "1", "55555", "1010101010")
    @e_ints = EnumerableSpecs.Numerous.new( 333,   22,   666666,   55555, 1010101010)

  it "max should return the maximum element", ->
    expect( EnumerableSpecs.Numerous.new().max() ).toEqual R(6)

  it "return the maximun (basic cases)", ->
    expect( EnumerableSpecs.Numerous.new(55).max() ).toEqual R(55)

    expect( EnumerableSpecs.Numerous.new(11,99).max() ).toEqual R(99)
    expect( EnumerableSpecs.Numerous.new(99,11).max() ).toEqual R(99)
    expect( EnumerableSpecs.Numerous.new(2, 33, 4, 11).max() ).toEqual R(33)

    expect( EnumerableSpecs.Numerous.new(1,2,3,4,5).max() ).toEqual R(5)
    expect( EnumerableSpecs.Numerous.new(5,4,3,2,1).max() ).toEqual R(5)
    expect( EnumerableSpecs.Numerous.new(4,1,3,5,2).max() ).toEqual R(5)
    expect( EnumerableSpecs.Numerous.new(5,5,5,5,5).max() ).toEqual R(5)

    expect( EnumerableSpecs.Numerous.new("aa","tt").max() ).toEqual R("tt")
    expect( EnumerableSpecs.Numerous.new("tt","aa").max() ).toEqual R("tt")
    expect( EnumerableSpecs.Numerous.new("2","33","4","11").max() ).toEqual R("4")

    expect( @e_strs.max() ).toEqual R("666666")
    expect( @e_ints.max() ).toEqual R(1010101010)

  it "returns nil for an empty Enumerable ", ->
    expect( EnumerableSpecs.Empty.new().max() ).toEqual null

  # ruby_version_is ""..."1.9", ->
  #   it "raises a NoMethodError for elements without #cmp", ->
  #     lambda do
  #       EnumerableSpecs.Numerous.new(Object.new, Object.new).max
  #     end.should raise_error(NoMethodError)

  describe 'ruby_version_is "1.9"', ->
    it "raises a NoMethodError for elements without #cmp", ->
      # TODO: change to toThrow("NoMethodError")
      expect( -> EnumerableSpecs.Numerous.new(new Object(), new Object() ).max() ).toThrow()

  it "raises an ArgumentError for incomparable elements", ->
    expect( -> EnumerableSpecs.Numerous.new(11,"22").max() ).toThrow("ArgumentError")
    expect( -> EnumerableSpecs.Numerous.new(11,12,22,33).max () -> null ).toThrow("ArgumentError")

  it "return the maximun when using a block rule", ->
    expect( EnumerableSpecs.Numerous.new("2","33","4","11").max (a,b) -> a.cmp b ).toEqual R("4")
    expect( EnumerableSpecs.Numerous.new( 2 , 33 , 4 , 11 ).max (a,b) -> a.cmp b ).toEqual R(33)

    expect( EnumerableSpecs.Numerous.new("2","33","4","11").max (a,b) -> b.cmp a ).toEqual R("11")
    expect( EnumerableSpecs.Numerous.new( 2 , 33 , 4 , 11 ).max (a,b) -> b.cmp a ).toEqual R(2)

    expect( @e_strs.max (a,b) -> a.size().cmp b.size() ).toEqual R("1010101010")
    expect( @e_strs.max (a,b) -> a.cmp b               ).toEqual R("666666")
    expect( @e_strs.max (a,b) -> a.to_i().cmp b.to_i() ).toEqual R("1010101010")
    expect( @e_ints.max (a,b) -> a.cmp b               ).toEqual R(1010101010)
    expect( @e_ints.max (a,b) -> a.to_s().cmp b.to_s() ).toEqual R(666666)



  xit "returns the maximum for enumerables that contain nils", ->
    # arr = EnumerableSpecs.Numerous.new(nil, nil, true)
    # arr.max { |a, b|
    #   x = a.nil? ? -1 : a ? 0 : 1
    #   y = b.nil? ? -1 : b ? 0 : 1
    #   x <=> y
    # }.should == nil

  xit "gathers whole arrays as elements when each yields multiple", ->
    # multi = EnumerableSpecs.YieldsMulti.new
    # multi.max.should == [1, 2]
