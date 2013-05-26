describe "Integer#upto [stop] when self and stop are Fixnums", ->
  it "does not yield when stop is less than self", ->
    result = []
    R(5).upto(4, (x) -> result.push(x))
    expect(result).toEqual []

  it "yields once when stop equals self", ->
    result = []
    R(5).upto(5, (x) -> result.push(x))
    expect(result).toEqual [5]

  it "yields while increasing self until it is less than stop", ->
    result = []
    R(2).upto(5, (x) -> result.push(x))
    expect(result).toEqual [2, 3, 4, 5]

  it "yields while increasing self until it is greater than floor of a Float endpoint", ->
    result = []
    R(9).upto( 13.3, (i) -> result.push(i))
    R(-5).upto(-1.3, (i) -> result.push(i))
    expect(result).toEqual [9,10,11,12,13,-5,-4,-3,-2]

  it "raises an ArgumentError for non-numeric endpoints", ->
    expect( -> R(1).upto("A", (x) -> ) ).toThrow "ArgumentError"
    expect( -> R(1).upto(null, (x) -> ) ).toThrow "ArgumentError"

  # ruby_version_is "" ... "1.8.7", ->
  #   it "raises a LocalJumpError when no block given", ->
  #     lambda { 2.upto(5) }.should raise_error(LocalJumpError)

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an Enumerator", ->
      result = R []
      en = R(2).upto(5)
      en.each (i) -> result.push(i)
      expect( result.unbox(true) ).toEqual [2, 3, 4, 5]
