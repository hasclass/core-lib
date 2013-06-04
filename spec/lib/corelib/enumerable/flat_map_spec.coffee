
describe "Enumerable#flat_map", ->
    # it_behaves_like(:enumerable_flat_map , :flat_map)
 it "returns a new array with the results of passing each element to block, flattened one level", ->
    numerous = EnumerableSpecs.Numerous.new(1, [2, 3], [4, [5, 6]], {'foo': 'bar'})
    expect(
      numerous.flat_map((i) -> i) ).toEqual R([R(1), 2, 3, 4, [5, 6], {'foo': 'bar'}])


  it "skips elements that are empty Arrays", ->
    numerous = EnumerableSpecs.Numerous.new(1, [], 2)
    expect( numerous.flat_map((i) -> i) ).toEqual R([1, 2], true)

  it "calls valueOf but not to_a", ->
    obj =
      valueOf: -> ['foo']
    obj2 =
      to_a: -> throw 'should_not_receive'

    numerous = EnumerableSpecs.Numerous.new(obj, obj2)
    expect( numerous.flat_map  (i) -> i ).toEqual R(['foo', obj2])

  it "returns an enumerator when no block given", ->
    en = R.$Array_r([1, 2]).flat_map()
    expect( en ).toBeInstanceOf(RubyJS.Enumerator)
    expect( en.each((i) -> i * i ) ).toEqual R([1, 4])
