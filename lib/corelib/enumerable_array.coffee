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
