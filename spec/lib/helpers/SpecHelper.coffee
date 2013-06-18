beforeEach ->
  @addMatchers({
    toBeInstanceOf: (klass) ->
      @actual instanceof klass;
  })
  @addMatchers({
    toBeTrue: (klass) ->
      @actual is true;
  })
  @addMatchers({
    toBeFalse: (klass) ->
      @actual is false;
  })
