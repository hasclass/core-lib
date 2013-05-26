_enum = R._enum =
  catch_break: R.Kernel.prototype.catch_break


  each: (coll, block) ->
    if coll.each?
      coll.each(block)
    else if RArray.isNativeArray(coll)
      _arr.each(coll, block)
    else
      for own k,v of coll
        block(k,v)
    coll


  all: (coll, block) ->
    @catch_break (breaker) ->
      callback = _blockify(block, coll)
      @each coll, ->
        result = callback.invoke(arguments)
        breaker.break(false) if R.falsey(result)
      true


  any: (coll, block) ->
    @catch_break (breaker) ->
      callback = _blockify(block, coll)
      @each coll, ->
        result = callback.invoke(arguments)
        breaker.break(true) unless R.falsey( result )
      false


  collect_concat: (coll, block = null) ->
    callback = _blockify(block, this)

    ary = []
    @each coll, ->
      ary.push(callback.invoke(arguments))

    _arr.flatten(ary, 1)


  flat_map: @collect_concat


  count: (coll, block) ->
    counter = 0
    if block is undefined
      @each coll, -> counter += 1
    else if block is null
      @each coll, (el) -> counter += 1 if el is null
    else if block.call?
      callback = _blockify(block, coll)
      @each coll, ->
        result = callback.invoke(arguments)
        counter += 1 unless R.falsey(result)
    else
      countable = R(block)
      @each coll, (el) ->
        counter += 1 if countable['=='](el)
    counter


  cycle: (coll, n, block) ->
    unless block
      if n && n.call?
        block = n
        n     = null

    if !(n is null or n is undefined)
      many  = CoerceProto.to_int_native(n)
      return null if many <= 0
    else
      many = null

    return coll.to_enum('cycle', n) unless block

    callback = _blockify(block, coll)

    cache = new R.Array([])
    @each coll, ->
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


  drop: (coll, n) ->
    # TODO use splice when implemented
    ary = []
    @each_with_index coll, (el, idx) ->
      ary.push(el) if n <= idx
    ary


  drop_while: (coll, block) ->
    callback = _blockify(block, coll)

    ary = []
    dropping = true

    @each coll, ->
      unless dropping && callback.invoke(arguments)
        dropping = false
        ary.push(callback.args(arguments))

    ary



  each_cons: (coll, n, block) ->
    # TODO: use callback
    callback = _blockify(block, coll)
    len = block.length
    ary = []
    @each coll, ->
      ary.push(BlockMulti.prototype.args(arguments))
      ary.shift() if ary.length > n
      if ary.length is n
        if len > 1
          block.apply(coll, ary.slice(0))
        else
          block.call(coll, ary.slice(0))

    null


  each_entry: (coll, block) ->
    # hard code BlockMulti because each_entry converts multiple
    # yields into an array
    callback = new BlockMulti(block, coll)
    len = block.length
    @each coll, ->
      args = callback.args(arguments)
      if len > 1 and R.Array.isNativeArray(args)
        block.apply(coll, args)
      else
        block.call(coll, args)

    coll


  each_slice: (coll, n, block) ->
    callback = _blockify(block, coll)
    len      = block.length
    ary      = []

    @each coll, ->
      ary.push( BlockMulti.prototype.args(arguments) )
      if ary.length == n
        args = ary.slice(0)
        if len > 1
          block.apply(coll, args)
        else
          block.call(coll, args)
        ary = []

    unless ary.length == 0
      args = ary.slice(0)
      if len > 1
        block.apply(coll, args)
      else
        block.call(coll, args)

    null


  each_with_index: (coll, block) ->
    callback = _blockify(block, coll)

    idx = 0
    @each coll, ->
      val = callback.invokeSplat(callback.args(arguments), idx)
      idx += 1
      val

    coll


  each_with_object: (coll, obj, block) ->
    callback = _blockify(block, coll)

    @each coll, ->
      args = BlockMulti.prototype.args(arguments)
      callback.invokeSplat(args, obj)

    obj


  find: (coll, ifnone, block = null) ->
    if block == null
      block  = ifnone
      ifnone = null

    callback = _blockify(block, this)
    @catch_break (breaker) ->
      @each coll, ->
        unless R.falsey(callback.invoke(arguments))
          breaker.break(callback.args(arguments))

      ifnone?()


  find_all: (coll, block) ->
    ary = []
    callback = _blockify(block, coll)
    @each coll, ->
      unless R.falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    ary


  find_index: (coll, value) ->
    value = R(value)

    if value.call?
      block = value
    else
      if value.rubyjs?
        block = (el) -> value['=='](el)
      else
        block = (el) -> el is value

    idx = 0
    callback = _blockify(block, coll)
    @catch_break (breaker) ->
      @each coll, ->
        breaker.break(idx) if callback.invoke(arguments)
        idx += 1

      null


  first: (coll, n = null) ->
    if n != null
      throw new R.ArgumentError('ArgumentError') if n < 0
      @take(coll, n)
    else
      @take(coll, 1)[0]


  # FIXME: This a very unfortunate solution just to enable the use of '=='
  include: (coll, other) ->
    other = R(other)

    @catch_break (breaker) ->
      @each coll, (el) ->
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
    ary      = new RArray([])
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

      h[key] ||= new RArray([])
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
  map: (coll, block) ->
    callback = R.blockify(block, coll)

    arr = []
    @each coll, ->
      arr.push(callback.invoke(arguments))

    arr


  # @alias #map


  # @alias #member


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
  max: (coll, block) ->
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

    @each coll, (item) ->
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
  max_by: (coll, block) ->
    max = undefined
    # OPTIMIZE: use sorted element
    @each coll, (item) ->
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
  min: (coll, block) ->
    min = undefined
    block ||= R.Comparable.cmp

    # Following Optimization won't complain if:
    # [1,2,'3']
    #
    # optimization for elements that are arrays

    @each coll, (item) ->
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
  min_by: (coll, block) ->
    min = undefined
    # OPTIMIZE: use sorted element
    @each coll, (item) ->
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
  minmax: (coll, block) ->
    # TODO: optimize
    [@min(coll, block), @max(coll, block)]


  minmax_by: (coll, block) ->
    [@min_by(coll, block), @max_by(coll, block)]


  none: (coll, block) ->
    @catch_break (breaker) ->
      callback = R.blockify(block, coll)
      @each coll, (args) ->
        result = callback.invoke(arguments)
        breaker.break(false) unless R.falsey(result)
      true


  one: (coll, block) ->
    counter  = 0

    @catch_break (breaker) ->
      callback = R.blockify(block, coll)
      @each coll, (args) ->
        result = callback.invoke(arguments)
        counter += 1 unless R.falsey(result)
        breaker.break(false) if counter > 1
      counter is 1



  partition: (coll, block) ->
    left  = []
    right = []

    callback = R.blockify(block, coll)

    @each coll, ->
      args = BlockMulti.prototype.args(arguments)

      if callback.invokeSplat(args)
        left.push(args)
      else
        right.push(args)

    [left, right]


  reject: (coll, block) ->
    callback = R.blockify(block, coll)

    ary = []
    @each coll, ->
      if R.falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    ary

  reverse_each: (coll, block) ->
    # There is no other way then to convert to an array first.
    # Because Enumerable depends only on #each (through #to_a)
    _arr.reverse_each(@to_a(coll), block )
    coll

  slice_before: (args...) ->
    # TODO
    # block = @__extract_block(args)
    # # throw R.ArgumentError.new() if args.length == 1
    # arg   = R(args[0])

    # if block
    #   has_init = !(arg is undefined)
    # else
    #   block = (elem) -> arg['==='] elem

    # self = this
    # R.Enumerator.create (yielder) ->
    #   accumulator = null
    #   self.each (elem) ->
    #     start_new = if has_init then block(elem, arg.dup()) else block(elem)
    #     if start_new
    #       yielder.yield accumulator if accumulator
    #       accumulator = R([elem])
    #     else
    #       accumulator ||= new RArray([])
    #       accumulator.append elem
    #   yielder.yield accumulator if accumulator


  sort: (coll, block) ->
    # TODO: throw Error when comparing different values.
    block ||= R.Comparable.cmpstrict
    coll = coll.to_native() if coll.to_native?
    coll.sort(block)


  sort_by: (coll, block) ->
    callback = R.blockify(block, coll)

    ary = []
    @each coll, (value) ->
      ary.push new MYSortedElement(value, callback.invoke(arguments))

    ary = _arr.sort(ary, R.Comparable.cmpstrict)
    _arr.map(ary, (se) -> se.value)


  take: (coll, n) ->
    throw R.ArgumentError.new() if n < 0
    ary = []
    @catch_break (breaker) ->
      @each coll, ->
        breaker.break() if ary.length is n
        ary.push(BlockMulti.prototype.args(arguments))

    ary



  take_while: (coll, block) ->
    ary = []

    @catch_break (breaker) ->
      @each coll, ->
        breaker.break() if R.falsey block.apply(coll, arguments)
        ary.push(BlockMulti.prototype.args(arguments))

    ary


  to_a: (coll) ->
    ary = []

    @each coll, ->
      # args = if arguments.length == 1 then arguments[0] else _slice_.call(arguments)
      ary.push(BlockMulti.prototype.args(arguments))
      null

    ary


  to_enum: (iter = "each", args...) ->
    new R.Enumerator(this, iter, args)


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



