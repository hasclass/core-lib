describe "Enumerable#min", ->
  beforeEach ->
    @a = EnumerableSpecs.Numerous.new( 2, 4, 6, 8, 10 )

    @e_strs = EnumerableSpecs.Numerous.new("333", "22", "666666", "1", "55555", "1010101010")
    @e_ints = EnumerableSpecs.Numerous.new( 333,   22,   666666,   55555, 1010101010)

  it "min should return the minimum element", ->
    expect( EnumerableSpecs.Numerous.new().min() ).toEqual R(1)

  it "return the minimun (basic cases)", ->
    expect( EnumerableSpecs.Numerous.new(55).min() ).toEqual R(55)

    expect( EnumerableSpecs.Numerous.new(11,99).min() ).toEqual R( 11)
    expect( EnumerableSpecs.Numerous.new(99,11).min() ).toEqual R(11)
    expect( EnumerableSpecs.Numerous.new(2, 33, 4, 11).min() ).toEqual R(2)

    expect( EnumerableSpecs.Numerous.new(1,2,3,4,5).min() ).toEqual R(1)
    expect( EnumerableSpecs.Numerous.new(5,4,3,2,1).min() ).toEqual R(1)
    expect( EnumerableSpecs.Numerous.new(4,1,3,5,2).min() ).toEqual R(1)
    expect( EnumerableSpecs.Numerous.new(5,5,5,5,5).min() ).toEqual R(5)

    expect( EnumerableSpecs.Numerous.new("aa","tt").min() ).toEqual R("aa")
    expect( EnumerableSpecs.Numerous.new("tt","aa").min() ).toEqual R("aa")
    expect( EnumerableSpecs.Numerous.new("2","33","4","11").min() ).toEqual R("11")

    expect( @e_strs.min() ).toEqual R("1")
    expect( @e_ints.min() ).toEqual R(22)

  it "returns nil for an empty Enumerable ", ->
    expect( EnumerableSpecs.Empty.new().min() ).toEqual null

  # ruby_version_is ""..."1.9", ->
  #   it "raises a NoMethodError for elements without #cmp", ->
  #     lambda do
  #       EnumerableSpecs.Numerous.new(Object.new, Object.new).min
  #     end.should raise_error(NoMethodError)

  describe 'ruby_version_is "1.9"', ->
    it "raises a NoMethodError for elements without #cmp", ->
      # TODO: change to toThrow("NoMethodError")
      expect( -> EnumerableSpecs.Numerous.new(new Object(), new Object() ).min() ).toThrow()

  it "raises an ArgumentError for incomparable elements", ->
    expect( -> EnumerableSpecs.Numerous.new(11,"22").min() ).toThrow("ArgumentError")
    expect( -> EnumerableSpecs.Numerous.new(11,12,22,33).min () -> null ).toThrow("ArgumentError")

  it "return the minimun when using a block rule", ->
    expect( EnumerableSpecs.Numerous.new("2","33","4","11").min (a,b) -> a.cmp b ).toEqual R("11")
    expect( EnumerableSpecs.Numerous.new( 2 , 33 , 4 , 11 ).min (a,b) -> a.cmp b ).toEqual R(2)

    expect( EnumerableSpecs.Numerous.new("2","33","4","11").min (a,b) -> b.cmp a ).toEqual R("4")
    expect( EnumerableSpecs.Numerous.new( 2 , 33 , 4 , 11 ).min (a,b) -> b.cmp a ).toEqual R(33)

    expect( EnumerableSpecs.Numerous.new( 1, 2, 3, 4 ).min  (a,b) -> 15 ).toEqual R( 1)
    expect( EnumerableSpecs.Numerous.new(11,12,22,33).min (a, b) -> 2 ).toEqual R(11)
    i = -2
    expect( EnumerableSpecs.Numerous.new(11,12,22,33).min (a, b) -> i += 1 ).toEqual R(12)

    expect( @e_strs.min (a,b) -> a.size().cmp b.size() ).toEqual R("1")
    expect( @e_strs.min (a,b) -> a.cmp b               ).toEqual R("1")
    expect( @e_strs.min (a,b) -> a.to_i().cmp b.to_i() ).toEqual R("1")
    expect( @e_ints.min (a,b) -> a.cmp b               ).toEqual R(22)
    expect( @e_ints.min (a,b) -> a.to_s().cmp b.to_s() ).toEqual R(1010101010)

  it "doesnt get confused if 0 is min argument", ->
    expect( R([1,0]).min() ).toEqual(0)

  xit "returns the minimum for enumerables that contain nils", ->
    # arr = EnumerableSpecs.Numerous.new(nil, nil, true)
    # arr.min { |a, b|
    #   x = a.nil? ? -1 : a ? 0 : 1
    #   y = b.nil? ? -1 : b ? 0 : 1
    #   x <=> y
    # }.should == nil

  xit "gathers whole arrays as elements when each yields multiple", ->
    # multi = EnumerableSpecs.YieldsMulti.new
    # multi.min.should == [1, 2]
