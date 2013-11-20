class HashMethods extends EnumerableMethods

  # Returns array of [ key, value ] if needle equals to a key in the hsh.
  # Otherwise, returns null.
  #
  # @example
  #   var hsh = {one: 1, two: 2}
  #   _h.assoc(hsh, 'two')        // => ['two', 2]
  #   _h.assoc(hsh, 2)            // => null
  #
  # @return [Array] or [null]
  #
  assoc: (hsh, needle) ->
    if typeof needle is 'object' and needle.equals?
      for own k, v of hsh
        return [k, v] if needle.equals(k)
    else
      for own k, v of hsh
        return [k, v] if needle == k

    null


  # Deletes key from hsh.
  # Returns value of the key if the key was found in hsh.
  # Invokes block if key was not found and block has been passed.
  # Returns null if key was not found in hsh.
  #
  # @example
  #   var hsh = {one: 1, two: 2}
  #   var print = function(i) {console.log(i + '..')};
  #   _h.delete(hsh, 'one')         // => 1
  #   _h.delete(hsh, 2, print )     // => 2..
  #   _h.delete(hsh, 'four')        // => null
  #
  # @return [String] or [this] or [null]
  #
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


  # Invokes block for each key in hsh.
  # Returns hsh.
  #
  # @example
  #   var print = function(i) {console.log(i + '..')};
  #   var hsh = {one: 1, two: 2}
  #   _h.each_key(hsh, print)   // => "one..\ntwo..\n{one: 1, two: 2}"
  #
  # @return [Object]
  #
  each_key: (hsh, block) ->
    for own k,v of hsh
      block(k)
    hsh


  # Invokes block for each value in hsh.
  # Returns hsh.
  #
  # @example
  #   var print = function(i) {console.log(i + '..')};
  #   var hsh = {one: 1, two: 2}
  #   _h.each_key(hsh, print)   // => "1..\n2..\n{one: 1, two: 2}"
  #
  # @return [Object]
  #
  each_value: (hsh, block) ->
    for own k,v of hsh
      block(v)
    hsh


  # Checks if hsh contains any keys and values.
  # Returns false if hsh contains any keys and values.
  # Returns true otherwise.
  #
  # @example
  #   var hsh = {one: 1, two: 2}
  #   _h.empty(hsh)       // => false
  #   _h.empty({})        // => true
  #
  # @return [Boolean]
  #
  empty: (hsh) ->
    for own k, v of hsh
      return false
    true


  # Returns a value for a passed key in hsh.
  # Throws ArgumentError if only one or no arguments were passed.
  # If the key cannot be found on hsh and default_value is not a function, then
  # value of default_value will be returned.
  # If the key cannot be found and default_value is a function, then
  # the function will be executed passing the key as a parameter.
  # Returns undefined after the execution of the function.
  # Throws KeyError if default_value was not passed and the key cannot be found
  # in hsh.
  #
  # @example
  #   var print = function(i) {console.log(i + '..')};
  #   var hsh = {one: 1, two: 2}
  #   _h.fetch(hsh, 'one')              // => 1
  #   _h.fetch(hsh, 'four')             // => Error: KeyError
  #   _h.fetch(hsh, 'four', 3)          // => 3
  #   _h.fetch(hsh)                     // => Error: ArgumentError
  #   _h.fetch(hsh, 'four', print)      // => four..\n undefined
  #
  # @return [this] or [String] or [Number] or [Undefined]
  #
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


  # Flattens a hsh into array.
  # By default, recursively flattens elements of the hsh and
  # returns one-dimensional array.
  # Recursion can be disabled by passing 0 as a second argument.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.flatten(hsh)                     // => ['one', 1, 'two', 2]
  #   _h.flatten(hsh, 0)                  // => [ ['one', 1], ['two', 2] ]
  #
  # @return [Array]
  flatten: (hsh, recursion = 1) ->
    recursion = __int(recursion)
    _arr.flatten(_hsh.to_a(hsh), recursion)


  # Returns value of the key in hsh.
  # Returns undefined If key was not found or not provided.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.get(hsh, 'one')                  // => 1
  #   _h.get(hsh, 1)                      // => undefined
  #
  # @return [Object]
  get: (hsh, key) ->
    hsh[key]


  # Returns true if a value is present for some key in hsh.
  # Returns false otherwise or if a value was not passed.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.has_value(hsh, 2)               // => true
  #   _h.has_value(hsh, 'one')           // => false
  #   _h.has_value(hsh)                  // => false
  #
  # @return [Boolean]
  has_value: (hsh, val) ->
    if typeof val is 'object' && val.equals?
      for own k, v of hsh
        return true if val.equals(v)
    else
      for own k, v of hsh
        return true if v == val

    false


  # Returns true if key was found in hsh.
  # Otherwise, returns false.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.has_key(hsh, 'one')                // => true
  #   _h.has_key(hsh, 2)                    // => false
  #
  # @return [Boolean]
  has_key: (hsh, key) ->
    `key in hsh`


  include: @prototype.has_key
  member:  @prototype.has_key


  # Deletes all key-value pairs from hsh for which block evaluates to false.
  # Returns hash.
  # Modifies original hash (destructive).
  # Throws error if no block was passed.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.keep_if(hsh, function(k, v) { return v == 1 })     // => {one: 1}
  #   _h.keep_if(hsh)                                       // => TypeError: undefined is not a function
  #
  # @return [Object]
  keep_if: (hsh, block) ->
    _hsh.reject$(hsh, block)
    hsh


  # Returns a key from hsh for a given value.
  # Returns null if the value was not found in hsh or was not passed.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.key(hsh, 2)                                        // => 'two'
  #   _h.key(hsh, 'three')                                  // => null
  #
  # @return [String] or [Object]
  key: (hsh, value) ->
    if typeof value is 'object' && value.equals?
      for own k, v of hsh
        return k if value.equals(v)
    else
      for own k, v of hsh
        return k if v == value

    null


  # Returns hash, in which values are keys of hsh
  # and values are keys of hsh.
  # Returns empty hash if no argument was passed.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.invert(hsh)                              // => {'1': 'one', '2': 'two'}
  #   _h.invert()                                 // => {}
  #
  # @return [Object]
  invert: (hsh) ->
    ret = {}
    for own k, v of hsh
      ret[v] = k
    ret


  # Returns a new array containing keys from hsh.
  # Returns empty array if hsh is empty.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   _h.keys(hsh)                          // => [ 'one', 'two' ]
  #   _h.keys({})                           // => []
  #
  # @return [Object]
  keys: (hsh) ->
    k for own k, v of hsh


  # Returns a hash, which contains contents of hsh and other.
  # If no block is passed then values of duplicate keys will be taken from other.
  # If block is passed then the value for each duplicate key is determined by
  # calling a block.
  #
  # @example
  #   hsh = {one: 1, two: 2}
  #   other = {three: 3}
  #   _h.merge(hsh, other)                      // => {one: 1, two: 2, three: 3}
  #
  #   block = function (key, a, b) { return a + b }
  #   hash = {two: '5.0'}
  #   _h.merge(hsh, hash, block)                // => {one: 1, two: '25.0'}
  #
  # @return [Object]
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


  # Destructive merge.
  # Returns a hash, which contains contents of hsh and other.
  # If no block is passed then values of duplicate keys will be taken from other and
  # overwritten in hsh.
  # If block is passed then the value for each duplicate key is determined by
  # calling a block with a key, it's value in hsh and it's value in other.
  #
  # @example
  #   hsh = {one:1, two:2}
  #   other = {two: 20, three: 3}
  #   _h.merge$(hsh, other)                     // => {one: 1, two: 20, three: 3}
  #   hsh                                       // => {one: 1, two: 20, three: 3}
  #
  #   block = function (key, v1, v2) { return v1 + v2 }
  #   hsh = {one:1, two:2}
  #   other = {two: 22, three: 3}
  #   _h.merge$(hsh, other, block)              // => {one: 1, two: 24, three: 3}
  #   hsh                                       // => {one: 1, two: 24, three: 3}
  #
  # @return [Object]
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


  # Searches through hsh by comparing values to needle.
  # Returns null if there were no matches.
  # Returns an array of two elements [key, value] of the first match.
  #
  # @example
  # hsh = {one: 1, two: 2, three:3, five: 3}
  # _h.rassoc(hsh, 5)                             // => null
  # _h.rassoc(hsh, 3)                             // => ['three', 3]
  #
  # @return [Array] or [null]
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


  # Removes key-value pairs from hsh for which block evaluates to true.
  # Returns a copy of hsh with key-value pairs removed.
  #
  # @example
  #   hsh = {one: 1, two: 2, three: 3}
  #   block = function (k, v) { return v < 2 }
  #   _h.reject(hsh, block)                         // => {two: 2, three: 3}
  #
  # @return [Object]
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



_hsh = R._hsh = (hsh) ->
  new Chain(hsh, _hsh)

R.extend(_hsh, new HashMethods())
