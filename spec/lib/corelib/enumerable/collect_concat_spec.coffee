describe "Enumerable#collect_concat", ->
  it "returns a new array with the results of passing each element to block, flattened one level", ->
    numerous = EnumerableSpecs.Numerous.new(1, [2, 3], [4, [5, 6]], {'foo': 'bar'})
    expect(numerous.collect_concat((i) -> i) ).toEqual R([R(1), 2, 3, 4, [5, 6], {foo: 'bar'}])
    # numerous.collect_concat((i) -> i).inspect() ).toEqual R('[1, 2, 3, 4, [5, 6],  {"foo": "bar"}]')


  it "skips elements that are empty Arrays", ->
    numerous = EnumerableSpecs.Numerous.new(1, [], 2)
    expect( numerous.collect_concat((i) -> i) ).toEqual R([1, 2], true)

  it "calls to_ary but not to_a", ->
    obj =
      to_ary: -> R(["foo"])

    obj2 =
      to_a: -> throw 'should not receive'

    numerous = EnumerableSpecs.Numerous.new(obj, obj2)
    expect( numerous.collect_concat (i) -> i ).toEqual R(["foo", obj2])

  it "returns an enumerator when no block given", ->
    en = R.$Array_r([1, 2]).collect_concat()
    expect( en ).toBeInstanceOf(RubyJS.Enumerator)
    expect( en.each((i) -> i * i ).inspect()).toEqual R('[1, 4]')
