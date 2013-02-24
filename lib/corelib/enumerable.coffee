# Enumerable is a module of iterator methods that all rely on #each for
# iterating. Classes that include Enumerable are Enumerator, Range, Array.
# However for performance reasons they are typically re-implemented in them
# to avoid the extra method calls through #each.
#
#
# @mixin
class RubyJS.Enumerable
  is_enumerable: -> true

  # Passes each element of the collection to the given block. The method
  # returns true if the block never returns false or nil. If the block is not
  # given, Ruby adds an implicit block of {|obj| obj} (that is all? will
  # return true only if none of the collection members are false or nil.)
  #
  # @example
  #     R.w('ant bear cat').all (word) -> word.length >= 3   # => true
  #     R.w('ant bear cat').all (word) -> word.length >= 4   # => false
  #     R([ null, true, 99 ]).all()                          # => false
  #
  all: (block) ->
    @catch_break (breaker) ->
      callback = R.blockify(block, this)
      @each ->
        result = callback.invoke(arguments)
        breaker.break(false) if R.falsey(result)

      true

  'all?': @prototype.all

  # Passes each element of the collection to the given block. The method
  # returns true if the block ever returns a value other than false or nil. If
  # the block is not given, Ruby adds an implicit block of {|obj| obj} (that
  # is any? will return true if at least one of the collection members is not
  # false or nil.
  #
  #     R.w('ant bear cat').any (word) -> word.length >= 3   # => true
  #     R.w('ant bear cat').any (word) -> word.length >= 4   # => true
  #     R([ null, true, 99 ]).any()                          # => true
  #
  any: (block) ->
    @catch_break (breaker) ->
      callback = R.blockify(block, this)
      @each ->
        result = callback.invoke(arguments)
        breaker.break(true) unless R.falsey( result )
      false


  # Returns a new array with the concatenated results of running block once
  # for every element in enum.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @alias #flat_map
  #
  # @example
  #    R([[1,2],[3,4]]).flat_map (i) -> i   #=> [1, 2, 3, 4]
  #
  collect_concat: (block = null) ->
    return @to_enum('collect_concat') unless block && block.call?
    callback = R.blockify(block, this)
    ary = []
    @each ->
      ary.push(callback.invoke(arguments))

    new R.Array(ary).flatten(1)

  flat_map: @prototype.collect_concat

  # Returns the number of items in enum, where size is called if it responds
  # to it, otherwise the items are counted through enumeration. If an argument
  # is given, counts the number of items in enum, for which equals to item. If
  # a block is given, counts the number of elements yielding a true value.
  #
  # @execute
  #     ary = R([1, 2, 4, 2])
  #     ary.count()                #=> 4
  #     ary.count(2)               #=> 2
  #     ary.count (x) -> x%2 == 0  #=> 3
  #
  count: (block) ->
    counter = 0
    if block is undefined
      @each -> counter += 1
    else if block is null
      @each (el) -> counter += 1 if el is null
    else if block.call?
      callback = R.blockify(block, this)
      @each ->
        result = callback.invoke(arguments)
        counter += 1 unless R.falsey(result)
    else
      @each (el) ->
        counter += 1 if R(el)['=='](block)
    @$Integer counter

  # this makes my head spin.
  # chunk: (initial_state = null, original_block) ->
  #   throw RubyJS.ArgumentError.new() unless original_block || initial_state
  #   new RubyJS.Enumerator (yielder) ->
  #     previous = null
  #     accumulate = R []
  #     # @each (val) ->
  #       # accumulate.push(original_block(val))
  #     accumulate


  # Calls block for each element of enum repeatedly n times or forever if none
  # or nil is given. If a non-positive number is given or the collection is
  # empty, does nothing. Returns nil if the loop has finished without getting
  # interrupted.
  #
  # #cycle saves elements in an internal array so changes to enum after the
  # #first pass have no effect.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R(["a", "b", "c"])
  #     a.cycle (x) -> R.puts x      # print, a, b, c, a, b, c,.. forever.
  #     a.cycle(2) (x) -> R.puts x   # print, a, b, c, a, b, c.
  #
  # @todo does not rescue StopIteration
  #
  cycle: (n, block) ->
    throw R.ArgumentError.new() if arguments.length > 2

    unless block
      if n && n.call?
        block = n
        n     = null

    if !(n is null or n is undefined)
      many  = CoerceProto.to_int_native(n)
      return null if many <= 0
    else
      many = null

    return @to_enum('cycle', n) unless block

    callback = R.blockify(block, this)

    cache = new R.Array([])
    @each ->
      args = callback.args(arguments)
      cache.append args
      callback.invoke(arguments)

    return null if cache.empty()

    if many > 0                                  # cycle(2, () -> ... )
      i = 0
      many -= 1
      while many > i
        # OPTIMIZE use normal arrays and for el in cache
        cache.each ->
          callback.invoke(arguments)
          i += 1
    else
      while true                                 # cycle(() -> ... )
        cache.each ->
          callback.invoke(arguments)

  # Drops first n elements from enum, and returns rest elements in an array.
  #
  # @example
  #     a = R([1, 2, 3, 4, 5, 0])
  #     a.drop(3)             #=> [4, 5, 0]
  #
  drop: (n) ->
    @__ensure_args_length(arguments, 1)
    n = CoerceProto.to_int_native(n)

    throw R.ArgumentError.new() if n < 0

    # TODO use splice when implemented
    ary = []
    @each_with_index (el, idx) ->
      ary.push(el) if n <= idx

    new R.Array(ary)


  # Drops elements up to, but not including, the first element for which the
  # block returns nil or false and returns an array containing the remaining
  # elements.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([1, 2, 3, 4, 5, 0])
  #     a.drop_while (i) -> i < 3    #=> [3, 4, 5, 0]
  #
  drop_while: (block) ->
    return @to_enum('drop_while') unless block && block.call?

    callback = R.blockify(block, this)

    ary = []
    dropping = true

    @each ->
      unless dropping && callback.invoke(arguments)
        dropping = false
        ary.push(callback.args(arguments))

    new R.Array(ary)

  # Iterates the given block for each array of consecutive <n> elements. If no
  # block is given, returns an enumerator.
  #
  # @example
  #      R.rng(1,6).each_cons 3, (a) -> R.puts a
  #      # output:
  #      # [1, 2, 3]
  #      # [2, 3, 4]
  #      # [3, 4, 5]
  #      # [4, 5, 6]
  #
  each_cons: (args...) ->
    block = @__extract_block(args)
    return @to_enum('each_cons', args...) unless block && block.call?

    @__ensure_args_length(args, 1)
    n = CoerceProto.to_int_native(args[0])

    throw R.ArgumentError.new() unless n > 0

    # TODO: use callback
    callback = R.blockify(block, this)
    len = block.length
    ary = []
    @each ->
      ary.push(BlockMulti.prototype.args(arguments))
      ary.shift() if ary.length > n
      if ary.length is n
        if len > 1
          block.apply(this, ary.slice(0))
        else
          block.call(this, ary.slice(0))


    null

  # Calls block once for each element in self, passing that element as a
  # parameter, converting multiple values from yield to an array.
  #
  # If no block is given, an enumerator is returned instead.
  #
  each_entry: (block) ->
    throw R.ArgumentError.new() if arguments.length > 1
    return @to_enum('each_entry') unless block && block.call?

    # hard code BlockMulti because each_entry converts multiple
    # yields into an array
    callback = new BlockMulti(block, this)
    len = block.length
    @each ->
      args = callback.args(arguments)
      if len > 1 and R.Array.isNativeArray(args)
        block.apply(this, args)
      else
        block.call(this, args)

    this

  # Iterates the given block for each slice of <n> elements. If no block is
  # given, returns an enumerator.
  #
  # @example
  #     (1..10).each_slice(3) {|a| p a}
  #     # outputs below
  #     [1, 2, 3]
  #     [4, 5, 6]
  #     [7, 8, 9]
  #     [10]
  #
  each_slice: (n, block) ->
    throw R.ArgumentError.new() unless n
    n = CoerceProto.to_int_native(n)

    throw R.ArgumentError.new() if n <= 0                  #each_slice(-1)
    throw R.ArgumentError.new() if block && !block.call?   #each_slice(1, block)

    return @to_enum('each_slice', n) if block is undefined #each_slice(1) # => enum

    callback = R.blockify(block, this)
    len      = block.length
    ary      = []

    @each ->
      ary.push( BlockMulti.prototype.args(arguments) )
      if ary.length == n
        args = ary.slice(0)
        if len > 1
          block.apply(this, args)
        else
          block.call(this, args)
        ary = []

    unless ary.length == 0
      args = ary.slice(0)
      if len > 1
        block.apply(this, args)
      else
        block.call(this, args)

    null


  # # TODO: I'm not quite sure wether this is smart or stupid
  # each_with_context: (context = null, block) ->
  #   return @to_enum('each_with_context', context) unless block && block.call?
  #
  #   @each (el...) ->
  #     el = el[0] if el.length == 1
  #     # call the block in the context or the iterated element.
  #     context ||= el
  #     block.call(context, el, context)
  #
  #   this

  # Calls block with two arguments, the item and its index, for each item in
  # enum. Given arguments are passed through to each().
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     hsh = {}
  #     R.w('cat dog wombat').each_with_index (item, index) ->
  #       hsh[item] = index
  #     hsh   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}
  #
  each_with_index: (block) ->
    return @to_enum('each_with_index') unless block && block.call?

    callback = R.blockify(block, this)

    idx = 0
    @each ->
      val = callback.invokeSplat(callback.args(arguments), idx)
      idx += 1
      val
    this


  # Iterates the given block for each element with an arbitrary object given,
  # and returns the initially given object.
  #
  # If no block is given, returns an enumerator.
  #
  # @example
  #     evens = R.rng(1,10).each_with_object [], (i, a) -> a.push(i*2)
  #     #=> [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  #
  each_with_object: (obj, block) ->
    return @to_enum('each_with_object', obj) unless block && block.call?

    callback = R.blockify(block, this)

    @each ->
      args = BlockMulti.prototype.args(arguments)
      callback.invokeSplat(args, obj)

    obj

  # Passes each entry in enum to block. Returns the first for which block is not
  # false. If no object matches, calls ifnone and returns its result when it is
  # specified, or returns nil otherwise.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1, 10 ).detect (i) -> i % 5 == 0 and i % 7 == 0   #=> nil
  #     R.rng(1, 100).detect (i) -> i % 5 == 0 and i % 7 == 0   #=> 35
  #
  # @alias #detect
  #
  find: (ifnone, block = null) ->
    if block == null
      block  = ifnone
      ifnone = null

    callback = R.blockify(block, this)
    @catch_break (breaker) ->
      @each ->
        unless R.falsey(callback.invoke(arguments))
          breaker.break(callback.args(arguments))

      ifnone?()

  # @alias #find
  #
  detect: @prototype.find


  # Returns an array containing all elements of enum for which block is not
  # false (see also Enumerable#reject).
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1,10).find_all (i) ->  i % 3 == 0    #=> [3, 6, 9]
  #
  find_all: (block) ->
    return @to_enum('find_all') unless block && block.call?

    ary = []
    callback = R.blockify(block, this)
    @each ->
      unless R.falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    new R.Array(ary)

  select: @prototype.find_all

  # Compares each entry in enum with value or passes to block. Returns the index
  # for the first for which the evaluated value is non-false. If no object
  # matches, returns nil
  #
  # If neither block nor argument is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1,10).find_index  (i) -> i % 5 == 0 and i % 7 == 0   #=> nil
  #     R.rng(1,100).find_index (i) -> i % 5 == 0 and i % 7 == 0   #=> 34
  #     R.rng(1,100).find_index(50)                                #=> 49
  #
  find_index: (value) ->
    return @to_enum('find_index') if arguments.length == 0
    value = R(value)

    if value.call?
      block = value
    else
      block = (el) -> R(el)['=='](value) or el is value

    idx = 0
    callback = R.blockify(block, this)
    @catch_break (breaker) ->
      @each ->
        breaker.break(new R.Fixnum(idx)) if callback.invoke(arguments)
        idx += 1

      null

  # Returns the first element, or the first n elements, of the enumerable. If
  # the enumerable is empty, the first form returns nil, and the second form
  # returns an empty array.
  #
  # @example
  #     R.w('foo bar baz').first()   #=> "foo"
  #     R.w('foo bar baz').first(2)  #=> ["foo", "bar"]
  #     R.w('foo bar baz').first(10) #=> ["foo", "bar", "baz"]
  #     new R.Array([]).first()                  #=> null
  #
  first: (n = null) ->
    if n != null
      n = CoerceProto.to_int_native(n)
      throw new R.ArgumentError('ArgumentError') if n < 0
      @take(n)
    else
      @take(1).to_native()[0]

  # Returns true if any member of enum equals obj. Equality is tested using ==.
  include: (other) ->
    other = @box(other)

    @catch_break (breaker) ->
      @each (el) ->
        # TODO: this is special. we're trying to typecast el, so we can
        # call == on it. This needs to be fixed, most probably with an R.equalss(a, b)
        # which takes care of non-R objects.
        el = R(el)
        breaker.break(true) if el['==']?(other) or other['==']?(el) or el is other
      false

  # @private
  __inject_args__: (initial, sym, block) ->
    if sym?.call?
      block = sym
    else if sym
      # for [1,2,3].inject(5, (memo, i) -> )
      block = (memo, el) -> memo[sym](el)
    else if @box(initial)?.is_string?
      # for [1,2,3].inject('-')
      _method = "#{initial}"
      block   = (memo, el) -> memo[_method](el)
      initial = undefined
    else if initial.call?
      # for inject (memo,i) ->
      block = initial
      initial = undefined

    [initial, sym, block]


  # Combines all elements of enum by applying a binary operation, specified by
  # a block or a symbol that names a method or operator.
  #
  # If you specify a block, then for each element in enum the block is passed
  # an accumulator value (memo) and the element. If you specify a symbol
  # instead, then each element in the collection will be passed to the named
  # method of memo. In either case, the result becomes the new value for memo.
  # At the end of the iteration, the final value of memo is the return value
  # for the method.
  #
  # If you do not explicitly specify an initial value for memo, then uses the
  # first element of collection is used as the initial value of memo.
  #
  # @example
  #
  #     # Sum some numbers
  #     # R.rng(5, 10).reduce(:+)                            #=> 45
  #     # Same using a block and inject
  #     R.rng(5, 10).inject {|sum, n| sum + n }            #=> 45
  #     # Multiply some numbers
  #     R.rng(5, 10).reduce(1, :*)                         #=> 151200
  #     # Same using a block
  #     R.rng(5, 10).inject(1) {|product, n| product * n } #=> 151200
  #     # find the longest word
  #     longest = R.w('cat sheep bear').inject (memo,word) ->
  #        if memo.length > word.length then memo else word
  #     # longest                                       #=> "sheep"
  #
  # @todo implement inject('+')
  #
  inject: (init, sym, block) ->
    [init, sym, block] = @__inject_args__(init, sym, block)

    callback = R.blockify(block, this)
    @each ->
      if init is undefined
        init = callback.args(arguments)
      else
        args = BlockMulti.prototype.args(arguments)
        init = callback.invokeSplat(init, args)

    init


  # _ruby: returns an object that works with
  # for .. in ..
  # @private
  iterator: () ->
    @each()

  # Returns an array of every element in enum for which Pattern === element. If the optional block is supplied, each matching element is passed to it, and the block’s result is stored in the output array.
  #
  # @example
  #     R.rng(1, 100).grep R.rng(38,44)   #=> [38, 39, 40, 41, 42, 43, 44]
  #
  grep: (pattern, block) ->
    ary      = new R.Array([])
    pattern  = R(pattern)
    callback = R.blockify(block, this)
    if block
      @each (el) ->
        if pattern['==='](el)
          ary.append(callback.invoke(arguments))
    else
      @each (el) ->
        ary.append(el) if pattern['==='](el)
    ary

  # Returns a hash, which keys are evaluated result from the block, and values
  # are arrays of elements in enum corresponding to the key.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #      R.rng(1, 6).group_by (i) -> i%3
  #      #=> {0=>[3, 6], 1=>[1, 4], 2=>[2, 5]}
  #
  group_by: (block) ->
    return @to_enum('group_by') unless block?.call?

    callback = R.blockify(block, this)

    h = {}
    @each ->
      args = callback.args(arguments)
      key  = callback.invoke(arguments)

      h[key] ||= new R.Array([])
      h[key].append(args)

    h


  # Returns a new array with the results of running block once for every
  # element in enum.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1, 4).collect (i) -> i*i   #=> [1, 4, 9, 16]
  #     R.rng(1, 4).collect -> "cat"     #=> ["cat", "cat", "cat", "cat"]
  #
  # @example #map with an enumerator:
  #
  #    en = R(['a']).each_with_index() #=> ['a', 0]
  #    en.map (x) ->   # x: 'a'
  #    en.map (x,i) -> # x: 'a', i: 0
  #    en.map (x...) -> # x: ['a', 0]
  #
  # @alias #collect
  #
  map: (block) ->
    return @to_enum('map') unless block?.call?

    callback = R.blockify(block, this)

    arr = []
    @each ->
      arr.push(callback.invoke(arguments))

    new R.Array(arr)


  # @alias #map
  collect: @prototype.map


  # @alias #member
  member:  @prototype.include


  # Returns the object in enum with the maximum value. The first form assumes
  # all objects implement Comparable; the second uses the block to return a
  # <=> b.
  #
  # @return
  #     a = R.w('albatross dog horse')
  #     a.max()                                #=> "horse"
  #     # Not recommended at the moment:
  #     a.max (a,b) -> R(a.length)['<=>'] b.length }   #=> "albatross"
  #
  max: (block) ->
    max = undefined

    block ||= R.Comparable.cmp

    # # Following Optimization won't complain if:
    # # [1,2,'3']
    # #
    # # optimization for elements that are arrays
    # #
    # if @__samesame__?()
    #   arr = @__native__
    #   if arr.length < 65535
    #     _max = Math.max.apply(Math, arr)
    #     return _max if _max isnt NaN

    @each (item) ->
      if max is undefined
        max = item
      else
        comp = block(item, max)
        throw R.ArgumentError.new() if comp is null
        max = item if comp > 0

    max or null


  # Returns the object in enum that gives the maximum value from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R.w('albatross dog horse')
  #     a.max_by (x) -> x.length    #=> "albatross"
  #
  max_by: (block) ->
    return @to_enum('max_by') unless block?.call?
    max = undefined
    # OPTIMIZE: use sorted element
    @each (item) ->
      if max is undefined
        max = item
      else
        cmp = R.Comparable.cmpstrict(block(item), block(max))
        max = item if cmp > 0
    max or null


  # Returns the object in enum with the minimum value. The first form assumes
  # all objects implement Comparable; the second uses the block to return a
  # <=> b.
  #
  #     a = R.w('albatross dog horse')
  #     a.min()                                  #=> "albatross"
  #     # Not recommended at the moment:
  #     a.min (a,b) -> R(a.length)['<=>'] b.length }   #=> "dog"
  #
  min: (block) ->
    min = undefined
    block ||= R.Comparable.cmp

    # Following Optimization won't complain if:
    # [1,2,'3']
    #
    # optimization for elements that are arrays
    #
    if @__samesame__?()
      arr = @__native__
      if arr.length < 65535
        _min = Math.min.apply(Math, arr)
        return _min if _min isnt NaN

    @each (item) ->
      if min is undefined
        min = item
      else
        comp = block.call(this, item, min)
        throw R.ArgumentError.new() if comp is null
        min = item if comp < 0

    min or null


  # Returns the object in enum that gives the minimum value from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R.w('albatross dog horse')
  #     a.min_by (x) -> x.length   #=> "dog"
  #
  min_by: (block) ->
    return @to_enum('min_by') unless block?.call?

    min = undefined
    # OPTIMIZE: use sorted element
    @each (item) ->
      if min is undefined
        min = item
      else
        cmp = R.Comparable.cmpstrict(block(item), block(min))
        min = item if cmp < 0
    min or null


  # Returns two elements array which contains the minimum and the maximum
  # value in the enumerable. The first form assumes all objects implement
  # Comparable; the second uses the block to return a <=> b.
  #
  # @example
  #     a = R.w('albatross dog horse')
  #     a.minmax()                                  #=> ["albatross", "horse"]
  #     a.minmax (a,b) -> a.length <=> b.length }   #=> ["dog", "albatross"]
  #
  minmax: (block) ->
    # TODO: optimize
    R([@min(block), @max(block)])


  minmax_by: (block) ->
    return @to_enum('minmax_by') unless block?.call?

    # TODO: optimize
    R([@min_by(block), @max_by(block)])

  # Passes each element of the collection to the given block. The method returns true if the block never returns true for all elements. If the block is not given, none? will return true only if none of the collection members is true.
  #
  # @example
  #     R.w('ant bear cat').none (word) -> word.length == 5   # => true
  #     R.w('ant bear cat').none (word) -> word.length >= 4   # => false
  #     new R.Array([]).none()                                          # => true
  #     R([nil]).none()                                       # => true
  #     R([nil,false]).none()                                 # => true
  #
  none: (block) ->
    @catch_break (breaker) ->
      callback = R.blockify(block, this)
      @each (args) ->
        result = callback.invoke(arguments)
        breaker.break(false) unless R.falsey(result)
      true

  'none?': @prototype.none

  # Passes each element of the collection to the given block. The method
  # returns true if the block returns true exactly once. If the block is not
  # given, one? will return true only if exactly one of the collection members
  # is true.
  #
  # @example
  #     R.w('ant bear cat').one (word) -> word.length == 4   # => true
  #     R.w('ant bear cat').one (word) -> word.length > 4    # => false
  #     R.w('ant bear cat').one (word) -> word.length < 4    # => false
  #     R([ nil, true, 99 ]).one()                           # => false
  #     R([ nil, true, false ]).one()                        # => true
  #
  one: (block) ->
    counter  = 0

    @catch_break (breaker) ->
      callback = R.blockify(block, this)
      @each (args) ->
        result = callback.invoke(arguments)
        counter += 1 unless R.falsey(result)
        breaker.break(false) if counter > 1
      counter is 1

  'one?': @prototype.one


  partition: (block) ->
    return @to_enum('partition') unless block && block.call?

    left  = []
    right = []

    callback = R.blockify(block, this)

    @each ->
      args = BlockMulti.prototype.args(arguments)

      if callback.invokeSplat(args)
        left.push(args)
      else
        right.push(args)

    new R.Array([new R.Array(left), new R.Array(right)])

  reduce: @prototype.inject

  reject: (block) ->
    return @to_enum('reject') unless block && block.call?

    callback = R.blockify(block, this)

    ary = []
    @each ->
      if R.falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    new R.Array(ary)

  reverse_each: (block) ->
    return @to_enum('reverse_each') unless block && block.call?

    # There is no other way then to convert to an array first.
    # Because Enumerable depends only on #each (through #to_a)

    @to_a().reverse_each( block )

    this

  slice_before: (args...) ->
    block = @__extract_block(args)
    # throw R.ArgumentError.new() if args.length == 1
    arg   = R(args[0])

    if block
      has_init = !(arg is undefined)
    else
      block = (elem) -> arg['==='] elem

    self = this
    R.Enumerator.create (yielder) ->
      accumulator = null
      self.each (elem) ->
        start_new = if has_init then block(elem, arg.dup()) else block(elem)
        if start_new
          yielder.yield accumulator if accumulator
          accumulator = R([elem])
        else
          accumulator ||= new R.Array([])
          accumulator.append elem
      yielder.yield accumulator if accumulator


  sort: (block) ->
    # TODO: throw Error when comparing different values.
    block ||= R.Comparable.cmpstrict
    arr = @to_a().to_native().sort(block)
    new R.Array(arr)


  sort_by: (block) ->
    return @to_enum('sort_by') unless block && block.call?

    callback = R.blockify(block, this)

    ary = []
    @each (value) ->
      ary.push new R.Enumerable.SortedElement(value, callback.invoke(arguments))

    ary = new R.Array(ary)

    ary.sort(R.Comparable.cmpstrict).map (se) -> se.value


  take: (n) ->
    @__ensure_args_length(arguments, 1)
    n = CoerceProto.to_int_native(n)
    throw R.ArgumentError.new() if n < 0

    arr = []
    @catch_break (breaker) ->
      @each ->
        breaker.break() if arr.length is n
        arr.push(BlockMulti.prototype.args(arguments))

    new R.Array(arr)


  take_while: (block) ->
    return @to_enum('take_while') unless block && block.call?

    ary = []

    @catch_break (breaker) ->
      @each ->
        breaker.break() if R.falsey block.apply(this, arguments)
        ary.push(BlockMulti.prototype.args(arguments))

    new R.Array(ary)


  to_a: () ->
    ary = []

    @each ->
      # args = if arguments.length == 1 then arguments[0] else _slice_.call(arguments)
      ary.push(BlockMulti.prototype.args(arguments))
      null

    new R.Array(ary)


  to_enum: (iter = "each", args...) ->
    new R.Enumerator(this, iter, args)

  entries: @prototype.to_a

  # Takes one element from enum and merges corresponding elements from each
  # args. This generates a sequence of n-element arrays, where n is one more
  # than the count of arguments. The length of the resulting sequence will be
  # enum#size. If the size of any argument is less than enum#size, nil values
  # are supplied. If a block is given, it is invoked for each output array,
  # otherwise an array of arrays is returned.
  #
  # @example
  #     a = R([ 4, 5, 6 ])
  #     b = R([ 7, 8, 9 ])
  #     R([1,2,3]).zip(a, b)      #=> [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  #     R([1,2]  ).zip(a,b)       #=> [[1, 4, 7], [2, 5, 8]]
  #     a.zip([1,2],[8])           #=> [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
  #
  # @todo recursive arrays Untested
  # @todo uses #each to extract arguments' elements when #to_ary fails
  #
  # @todo dont yield R.Arrays
  zip: (others...) ->
    block = @__extract_block(others)

    others = R(others).map (other) ->
      o = R(other)
      if o.to_ary? then o.to_ary() else o.to_enum('each')

    results = new R.Array([])
    idx     = 0
    @each (el) ->
      inner = R([el])
      others.each (other) ->
        el = if other.is_array? then other.at(idx) else other.next()
        el = null if el is undefined
        inner.append(el)

      block( inner ) if block
      results.append( inner )
      idx += 1

    if block then null else results

  # --- Aliases ---------------------------------------------------------------

  collectConcat:   @prototype.collect_concat
  dropWhile:       @prototype.drop_while
  eachCons:        @prototype.each_cons
  eachEntry:       @prototype.each_entry
  eachSlice:       @prototype.each_slice
  eachWithIndex:   @prototype.each_with_index
  eachWithObject:  @prototype.each_with_object
  findAll:         @prototype.find_all
  findIndex:       @prototype.find_index
  flatMap:         @prototype.flat_map
  groupBy:         @prototype.group_by
  maxBy:           @prototype.max_by
  minBy:           @prototype.min_by
  minmaxBy:        @prototype.minmax_by
  reverseEach:     @prototype.reverse_each
  sliceBefore:     @prototype.slice_before
  sortBy:          @prototype.sort_by
  takeWhile:       @prototype.take_while
  toA:             @prototype.to_a



# `value` is the original element and `sort_by` the one to be sorted by
#
# @private
class RubyJS.Enumerable.SortedElement
  constructor: (@value, @sort_by) ->

  '<=>': (other) ->
    @sort_by?['<=>'](other.sort_by)
