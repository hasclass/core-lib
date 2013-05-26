_arr = R._arr =
  flatten: (coll, recursion = -1) ->
    recursion = RCoerce.to_int_native(recursion)

    arr = []

    @each coll, (element) ->
      el = R(element)
      if recursion != 0 && el?.to_ary?
        el.to_ary().flatten(recursion - 1).each (e) -> arr.push(e)
      else
        arr.push(element)
    arr


  each: (coll, block) ->
    if block && block.call?

      if block.length > 0 # 'if' needed for to_a
        block = Block.supportMultipleArgs(block)

      idx = -1
      len = coll.length
      while ++idx < len
        block(coll[idx])

      this
    else
      new R.Enumerator(coll, 'each')


  reverse_each: (coll, block) ->
    if block.length > 0 # if needed for to_a
      block = Block.supportMultipleArgs(block)

    idx = coll.length
    while idx--
      block(coll[idx])

    coll



_arr.map = _enum.map
_arr.sort = _enum.sort