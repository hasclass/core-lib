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


