describe "Enumerable with block arity 1", ->
  beforeEach ->
    @en = R(['a'])

  it "#all", ->
    @en.all((a) -> expect( a ).toEqual('a'))

  it "#any", ->
    @en.any((a) -> expect( a ).toEqual('a'))

  xit "#chunk", ->
    @en.chunk((a) -> expect( a ).toEqual('a'))

  it "#collect_concat", ->
    @en.collect_concat((a) -> expect( a ).toEqual('a'); a )

  it "#collect", ->
    @en.collect((a) -> expect( a ).toEqual('a'))

  it "#count", ->
    @en.count((a) -> expect( a ).toEqual('a'))

  xit "#cycle", ->
    @en.cycle(1, (a) -> expect( a ).toEqual('a'))

  it "#detect", ->
    @en.detect((a) -> expect( a ).toEqual('a'))

  it "#drop_while", ->
    @en.drop_while((a) -> expect( a ).toEqual('a'))

  it "#each_cons", ->
    @en.each_cons(1, (a) -> expect( a ).toEqual(['a']))

  it "#each_entry", ->
    @en.each_entry((a) -> expect( a ).toEqual('a'))

  it "#each_slice", ->
    @en.each_slice(1, (a) -> expect( a ).toEqual(['a']))

  it "#each_with_index", ->
    @en.each_with_index((a) -> expect( a ).toEqual('a'))

  it "#each_with_object", ->
    @en.each_with_object(1, (a) -> expect( a ).toEqual('a'))

  it "#entries", ->
    @en.entries((a) -> expect( a ).toEqual('a'))

  it "#find_all", ->
    @en.find_all((a) -> expect( a ).toEqual('a'))

  it "#find_index", ->
    @en.find_index((a) -> expect( a ).toEqual('a'))

  it "#find", ->
    @en.find((a) -> expect( a ).toEqual('a'))

  it "#flat_map", ->
    @en.flat_map((a) -> expect( a ).toEqual('a'); a)

  it "#grep", ->
    @en.grep(/a/, (a) -> expect( a ).toEqual('a'))

  it "#group_by", ->
    @en.group_by((a) -> expect( a ).toEqual('a'))

  it "#inject", ->
    @en.inject((a) -> expect( a ).toEqual('a'))

  it "#map", ->
    @en.map((a) -> expect( a ).toEqual('a'))

  it "#max_by", ->
    @en.max_by((a) -> expect( a ).toEqual('a'))

  it "#max", ->
    @en.max((a) -> expect( a ).toEqual('a'))

  it "#member", ->
    @en.member((a) -> expect( a ).toEqual('a'))

  it "#min_by", ->
    @en.min_by((a) -> expect( a ).toEqual('a'))

  it "#min", ->
    @en.min((a) -> expect( a ).toEqual('a'))

  it "#minmax_by", ->
    @en.minmax_by((a) -> expect( a ).toEqual('a'))

  it "#minmax", ->
    @en.minmax((a) -> expect( a ).toEqual('a'))

  it "#none", ->
    @en.none((a) -> expect( a ).toEqual('a'))

  it "#one", ->
    @en.one((a) -> expect( a ).toEqual('a'))

  it "#partition", ->
    @en.partition((a) -> expect( a ).toEqual('a'))

  it "#reduce", ->
    @en.reduce((a) -> expect( a ).toEqual('a'))

  it "#reject", ->
    @en.reject((a) -> expect( a ).toEqual('a'))

  it "#reverse_each", ->
    @en.reverse_each((a) -> expect( a ).toEqual('a'))

  it "#select", ->
    @en.select((a) -> expect( a ).toEqual('a'))

  it "#slice_before", ->
    @en.slice_before((a) -> expect( a ).toEqual('a'))

  it "#sort_by", ->
    @en.sort_by((a) -> expect( a ).toEqual('a'))

  it "#sort", ->
    @en.sort((a) -> expect( a ).toEqual('a'))

  it "#take_while", ->
    @en.take_while((a) -> expect( a ).toEqual('a'))

  it "#to_a", ->
    @en.to_a((a) -> expect( a ).toEqual('a'))

  it "#zip", ->
    @en.zip((a) -> expect( a ).toEqual(R(['a'])))
