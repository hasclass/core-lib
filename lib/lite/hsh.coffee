class HashMethods extends EnumerableMethods
  assoc: (hsh, needle) ->
    if typeof needle is 'object' and needle.equals?
      for own k, v of hsh
        return [k, v] if needle.equals(k)
    else
      for own k, v of hsh
        return [k, v] if needle == k

    null


  delete: (hsh, key, block) ->
    if `key in hsh`
      value = hsh[key]
      delete hsh[key]
      return value
    else
      if block?.call?
        block(key)
      else
        null


  delete_if: (hsh, block) ->
    if block?.call?
      for own k,v of hsh
        if block(k,v)
          delete hsh[k]
      hsh
    else
      # TODO: @to_enum('delete_if')


  each: (hsh, block) ->
    # TODO to_enum
    for own k,v of hsh
      block(k,v)
    hsh


  each_key: (hsh, block) ->
    for own k,v of hsh
      block(k)
    hsh


  each_value: (hsh, block) ->
    for own k,v of hsh
      block(v)
    hsh


  empty: (hsh) ->
    for own k, v of hsh
      return false
    true


  fetch: (hsh, key, default_value) ->
    if arguments.length <= 1
      _err.throw_argument()

    if `key in hsh`
      hsh[key]
    else if default_value?.call? || arguments[3]?.call?
      (arguments[3] || default_value)(key)
    else if default_value != undefined
      default_value
    else
      _err.throw_key()


  flatten: (hsh, recursion = 1) ->
    recursion = __int(recursion)
    _arr.flatten(_hsh.to_a(hsh), recursion)


  get: (hsh, key) ->
    hsh[key]


  has_value: (hsh, val) ->
    if typeof val is 'object' && val.equals?
      for own k, v of hsh
        return true if val.equals(v)
    else
      for own k, v of hsh
        return true if v == val

    false


  has_key: (hsh, key) ->
    `key in hsh`


  include: @prototype.has_key
  member:  @prototype.has_key


  keep_if: (hsh, block) ->
    _hsh.reject$(hsh, block)
    hsh


  key: (hsh, value) ->
    if typeof value is 'object' && value.equals?
      for own k, v of hsh
        return k if value.equals(v)
    else
      for own k, v of hsh
        return k if v == value

    null


  invert: (hsh) ->
    ret = {}
    for own k, v of hsh
      ret[v] = k
    ret


  keys: (hsh) ->
    k for own k, v of hsh


  merge: (hsh, other, block) ->
    out = {}
    other = other.__native__ if other.rubyjs?

    for own k, v of hsh
      out[k] = v
    for own k, v of other
      if block?.call? and `k in out`
        out[k] = block(k, out[k], v)
      else
        out[k] = v

    out


  merge$: (hsh, other, block) ->
    other = other.__native__ if other.rubyjs?

    for own k, v of hsh
      hsh[k] = v
    for own k, v of other
      if block?.call? and `k in hsh`
        hsh[k] = block(k, hsh[k], v)
      else
        hsh[k] = v

    hsh


  rassoc: (hsh, needle) ->
    if typeof needle is 'object' && needle.equals?
      for own k, v of hsh
        if needle.equals(v)
          return [k, v]
    else
      for own k, v of hsh
        if needle == v
          return [k, v]

    null


  reject: (hsh, block) ->
    dup = {}
    for own k,v of hsh
      if !block(k, v)
        dup[k] = v
    dup


  # @destructive
  reject$: (hsh, block) ->
    changed = false
    for own k,v of hsh
      if !block(k, v)
        delete hsh[k]
        changed = true

    if changed then hsh else null


  select: (hsh, block) ->
    dup = {}
    for own k,v of hsh
      if block(k, v)
        dup[k] = v
    dup


  select$: (hsh, block) ->
    changed = false
    for own k,v of hsh
      if block(k, v)
        delete hsh[k]
        changed = true

    if changed then hsh else null


  size: (hsh) ->
    counter = 0
    for own k, v of hsh
      counter += 1
    counter


  sort: (hsh, block) ->
    _arr.sort(_hsh.to_a(hsh), block)



  to_a: (hsh) ->
    for own k, v of hsh
      [k, v]


  values: (hsh) ->
    v for own k, v of hsh


  values_at: (hsh, keys...) ->
    hsh[k] for k in keys



_hsh = R._hsh = (arr) ->
  new RHash(arr)

R.extend(_hsh, new HashMethods())