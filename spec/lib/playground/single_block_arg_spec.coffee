
R.args = R.RCoerce.single_block_args

describe "RubyJS.single_block_arg", ->
  describe "R.args", ->
    a = 'a'
    b = 'b'
    a_b = [a, b]
    expect( R.args([a],    (x)    -> expect( x ).toEqual(a) ) ).toEqual a
    expect( R.args([a, b], (x)    -> expect( x ).toEqual(a) ) ).toEqual a
    expect( R.args([a, b], (x...) -> expect( x ).toEqual(a_b) ) ).toEqual a_b
    expect( R.args([a, b], ()     -> expect( arguments ).toEqual(a_b) ) ).toEqual a_b

    expect( R.args([])    ).toEqual [] #[a, undefined]
    expect( R.args([a])   ).toEqual a #[a, undefined]
    expect( R.args([a, b])).toEqual a_b

    expect( R.args([a, b], (a, b) -> expect( [a, b] ).toEqual(a_b) ) ).toEqual a_b
    expect( R.args([a],    (a, b) -> expect( [a, b] ).toEqual([a, undefined]) ) ).toEqual a #[a, undefined]
    expect( R.args([a],    () ->     expect( arguments ).toEqual(a_b) ) ).toEqual a #[a, undefined]


  it "return array if yielding multiple", ->
    R([1,2,3]).each_cons 3, (a, b, c) ->
      expect( a ).toEqual 1
      expect( b ).toEqual 2
      expect( c ).toEqual 3

    R([1,2,3]).each_cons 3, (a) ->
      expect( a ).toEqual [1,2,3]

    R([1, 2]).each_cons 2, (a) ->
      expect( a ).toEqual [1, 2]

    expect( R([1]).each_cons(1).to_a().to_native() ).toEqual [[1]]

    R([1]).each_cons 3, (a) ->
      expect( a ).toEqual [1,2,3]

    R([1]).each_slice 3, (a) ->
      expect( a ).toEqual [1]

    R([1]).each_slice 3, (a,b,c) ->
      expect( a ).toEqual 1

    expect( R([1,2,3]).each_cons(1).to_a().to_native() ).toEqual [[1],[2],[3]]
    expect( R([1,2,3]).each_cons(3).to_a().to_native() ).toEqual [[1,2,3]]

    expect( R([1,2,3]).each_slice(1).to_a().to_native() ).toEqual [[1],[2],[3]]
    expect( R([1,2,3,4]).each_slice(3).to_a().to_native() ).toEqual [[1,2,3], [4]]

  it "return array if yielding multiple", ->
    R([1,2,3]).each_cons 3, (a) ->
      expect( a ).toEqual [1,2,3]



  # it "each_with_object('b')", ->
  #   R(['a']).each_with_object('b').each_with_index ([a, b], i) ->
  #     expect( a ).toEqual 'a'
  #     expect( b ).toEqual 'b'
  #     expect( i ).toEqual R(0)

  it "each_slice (1) fills to_a", ->
    expect( R([1,2]).each_slice(2).to_a().to_native() ).toEqual [[1, 2]]
    expect( R([1,2]).each_slice(1).to_a().to_native() ).toEqual [[1],[2]]

  it "each_slice (1) fills to_a", ->
    expect( R([1,2]).each_slice(1).to_a().to_native() ).toEqual [[1],[2]]

  it "R([1,2]).to_a()", ->
    expect( R([1,2]).to_a().to_native() ).toEqual [1, 2]

  it "R([[1],[2]]).to_a", ->
    expect( R([[1],[2]]).to_a().to_native() ).toEqual [[1], [2]]

  it "R([1,2]).to_enum().to_a()", ->
    expect( R([1,2]).to_enum().to_a().to_native() ).toEqual [1, 2]
    expect( R([1,2]).each_slice(1).to_a().to_native() ).toEqual [[1],[2]]

  it "[1,2,3).to_a fills to_a", ->
    expect( R([1,2]).to_a().to_native() ).toEqual [1,2]

  it "each_slice(1).to_a()", ->
    expect( R([1,2]).each_slice(1).to_a().to_native() ).toEqual [[1],[2]]

  it "each_slice(1).each_with_object('a').to_a()", ->
    expect( R([1,2]).each_with_object('a').each_slice(1).to_a().to_native() ).toEqual [[[1, 'a']],[[2, 'a']]]
    expect( R([1]).each_cons(1).each_slice(1).to_a().to_native() ).toEqual [[[1]]]

  it "each().to_a()", ->
    expect( R([1,2]).each().to_a().to_native() ).toEqual [1,2]

  it "to_a()", ->
    expect( R([1,2]).to_a().to_native() ).toEqual [1,2]
    expect( R([[1],[2]]).to_a().to_native() ).toEqual [[1], [2]]

  it "to_enum().to_a()", ->
    expect( R([1,2]).to_enum().to_a().to_native() ).toEqual [1,2]
    expect( R([[1],[2]]).to_enum().to_a().to_native() ).toEqual [[1], [2]]

  it "cycle().to_a()", ->
    expect( R( [1,2] ).cycle(2).to_a().to_native() ).toEqual [1,2,1,2]
    # expect( R([[1]]  ).cycle(2).to_a().to_native() ).toEqual [[1],[1]]
    expect( R([[1]]  ).each_with_object('a').cycle(2).to_a().to_native() ).toEqual [[[1], "a"], [[1], "a"]]
    expect( R([[1,2]]).cycle(2).to_a().to_native() ).toEqual [[1,2],[1,2]]

  it "reject().to_a()", ->
    expect( R( [1,2] ).reject((i) -> i == 'a').to_a().to_native() ).toEqual [1,2]
    expect( R([[1]]  ).reject((i) -> i == 'a').to_a().to_native() ).toEqual [[1]]
    R([1]).each_with_object('a').reject((i, a) -> expect( a ).toEqual('a'))
    expect( R([[1],[2]]).each_with_object('a').reject((i, a) -> a == 'a').to_a().to_native() ).toEqual []
    expect( R([[1,2]]).reject((i) -> i == 'a').to_a().to_native() ).toEqual [[1,2]]

  it "each_with_index().to_a()", ->
    expect( R(['a']).each_with_index().to_a().to_native() ).toEqual [['a', 0]]

