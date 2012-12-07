describe "Array#cycle", ->
  beforeEach ->
    @arr = []
    arr = @arr
    @ary = R([1, 2, 3])
    @prc = (x) -> arr.push(x)

  it "does not yield and returns nil when the array is empty", ->
    expect( R([]).cycle(6, @prc)).toEqual null
    expect( @arr ).toEqual []

  it "does not yield and returns nil when passed 0", ->
    expect( @ary.cycle(0, @prc)).toEqual null
    expect( @arr ).toEqual []

  it "iterates the array 'count' times yielding each item to the block", ->
    @ary.cycle(2, @prc)
    expect( @arr ).toEqual [1, 2, 3, 1, 2, 3]

  it "iterates indefinitely when not passed a count", ->
    arr = @arr
    ary = @ary
    R.catch_break (breaker) ->
      ary.cycle (x) ->
        arr.push x
        breaker.break() if arr.length > 7
    expect( @arr ).toEqual [1, 2, 3, 1, 2, 3, 1, 2]

  it "iterates indefinitely when passed nil", ->
    arr = @arr
    ary = @ary
    R.catch_break (breaker) ->
      ary.cycle null, (x) ->
        arr.push x
        breaker.break() if arr.length > 7
    expect( @arr ).toEqual [1, 2, 3, 1, 2, 3, 1, 2]

  xit "does not rescue StopIteration when not passed a count", ->
  #   lambda do
  #     @ary.cycle { raise StopIteration }
  #   end.should raise_error(StopIteration)

  xit "does not rescue StopIteration when passed a count", ->
  #   lambda do
  #     @ary.cycle(3) { raise StopIteration }
  #   end.should raise_error(StopIteration)

  it "iterates the array Integer(count) times when passed a Float count", ->
    @ary.cycle(2.7, @prc)
    expect( @arr ).toEqual [1, 2, 3, 1, 2, 3]

  it "calls #to_int to convert count to an Integer", ->
    count =
      to_int: -> R(2)
    @ary.cycle(count, @prc)
    expect( @arr ).toEqual [1, 2, 3, 1, 2, 3]

  xit "raises a TypeError if #to_int does not return an Integer", ->
  #   count = mock("cycle count 2")
  #   count.should_receive(:to_int).and_return("2")

  #   expect( -> @ary.cycle(count, @prc) ).toThrow(TypeError)

  it "raises a TypeError if passed a String", ->
    ary = @ary
    expect( -> ary.cycle('4', ->) ).toThrow('TypeError')

  it "raises a TypeError if passed an Object", ->
    ary = @ary
    expect( -> ary.cycle({}, ->) ).toThrow('TypeError')

  it "raises a TypeError if passed true", ->
    ary = @ary
    expect( -> ary.cycle(true, ->) ).toThrow('TypeError')

  it "raises a TypeError if passed false", ->
    ary = @ary
    expect( -> ary.cycle(false, ->) ).toThrow('TypeError')
