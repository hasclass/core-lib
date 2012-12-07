beforeEach ->
  @addMatchers({
    toBeInstanceOf: (klass) ->
      @actual instanceof klass;
  })
