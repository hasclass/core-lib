describe "Enumerable", ->
  #describe "#each", ->

  describe 'breaking iterators', ->
    beforeEach -> @arr = R([2])

    it 'breaks',  ->
      # expect( R.catch_break () -> __break( 'foo' ) ).toEqual 'foo'
      # expect( @arr.each_with_index (x,i) -> __break('foo') ).toEqual 'foo'

  describe 'chaining iterators', ->
    beforeEach -> @arr = R([2])

    it "each_with_object('foo')", ->
      expect(
        @arr.each_with_object('foo').to_a()
      ).toEqual R([[2, 'foo']])

    it "each_with_index()", ->
      expect(
        @arr.each_with_index().to_a()
      ).toEqual R([[2, 0]])

    it "each_with_index().each (x,i)", ->
      @arr.each_with_index().each (x,i) ->
        expect( x ).toEqual 2
        expect( i ).toEqual 0

    xit "each_with_index().each_entry (x,i)", ->
      # TODO: fix this...
      @arr.each_with_index().each_entry (x,i) ->
        expect( x ).toEqual 2
        expect( i ).toEqual 0

    xit "each_with_object('foo').each_with_index().to_a()", ->
      expect(
        @arr.each_with_object('foo').each_with_index().to_a()
      ).toEqual R([[[2, "foo"], 0]])

    xit "each_with_index().each_with_object('foo')", ->
      expect(
        @arr.each_with_index().each_with_object('foo').to_a()
      ).toEqual R([[[2, 0], "foo"]])

    it "each_with_index().each_with_object 'foo', (a,b) -> assigns arguments", ->
      ret = @arr.each_with_index().each_with_object 'foo', (first, second) ->
        expect( first  ).toEqual [2, 0]
        expect( second ).toEqual 'foo'

    it "each_with_index().each_with_object 'foo', (a,b) -> returns 'foo'", ->
      expect(
        @arr.each_with_index().each_with_object 'foo', () ->
      ).toEqual 'foo'

    xit "each_with_index().each_with_context('foo')", ->
      expect(
        @arr.each_with_index().each_with_context('foo').to_a().unbox()
      ).toEqual [[[2, 0], "foo"]]

      @arr.each_with_index().each_with_context 'foo', (first, second) ->
        expect( first  ).toEqual [2, 0]
        expect( second ).toEqual 'foo'
        expect( this   ).toEqual 'foo'

    xit "each_with_index().each_with_context( null ) uses the iterated element", ->
      @arr.each_with_index().each_with_context (first, second) ->
        expect( second ).toEqual 2
        expect( this   ).toEqual 2

    xit "each_with_context( null ).each_with_index (a,b) a is [2,2]", ->
      # this seems counter intuitive at first. But
      # each_with_context 'foo', (element, context) ->
      #   => element = 2 and context = 'foo'
      # by passing no argument to each_with_context the context is
      # the iterated element. so element becomes context.
      @arr.each_with_context().each_with_index (first, second) ->
        expect( first  ).toEqual  [2, 2]
        expect( this   ).toEqual 2
        expect( second ).toEqual 0

  describe "#all", ->
    beforeEach ->
      @arr = R([2])

    xit "test splatting parameters with one or more nested enumerators", ->
      @arr.each_with_object("foo").all (a, b) ->
        expect( a ).toEqual    2
        expect( b ).toEqual 'foo'

      @arr.each_with_index().all (a, b) ->
        expect( a ).toEqual    2
        expect( b ).toEqual 0

      @arr.each_with_object("foo").each_with_index().all (a, b) ->
        expect( a ).toEqual [2,'foo']
        expect( b ).toEqual 0

      @arr.each().all (a, b) ->
        expect( a ).toEqual 2
        expect( b is undefined ).toEqual true

      expect( @arr.each_with_index().all() ).toEqual true
      expect( @arr.all()                   ).toEqual true
      expect( R([true]).all()             ).toEqual true




  R(['all', 'any', 'one']).each (method) ->
    describe "##{method}", ->
      beforeEach ->
        @arr = R([2])

      it "to assign args", ->
        @arr[method] (args) -> expect( args ).toEqual 2

      it "can access outside variables", ->
        val = 3
        @arr[method] (args) -> expect( val ).toEqual 3

      describe 'with enumerator', ->
        beforeEach ->
          @arr_each_index = @arr.each_with_index()

        it "can access outside variables", ->
          val = 3
          @arr_each_index[method] (a, idx) -> expect( val ).toEqual 3

        it "to assign args", ->
          @arr_each_index[method] (a, idx) -> expect( a ).toEqual 2

        it "to return value", ->               #  a < idx
          expect(@arr_each_index[method] (a, idx) -> idx < a).toEqual true
          expect(@arr_each_index[method] (a, idx) -> idx > a).toEqual false

        it "to return value with additional enumerator", ->
          expect( @arr_each_index.each()[method] (a, idx) -> idx < a ).toEqual true
