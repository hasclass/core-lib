describe "Enumerable block args", ->

  beforeEach ->

    @en = R(['a'])
    @enobj = @en.each_with_object('o')

    @expect_splat_args_for_enum = (fn) ->
      @en[fn]((a, b) -> expect( a ).toEqual('a'))

      @enobj[fn]((a   ) -> expect( a ).toEqual(  'a'        ))
      @enobj[fn]((a...) -> expect( a ).toEqual(  ['a', 'o'] ))
      @enobj[fn]((a, b) -> expect( a ).toEqual(  'a'        ))
      @enobj[fn]((a, b) -> expect( b ).toEqual(  'o'        ))

    @expect_splat_args_for_arr = (fn) ->
      arr = R([['a', 'o']])
      arr[fn]((a   ) -> expect( a ).toEqual(  ['a', 'o'] ))
      arr[fn]((a...) -> expect( a ).toEqual(  ['a', 'o'] ))
      arr[fn]((a, b) -> expect( a ).toEqual(  'a'        ))
      arr[fn]((a, b) -> expect( b ).toEqual(  'o'        ))


  R.w('all any collect collect_concat count detect drop_while entries
      find_all find_index find flat_map group_by inject map
      max_by member min_by min minmax_by minmax none
      one reduce reject select slice_before sort_by ').each (method) ->

    it "##{method} with enum", ->
      @expect_splat_args_for_enum(method)

    it "##{method} with arr", ->
      @expect_splat_args_for_arr(method)

  xit "#chunk", ->
    @en.chunk((a, b) -> expect( a ).toEqual('a'))
    @enobj.chunk((a, b) -> expect( b ).toEqual('o'))

  it "#cycle", ->
    R([[1,2]]).cycle(1, (a) -> expect( a ).toEqual([1,2]))
    R([[1,2]]).cycle(1, (a,b) -> expect( a ).toEqual(1))

    @en.cycle(1, (a   ) -> expect( a ).toEqual('a'))
    @en.cycle(1, (a, b) -> expect( a ).toEqual('a'))
    @enobj.cycle(1, (a, b) -> expect( b ).toEqual('o'))

  it "#each_cons", ->
    @en.each_cons(1, (a, b) -> expect( a ).toEqual('a'))

    R([1,2]).each_cons(2, (a)    -> expect( a ).toEqual([1, 2]) )
    R([1,2]).each_cons(2, (a, b) -> expect( a ).toEqual(1) )

    @enobj.each_cons(1, (a   ) -> expect( a ).toEqual([['a', 'o']]))
    @enobj.each_cons(1, (a...) -> expect( a ).toEqual([[['a', 'o']]]))
    @enobj.each_cons(1, (a, b) -> expect( a ).toEqual(['a', 'o']))
    @enobj.each_cons(1, (a, b) -> expect( b ).toEqual(null))

    expect( @enobj.each_cons(1).to_a() ).toEqual R([[['a', 'o']]])

  it "#each_entry", ->
    @en.each_entry((a, b) -> expect( a ).toEqual('a'))

    @enobj.each_entry((a   ) -> expect( a ).toEqual(['a', 'o']))
    @enobj.each_entry((a...) -> expect( a ).toEqual([['a', 'o']]))
    @enobj.each_entry((a, b) -> expect( a ).toEqual('a'))
    @enobj.each_entry((a, b) -> expect( b ).toEqual('o'))

    expect( @enobj.each_entry().to_a() ).toEqual R([['a', 'o']])


  it "#each_slice", ->
    @en.each_slice(1, (a, b) -> expect( a ).toEqual('a'))
    @enobj.each_slice(1, (a   ) -> expect( a ).toEqual([['a', 'o']]))
    @enobj.each_slice(1, (a...) -> expect( a ).toEqual([[['a', 'o']]]))
    @enobj.each_slice(1, (a, b) -> expect( a ).toEqual(['a', 'o']))
    @enobj.each_slice(1, (a, b) -> expect( b ).toEqual(undefined))

    expect( @enobj.each_slice(1).to_a() ).toEqual R([[['a', 'o']]])

  it "#each_with_index", ->
    @en.each_with_index((a, b) -> expect( a ).toEqual('a'))
    @enobj.each_with_index((a   ) -> expect( a ).toEqual(['a', 'o']))
    @enobj.each_with_index((a...) -> expect( a ).toEqual([['a', 'o'], 0]))
    @enobj.each_with_index((a, b) -> expect( a ).toEqual(['a', 'o']))
    @enobj.each_with_index((a, b) -> expect( b ).toEqual(0))

    expect( @enobj.each_with_index().to_a() ).toEqual R([[['a', 'o'], 0]])

  it "#each_with_object", ->
    @en.each_with_object(1, (a, b) -> expect( a ).toEqual('a'))
    @enobj.each_with_object('b', (a, b) -> expect( b ).toEqual(  'b'         ))
    @enobj.each_with_object('b', (a   ) -> expect( a ).toEqual(  ['a', 'o']  ))
    @enobj.each_with_object('b', (a...) -> expect( a ).toEqual(  [['a', 'o'], 'b'] ))
    @enobj.each_with_object('b', (a, b) -> expect( a ).toEqual(  ['a', 'o']   ))
    @enobj.each_with_object('b', (a, b) -> expect( b ).toEqual(  'b'          ))

  it "#grep", ->
    @en.grep(/a/, (a, b) -> expect( a ).toEqual('a'))
    @enobj.grep(/a/, (a   ) -> expect(a).toEqual('a'))
    @enobj.grep(/a/, (a...) -> expect(a).toEqual(['a', 'o']))
    @enobj.grep(/a/, (a, b) -> expect(a).toEqual('a'))
    @enobj.grep(/a/, (a, b) -> expect(b).toEqual('o'))

  it "#inject", ->
    # test with inject(1, ->)

  xit "#partition", ->
    @en.partition((a, b) -> expect( a ).toEqual('a'))
    @enobj.partition((a, b) -> expect( b ).toEqual('o'))

  it "#reverse_each", ->
    @en.reverse_each((a, b) -> expect( a ).toEqual('a'))

    @enobj.reverse_each((a   ) -> expect(a).toEqual(['a', 'o']))
    @enobj.reverse_each((a...) -> expect(a).toEqual([['a', 'o']]))
    @enobj.reverse_each((a, b) -> expect(a).toEqual('a'))
    @enobj.reverse_each((a, b) -> expect(b).toEqual('o'))

  it "#zip", ->
    @en.zip((a, b) -> expect( a ).toEqual(R(['a'])))
    @enobj.zip((a, b) -> expect( a ).toEqual(R(['a'])))


describe "Integer block args", ->

  beforeEach ->

    @num = R(1)
    # @enobj = @en.each_with_object('o')

    # @expect_splat_args_for_enum = (fn) ->
    #   @en[fn]((a, b) -> expect( a ).toEqual('a'))

    #   @enobj[fn]((a   ) -> expect( a ).toEqual(  'a'        ))
    #   @enobj[fn]((a...) -> expect( a ).toEqual(  ['a', 'o'] ))
    #   @enobj[fn]((a, b) -> expect( a ).toEqual(  'a'        ))
    #   @enobj[fn]((a, b) -> expect( b ).toEqual(  'o'        ))

    @expect_splat_args_for_arr = (fn) ->
      num = R(1)
      num[fn]((a   ) -> expect( a ).toEqual(  ['a', 'o'] ))
      num[fn]((a...) -> expect( a ).toEqual(  ['a', 'o'] ))
      num[fn]((a, b) -> expect( a ).toEqual(  'a'        ))
      num[fn]((a, b) -> expect( b ).toEqual(  'o'        ))

  it "#times", ->
    num = R(1)
    num.times((a   ) -> expect( a ).toEqual(  R(0)   ))
    num.times((a...) -> expect( a ).toEqual(  [R(0)] ))
    num.times((a, b) -> expect( a ).toEqual(  R(0)   ))
    num.times((a, b) -> expect( b ).toEqual(  undefined   ))

    z = R(0)
    en = num.times()
    en.each_with_index((a   ) -> expect(a).toEqual( z      ))
    en.each_with_index((a...) -> expect(a).toEqual( [z, 0] ))
    en.each_with_index((a, b) -> expect(a).toEqual( z      ))
    en.each_with_index((a, b) -> expect(b).toEqual( 0      ))

  it "#upto", ->
    num = R(1)
    z = R(1)
    num.upto(1, (a   ) -> expect( a ).toEqual(  z   ))
    num.upto(1, (a...) -> expect( a ).toEqual( [z]  ))
    num.upto(1, (a, b) -> expect( a ).toEqual(  z   ))
    num.upto(1, (a, b) -> expect( b ).toEqual(  undefined   ))

    en = num.upto(1)
    en.each_with_index((a   ) -> expect(a).toEqual(  z     ))
    en.each_with_index((a...) -> expect(a).toEqual( [z, 0] ))
    en.each_with_index((a, b) -> expect(a).toEqual(  z     ))
    en.each_with_index((a, b) -> expect(b).toEqual(  0     ))







