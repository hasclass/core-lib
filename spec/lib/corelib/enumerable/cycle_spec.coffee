# describe 'ruby_version_is "1.8.7"', ->

describe "Enumerable#cycle", ->
  it "loops indefinitely if no argument or nil argument", ->
    R( [undefined,null] ).each (args) ->
      bomb = 10
      result = R.catch_break( (breaker) ->
        EnumerableSpecs.Numerous.new().cycle args, ->
          bomb -= 1
          breaker.break(42) if bomb <= 0
      )
      expect( result ).toEqual 42
      expect( bomb   ).toEqual 0

  it "returns if there are no elements", ->
    out = R.catch_break (breaker) ->
      EnumerableSpecs.Empty.new().cycle -> breaker.break('nope')
    expect( out ).toEqual null

  it "yields successive elements of the array repeatedly", ->
    b = R []
    out = R.catch_break (breaker) ->
      EnumerableSpecs.Numerous.new(1,2,3).cycle (elem) ->
        b.push elem
        breaker.break() if b.size().equals 7

    expect( b ).toEqual R.$Array_r([1,2,3,1,2,3,1])

  describe "passed a number n as an argument", ->

    it "returns nil and does nothing for non positive n", ->
      expect( EnumerableSpecs.Numerous.new().cycle(  0, -> throw 'no cycle') ).toEqual null
      expect( EnumerableSpecs.Numerous.new().cycle(-22, -> throw 'no cycle') ).toEqual null

    xit "calls each at most once", ->
      # TODO: implemented but not tested
      # enum = EnumerableSpecs.EachCounter.new(1, 2)
      # enum.cycle(3).to_a.should == [1,2,1,2,1,2]
      # enum.times_called.should == 1

    xit "yields only when necessary", ->
      # TODO: implemented but not tested
      # enum = EnumerableSpecs.EachCounter.new(10, 20, 30)
      # enum.cycle(3) { |x| break if x == 20}
      # enum.times_yielded.should == 2

    it "tries to convert n to an Integer using #valueOf", ->
      en = EnumerableSpecs.Numerous.new(3, 2, 1)
      expect( en.cycle(2.3).to_a() ).toEqual R.$Array_r([3, 2, 1, 3, 2, 1])

      obj =
        valueOf: -> 2
      expect( en.cycle(obj).to_a() ).toEqual R.$Array_r([3, 2, 1, 3, 2, 1])

    xit "raises a TypeError when the passed n can be coerced to Integer", ->
      en = EnumerableSpecs.Numerous.new()
      expect( -> en.cycle("cat", -> null ) ).toThrow('TypeError')

    it "raises an ArgumentError if more arguments are passed", ->
      en = EnumerableSpecs.Numerous.new()
      # expect( ->  en.cycle(1, 2)     ).toThrow('ArgumentError')
      expect( ->  en.cycle(1, 2, ->) ).toThrow('ArgumentError')

    xit "gathers whole arrays as elements when each yields multiple", ->
      # TODO: implement (iterates to death atm)
      multi = new EnumerableSpecs.YieldsMulti()
      expect( multi.cycle(2).to_a() ).toEqual R([[1, 2], [3, 4, 5], [6, 7, 8, 9], [1, 2], [3, 4, 5], [6, 7, 8, 9]])

