describe "Enumerable#any?", ->
  beforeEach ->
    @enum = EnumerableSpecs.Numerous.new
    @empty = EnumerableSpecs.Empty.new()
    @enum1 = R([0, 1, 2, -1])
    @enum2 = R([null, false, true])

  it "does not hide exceptions out of #each", ->
    expect( ->
      EnumerableSpecs.ThrowingEach.new().any()
    ).toThrow "RuntimeError"

    expect( ->
      EnumerableSpecs.ThrowingEach.new().any(-> false)
    ).toThrow "RuntimeError"

  it "always returns false on empty enumeration", ->
    expect(@empty.any()).toEqual false
    expect(@empty.any(-> null)).toEqual false

    expect(R.$Array([]).any()).toEqual false
    expect(R.$Array([]).any( -> false )).toEqual false

  xit "implement", ->
    # {}.any?.should == false
    # {}.any? { null }.should == false

  #it "raises an ArgumentError when any arguments provided", ->
    expect( -> @enum.any(-> ) ).toThrow "ArgumentError"
    expect( -> @enum.any(null) ).toThrow "ArgumentError"
    expect( -> @empty.any(1) ).toThrow "ArgumentError"
    expect( -> @enum1.any(1, ->) ).toThrow "ArgumentError"
    expect( -> @enum2.any(1, 2, 3) ).toThrow "ArgumentError"

  it "does not hide exceptions out of #each", ->
    expect( ->
      EnumerableSpecs.ThrowingEach.new().any()
    ).toThrow "RuntimeError"

    expect( ->
      EnumerableSpecs.ThrowingEach.new().any(-> false)
    ).toThrow "RuntimeError"


  describe "with no block", ->
    it "returns true if any element is not false or nil", ->
      # why does this not work?
      # expect( @enum.any()  ).toEqual true
      expect( @enum1.any() ).toEqual true
      expect( @enum2.any() ).toEqual true

      expect( EnumerableSpecs.Numerous.new(true).any()).toEqual true
      expect( EnumerableSpecs.Numerous.new('a','b','c').any()).toEqual true
      expect( EnumerableSpecs.Numerous.new('a','b','c', null).any()).toEqual true
      expect( EnumerableSpecs.Numerous.new(1, null, 2).any()).toEqual true
      expect( EnumerableSpecs.Numerous.new(1, false).any()).toEqual true
      expect( EnumerableSpecs.Numerous.new(false, null, 1, false).any()).toEqual true
      expect( EnumerableSpecs.Numerous.new(false, 0, null).any()).toEqual true

    it "returns false if all elements are false or nil", ->
      expect( EnumerableSpecs.Numerous.new(false).any()).toEqual false
      expect( EnumerableSpecs.Numerous.new(false, false).any()).toEqual false
      expect( EnumerableSpecs.Numerous.new(null).any()).toEqual false
      expect( EnumerableSpecs.Numerous.new(null, null).any()).toEqual false
      expect( EnumerableSpecs.Numerous.new(null, false, null).any()).toEqual false

  #   it "gathers whole arrays as elements when each yields multiple", ->
  #     multi = EnumerableSpecs::YieldsMultiWithFalse.new
  #     multi.any?.should be_true

  describe "with block", ->
    it "returns true if the block ever returns other than false or nil", ->
      # expect( @enum.any(-> true) ).toEqual true
      # expect( @enum.any(-> 0) ).toEqual true
      # expect( @enum.any(-> 1) ).toEqual true

      expect( @enum1.any(-> new Object()) ).toEqual true
      expect( @enum1.any((o) -> o < 1 ) ).toEqual true
      expect( @enum1.any((o) -> 5 ) ).toEqual true
      expect( @enum2.any((i) -> i == null ) ).toEqual true

    it "any? should return false if the block never returns other than false or nil", ->
      # expect( @enum.any( -> false ) ).toEqual false
      # expect( @enum.any( -> null ) ).toEqual false
      expect( @enum1.any( (o) -> o < -10 ) ).toEqual false
      expect( @enum1.any( (o) -> null ) ).toEqual false
      expect( @enum2.any( (i) -> i == "stuff" ) ).toEqual false

  #   it "stops iterating once the return value is determined", ->
  #     yielded = []
  #     EnumerableSpecs::Numerous.new(:one, :two, :three).any? do |e|
  #       yielded << e
  #       false
  #     end.should == false
  #     yielded.should == [:one, :two, :three]

  #     yielded = []
  #     EnumerableSpecs::Numerous.new(true, true, false, true).any? do |e|
  #       yielded << e
  #       e
  #     end.should == true
  #     yielded.should == [true]

  #     yielded = []
  #     EnumerableSpecs::Numerous.new(false, nil, false, true, false).any? do |e|
  #       yielded << e
  #       e
  #     end.should == true
  #     yielded.should == [false, nil, false, true]

  #     yielded = []
  #     EnumerableSpecs::Numerous.new(1, 2, 3, 4, 5).any? do |e|
  #       yielded << e
  #       e
  #     end.should == true
  #     yielded.should == [1]


    it "does not hide exceptions out of #each", ->
      expect( ->
        EnumerableSpecs.ThrowingEach.new().any()
      ).toThrow "RuntimeError"

      expect( ->
        EnumerableSpecs.ThrowingEach.new().any(-> false)
      ).toThrow "RuntimeError"

  #   ruby_version_is "" ... "1.9", ->
  #     it "gathers whole arrays as elements when each yields multiple", ->
  #       multi = EnumerableSpecs::YieldsMulti.new
  #       multi.any? {|e| e == [1, 2] }.should be_true

    describe 'ruby_version_is "1.9"', ->
      it "gathers initial args as elements when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        expect( multi.any (e) -> e == 1 ).toEqual true

      it "yields multiple arguments when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        yielded = []
        multi.any (e, i) -> yielded.push [e, i]
        expect( yielded ).toEqual [[1, 2]]

