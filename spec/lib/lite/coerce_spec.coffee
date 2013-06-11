_coerce = R.coerce

describe "_coerce", ->
  describe "call_with", ->
    call_with = _coerce.call_with
    arg = R.argify

    fn0 = (me) -> [me]
    fn1 = (me, a) -> [me, a]
    fn2 = (me, a) -> [me, a]
    fn6 = (me, a,b,c,d,e) -> [me, a,b,c,d,e]
    fn9 = (me, a,b,c,d,e,f,g,h) -> [me, a,b,c,d,e,f,g,h]

    it "works with arguments as args", ->
      expect( call_with(fn0, "foo", arg())                ).toEqual(["foo"])
      expect( call_with(fn1, "foo", arg(1))               ).toEqual(["foo", 1])
      expect( call_with(fn0, "foo", [])                   ).toEqual(["foo"])
      expect( call_with(fn1, "foo", [1])                  ).toEqual(["foo", 1])
      expect( call_with(fn6, "foo", arg(1,2,3,4,5))       ).toEqual(["foo", 1,2,3,4,5])
      expect( call_with(fn9, "foo", arg(1,2,3,4,5,6,7,8)) ).toEqual(["foo", 1,2,3,4,5,6,7,8])

    it "works with arrays as args", ->
      expect( call_with(fn0, "foo", [])                   ).toEqual(["foo"])
      expect( call_with(fn1, "foo", [1])                  ).toEqual(["foo", 1])


    it "doesn't fill up args with undefined", ->
      expect( call_with((() -> arguments.length), "foo", [] )).toEqual(1)
      expect( call_with((() -> arguments.length), "foo", [1])).toEqual(2)

