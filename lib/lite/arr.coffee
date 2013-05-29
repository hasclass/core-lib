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
    other = RCoerce.to_ary(other)
    arr   = new R.Array([])
    # TODO suboptimal solution.
    _arr.each (el) -> arr.push(el) if other.include(el)
    arr.uniq()


  # @private
  '<=>': (other) ->
    # TODO


  at: (arr, index) ->
    if index < 0
      arr[arr.length + index]
    else
      arr[index]


  combination: (arr, num, block) ->
    len = arr.length

    if num == 0
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
    ary = []
    _arr.each arr, (el) ->
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


  flatten: (coll, recursion = -1) ->
    recursion = RCoerce.to_int_native(recursion)

    arr = []

    _arr.each coll, (element) ->
      el = R(element)
      if recursion != 0 && el?.to_ary?
        el.to_ary().flatten(recursion - 1).each (e) -> arr.push(e)
      else
        arr.push(element)
    arr


  each: (arr, block) ->
    return _itr.to_enum(arr, 'each') unless block?.call?

    if block.length > 0 # 'if' needed for to_a
      block = Block.supportMultipleArgs(block)

    idx = -1
    len = arr.length
    while ++idx < arr.length
      block(arr[idx])

    arr


  get: (a, b) ->
    _arr.slice(a,b)


  empty: (arr) ->
    arr.length is 0


  fetch: (arr, idx, default_or_block) ->
    len = arr.length
    orig = idx
    idx = idx + len if idx < 0

    if idx < 0 or idx >= len
      return default_or_block(orig) if default_or_block?.call?
      return default_or_block   unless default_or_block is undefined

      throw R.IndexError.new()

    arr[idx]


  fill: ->
    # TODO


  # @destructive
  insert: (arr, idx, items...) ->
    throw R.ArgumentError.new() if idx is undefined

    return arr if items.length == 0

    # Adjust the index for correct insertion
    idx = idx + arr.length + 1 if idx < 0 # Negatives add AFTER the element

    # TODO: add message "#{idx} out of bounds"
    throw R.IndexError.new() if idx < 0

    after  = arr.slice(idx)
    len = items.length

    if idx > arr.length
      for i in [(arr.length)...idx]
        arr[i] = null

    for el, i in items
      arr[idx+i] = el

    for el, i in after
      arr[idx+len+i] = el

    arr


  join: (arr, separator) ->
    return '' if arr.length == 0
    separator = R['$,']  if separator is undefined
    separator = ''       if separator is null
    arr_join.call(arr, separator)


  reverse_each: (coll, block) ->
    if block.length > 0 # if needed for to_a
      block = Block.supportMultipleArgs(block)

    idx = coll.length
    while idx--
      block(coll[idx])

    coll


  uniq: (arr) ->
    ary = []
    _arr.each arr, (el) ->
      ary.push(el) if ary.indexOf(el) < 0
    ary


  __native_array_with__: (size, obj) ->
    ary = nativeArray(RCoerce.to_int_native(size))
    idx = -1
    while ++idx < size
      ary[idx] = obj
    ary


_arr = R._arr = new ArrayMethods()