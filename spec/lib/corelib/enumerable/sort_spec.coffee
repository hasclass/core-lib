
describe "Enumerable#sort", ->
  it "sorts by the natural order as defined by <=> ", ->
    expect(new EnumerableSpecs.Numerous().to_a().unbox(true)).toEqual [2,5,3,6,1,4]
    expect(
      new EnumerableSpecs.Numerous().sort().unbox(true)
    ).toEqual [1, 2, 3, 4, 5, 6]

    s = EnumerableSpecs.ComparesByVowelCount.wrap("a", "aa", "aaaa", "aaaa", "aaaaa")
    s = s.unbox() # unbox so we can access elements with []
    expect(
      new EnumerableSpecs.Numerous(s[2],s[0],s[1],s[3],s[4]).sort().unbox(true)
    ).toEqual ["a", "aa", "aaaa", "aaaa", "aaaaa"]

  it "yields elements to the provided block", ->
    expect(
      new EnumerableSpecs.Numerous().sort((a,b) -> b['<=>'](a) ).unbox(true)
    ).toEqual [6, 5, 4, 3, 2, 1]
    expect(
      new EnumerableSpecs.Numerous(2,0,1,3,4).sort((n, m) -> -(n['<=>'] m)).unbox(true)
    ).toEqual [4,3,2,1,0]

  # ruby_version_is ""..."1.9", ->
  #   it "raises a NoMethodError if elements do not define <=>", ->
  #     lambda {
  #       EnumerableSpecs::Numerous.new(Object.new, Object.new, Object.new).sort
  #     }.should raise_error(NoMethodError)


  describe 'ruby_version_is "1.9"', ->
    it "raises a NoMethodError if elements do not define <=>", ->
      expect(
        -> new EnumerableSpecs.Numerous(new Object(), new Object(), new Object()).sort()
      ).toThrow 'NoMethodError'

  xit "sorts enumerables that contain nils", ->
    # arr = EnumerableSpecs::Numerous.new(nil, true, nil, false, nil, true, nil, false, nil)
    # arr.sort { |a, b|
    #   x = a ? -1 : a.nil? ? 0 : 1
    #   y = b ? -1 : b.nil? ? 0 : 1
    #   x <=> y
    # }.should == [true, true, nil, nil, nil, nil, nil, false, false]

  it "compare values returned by block with 0", ->
    expect(
      new EnumerableSpecs.Numerous().sort((n, m) -> -(n + +m) * (n['<=>'] m) ).unbox(true)
    ).toEqual [6, 5, 4, 3, 2, 1]

    # EnumerableSpecs::Numerous.new.sort { |n, m|
    #   EnumerableSpecs::ComparableWithFixnum.new(-(n+m) * (n <=> m))
    # }.should == [6, 5, 4, 3, 2, 1]

  xit "Not implemented", ->
    expect( ->
      new EnumerableSpecs.Numerous().sort((n, m) -> (n['<=>'] m).to_s() )
    ).toThrow 'ArgumentError'

  xit "raises an error if objects can't be compared", ->
  #   a=EnumerableSpecs::Numerous.new(EnumerableSpecs::Uncomparable.new, EnumerableSpecs::Uncomparable.new)
  #   lambda {a.sort}.should raise_error(ArgumentError)

  xit "gathers whole arrays as elements when each yields multiple", ->
  #   multi = EnumerableSpecs::YieldsMulti.new
  #   multi.sort {|a, b| a.first <=> b.first}.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]

