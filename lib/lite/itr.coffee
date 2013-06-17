# Module
class EnumerableMethods
  catch_break: R.Kernel.prototype.catch_break


  to_enum: (args...) ->
    new RubyJS.Enumerator(args...)


  each: (coll, block) ->
    if coll.each?
      coll.each(block)
    else if __isArr(coll)
      _arr.each(coll, block)
    else
      for own k,v of coll
        block(k,v)
    coll


  all: (coll, block) ->
    _itr.catch_break (breaker) ->
      callback = __blockify(block, coll)
      _itr.each coll, ->
        result = callback.invoke(arguments)
        breaker.break(false) if __falsey(result)
      true


  any: (coll, block) ->
    _itr.catch_break (breaker) ->
      callback = __blockify(block, coll)
      _itr.each coll, ->
        result = callback.invoke(arguments)
        breaker.break(true) unless __falsey( result )
      false


  collect_concat: (coll, block = null) ->
    callback = __blockify(block, this)

    ary = []
    _itr.each coll, ->
      ary.push(callback.invoke(arguments))

    _arr.flatten(ary, 1)


  flat_map: @collect_concat


  count: (coll, block) ->
    counter = 0
    if block is undefined
      _itr.each coll, -> counter += 1
    else if block is null
      _itr.each coll, (el) -> counter += 1 if el is null
    else if block.call?
      callback = __blockify(block, coll)
      _itr.each coll, ->
        result = callback.invoke(arguments)
        counter += 1 unless __falsey(result)
    else
      countable = block
      _itr.each coll, (el) ->
        counter += 1 if __equals(countable, el)
    counter


  cycle: (coll, n, block) ->
    unless block
      if n && n.call?
        block = n
        n     = null

    if !(n is null or n is undefined)
      many  = __int(n)
      return null if many <= 0
    else
      many = null

    return coll.to_enum('cycle', n) unless block

    callback = __blockify(block, coll)

    cache = []
    _itr.each coll, ->
      cache.push(callback.args(arguments))
      callback.invoke(arguments)

    return null if cache.length == 0

    if many > 0                                  # cycle(2, () -> ... )
      i = 0
      many -= 1
      while many > i
        # OPTIMIZE use normal arrays and for el in cache
        _arr.each cache, ->
          callback.invoke(arguments)
          i += 1
    else
      while true                                 # cycle(() -> ... )
        _arr.each cache, ->
          callback.invoke(arguments)


  drop: (coll, n) ->
    # TODO use splice when implemented
    ary = []
    _itr.each_with_index coll, (el, idx) ->
      ary.push(el) if n <= idx
    ary


  drop_while: (coll, block) ->
    callback = __blockify(block, coll)

    ary = []
    dropping = true

    _itr.each coll, ->
      unless dropping && callback.invoke(arguments)
        dropping = false
        ary.push(callback.args(arguments))

    ary



  each_cons: (coll, n, block) ->
    # TODO: use callback
    callback = __blockify(block, coll)
    len = block.length
    ary = []
    _itr.each coll, ->
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
    _itr.each coll, ->
      args = callback.args(arguments)
      if len > 1 and __isArr(args)
        block.apply(coll, args)
      else
        block.call(coll, args)

    coll


  each_slice: (coll, n, block) ->
    callback = __blockify(block, coll)
    len      = block.length
    ary      = []

    _itr.each coll, ->
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
    return new R.Enumerator(_itr, 'each_with_index', [coll]) unless block?.call?

    callback = __blockify(block, coll)

    idx = 0
    _itr.each coll, ->
      val = callback.invokeSplat(callback.args(arguments), idx)
      idx += 1
      val

    coll


  each_with_object: (coll, obj, block) ->
    callback = __blockify(block, coll)

    _itr.each coll, ->
      args = BlockMulti.prototype.args(arguments)
      callback.invokeSplat(args, obj)

    obj


  find: (coll, ifnone, block = null) ->
    if block == null
      block  = ifnone
      ifnone = null

    callback = __blockify(block, this)
    _itr.catch_break (breaker) ->
      _itr.each coll, ->
        unless __falsey(callback.invoke(arguments))
          breaker.break(callback.args(arguments))

      ifnone?()


  find_all: (coll, block) ->
    ary = []
    callback = __blockify(block, coll)
    _itr.each coll, ->
      unless __falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    ary


  find_index: (coll, value) ->
    if value.call?
      block = value
    else
      block = (el) -> __equals(value, el)

    _itr.catch_break (breaker) ->
      idx = 0
      callback = __blockify(block, coll)
      _itr.each coll, ->
        breaker.break(idx) if callback.invoke(arguments)
        idx += 1

      null


  first: (coll, n = null) ->
    if n != null
      _err.throw_argument() if n < 0
      _itr.take(coll, n)
    else
      _itr.take(coll, 1)[0]


  include: (coll, other) ->
    _itr.catch_break (breaker) ->
      _itr.each coll, (el) ->
        breaker.break(true) if __equals(other, el)
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
      block   = (memo, el) -> memo["#{initial}"](el)
      initial = undefined
    else if initial.call?
      block = initial
      initial = undefined

    [initial, sym, block]



  inject: (coll, init, sym, block) ->
    [init, sym, block] = _itr.__inject_args__(init, sym, block)

    callback = __blockify(block, coll)
    _itr.each coll, ->
      if init is undefined
        init = callback.args(arguments)
      else
        args = BlockMulti.prototype.args(arguments)
        init = callback.invokeSplat(init, args)

    init


  grep: (coll, pattern, block) ->
    ary      = []
    pattern  = R(pattern)
    callback = __blockify(block, coll)
    if block
      _itr.each coll, (el) ->
        if pattern['==='](el)
          ary.push(callback.invoke(arguments))
    else
      _itr.each coll, (el) ->
        ary.push(el) if pattern['==='](el)
    ary


  group_by: (coll, block) ->
    callback = __blockify(block, coll)

    h = {}
    _itr.each coll, ->
      args = callback.args(arguments)
      key  = callback.invoke(arguments)

      h[key] ||= []
      h[key].push(args)

    h


  map: (coll, block) ->
    callback = __blockify(block, coll)

    arr = []
    _itr.each coll, ->
      arr.push(callback.invoke(arguments))

    arr


  max: (coll, block) ->
    max = undefined

    block ||= __cmp

    _itr.each coll, (item) ->
      if max is undefined
        max = item
      else
        comp = block(item, max)
        _err.throw_argument() if comp is null
        max = item if comp > 0

    max or null


  max_by: (coll, block) ->
    max = undefined
    # OPTIMIZE: use sorted element
    _itr.each coll, (item) ->
      if max is undefined
        max = item
      else
        cmp = __cmpstrict(block(item), block(max))
        max = item if cmp > 0
    max or null


  min: (coll, block) ->
    min = undefined
    block ||= __cmp

    # Following Optimization won't complain if:
    # [1,2,'3']
    #
    # optimization for elements that are arrays

    _itr.each coll, (item) ->
      if min is undefined
        min = item
      else
        comp = block.call(this, item, min)
        _err.throw_argument() if comp is null
        min = item if comp < 0

    min or null



  min_by: (coll, block) ->
    min = undefined
    # OPTIMIZE: use sorted element
    _itr.each coll, (item) ->
      if min is undefined
        min = item
      else
        cmp = __cmpstrict(block(item), block(min))
        min = item if cmp < 0
    min or null


  minmax: (coll, block) ->
    # TODO: optimize
    [_itr.min(coll, block), _itr.max(coll, block)]


  minmax_by: (coll, block) ->
    [_itr.min_by(coll, block), _itr.max_by(coll, block)]


  none: (coll, block) ->
    _itr.catch_break (breaker) ->
      callback = __blockify(block, coll)
      _itr.each coll, (args) ->
        result = callback.invoke(arguments)
        breaker.break(false) unless __falsey(result)
      true


  one: (coll, block) ->
    counter  = 0

    _itr.catch_break (breaker) ->
      callback = __blockify(block, coll)
      _itr.each coll, (args) ->
        result = callback.invoke(arguments)
        counter += 1 unless __falsey(result)
        breaker.break(false) if counter > 1
      counter is 1



  partition: (coll, block) ->
    left  = []
    right = []

    callback = __blockify(block, coll)

    _itr.each coll, ->
      args = BlockMulti.prototype.args(arguments)

      if callback.invokeSplat(args)
        left.push(args)
      else
        right.push(args)

    [left, right]


  reject: (coll, block) ->
    callback = __blockify(block, coll)

    ary = []
    _itr.each coll, ->
      if __falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    ary


  reverse_each: (coll, block) ->
    # There is no other way then to convert to an array first.
    # Because Enumerable depends only on #each (through #to_a)
    _arr.reverse_each(_itr.to_a(coll), block )
    coll

  slice_before: (args...) ->
    # TODO
    # block = __extract_block(args)
    # # _err.throw_argument() if args.length == 1
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
    block ||= __cmpstrict
    coll = coll.to_native() if coll.to_native?
    nativeSort.call(coll, block)


  sort_by: (coll, block) ->
    callback = __blockify(block, coll)

    ary = []
    _itr.each coll, (value) ->
      ary.push new SortedElement(value, callback.invoke(arguments))

    ary = _arr.sort(ary, __cmpstrict)
    _arr.map(ary, (se) -> se.value)


  take: (coll, n) ->
    _err.throw_argument() if n < 0
    ary = []
    _itr.catch_break (breaker) ->
      _itr.each coll, ->
        breaker.break() if ary.length is n
        ary.push(BlockMulti.prototype.args(arguments))

    ary



  take_while: (coll, block) ->
    ary = []

    _itr.catch_break (breaker) ->
      _itr.each coll, ->
        breaker.break() if __falsey block.apply(coll, arguments)
        ary.push(BlockMulti.prototype.args(arguments))

    ary


  to_a: (coll) ->
    ary = []

    _itr.each coll, ->
      args = if arguments.length > 1 then nativeSlice.call(arguments, 0) else arguments[0]
      ary.push(args)
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
class SortedElement
  constructor: (@value, @sort_by) ->

  cmp: (other) ->
    @sort_by?.cmp(other.sort_by)


_itr = R._itr = new EnumerableMethods()
