# Rules:
#
# Do not call methods as instance methods, but through the singleton object "_arr".
# This allows for painless method chaining: _arr.map(["foo"], _str.capitalize)
#
class ArrayMethods extends EnumerableMethods
  equals: (arr, other) ->
    return true  if arr is other
    return false unless other?

    unless RArray.isNativeArray(other)
      return false unless other.to_ary?
      # return other['=='] arr

    return false unless arr.length is other.length

    i = 0
    total = i + arr.length
    while i < total
      return false unless R.is_equal(arr[i], other[i])
      i += 1

    true

  append: (arr, obj) ->
    arr.push(obj)
    arr


  '&': (other) ->
    arr   = []
    # TODO suboptimal solution.
    _arr.each arr, (el) ->
      arr.push(el) if _arr.include(other, el)

    _arr.uniq(arr)


  # @private
  '<=>': (other) ->
    # TODO


  at: (arr, index) ->
    if index < 0
      arr[arr.length + index]
    else
      arr[index]


  combination: (arr, num, block) ->
    return _arr.to_enum('combination', arr, num) unless block?.call?

    num = __int(num)
    len = arr.length


    if num is 0
      block([])
    else if num == 1
      _arr.each arr, (args...) ->
        block.call(arr, args)

    else if num == len
      block(arr.slice(0))

    else if num >= 0 && num < len
      num    = num
      stack  = (0 for i in [0..num+1])
      chosen = []
      lev    = 0
      done   = false
      stack[0] = -1
      until done
        chosen[lev] = arr[stack[lev+1]]
        while lev < num - 1
          lev += 1
          stack[lev+1] = stack[lev] + 1
          chosen[lev] = arr[stack[lev+1]]

        block.call(arr, chosen.slice(0))
        lev += 1

        # this is begin ... while
        done = lev == 0
        stack[lev] += 1
        lev = lev - 1
        while (stack[lev+1] + num == len + lev + 1)
          done = lev == 0
          stack[lev] += 1
          lev = lev - 1
    arr


  compact: (arr) ->
    # one liner: _arr.select arr, (el) -> el?
    ary = []
    for el in arr
      ary.push(el) if el?
    ary


  # @destructive
  delete: (arr, obj, block) ->
    deleted = []

    i = 0
    len = arr.length
    while i < len
      if R.is_equal(obj, arr[i])
        deleted.push(i)
      i += 1

    if deleted.length > 0
      arr.splice(i,1) for i in deleted.reverse()
      return obj

    if block then block() else null


  # @destructive
  delete_at: (arr, idx) ->
    idx = idx + arr.length if idx < 0
    return null if idx < 0 or idx >= arr.length
    arr.splice(idx, 1)[0]


  flatten: (arr, recursion = -1) ->
    arr = __arr(arr)
    ary = []

    _arr.each arr, (el) ->
      if recursion != 0 && __isArr(el)
        for item in _arr.flatten(el, recursion - 1)
          ary.push(item)
      else
        ary.push(el)

    ary


  each: (arr, block) ->
    return _arr.to_enum('each', [arr]) unless block?.call?

    if block.length > 0 # 'if' needed for to_a
      block = Block.supportMultipleArgs(block)

    idx = -1
    len = arr.length
    while ++idx < arr.length
      block(arr[idx])

    arr


  to_enum: (name, args) ->
    new R.Enumerator(_arr, name, args)


  each_index: (arr, block) ->
    return _arr.to_enum('each_index', [arr]) unless block?.call?

    idx = -1
    len = arr.length
    while ++idx < len
      block(idx)
    this


  get: (a, b) ->
    _arr.slice(a,b)


  empty: (arr) ->
    arr.length is 0


  fetch: (arr, idx, default_or_block) ->
    idx  = __int(idx)
    len  = arr.length
    orig = idx
    idx  = idx + len if idx < 0

    if idx < 0 or idx >= len
      return default_or_block(orig) if default_or_block?.call?
      return default_or_block   unless default_or_block is undefined

      throw R.IndexError.new()

    arr[idx]


  fill: ->
    # TODO


  # @destructive
  # @param items...
  insert: (arr, idx) ->
    throw R.ArgumentError.new() if idx is undefined

    return arr if arguments.length == 2
    items = _coerce.split_args(arguments, 2)

    len = arr.length
    # Adjust the index for correct insertion
    idx = idx + len + 1 if idx < 0 # Negatives add AFTER the element

    # TODO: add message "#{idx} out of bounds"
    throw R.IndexError.new() if idx < 0

    after  = arr.slice(idx)

    if idx > len
      for i in [len...idx]
        arr[i] = null

    len = 0
    for el, i in items
      if el != undefined
        arr[idx+i] = el
        len += 1

    for el, i in after
      arr[idx+len+i] = el

    arr


  join: (arr, separator) ->
    return '' if arr.length == 0
    separator = R['$,']  if separator is undefined
    separator = ''       if separator is null
    nativeJoin.call(arr, separator)


  last: (arr, n) ->
    len = arr.length
    if n is undefined
      return arr[len-1]

    if len is 0 or n is 0
      return []

    throw R.ArgumentError.new("count must be positive") if n < 0

    n = len if n > len
    arr[-n.. -1]


  product: (arr, args...) ->
    # TODO
    # block = R.__extract_block(args)
    # args = args.reverse()
    # for a in args
    #   throw R.TypeError.new() unless __isArr(a)

    # ary = []
    # args.push(arr)

    # # Implementation notes: We build a block that will generate all the
    # # combinations by building it up successively using "inject" and starting
    # # with one responsible to append the values.
    # outer = _arr.inject arr, ary.push, (trigger, values) ->
    #   (partial) ->
    #     for val in values
    #       trigger.call(ary, partial.concat(val))

    # outer( [] )
    # if block
    #   block_result = arr
    #   for v in ary
    #     block_result.push(block(v))
    #   block_result
    # else
    #   ary


  reverse_each: (arr, block) ->
    if block.length > 0 # if needed for to_a
      block = Block.supportMultipleArgs(block)

    idx = arr.length
    while idx--
      block(arr[idx])

    arr


  transpose: (arr) ->
    return [] if arr.length == 0

    out = []
    max = null

    # TODO: dogfood
    for ary in arr
      ary = _coerce.arr(ary)
      max ||= ary.length

      # Catches too-large as well as too-small (for which #fetch would suffice)
      # throw R.IndexError.new("All arrays must be same length") if ary.size != max
      throw R.IndexError.new() unless ary.length == max

      idx = -1
      len = ary.length
      while ++idx < len
        out.push([]) unless out[idx]
        entry = out[idx]
        entry.push(ary[idx])

    out

  uniq: (arr) ->
    ary = []
    _arr.each arr, (el) ->
      ary.push(el) if ary.indexOf(el) < 0
    ary


  __native_array_with__: (size, obj) ->
    ary = nativeArray(__int(size))
    idx = -1
    while ++idx < size
      ary[idx] = obj
    ary


_arr = R._arr = (arr) ->
  new RArray(arr)

R.extend(_arr, new ArrayMethods())