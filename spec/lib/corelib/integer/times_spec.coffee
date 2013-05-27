describe "Integer#times custom", ->
  it "returns self if always break", ->
    expect( R(3).times -> return 'next' ).toEqual R(3)

describe "Integer#times", ->
  it "returns self", ->
    expect( R(5).times( -> )).toEqual  R(5)
    expect( R(9).times( -> )).toEqual  R(9)
    expect( R(9).times( (n) -> n - 2)).toEqual  R(9)

  it "yields each value from 0 to self - 1", ->
    a = []
    R(9).times (i) -> a.push(i)
    R(-2).times (i) -> a.push(i)
    expect(a).toEqual [0, 1, 2, 3, 4, 5, 6, 7, 8]

  it "skips the current iteration when encountering 'next'", ->
    a = []
    ret = R(3).times (i) ->
      return 'next' if i == 1
      a.push(i)
    expect(a).toEqual [0, 2]

  it "skips all iterations when encountering 'break'", ->
    a = []
    x = R.catch_break (_b) ->
      R(5).times (i) ->
        _b.break() if i == 3
        a.push(i)

    expect(x).toEqual null
    expect(a).toEqual [0, 1, 2]

  it "skips all iterations when encountering break with an argument and returns that argument", ->
    expect(R.catch_break (_b) -> R(9).times(-> _b.break(1) )).toEqual 1

  it "executes a nested while loop containing a break expression", ->
    a = [true, false]
    b = R.catch_break (_b) ->
      R(2).times (i) ->
        while e = a.shift()
          if e
            _b.break(1)
          else
            expect(e).toEqual true
    expect(b).toEqual 1

  it "executes a nested #times", ->
    a = 0
    b = R(3).times (i) ->
      R(2).times -> a += 1
    expect(a).toEqual 6
    expect(b).toEqual R(3)

  # ruby_version_is "" ... "1.8.7", ->
  #   it "raises a LocalJumpError when no block given", ->
  #     lambda { 3.times }.should raise_error(LocalJumpError)

  # ruby_version_is "1.8.7", ->
  #   it "returns an Enumerator", ->
  #     result = []

  #     enum = 3.times
  #     enum.each { |i| result << i }

  #     result.should == [0, 1, 2]
  # end
