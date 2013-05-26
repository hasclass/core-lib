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


  take: (coll, n) ->
    throw R.ArgumentError.new() if n < 0

    ary = []
    @catch_break (breaker) ->
      @each coll, ->
        breaker.break() if ary.length is n
        ary.push(BlockMulti.prototype.args(arguments))

    ary

_enum.detect = _enum.find
_enum.select = _enum.find_all

