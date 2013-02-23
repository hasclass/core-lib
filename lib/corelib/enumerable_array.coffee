# EnumerableArray provides optimized Enumerable methods for Array
#
# ## Optimized enumerable methods for Array
#
# Enumerables are slow through because of @each. using while loops
# is an order of magnitude faster. So all enum methods get a counterpart
# in array.
#
# @mixin
# @private
class RubyJS.EnumerableArray

  map: (block) ->
    return @to_enum('map') unless block?.call?

    [idx,len,ary] = @__iter_vars__()
    _isArr = R.Array.isNativeArray

    if block.length != 1
      while (++idx < @__native__.length)
        el = @__native__[idx]
        if typeof el is 'object' and _isArr(el)
          ary[idx] = block.apply(this, el)
        else
          ary[idx] = block(el);
    else
      while (++idx < @__native__.length)
        ary[idx] = block( @__native__[idx] )

    # adjust the array if elements were removed from this inside the bloc
    if len > @__native__.length
      ary.length = idx

    new R.Array(ary)


  __iter_vars__: (no_array) ->
    len = @__native__.length
    if no_array
      [-1, len]
    else
      [-1, len, nativeArray(len)]


  inject: (initial, sym, block) ->
    [initial, sym, block] = @__inject_args__(initial, sym, block)

    idx = -1

    while (++idx < @__native__.length)
      args = @__native__[idx]
      if initial is undefined
        initial = args
      else
        initial = block.call(this, initial, args)

    initial


  # any: (block) ->
  #   callback = $blockCallback(this, block)
  #   len = @__native__.length
  #   idx = -1
  #   while ++idx < len
  #     item = @__native__[idx]
  #     if block_given
  #       item = @__apply_block__(block, item)
  #     return true if R.truthy( item )
  #   false

  # all: (block) ->
  #   block_given = block && block.call?

  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     if block_given
  #       item = @__apply_block__(block, item)
  #     return false if R.falsey(item)
  #   true


  # collect_concat: (block = null) ->
  #   return @to_enum('collect_concat') unless block && block.call?

  #   ary = []

  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     ary.push @__apply_block__(block, item)

  #   new R.Array(ary).flatten(1)


  # count: (block) ->
  #   counter = 0
  #   idx = -1
  #   len = @__size__()

  #   if block is undefined
  #     counter = len
  #   else if block is null
  #     while ++idx < len
  #       counter += 1 if @__native__[idx] is null
  #   else if block.call?
  #     while ++idx < len
  #       unless R.falsey(@__apply_block__(block, @__native__[idx]))
  #         counter += 1
  #   else
  #     while ++idx < len
  #       # OPTIMIZE:
  #       counter += 1 if R(@__native__[idx])['=='](block)

  #   new R.Fixnum(counter)


  # cycle: (n, block) ->
  #   throw R.ArgumentError.new() if arguments.length > 2

  #   unless block
  #     if n && n.call?
  #       block = n
  #       n     = null

  #   if n is null or n is undefined
  #     many = null
  #   else
  #     many  = CoerceProto.to_int_native(n)
  #     return null if many <= 0

  #   return @to_enum('cycle', n) unless block

  #   idx   = -1
  #   cache = []
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     cache.push item
  #     @__apply_block__(block, item)

  #   return null if cache.length is 0

  #   if many is null
  #     while true
  #       idx = -1
  #       len = cache.length
  #       while ++idx < len
  #         @__apply_block__(block, cache[idx])
  #   else
  #     i = 0
  #     many = many - 1
  #     while many > i
  #       idx = -1
  #       len = cache.length
  #       while ++idx < len
  #         @__apply_block__(block, cache[idx])
  #         i += 1


  # drop: (n) ->
  #   @__ensure_args_length(arguments, 1)
  #   n = CoerceProto.to_int_native(n)

  #   throw R.ArgumentError.new() if n < 0

  #   ary = []
  #   len = @__native__.length
  #   idx = -1
  #   while ++idx < len
  #     ary.push(@__native__[idx]) if n <= idx

  #   new R.Array(ary)


  # drop_while: (block) ->
  #   return @to_enum('drop_while') unless block && block.call?

  #   idx = -1
  #   while ++idx < @__native__.length
  #     result = @__apply_block__(block, @__native__[idx])
  #     break if R.falsey(result)

  #   new R.Array(@__native__.slice(idx), false)


  # each_cons: (args...) ->
  #   block = @__extract_block(args)
  #   return @to_enum('each_cons', args...) unless block && block.call?

  #   @__ensure_args_length(args, 1)
  #   n = CoerceProto.to_int_native(args[0])

  #   throw R.ArgumentError.new() unless n > 0

  #   ary = []
  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     ary.push item
  #     ary.shift() if ary.length > n
  #     $exec(this, block, ary.slice(0))if ary.length is n
  #     @__apply_block__(block, ary.slice(0)) if ary.length is n

  #   null


  each_entry: (block) ->
    throw R.ArgumentError.new() if arguments.length > 1
    return @to_enum('each_entry') unless block && block.call?

    block = Block.supportMultipleArgs(block)
    idx = -1
    while ++idx < @__native__.length
      block(@__native__[idx])

    this


  # each_slice: (n, block) ->
  #   throw R.ArgumentError.new() unless n
  #   n = CoerceProto.to_int_native(n)

  #   throw R.ArgumentError.new() if n <= 0                  #each_slice(-1)
  #   throw R.ArgumentError.new() if block && !block.call?   #each_slice(1, block)

  #   return @to_enum('each_slice', n) if block is undefined #each_slice(1) # => enum

  #   ary = []
  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     ary.push( item )
  #     if ary.length == n
  #       @__apply_block__(block, ary.slice(0))
  #       ary = []

  #   unless ary.length == 0
  #     # TODO: check single arg:
  #     block(ary.slice(0))

  #   null

  each_with_index: (block) ->
    return @to_enum('each_with_index') unless block && block.call?

    idx = -1
    while ++idx < @__native__.length
      item = @__native__[idx]
      block(item, idx)
    this


  each_with_object: (obj, block) ->
    #throw RubyJS.ArgumentError.new() if block == undefined
    return @to_enum('each_with_object', obj) unless block && block.call?

    idx = -1
    while ++idx < @__native__.length
      block(@__native__[idx], obj)

    obj


  find: (ifnone, block = null) ->
    if block == null
      block  = ifnone
      ifnone = null

    block = Block.supportMultipleArgs(block)

    idx = -1
    len = @__native__.length
    while ++idx < len
      item = @__native__[idx]
      unless R.falsey(block(item))
        return item

    ifnone?()


  find_all: (block) ->
    return @to_enum('find_all') unless block && block.call?

    block = Block.supportMultipleArgs(block)

    ary = []
    idx = -1
    len = @__native__.length
    while ++idx < len
      item = @__native__[idx]
      unless R.falsey(block(item))
        ary.push(item)

    new R.Array(ary)


  find_index: (value) ->
    return @to_enum('find_index') if arguments.length == 0
    value = @box(value)

    if value.call?
      block = Block.supportMultipleArgs(value)
    else
      # OPTIMIZE: sorting
      block = (el) -> R(el)['=='](value) or el is value


    idx = -1
    len = @__native__.length
    while ++idx < len
      item = @__native__[idx]
      return R(idx) if block(item)
    null


  include: (other) ->
    other = R(other)

    idx = -1
    len = @__native__.length
    while ++idx < len
      item = @__native__[idx]
      # TODO: this is special. we're trying to typecast el, so we can
      # call == on it. This needs to be fixed, most probably with an R.equalss(a, b)
      # which takes care of non-R objects.
      # OPTIMIZE
      el = R(item)
      return true if other['==']?(el) or el['==']?(other)

    false


  grep: (pattern, block) ->
    ary = new R.Array([])
    pattern = R(pattern)

    block = Block.supportMultipleArgs(block)

    idx = -1
    len = @__native__.length
    if block
      while ++idx < len
        item = @__native__[idx]
        ary.append(block(item)) if pattern['==='](item)
    else
      while ++idx < len
        item = @__native__[idx]
        ary.append(item) if pattern['==='](item)

    ary


  group_by: (block) ->
    return @to_enum('group_by') unless block?.call?
    block = Block.supportMultipleArgs(block)

    hsh = {}
    idx = -1
    len = @__native__.length
    while ++idx < len
      item = @__native__[idx]
      key  = block(item)

      hsh[key] ||= new R.Array([])
      hsh[key].append(item)

    hsh

  # first: needs no specific changes

  max: (block) ->
    max = undefined
    block ||= RubyJS.Comparable.cmp
    # Following Optimization won't complain if:
    # [1,2,'3']
    # optimization for elements that are arrays
    # OPTIMIZE: use normal iterator
    if @__samesame__?()
      arr = @__native__
      if arr.length < 65535
        _max = Math.max.apply(Math, arr)
        return _max if _max isnt NaN
    idx = -1
    len = @__native__.length
    while ++idx < len
      item = @__native__[idx]
      if max is undefined
        max = item
      else
        comp = block(item, max)
        throw R.ArgumentError.new() if comp is null
        max = item if comp > 0
    max or null


  max_by: (block) ->
    return @to_enum('max_by') unless block?.call?

    max = undefined
    idx = -1
    len = @__native__.length
    # OPTIMIZE. uses SortedElement!
    while ++idx < len
      item = @__native__[idx]
      if max is undefined
        max = item
      else
        cmp = R.Comparable.cmpstrict(block(item), block(max))
        max = item if cmp > 0
    max or null

  # The following breaks block arg specs:
  # max_by: (block) ->
  #   return @to_enum('max_by') unless block?.call?

  #   max_val = undefined # the actual element
  #   max_cmp = undefined # evaluated block value
  #   idx = -1
  #   len = @__native__.length
  #   while ++idx < len
  #     item = @__native__[idx]
  #     if max_val is undefined
  #       max_val = item
  #       max_cmp = block(item)
  #     else
  #       item_cmp = block(item)
  #       cmp = R.Comparable.cmpstrict(item_cmp, max_cmp)
  #       if cmp > 0
  #         max_val = item
  #         max_cmp = item_cmp
  #   max_val or null

  min: (block) ->
    min = undefined
    block ||= RubyJS.Comparable.cmp
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
    idx = -1
    len = @__native__.length
    # OPTIMIZE
    while ++idx < len
      item = @__native__[idx]
      if min is undefined
        min = item
      else
        cmp = block(item, min)
        throw R.ArgumentError.new() if cmp is null
        min = item if cmp < 0
    min or null


  min_by: (block) ->
    return @to_enum('min_by') unless block?.call?

    min = undefined
    block ||= (el, min) -> el['<=>'](min)
    idx = -1
    len = @__native__.length
    # OPTIMIZE. uses SortedElement!
    while ++idx < len
      item = @__native__[idx]
      if min is undefined
        min = item
      else
        cmp = RubyJS.Comparable.cmpstrict(block(item), block(min))
        min = item if cmp < 0
    min or null


  minmax: (block) ->
    # TODO: optimize
    R([@min(block), @max(block)])


  minmax_by: (block) ->
    return @to_enum('minmax_by') unless block?.call?

    # TODO: optimize
    R([@min_by(block), @max_by(block)])


  # none: (block) ->
  #   block_given = block && block.call?
  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     if block_given
  #       item = @__apply_block__(block, item)
  #     return false unless R.falsey( item )
  #   true

  # one: (block) ->
  #   block_given = block && block.call?

  #   cnt = 0
  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     if block_given
  #       item = @__apply_block__(block, item)
  #     cnt += 1 unless R.falsey( item )
  #     return false if cnt > 1

  #   cnt is 1


  # partition: (block) ->
  #   return @to_enum('partition') unless block && block.call?

  #   left  = []
  #   right = []

  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     if @__apply_block__(block, item)
  #       left.push(item)
  #     else
  #       right.push(item)

  #   new R.Array([new R.Array(left), new R.Array(right)])


  # reject: (block) ->
  #   return @to_enum('reject') unless block && block.call?

  #   ary = []
  #   idx = -1
  #   while ++idx < @__native__.length
  #     item = @__native__[idx]
  #     if R.falsey(@__apply_block__(block, item))
  #       ary.push(item)

  #   new R.Array(ary)


  # slice_before: (args...) ->
  #   block = @__extract_block(args)
  #   # throw R.ArgumentError.new() if args.length == 1
  #   arg   = R(args[0])

  #   if block
  #     has_init = !(arg is undefined)
  #   else
  #     block = (elem) -> arg['==='] elem

  #   arr = @__native__
  #   idx = -1
  #   len = arr.length
  #   R.Enumerator.create (yielder) ->
  #     accumulator = null
  #     while ++idx < len
  #       elem = arr[idx]
  #       start_new = if has_init then block(elem, arg.dup()) else block(elem)
  #       if start_new
  #         yielder.yield accumulator if accumulator
  #         accumulator = R([elem])
  #       else
  #         accumulator ||= new R.Array([])
  #         accumulator.append elem
  #     yielder.yield accumulator if accumulator


  # sort_by: (block) ->
  #   return @to_enum('sort_by') unless block && block.call?


  #   idx = -1
  #   len = @__native__.length
  #   ary = nativeArray(len)
  #   while ++idx < len
  #     item = @__native__[idx]
  #     ary[idx] = new R.Enumerable.SortedElement(item, @__apply_block__(block, item))

  #   # OPTIMIZE
  #   ary = new R.Array(ary)
  #   ary.sort().map (se) -> se.value


  # take: (n) ->
  #   @__ensure_args_length(arguments, 1)
  #   n = CoerceProto.to_int_native(n)
  #   throw R.ArgumentError.new() if n < 0

  #   ary = []
  #   idx = -1
  #   len = @__native__.length
  #   while ++idx < len
  #     break if ary.length is n
  #     ary.push(@__native__[idx])

  #   new R.Array(ary)


  # take_while: (block) ->
  #   return @to_enum('take_while') unless block && block.call?

  #   ary = []
  #   idx = -1
  #   len = @__native__.length
  #   while ++idx < len
  #     item = @__native__[idx]
  #     break if R.falsey block(item)
  #     ary.push(item)

  #   new R.Array(ary)


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


