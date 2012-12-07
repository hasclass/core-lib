describe 'ruby_version_is "1.9"', ->

  describe "Array#sort_by!", ->
    it "sorts array in place by passing each element to the given block", ->
      a = R [-100, -2, 1, 200, 30000]
      a.sort_by_bang (e) -> R(e).to_s().size()
      expect( a ).toEqual R([1, -2, 200, -100, 30000])

    it "returns an Enumerator if not given a block", ->
      expect( R([1,2]).sort_by_bang() ).toBeInstanceOf R.Enumerator

    it "completes when supplied a block that always returns the same result", ->
      a = R [2, 3, 5, 1, 4]
      a.sort_by_bang -> R(1 )
      expect( a.is_array? ).toEqual true
      a.sort_by_bang -> R( 0 )
      expect( a.is_array? ).toEqual true
      a.sort_by_bang -> R(-1 )
      expect( a.is_array? ).toEqual true

    # it "raises a RuntimeError on a frozen array", ->
    #   expect( -> ArraySpecs.frozen_array.sort_by_bang {}).toThrow(RuntimeError)

    # it "raises a RuntimeError on an empty frozen array", ->
    #   expect( -> ArraySpecs.empty_frozen_array.sort_by! {}).toThrow(RuntimeError)

    xit "returns the specified value when it would break in the given block", ->
      # [1, 2, 3].sort_by!{ break :a }.should == :a

    xit "makes some modification even if finished sorting when it would break in the given block", ->
      # partially_sorted = (1..5).map{|i|
      #   ary = [5, 4, 3, 2, 1]
      #   ary.sort_by!{|x,y| break if x==i; x<=>y}
      #   ary
      # }
      # partially_sorted.any?{|ary| ary != [1, 2, 3, 4, 5]}.should be_true
