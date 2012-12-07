describe "Examples/Loops: breaking out of loops", ->

describe "Examples/Loops: context", ->
  xit "", ->
    arr = R([1])
    my_var = 2
    @my_var = 3

    arr.each (i) ->
      expect( my_var ).toEqual 2
      expect( @my_var ).toBeUndefined
      expect( this ).toEqual global ? window

    arr.each (i) =>
      expect( my_var ).toEqual 2
      expect( @my_var ).toEqual 3

    arr.each_with_context this, () ->
      expect( my_var ).toEqual 2
      expect( @my_var ).toEqual 3

  xit "takes context", ->
    arr = R([1])
    obj =
      my_var2: "foo"
    arr.each_with_context obj, () ->
      expect( @my_var2 ).toEqual 'foo'
      expect( this   ).toEqual obj

  xit "each_with_context(obj).each_with_index()", ->
    arr = R([1])
    obj =
      my_var2: "foo"

    arr.each_with_context(obj).each_with_index (w, idx) ->
      expect( idx ).toEqual R(0)
      expect( w   ).toEqual [1, obj]
      expect( this   ).toEqual obj

  xit "takes enumerator when called on enumerator 1", ->
    arr = R([1])
    obj =
      my_var2: "foo"

    arr.each_with_index().each_with_context obj, (first) ->
      expect( first  ).toEqual [1, R(0)]
      expect( this   ).toEqual obj
      expect( @my_var2 ).toEqual 'foo'

    arr.each_with_index().each_with_context obj, (first) ->
      expect( first   ).toEqual [1, R(0)]
      expect( this   ).toEqual obj
      expect( @my_var2 ).toEqual 'foo'

  xit "takes enumerator when called on enumerator 2", ->
    arr = R([1])
    obj =
      my_var2: "foo"
    arr.each_with_index().each_with_context (w) ->
      expect( w   ).toEqual 1
      expect( this   ).toEqual w



  xdescribe 'each_with_context', ->
    it "loops", ->
      arr    = R.$Array_r([1,2,4,8,16])
      record = []
      # arr.each_with_context (n) ->
      #   record.push(@unbox())
      # expect( record ).toEqual [1,2,4,8,16]

      record = []
      arr.each_with_context this, (n) ->
        record.push(n.unbox())
      expect( record ).toEqual [1,2,4,8,16]

    it "loops with context", ->
      arr     = R.$Array_r([1,2,4,8,16])
      record  = []
      context = R(1)
      arr.each_with_context context, (c) ->
        record.push(@unbox())
      expect( record ).toEqual [1,1,1,1,1]










