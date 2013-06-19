describe "_arr", ->
  array = [1,[1,2],2]
  args = R.Support.argify(1,[1,2],2)

  describe "rindex", ->
    it "splats block arguments", ->
      expect( _a.rindex(array, (a,b) -> b == 2 ) ).toEqual 1
      expect( _a.rindex(args, (a,b) -> b == 2 ) ).toEqual 1

  describe "keep_if", ->
    it "splats block arguments", ->
      expect( _a.keep_if(array, (a,b) -> b == 2 ) ).toEqual [[1,2]]
      expect( _a.keep_if(args, (a,b) -> b == 2 ) ).toEqual [[1,2]]

  describe "each", ->
    it "splats block arguments", ->
      arr = []
      _a.each(array, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]
      arr = []
      _a.each(args, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

  describe "reverse_each", ->
    it "splats block arguments", ->
      arr = []
      _a.reverse_each(array, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

      arr = []
      _a.reverse_each(args, (a,b) -> arr.push(b) )
      expect( arr ).toEqual [undefined,2,undefined]

  describe "find_index", ->
    it "splats block arguments", ->
      expect( _a.find_index(array, (a,b) -> b == 2) ).toEqual 1
      expect( _a.find_index(args, (a,b) -> b == 2) ).toEqual 1


describe "_a.equals", ->
  it "returns false if any corresponding elements are not #==", ->
    a = ["a", "b", "c"]
    b = ["a", "b", "not equal value"]
    expect( _a.equals(a, b) ).toBe(false)

    c = { equals: -> false }
    expect( _a.equals(["a", "b", c], a)).toBe(false)

  it "returns true if corresponding elements are #==", ->
    expect( _a.equals([],   [] ) ).toBe(true)
    expect( _a.equals([], R([])) ).toBe(true)
    expect( _a.equals(["a", "c", 7], ["a", "c", 7])).toBe(true)
    expect( _a.equals([1, 2, 3], [1.0, 2.0, 3.0] ) ).toBe(true)

    obj = {equals: -> true}
    expect( _a.equals([obj], [5] )).toBe(true)

  it "returns true if nested arrays are equals", ->
    expect( _a.equals([[]], [[]] )         ).toBe(true)
    expect( _a.equals([1, []], [1, []] )   ).toBe(true)
    expect( _a.equals([1, [2]], [1, [2]] ) ).toBe(true)
    expect( _a.equals([1, [2, ['f', [[]]]]], [1, [2, ['f', [[]]]]] ) ).toBe(true)

  it "returns false if nested arrays are not equals", ->
    expect( _a.equals([[]], [[],[]] )      ).toBe(false)
    expect( _a.equals([1, []], [2, []] )   ).toBe(false)
    expect( _a.equals([1, [2]], [1, [3]] ) ).toBe(false)
    expect( _a.equals([1, [2, ['f', [[]]]]], [1, [2, ['f', [[3]]]]] ) ).toBe(false)

  it "returns true if other is the same array", ->
    a = [1]
    expect( _a.equals(a, a) ).toBe(true)

  it "returns true if corresponding elements are #eql?", ->
    expect( _a.equals([], []) ).toBe(true)
    expect( _a.equals([1, 2], [1, 2]) ).toBe(true)

  it "returns false if other is shorter than self", ->
    expect( _a.equals( [1, 2, 3, 4], [1, 2, 3]) ).toBe(false)

  it "returns false if other is longer than self", ->
    expect( _a.equals( [1, 2], [1, 2, 5]) ).toBe(false)

  it "returns false immediately when sizes of the arrays differ", ->
    obj = { valueOf: -> throw "should not call" }
    expect( _a.equals( []   ,    [obj]  )).toBe(false)
    expect( _a.equals( [obj],    []     )).toBe(false)


describe "docs", ->
  it "_a.at", ->
    a = [ "a", "b", "c", "d", "e" ]
    expect( _a.at(a, 0)  ).toEqual("a")
    expect( _a.at(a, -1) ).toEqual("e")

  it "_a.combination", ->
    a = [1, 2, 3, 4]
    acc = []
    _a.combination(a, 1, (arr) -> acc.push(arr) )
    expect( acc ).toEqual [[1],[2],[3],[4]]
    expect( _a.combination(a, 1) ).toEqual [[1],[2],[3],[4]]
    expect( _a.combination(a, 2) ).toEqual [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
    expect( _a.combination(a, 3) ).toEqual [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
    expect( _a.combination(a, 4) ).toEqual [[1,2,3,4]]
    expect( _a.combination(a, 0) ).toEqual [[]] # one combination of length 0
    expect( _a.combination(a, 5) ).toEqual []   # no combinations of length 5

  it "_a.compact", ->
    expect(
      _a.compact([ "a", null, "b", null, "c", null ])
    ).toEqual [ "a", "b", "c" ]


  it "_a.delete", ->
    a = [ "a", "b", "b", "b", "c" ]
    expect( _a.delete(a, "b") ).toEqual "b"
    expect( a                 ).toEqual ["a", "c"]
    expect( _a.delete(a, "z") ).toEqual null
    expect( _a.delete(a, "z", -> 'not found') ).toEqual "not found"


  it "_a.delete_at", ->
    arr = ['ant','bat','cat','dog']
    expect( _a.delete_at(arr, 2)    ).toEqual "cat"
    expect( arr                     ).toEqual ["ant", "bat", "dog"]
    expect( _a.delete_at(arr, 99)   ).toEqual null


  it "_a.flatten", ->
    s = [ 1, 2, 3 ]
    t = [ 4, 5, 6, [7, 8] ]
    arr = [ s, t, 9, 10 ]
    expect( _a.flatten(arr) ).toEqual [1,2,3,4,5,6,7,8,9,10]
    arr = [1,2,[3,[4,5]]]
    expect( _a.flatten(arr, 1)        ).toEqual [1, 2, 3, [4, 5]]


  it "_a.each_with_context", ->
    arr = [ "a", "b", "c" ]
    obj = []
    _a.each_with_context(arr, obj, (x) -> this.push(x) )
    expect( obj ).toEqual [ "a", "b", "c" ]


  it "_a.fetch", ->
    arr = [ 11, 22, 33, 44 ]
    expect( _a.fetch(arr, 1)              ).toEqual 22
    expect( _a.fetch(arr, -1)             ).toEqual 44
    expect( _a.fetch(arr, 4, 'cat')       ).toEqual "cat"
    expect( _a.fetch(arr, 4, (i) -> i*i ) ).toEqual 16


  it "_a.fill", ->
    arr = [ "a", "b", "c", "d" ]
    expect( _a.fill(arr, "x")               ).toEqual ["x", "x", "x", "x"]
    expect( _a.fill(arr, "z", 2, 2)         ).toEqual ["x", "x", "z", "z"]
    # expect( _a.fill(arr, "y", 0..1)         ).toEqual ["y", "y", "z", "z"]
    expect( _a.fill(arr, (i) -> i*i      )  ).toEqual [0, 1, 4, 9]
    expect( _a.fill(arr, -2, (i) -> i*i*i)  ).toEqual [0, 1, 8, 27]


  it "_a.first", ->
    arr = ['foo','bar','baz']
    expect( _a.first(arr)     ).toEqual "foo"
    expect( _a.first(arr, 2)  ).toEqual ["foo", "bar"]
    expect( _a.first(arr, 10) ).toEqual ["foo", "bar", "baz"]
    expect( _a.first([])      ).toEqual null


  it "_a.insert", ->
    arr = ['a','b','c','d']
    expect( _a.insert(arr, 2, 99)         ).toEqual ["a", "b", 99, "c", "d"]
    expect( _a.insert(arr, -2, 1, 2, 3)   ).toEqual ["a", "b", 99, "c", 1, 2, 3, "d"]


  it "_a.join", ->
    arr = ['a', 'b', 'c']
    expect( _a.join(arr)       ).toEqual "abc"
    expect( _a.join(arr,null)  ).toEqual "abc"
    expect( _a.join(arr,"-")   ).toEqual "a-b-c"
    # joins nested arrays
    expect( _a.join([1,[2,[3,4]]], '.')      ).toEqual '1.2.3.4'
    # Default separator R['$,'] (in ruby: $,)
    expect( R['$,']           ).toEqual null
    expect( _a.join(arr)      ).toEqual "abc"
    expect( R['$,'] = '|'     ).toEqual '|'
    expect( _a.join(arr)      ).toEqual "a|b|c"


  it "_a.keep_if", ->
    arr = [1,2,3,4]
    expect( _a.keep_if(arr, (v) -> v < 3 )  ).toEqual [1,2]
    expect( _a.keep_if(arr, (v) -> true  )  ).toEqual [1,2,3,4]


  it "_a.last", ->
    arr = [ "w", "x", "y", "z" ]
    expect( _a.last(arr)       ).toEqual "z"
    expect( _a.last(arr, 2)    ).toEqual ["y", "z"]


  it "_a.minus", ->
    expect(
      _a.minus([ 1, 1, 2, 2, 3, 3, 4, 5 ], [ 1, 2, 4 ])
    ).toEqual([3,3,5])


  it "_a.multiply", ->
    arr = [ 1, 2, 3 ]
    expect( _a.multiply(arr, 3  ) ).toEqual [ 1, 2, 3, 1, 2, 3, 1, 2, 3 ]
    expect( _a.multiply(arr, ",") ).toEqual "1,2,3"


  it "_a.pop", ->
    arr = [ "a", "b", "c", "d" ]
    expect( _a.pop(arr,)     ).toEqual "d"
    expect( _a.pop(arr,2)    ).toEqual ["b", "c"]
    expect( arr              ).toEqual ["a"]


  it "_a.push", ->
    arr = [ "a", "b", "c" ]
    expect( _a.push(arr, "d", "e", "f") ).toEqual ["a", "b", "c", "d", "e", "f"]


  it "_a.rassoc", ->
    arr = [[1, "one"], [2, "two"], [3, "three"], ["ii", "two"]]
    expect( _a.rassoc(arr, "two")  ).toEqual [2, "two"]
    expect( _a.rassoc(arr, "four") ).toEqual null


  it "_a.reverse_each", ->
    arr = [ "a", "b", "c" ]
    acc = []
    _a.reverse_each arr, (x) -> acc.push("#{x} ")
    expect( acc ).toEqual ['c ', 'b ', 'a ']


  it "_a.rindex", ->
    arr = [ "a", "b", "b", "b", "c" ]
    expect( _a.rindex(arr, "b")             ).toEqual 3
    expect( _a.rindex(arr, "z")             ).toEqual null
    expect( _a.rindex(arr, (x) -> x == "b") ).toEqual 3
