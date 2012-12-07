describe "Enumerable#each_with_object", ->

  beforeEach ->
    @values = R.$Array_r [2, 5, 3, 6, 1, 4]
    @enum = EnumerableSpecs.Numerous.new(2, 5, 3, 6, 1, 4)
    @initial = R "memo"

  it "passes each element and its argument to the block", ->
    initial = @initial
    acc    = R []

    ret = @enum.each_with_object initial, (elem, obj) ->
        expect( obj ).toEqual(R('memo'))
        obj = 42
        acc.push(elem)

    expect( ret ).toEqual(R('memo'))
    expect( acc ).toEqual @values

  it "does not work with primitive (e.g. strings)", ->
    ret = @enum.each_with_object "", (e, o) -> o += e
    expect( ret ).toEqual('')

  it "does work with jruby objects", ->
    ret = @enum.each_with_object R(""), (e, o) -> o.replace(o+e)
    expect( ret.unbox() ).toEqual('253614')

  it "does not overwrite the object", ->
    ret = @enum.each_with_object R(""), (e, o) ->
      o.replace(o+e)
      o = 'foo'
    expect( ret.unbox() ).toEqual('253614')

  it "does work with arrays", ->
    ret = @enum.each_with_object [], (e, o) -> o.push(e.unbox())
    expect( ret ).toEqual([2, 5, 3, 6, 1, 4])

  it "returns an enumerator if no block", ->
    initial = @initial
    acc    = R []

    e = @enum.each_with_object(initial)
    ret = e.each (elem, obj) ->
      expect(obj).toEqual(initial)
      obj = 42
      acc.push elem

    expect( ret ).toEqual(initial)
    expect( acc ).toEqual @values

  xit "gathers whole arrays as elements when each yields multiple", ->
    # multi = EnumerableSpecs::YieldsMulti.new
    # array = R []
    # multi.each_with_object(array) { |elem, obj| obj << elem }
    # array.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]

