# Module
class EnumerableMethods
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
      many  = RCoerce.to_int_native(n)
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
    else if R(initial)?.is_string?
      # for [1,2,3].inject('-')
      _method = "#{initial}"
      block   = (memo, el) -> memo[_method](el)
      initial = undefined
    else if initial.call?
      # for inject (memo,i) ->
      block = initial
      initial = undefined

    [initial, sym, block]



  inject: (coll, init, sym, block) ->
    [init, sym, block] = @__inject_args__(init, sym, block)

    callback = R.blockify(block, coll)
    @each coll, ->
      if init is undefined
        init = callback.args(arguments)
      else
        args = BlockMulti.prototype.args(arguments)
        init = callback.invokeSplat(init, args)

    init


  grep: (coll, pattern, block) ->
    ary      = []
    pattern  = R(pattern)
    callback = R.blockify(block, coll)
    if block
      @each coll, (el) ->
        if pattern['==='](el)
          ary.push(callback.invoke(arguments))
    else
      @each coll, (el) ->
        ary.push(el) if pattern['==='](el)
    ary


  group_by: (coll, block) ->
    callback = R.blockify(block, coll)

    h = {}
    @each coll, ->
      args = callback.args(arguments)
      key  = callback.invoke(arguments)

      h[key] ||= []
      h[key].push(args)

    h


  map: (coll, block) ->
    callback = R.blockify(block, coll)

    arr = []
    @each coll, ->
      arr.push(callback.invoke(arguments))

    arr


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


  zip: (coll, others) ->
    # TODO



  # --- Aliases ---------------------------------------------------------------
  detect: @prototype.find
  select: @prototype.find_all
  collectConcat: @prototype.collect_concat
  dropWhile: @prototype.drop_while
  eachCons: @prototype.each_cons
  eachEntry: @prototype.each_entry
  eachSlice: @prototype.each_slice
  eachWithIndex: @prototype.each_with_index
  eachWithObject: @prototype.each_with_object
  findAll: @prototype.find_all
  findIndex: @prototype.find_index
  flatMap: @prototype.flat_map
  groupBy: @prototype.group_by
  maxBy: @prototype.max_by
  minBy: @prototype.min_by
  minmaxBy: @prototype.minmax_by
  reverseEach: @prototype.reverse_each
  sliceBefore: @prototype.slice_before
  sortBy: @prototype.sort_by
  takeWhile: @prototype.take_while
  toA: @prototype.to_a

  collect: @prototype.map
  member: @prototype.include
  reduce: @prototype.inject
  entries: @prototype.to_a


# `value` is the original element and `sort_by` the one to be sorted by
#
# @private
class MYSortedElement
  constructor: (@value, @sort_by) ->

  '<=>': (other) ->
    @sort_by?['<=>'](other.sort_by)


_enum = R._enum = new EnumerableMethods()
