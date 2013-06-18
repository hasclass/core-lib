class ArrayMethods extends EnumerableMethods

  equals: (arr, other) ->
    return true  if arr is other
    return false unless other?

    if __isArr(other)
      other = __arr(other)
    else
      return false

    return false unless arr.length is other.length

    i = 0
    total = i + arr.length
    while i < total
      return false unless __equals(arr[i], other[i])
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
  cmp: (other) ->
    # TODO


  at: (arr, index) ->
    if index < 0
      arr[arr.length + index]
    else
      arr[index]


  combination: (arr, num, block) ->
    return __enumerate(_arr.combination, arr, num) unless block?

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
      if __equals(obj, arr[i])
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

    len = arr.length
    idx = -1
    while (++idx < len)
      el = arr[idx]
      if recursion != 0 && __isArr(el)
        nativePush.apply(ary, _arr.flatten(el, recursion - 1))
      else
        ary.push(el)

    ary


  each: (arr, block) ->
    return __enumerate(_arr.each, [arr]) unless block?

    block = Block.splat_arguments(block)

    idx = -1
    len = arr.length
    while ++idx < arr.length
      block(arr[idx])

    arr


  # @non-ruby
  each_with_context: (arr, thisArg, block) ->
    return __enumerate(_arr.each_with_context, [arr, thisArg]) unless block?

    block = Block.splat_arguments(block)

    idx = -1
    len = arr.length
    while ++idx < arr.length
      block.call(thisArg, arr[idx])

    thisArg


  each_index: (arr, block) ->
    return __enumerate(_arr.each_index, [arr]) unless block?

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

      _err.throw_index()

    arr[idx]


  # @destructive
  fill: (arr, args...) ->
    _err.throw_argument() if args.length == 0
    block = __extract_block(args)

    if block
      _err.throw_argument() if args.length >= 3
      one = args[0]; two = args[1]
    else
      _err.throw_argument() if args.length > 3
      obj = args[0]; one = args[1]; two = args[2]

    size = arr.length

    if one?.is_range?
      # TODO: implement fill with range
      _err.throw_not_implemented()

    else if one isnt undefined && one isnt null
      left = __int(one)
      left = left + size    if left < 0
      left = 0              if left < 0

      if two isnt undefined && two isnt null
        try
          right = __int(two)
        catch e
          _err.throw_argument("second argument must be a Fixnum")
        return arr if right is 0
        right = right + left
      else
        right = size
    else
      left  = 0
      right = size

    total = right

    if right > size # pad with nul if length is greater than array
      fill = _arr.__native_array_with__(right - size, null)
      arr.push.apply(arr, fill)
      total = right

    i = left
    if block
      while total > i
        v = block(i)
        arr[i] = if v is undefined then null else v
        i += 1
    else
      while total > i
        arr[i] = obj
        i += 1

    arr


  # @destructive
  # @param items...
  insert: (arr, idx) ->
    _err.throw_argument() if idx is undefined

    return arr if arguments.length == 2
    items = _coerce.split_args(arguments, 2)

    len = arr.length
    # Adjust the index for correct insertion
    idx = idx + len + 1 if idx < 0 # Negatives add AFTER the element

    # TODO: add message "#{idx} out of bounds"
    _err.throw_index() if idx < 0

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


  keep_if: (arr, block) ->
    return __enumerate(_arr.keep_if, [arr]) unless block?

    block = Block.splat_arguments(block)

    ary = []
    idx = -1
    len = arr.length
    while ++idx < len
      el = arr[idx]
      ary.push(el) unless __falsey(block(el))

    ary


  last: (arr, n) ->
    len = arr.length
    if n is undefined
      return arr[len-1]

    if len is 0 or n is 0
      return []

    _err.throw_argument("count must be positive") if n < 0

    n = len if n > len
    arr[-n.. -1]


  minus: (arr, other) ->
    other = __arr(other)

    ary = []
    idx = -1
    len = arr.length
    while ++idx < len
      el = arr[idx]
      ary.push(el) unless _arr.include(other, el)

    ary


  multiply: (arr, multiplier) ->
    _err.throw_type() if multiplier is null

    if __isStr(multiplier)
      return _arr.join(arr, __str(multiplier))
    else
      multiplier = __int(multiplier)

      _err.throw_argument("count cannot be negative") if multiplier < 0

      total = arr.length
      if total is 0
        return []
      else if total is 1
        return arr.slice(0)

      ary = []
      idx = -1
      while ++idx < multiplier
        ary = ary.concat(arr)

      ary


  pop: (arr, many) ->
    if many is undefined
      arr.pop()
    else
      many = __int(many)
      _err.throw_argument("negative array size") if many < 0
      ary = []
      len = arr.length
      many = len if many > len
      while many--
        ary[many] = arr.pop()
      ary


  product: (arr, args...) ->
    result = []
    block = __extract_block(args)

    args = for a in args
      __arr(a)
    args = args.reverse()
    args.push(arr)

    # Implementation notes: We build a block that will generate all the
    # combinations by building it up successively using "inject" and starting
    # with one responsible to append the values.
    outer = _arr.inject args, result.push, (trigger, values) ->
      (partial) ->
        for val in values
          trigger.call(result, partial.concat(val))

    outer( [] )
    if block
      block_result = arr
      for v in result
        block_result.push(block(v))
      block_result
    else
      result


  rassoc: (arr, obj) ->
    len = arr.length
    idx = -1
    while ++idx < len
      elem = arr[idx]
      try
        el = __arr(elem)
        if __equals(el[1], obj)
          return elem
      catch e
        null
    null


  reverse_each: (arr, block) ->
    return __enumerate(_arr.reverse_each, [arr]) unless block?

    block = Block.splat_arguments(block)

    idx = arr.length
    while idx--
      block(arr[idx])

    arr


  rindex: (arr, other) ->
    return __enumerate(_arr.rindex, [arr, other]) if other is undefined

    len = arr.length
    ridx = arr.length
    if other.call?
      block = Block.splat_arguments(other)
      while ridx--
        el = arr[ridx]
        unless __falsey(block(el))
          return ridx

    else
      # TODO: 2012-11-06 use a while loop with idx counting down
      while ridx--
        el = arr[ridx]
        if __equals(el, other)
          return ridx

    null


  rotate: (arr, cnt) ->
    if cnt is undefined
      cnt = 1
    else
      cnt = __int(cnt)

    len = arr.length
    return arr  if len is 1
    return []   if len is 0

    idx = cnt % len

    # TODO: optimize
    sliced = arr.slice(0, idx)
    arr.slice(idx).concat(sliced)


  sample: (arr, n, range = undefined) ->
    len = arr.length
    return arr[__rand(len)] if n is undefined
    n = __int(n)
    _err.throw_argument() if n < 0

    n    = len if n > len

    ary = arr.slice(0)
    idx = -1
    while ++idx < n
      ridx = idx + __rand(len - idx) # Random idx
      tmp  = ary[idx]
      ary[idx]  = ary[ridx]
      ary[ridx] = tmp

    ary.slice(0, n)


  shuffle: (arr) ->
    len = arr.length
    ary = new Array(len)
    idx = -1
    while ++idx < len
      rnd = idx + __rand(len - idx)
      tmp = arr[idx]
      ary[idx] = arr[rnd]
      ary[rnd] = tmp
    ary


  slice: (arr, idx, length) ->
    _err.throw_type() if idx is null
    size = arr.length

    if idx?.is_range?
      range = idx
      range_start = __int(range.begin())
      range_end   = __int(range.end()  )
      range_start = range_start + size if range_start < 0

      if range_end < 0
        range_end = range_end + size

      range_end   = range_end + 1 unless range.exclude_end()
      range_lenth = range_end - range_start
      return null if range_start > size  or range_start < 0
      return arr.slice(range_start, range_end)
    else
      idx = __int(idx)

    idx = size + idx if idx < 0
    # return @$String('') if is_range and idx.lteq(size) and idx.gt(length)

    if length is undefined
      return null if idx < 0 or idx >= size
      arr[idx]
    else
      length = __int(length)
      return null if idx < 0 or idx > size or length < 0
      arr.slice(idx, length + idx)


  transpose: (arr) ->
    return [] if arr.length == 0

    out = []
    max = null

    # TODO: dogfood
    for ary in arr
      ary = __arr(ary)
      max ||= ary.length

      # Catches too-large as well as too-small (for which #fetch would suffice)
      # _err.throw_index("All arrays must be same length") if ary.size != max
      _err.throw_index() unless ary.length == max

      idx = -1
      len = ary.length
      while ++idx < len
        out.push([]) unless out[idx]
        entry = out[idx]
        entry.push(ary[idx])

    out


  uniq: (arr) ->
    idx = -1
    len = arr.length
    ary = []

    while (++idx < len)
      el = arr[idx]
      ary.push(el) if ary.indexOf(el) < 0

    ary


  unshift: (arr, args...) ->
    args.concat(arr)


  # values_at2: (arr, args...) ->
  #   for idx in args
  #     _arr.at(arr, __int(idx)) || null


  union: (arr, other) ->
    _arr.uniq(arr.concat(__arr(other)))



  values_at: (arr) ->
    len = arguments.length
    ary = new Array(len - 1)
    idx = 1
    while idx < len
      ary[idx - 1] = _arr.at(arr, __int(arguments[idx])) || null
      idx += 1
    ary



  # ---- Enumerable implementations ------------------------


  find_index: (arr, value) ->
    len = arr.length
    idx = -1

    if typeof value is 'function' or (typeof value is 'object' && value.call?)
      block = Block.splat_arguments(value)
    else if value != null && typeof value is 'object'
      block = (el) -> __equals(value, el)
    else
      while ++idx < len
        return idx if arr[idx] == value
      return null

    while ++idx < len
      return idx if block(arr[idx])

    null


  first: (arr, n) ->
    if n?
      _err.throw_argument() if n < 0
      arr.slice(0,n)
    else
      arr[0]


  map: (arr, block) ->
    callback = Block.splat_arguments(block)

    idx = -1
    len = arr.length
    ary = new Array(len)
    while ++idx < len
      ary[idx] = callback(arr[idx])

    ary


  take: @prototype.first



  __native_array_with__: (size, obj) ->
    ary = nativeArray(__int(size))
    idx = -1
    while ++idx < size
      ary[idx] = obj
    ary


_arr = R._arr = (arr) ->
  new RArray(arr)


R.extend(_arr, new ArrayMethods())