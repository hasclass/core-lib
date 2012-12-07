
describe "Range#step", ->

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an enumerator when no block is given", ->
      en = R.Range.new(1, 10).step(4)
      expect( en ).toBeInstanceOf(R.Enumerator)
      expect( en.to_a().unbox(true) ).toEqual([1, 5, 9])

  it "returns self", ->
    r = R.Range.new(1,2)
    expect( r.step(->) ).toEqual(r)

  it "raises a TypeError if step does not respond to #to_int", ->
    obj = {}
    expect( -> R.Range.new(1, 10).step(obj, ->) ).toThrow('TypeError')

  it "calls #to_int to coerce step to an Integer", ->
    obj = {to_int: -> R(1)}
    acc = []
    R.Range.new(1,2).step obj, (x) -> acc.push(x.to_native())
    expect( acc ).toEqual([1,2])

  # TODO Fix special case
  xit "raises a TypeError if #to_int does not return an Integer", ->
    obj = {to_int: -> "1" }
    expect( -> (R.Range.new(1,2)).step(obj, ->) ).toThrow('TypeError')

  it "coerces the argument to integer by invoking to_int", ->
    obj = {to_int: -> R(2)}
    res = []
    R.Range.new(1, 10).step(obj, (x) -> res.push(x.to_native()))
    expect( res ).toEqual [1, 3, 5, 7, 9]

  # it "raises a TypeError if the first element does not respond to #succ", ->
  #   obj = mock("Range#step non-comparable")
  #   obj.should_receive(:<=>).with(obj).and_return(1)

  #   expect( -> (obj..obj).step { |x| x } ).toThrow('TypeError')

  it "raises an ArgumentError if step is 0", ->
    expect( -> R.Range.new(-1, 1).step(0, (x) -> x)  ).toThrow('ArgumentError')

  it "raises an ArgumentError if step is 0.0", ->
    expect( -> R.Range.new(-1, 1).step(0.0, (x) -> x)  ).toThrow('ArgumentError')

  it "raises an ArgumentError if step is negative", ->
    expect( -> R.Range.new(-1, 1).step(-2, (x) -> x)  ).toThrow('ArgumentError')


  describe "with inclusive end", ->
    describe "and Integer values", ->
      it "yields Integer values incremented by 1 and less than or equal to end when not passed a step", ->
        acc = []
        R.Range.new(-2, 2).step (x) -> acc.push(x.to_native())
        expect( acc ).toEqual([-2, -1, 0, 1, 2])

      it "yields Integer values incremented by an Integer step", ->
        acc = []
        R.Range.new(-5,5).step(2, (x) -> acc.push(x.to_native()) )
        expect( acc ).toEqual([-5, -3, -1, 1, 3, 5])

      # describe 'ruby_version_is ""..."1.8.7"', ->
      #   it "yields truncated Integer values incremented by a Float step", ->
      #     acc = []
      #     R.Range.new(-2, 2).step(1.5, (x) -> acc.push(x.to_native()) )
      #     expect( acc ).toEqual([-2, -1, 0, 1, 2])

      describe 'ruby_version_is "1.8.7"', ->
        it "yields Float values incremented by a Float step", ->
          acc = []
          R.Range.new(-2, 2).step(1.5, (x) -> acc.push(x.to_native()) )
          expect( acc ).toEqual([-2.0, -0.5, 1.0])

    describe "and Float values", ->
      it "yields Float values incremented by 1 and less than or equal to end when not passed a step", ->
        acc = []
        R.Range.new(-2.0, 2.0).step (x) -> acc.push(x.to_native())
        expect( acc ).toEqual([-2.0, -1.0, 0.0, 1.0, 2.0])

      it "yields Float values incremented by an Integer step", ->
        acc = []
        R.Range.new(-5.0, 5.0).step(2, (x) -> acc.push(x.to_native()) )
        expect( acc ).toEqual([-5.0, -3.0, -1.0, 1.0, 3.0, 5.0])

      it "yields Float values incremented by a Float step", ->
        acc = []
        R.Range.new(-1.0, 1.0).step(0.5, (x) -> acc.push(x.to_native()) )
        expect( acc ).toEqual([-1.0, -0.5, 0.0, 0.5, 1.0])

      describe 'ruby_bug "redmine #4576", "1.9.3"', ->
        xit "returns Float values of 'step * n + begin <= end'", ->
          acc = []
          R.Range.new(1.0, 6.4).step(1.8, (x) -> acc.push(x.round(1).to_native()) )
          R.Range.new(1.0, 12.7).step(1.3, (x) -> acc.push(x.round(1).to_native()) )
          expect( acc ).toEqual([1.0, 2.8, 4.6, 6.4, 1.0, 2.3, 3.6,
                                         4.9, 6.2, 7.5, 8.8, 10.1, 11.4, 12.7])

    describe "and Integer, Float values", ->
      describe 'ruby_version_is "1.8.7"', ->
        it "yields Float values incremented by 1 and less than or equal to end when not passed a step", ->
          acc = []
          R.Range.new(-2, 2.0).step (x) -> acc.push( x.to_native() )
          expect( acc ).toEqual([-2.0, -1.0, 0.0, 1.0, 2.0])

        it "yields Float values incremented by an Integer step", ->
          acc = []
          R.Range.new(-5, 5.0).step(2, (x) -> acc.push( x.to_native() ))
          expect( acc ).toEqual([-5.0, -3.0, -1.0, 1.0, 3.0, 5.0])

        it "yields Float values incremented by a Float step", ->
          acc = []
          R.Range.new(-1, 1.0).step(0.5, (x) -> acc.push( x.to_native() ))
          expect( acc ).toEqual([-1.0, -0.5, 0.0, 0.5, 1.0])


    describe "and Float, Integer values", ->
      it "yields Float values incremented by 1 and less than or equal to end when not passed a step", ->
        acc = []
        R.Range.new(-2.0, 2).step (x) -> acc.push( x.to_native() )
        expect( acc ).toEqual([-2.0, -1.0, 0.0, 1.0, 2.0])

      it "yields Float values incremented by an Integer step", ->
        acc = []
        R.Range.new(-5.0, 5).step(2, (x) -> acc.push( x.to_native() ))
        expect( acc ).toEqual([-5.0, -3.0, -1.0, 1.0, 3.0, 5.0])

      it "yields Float values incremented by a Float step", ->
        acc = []
        R.Range.new(-1.0, 1).step(0.5, (x) -> acc.push( x.to_native() ))
        expect( acc ).toEqual([-1.0, -0.5, 0.0, 0.5, 1.0])

    describe "and String values", ->
      it "yields String values incremented by #succ and less than or equal to end when not passed a step", ->
        acc = []
        R.Range.new("A", "E").step( (x) -> acc.push( x.to_native() ) )
        expect( acc ).toEqual  ["A", "B", "C", "D", "E"]

      it "yields String values incremented by #succ called Integer step times", ->
        acc = []
        R.Range.new("A", "G").step(2, (x) -> acc.push( x.to_native() ) )
        expect( acc ).toEqual  ["A", "C", "E", "G"]

      # describe 'ruby_version_is ""..."1.8.7"', ->
      #   it "yields String values incremented by #succ called Float step times", ->
      #     acc = []
      #     R.Range.new("A", "G").step(2.0, (x) -> acc.push( x.to_native() ))
      #     expect( acc ).toEqual  ["A", "C", "E", "G"]

      describe 'ruby_version_is "1.8.7"', ->
        xit "raises a TypeError when passed a Float step", ->
          expect( -> R.Range.new("A", "G").step(2.0, ->) ).toThrow('TypeError')

      xit "calls #succ on begin and each element returned by #succ", ->
        # obj =
        #   '<=>').exactly(3).times.and_return(-1, -1, -1, 0)
        # obj.should_receive(:succ).exactly(2).times.and_return(obj)

        # acc = []
        # R.Range.new(obj..obj).step { |x| ScratchPad << x }
        # expect( acc ).toEqual  [obj, obj, obj]

  describe "with exclusive end", ->
    describe "and Integer values", ->
      it "yields Integer values incremented by 1 and less than end when not passed a step", ->
        acc = []
        R.Range.new(-2, 2, true).step (x) -> acc.push(x.to_native())
        expect( acc ).toEqual([-2, -1, 0, 1])

      it "yields Integer values incremented by an Integer step", ->
        acc = []
        R.Range.new(-5, 5, true).step(2, (x) -> acc.push(x.to_native()))
        expect( acc ).toEqual([-5, -3, -1, 1, 3])

      describe 'ruby_version_is "1.8.7"', ->
        it "yields Float values incremented by a Float step", ->
          acc = []
          R.Range.new(-2, 2, true).step(1.5, (x) -> acc.push(x.to_native()))
          expect( acc ).toEqual([-2.0, -0.5, 1.0])

    describe "and Float values", ->
      it "yields Float values incremented by 1 and less than end when not passed a step", ->
        acc = []
        R.Range.new(-2.0, 2.0, true).step (x) -> acc.push(x.to_native())
        expect( acc ).toEqual([-2.0, -1.0, 0.0, 1.0])

      it "yields Float values incremented by an Integer step", ->
        acc = []
        R.Range.new(-5.0, 5.0, true).step(2, (x) -> acc.push(x.to_native()))
        expect( acc ).toEqual([-5.0, -3.0, -1.0, 1.0, 3.0])

      it "yields Float values incremented by a Float step", ->
        acc = []
        R.Range.new(-1.0, 1.0, true).step(0.5, (x) -> acc.push(x.to_native()))
        expect( acc ).toEqual([-1.0, -0.5, 0.0, 0.5])

      describe 'ruby_bug "redmine #4576", "1.9.3"', ->
        xit "returns Float values of 'step * n + begin < end'", ->
          acc = []
          R.Range.new(1.0, 6.4, true).step(1.8, (x) -> acc.push(x.to_native()))
          R.Range.new(1.0, 55.6, true).step(18.2, (x) -> acc.push(x.to_native()))
          expect( acc ).toEqual([1.0, 2.8, 4.6, 1.0, 19.2, 37.4])

    describe "and Integer, Float values", ->
      describe 'ruby_version_is "1.8.7"', ->
        it "yields Float values incremented by 1 and less than end when not passed a step", ->
          acc = []
          R.Range.new(-2, 2.0, true).step (x) -> acc.push(x.to_native())
          expect( acc ).toEqual([-2.0, -1.0, 0.0, 1.0])

        it "yields Float values incremented by an Integer step", ->
          acc = []
          R.Range.new(-5, 5.0, true).step(2, (x) -> acc.push(x.to_native()))
          expect( acc ).toEqual([-5.0, -3.0, -1.0, 1.0, 3.0])

        it "yields an Float and then Float values incremented by a Float step", ->
          acc = []
          R.Range.new(-1, 1.0, true).step(0.5, (x) -> acc.push(x.to_native()))
          expect( acc ).toEqual([-1.0, -0.5, 0.0, 0.5])

    describe "and Float, Integer values", ->
      it "yields Float values incremented by 1 and less than end when not passed a step", ->
        acc = []
        R.Range.new(-2.0,2, true).step (x) -> acc.push(x.to_native())
        expect( acc).toEqual([-2.0, -1.0, 0.0, 1.0])

      it "yields Float values incremented by an Integer step", ->
        acc = []
        R.Range.new(-5.0,5, true).step(2, (x) -> acc.push(x.to_native()) )
        expect( acc).toEqual([-5.0, -3.0, -1.0, 1.0, 3.0])

      it "yields Float values incremented by a Float step", ->
        acc = []
        R.Range.new(-1.0,1, true).step(0.5, (x) -> acc.push(x.to_native()) )
        expect( acc).toEqual([-1.0, -0.5, 0.0, 0.5])

    describe "and String values", ->
      it "yields String values incremented by #succ and less than or equal to end when not passed a step", ->
        acc = []
        R.Range.new("A", "E", true).step (x) -> acc.push(x.to_native())
        expect( acc ).toEqual  ["A", "B", "C", "D"]

      it "yields String values incremented by #succ called Integer step times", ->
        acc = []
        R.Range.new("A", "G", true).step(2, (x) -> acc.push(x.to_native()) )
        expect( acc ).toEqual  ["A", "C", "E"]

      describe 'ruby_version_is "1.8.7"', ->
        xit "raises a TypeError when passed a Float step", ->
          expect( -> R.Range.new("A", "G", true).step(2.0, ->) ).toThrow('TypeError')
