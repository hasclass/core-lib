
describe "Enumerable#all?", ->

  beforeEach ->
    @enum  = new EnumerableSpecs.Numerous()
    @empty = new EnumerableSpecs.Empty()
    @enum1 = R([0, 1, 2, -1])
    @enum2 = R([null, false, true])


  it "always returns true on empty enumeration", ->
    expect(@empty.all()).toEqual true
    expect(@empty.all(-> null)).toEqual true

    expect(R.$Array([]).all()).toEqual true
    expect(R.$Array([]).all( -> false )).toEqual true

  xit "implement", ->
    # {}.all?.should == true
    # {}.all? { nil }.should == true

  it "does not hide exceptions out of #each", ->
    expect( ->
      EnumerableSpecs.ThrowingEach.new().all()
    ).toThrow "RuntimeError"

    expect( ->
      EnumerableSpecs.ThrowingEach.new().all(-> false)
    ).toThrow "RuntimeError"

  describe "with no block", ->
    it "returns true if no elements are false or nil", ->
      expect( @enum.each().length  ).toEqual 6
      expect( @enum.all()  ).toEqual true
      expect( @enum1.all() ).toEqual true
      expect( @enum2.all() ).toEqual false

      expect(
        EnumerableSpecs.Numerous.new('a','b','c').all()
      ).toEqual true

      expect(
        EnumerableSpecs.Numerous.new(0, "x", true).all()
      ).toEqual true


    it "returns false if there are false or nil elements", ->
      expect(new EnumerableSpecs.Numerous(false).all()        ).toEqual false
      expect(new EnumerableSpecs.Numerous(false, false).all() ).toEqual false

      expect(new EnumerableSpecs.Numerous(null).all()          ).toEqual false
      expect(new EnumerableSpecs.Numerous(null, null).all()     ).toEqual false

      expect(new EnumerableSpecs.Numerous(1, null, 2).all()    ).toEqual false
      expect(new EnumerableSpecs.Numerous(0, "x", false, true).all()).toEqual false
      expect(@enum2.all()).toEqual false

    # multiple yields not yet possible
    xit "gathers whole arrays as elements when each yields multiple", ->
      multi = new EnumerableSpecs.YieldsMultiWithFalse()
      expect( multi.all() ).toEqual true


  describe "with block", ->
    it "returns true if the block never returns false or null", ->
      expect( @enum.all(-> true )       ).toEqual true
      expect( @enum1.all((o) -> o < 5 ) ).toEqual true
      expect( @enum1.all((o) -> 5 )     ).toEqual true


    it "returns false if the block ever returns false or nil", ->
      expect( @enum.all(-> false )      ).toEqual false
      expect( @enum.all(-> null  )      ).toEqual false
      expect( @enum1.all((o) -> o > 2 ) ).toEqual false

      expect( EnumerableSpecs.Numerous.new().all((i) -> i > 5 )).toEqual false
      expect( EnumerableSpecs.Numerous.new().all((i) -> i == 3 ? null : true )).toEqual false

#     it "stops iterating once the return value is determined", ->
#       yielded = []
#       EnumerableSpecs::Numerous.new(:one, :two, :three).all? do |e|
#         yielded << e
#         false
#       end.toEqual false
#       yielded.toEqual [:one]

#       yielded = []
#       EnumerableSpecs::Numerous.new(true, true, false, true).all? do |e|
#         yielded << e
#         e
#       end.toEqual false
#       yielded.toEqual [true, true, false]

#       yielded = []
#       EnumerableSpecs::Numerous.new(1, 2, 3, 4, 5).all? do |e|
#         yielded << e
#         e
#       end.toEqual true
#       yielded.toEqual [1, 2, 3, 4, 5]
#     end

    # already tested
    # it "does not hide exceptions out of the block", ->
    #   lambda {
    #     @enum.all? { raise "from block" }
    #   }.should raise_error(RuntimeError)
    # end

#     ruby_version_is "" ... "1.9", ->
#       it "gathers whole arrays as elements when each yields multiple", ->
#         multi = EnumerableSpecs::YieldsMulti.new
#         multi.all? {|e| Array === e}.should be_true
#       end
#     end

    describe 'ruby_version_is "1.9"', ->
      it "gathers initial args as elements when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        expect( multi.all (e) -> !(e.is_array?) ).toEqual true

      it "yields multiple arguments when each yields multiple", ->
        multi = new EnumerableSpecs.YieldsMulti()
        yielded = []
        multi.all (e, i) -> yielded.push [e, i]
        expect( yielded ).toEqual [[1, 2], [3, 4], [6, 7]]