# `value` is the original element and `sort_by` the one to be sorted by
#
# @private
class MYSortedElement
  constructor: (@value, @sort_by) ->

  '<=>': (other) ->
    @sort_by?['<=>'](other.sort_by)



REnumerable = RubyJS.Enumerable
_enum.detect = _enum.find
_enum.select = _enum.find_all
_enum.collectConcat = _enum.collect_concat
_enum.dropWhile = _enum.drop_while
_enum.eachCons = _enum.each_cons
_enum.eachEntry = _enum.each_entry
_enum.eachSlice = _enum.each_slice
_enum.eachWithIndex = _enum.each_with_index
_enum.eachWithObject = _enum.each_with_object
_enum.findAll = _enum.find_all
_enum.findIndex = _enum.find_index
_enum.flatMap = _enum.flat_map
_enum.groupBy = _enum.group_by
_enum.maxBy = _enum.max_by
_enum.minBy = _enum.min_by
_enum.minmaxBy = _enum.minmax_by
_enum.reverseEach = _enum.reverse_each
_enum.sliceBefore = _enum.slice_before
_enum.sortBy = _enum.sort_by
_enum.takeWhile = _enum.take_while
_enum.toA = _enum.to_a


_enum.collect = _enum.map
_enum.member = _enum.include
_enum.reduce = _enum.inject
_enum.entries = _enum.to_a