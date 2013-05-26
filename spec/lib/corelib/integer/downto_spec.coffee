describe "Integer#downto [stop] when self and stop are Fixnums", ->
  it "does not yield when stop is greater than self", ->
    result = []
    R(5).downto(6, (x) -> result.push(x) )
    expect( result ).toEqual []

  it "yields once when stop equals self", ->
    result = []
    R(5).downto(5, (x) -> result.push(x) )
    expect( result ).toEqual [5]

  it "yields while decreasing self until it is less than stop", ->
    result = []
    R(5).downto(2, (x) -> result.push(x) )
    expect( result ).toEqual [5, 4, 3, 2]

  it "yields while decreasing self until it less than ceil for a Float endpoint", ->
    result = []
    R(9).downto(1.3, (x) -> result.push(x) )
    R(3).downto(-1.3, (x) -> result.push(x) )
    expect( result ).toEqual [9, 8, 7, 6, 5, 4, 3, 2, 3, 2, 1, 0, -1]

  it "raises a ArgumentError for invalid endpoints", ->
    expect( -> R(1).downto("A", (x) -> ) ).toThrow "ArgumentError"
    expect( -> R(1).downto(null, (x) -> ) ).toThrow "ArgumentError"



  # ruby_version_is "" ... "1.8.7", ->
  #   it "does not require a block if self is less than stop", ->
  #     1.downto(2).should equal(1)

  #   it "raises a LocalJumpError when no block given", ->
  #     lambda { 5.downto(2) }.should raise_error(LocalJumpError)


  # ruby_version_is "1.8.7", ->
  #   it "returns an Enumerator", ->
  #     result = []

  #     enum = 5.downto(2)
  #     enum.each { |i| result << i }

  #     expect( result ).toEqual [5, 4, 3, 2]
