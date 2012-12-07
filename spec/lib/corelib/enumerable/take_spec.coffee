describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#take", ->
    it "requires an argument", ->
      expect( ->  EnumerableSpecs.Numerous.new().take() ).toThrow('ArgumentError')

describe "Enumerable#take", ->
  beforeEach ->
    @values = [4,3,2,1,0,-1]
    @en = EnumerableSpecs.Numerous.new(4,3,2,1,0,-1)

  it "returns the first count elements if given a count", ->
    expect( @en.take(2) ).toEqual R.$Array_r([4, 3])
    expect( @en.take(4) ).toEqual R.$Array_r([4, 3, 2, 1]) # See redmine #1686 !

  it "returns an empty array when passed count on an empty array", ->
    empty = EnumerableSpecs.Empty.new()
    expect( empty.take(0) ).toEqual R.$Array_r([])
    expect( empty.take(1) ).toEqual R.$Array_r([])
    expect( empty.take(2) ).toEqual R.$Array_r([])

  it "returns an empty array when passed count == 0", ->
    expect( @en.take(0) ).toEqual R.$Array_r([])

  it "returns an array containing the first element when passed count == 1", ->
    expect( @en.take(1) ).toEqual R.$Array_r([4])

  it "raises an ArgumentError when count is negative", ->
    en = @en
    expect( -> en.take(-1) ).toThrow('ArgumentError')

  it "returns the entire array when count > length", ->
    expect( @en.take(100) ).toEqual R.$Array_r(@values)
    expect( @en.take(8) ).toEqual   R.$Array_r(@values)  # See redmine #1686 !

  it "tries to convert the passed argument to an Integer using #to_int", ->
    obj =
      to_int: -> R(3)
    expect( @en.take(obj) ).toEqual R.$Array([4, 3, 2], true)

  it "raises a TypeError if the passed argument is not numeric", ->
    en = @en
    expect( -> en.take(null) ).toThrow('TypeError')
    expect( -> en.take("a") ).toThrow('TypeError')
    expect( -> en.take({}) ).toThrow('TypeError')

  xit "gathers whole arrays as elements when each yields multiple", ->
    # multi = EnumerableSpecs.YieldsMulti.new
    # expect( multi.take(1) ).toEqual R([[1, 2]])

  # ruby_bug "#1554", "1.9.1", ->
  #   it "consumes only what is needed", ->
  #     thrower = EnumerableSpecs.ThrowingEach.new
  #     expect( thrower.take(0) ).toEqual R([])
  #     counter = EnumerableSpecs.EachCounter.new(1,2,3,4)
  #     expect( counter.take(2) ).toEqual R([1,2])
  #     expect( counter.times_called ).toEqual 1
  #     expect( counter.times_yielded ).toEqual 2
