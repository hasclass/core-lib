#
# Unsupported: #value?() use @has_value?
#
class RubyJS.Hash extends RubyJS.Object
  @include R.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  @new: () ->
    new R.Hash()

  constructor: (hsh, default_value) ->
    @__native__ = hsh
    @__default__ = default_value

  # ---- RubyJSism ------------------------------------------------------------

  # ---- Javascript primitives --------------------------------------------------

  # ---- Instance methods -----------------------------------------------------

  # Searches through the hash comparing obj with the key using ==. Returns the
  # key-value pair (two elements array) or nil if no match is found. See
  # Array#assoc.
  #
  # @example
  #     h = R.hashify({colors: ["red", "blue", "green"], letters: ["a", "b", "c" ]})
  #     h.assoc("letters")  #=> ["letters", ["a", "b", "c"]]
  #     h.assoc("foo")      #=> null
  #
  assoc: (needle) ->
    needle = R(needle)

    arr = []
    if needle.rubyjs?
      for own k, v of @__native__
        if needle.equals(k)
          return new R.Array([k, v])
    else
      for own k, v of @__native__
        if needle == k
          return new R.Array([k, v])

    null


  # Removes all key-value pairs from hsh.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.clear()  #=> {}
  #
  # @return [this]
  #
  clear: ->
    @__native__ = {}
    this


  # Returns the default value, the value that would be returned by hsh if key
  # did not exist in hsh. See also Hash::new and Hash#default=.
  #
  # @example
  #      h = R.Hash.new()                        #=> {}
  #      h.default()                             #=> null
  #      h.default(2)                            #=> null
  #
  #      h = R.Hash.new({}, "cat")               #=> {}
  #      h.default( )                            #=> "cat"
  #      h.default(2)                            #=> "cat"
  #
  #      h = R.Hash.new({}, function(h,k) { return h.set(k, k*10) }   #=> {}
  #      h.default( )                            #=> null
  #      h.default(2)                            #=> 20
  #
  # @return [Object, null]
  #
  default: (key) ->
    if @__default__
      if @__default__.call?
        @__default__(this, key) unless key is undefined
      else
        @__default__
    else
      null


  # If Hash.new was invoked with a block, return that block, otherwise return
  # nil.
  #
  # @example
  #     h = new R.Hash(function(h,k) { return h.set(k, k*k) }   #=> {}
  #     p = h.default_proc()               #=> function
  #
  default_proc: ->
    if @__default__?.call?
      @__default__
    else
      null


  # Deletes and returns a key-value pair from hsh whose key is equal to key.
  # If the key is not found, returns the default value. If the optional code
  # block is given and the key is not found, pass in the key and return the
  # result of block.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.delete("a")                              #=> 100
  #     h.delete("z")                              #=> nil
  #     h.delete("z", function (el) { return "#{el} not found" )
  #     #=> "z not found"
  #
  # @return [Object, null]
  #
  delete: (key, block) ->
    if @has_key(key)
      value = @get(key)
      delete @__native__[key]
      return value
    else
      if block?.call?
        block(key)
      else
        null


  # Deletes every key-value pair from hsh for which block evaluates to true.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200, c: 300 })
  #     h.delete_if(function(key, value) {return key >= "b"}
  #     #=> {"a"=>100}
  #
  # @return [this, R.Enumerator]
  #
  delete_if: (block) ->
    if block?.call?
      for own k,v of @__native__
        if block(k,v)
          delete @__native__[k]

      this
    else
      @to_enum('delete_if')


  # Calls block once for each key in hsh, passing the key-value pair as
  # parameters.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.each(function (k,v) { R.puts "#{k} is #{v}" }
  #     # produces:
  #     # a is 100
  #     # b is 200
  #
  # @return [this, R.Enumerator]
  #
  each: (block) ->
    if block?.call?
      for own k,v of @__native__
        block(k,v)
      this
    else
      @to_enum('each')



  # Alias for {#each}
  each_pair: @prototype.each


  # Calls block once for each key in hsh, passing the key as a parameter.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 }
  #     h.each_key (key) -> R.puts(key)
  #     # produces:
  #     # a
  #     # b
  #
  # @return [this, R.Enumerator]
  #
  each_key: (block) ->
    if block?.call?
      for own k,v of @__native__
        block(k)
      this
    else
      @to_enum('each_key')


  # Calls block once for each key in hsh, passing the value as a parameter.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.each(function (k,v) { R.puts v }
  #     # produces:
  #     # 100
  #     # 200
  #
  # @return [this, R.Enumerator]
  #
  each_value: (block) ->
    if block?.call?
      for own k,v of @__native__
        block(v)
      this
    else
      @to_enum('each_value')

  # Returns true if hsh contains no key-value pairs.
  #
  #     R.hashify({}).empty()   #=> true
  #
  # @return [Boolean]
  #
  empty: ->
    for own k, v of @__native__
      return false
    true


  eql: (other) ->
    other = other.to_native?() || other

    for own k,v of @__native__
      if `k in other`
        return false unless R.is_eql(other[k], v)
      else
        return false

    true


  # Returns a value from the hash for the given key. If the key can’t be
  # found, there are several options: With no other arguments, it will raise
  # an KeyError exception; if default is given, then that will be returned; if
  # the optional code block is specified, then that will be run and its result
  # returned.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.fetch("a")                            #=> 100
  #     h.fetch("z", "go fish")                 #=> "go fish"
  #     h.fetch("z", (el) -> "go fish, #{el}")  #=> "go fish, z"
  #
  # The following example shows that an exception is raised if the key is not
  # found and a default value is not supplied.
  #
  #     h = { a: 100, b: 200 }
  #     h.fetch("z")
  #     produces:
  #     # key not found (KeyError)
  #
  fetch: (key, default_value) ->
    if arguments.length == 0
      throw R.ArgumentError.new()

    if @has_key(key)
      @get(key)
    else if default_value?.call? || arguments[2]?.call?
      (arguments[2] || default_value)(key)
    else if default_value != undefined
        default_value
    else
      throw R.KeyError.new()


  # Element Reference—Retrieves the value object corresponding to the key
  # object. If not found, returns the default value (see Hash::new for
  # details).
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.get("a")   #=> 100
  #     h.get("c")   #=> nil
  #
  # @param [String] key
  # @return [Object]
  #
  get: (key) ->
    if @__default__? and !@has_key(key)
      @default(key)
    else
      @__native__[key]


  # Returns true if the given value is present for some key in hsh.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.has_value(100)   #=> true
  #     h.has_value(999)   #=> false
  #
  # @return [Boolean]
  #
  has_value: (val) ->
    val = R(val)

    if val.rubyjs?
      for own k, v of @__native__
        return true if val.equals(v)
    else
      for own k, v of @__native__
        return true if v == val

    false


  # Returns true if the given key is present in hsh.
  #
  # @example
  #     h = R.hashify({a: 100, b: 200 })
  #     h.has_key("a")   #=> true
  #     h.has_key("z")   #=> false
  #
  # @alias #include, #member
  #
  has_key: (key) ->
    `key in this.__native__`


  include: @prototype.has_key
  member: @prototype.has_key


  # Deletes every key-value pair from hsh for which block evaluates to false.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @return [R.Hash] this
  #
  keep_if: (block) ->
    return @to_enum('keep_if') unless block?.call?
    @reject_bang(block)
    this


  # Returns the key of an occurrence of a given value. If the value is not
  # found, returns nil.
  #
  # @example
  #      h = R.hashify({ a: 100, b: 200, c: 300, d: 300 })
  #      h.key(200)   #=> "b"
  #      h.key(300)   #=> "c"
  #      h.key(999)   #=> nil
  #
  # @return [String]
  # @alias #index
  #
  key: (value) ->
    value = R(value)

    if value.rubyjs?
      for own k, v of @__native__
        return k if value.equals(v)
    else
      for own k, v of @__native__
        return k if v == value

    null


  index: @prototype.key


  # Returns a new hash created by using hsh’s values as keys, and the keys as values.
  #
  # @example
  #     h = { n: 100, m: 100, y: 300, d: 200, a: 0 }
  #     h.invert()   #=> {0: a", 100: "m", 200: "d", 300: "y"}
  #
  # @return [R.Hash]
  #
  invert: ->
    hsh = {}
    for own k, v of @__native__
      hsh[v] = k
    new R.Hash(hsh)

  # Returns a new array populated with the keys from this hash. See also
  # Hash#values.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200, c: 300, d: 400 })
  #     h.keys()   #=> ["a", "b", "c", "d"]
  #
  # @return [R.Array]
  #
  keys: ->
    arr = for own k, v of @__native__
      k
    new R.Array(arr)


  merge: (other, block) ->
    hsh = {}
    other = other.__native__ if other.rubyjs?

    for own k, v of @__native__
      hsh[k] = v
    for own k, v of other
      if block?.call? and `k in hsh`
        hsh[k] = block(k, hsh[k], v)
      else
        hsh[k] = v

    new R.Hash(hsh)


  merge_bang: (other, block) ->
    other = other.__native__ if other.rubyjs?

    for own k, v of @__native__
      @__native__[k] = v
    for own k, v of other
      if block?.call? and `k in this.__native__`
        @__native__[k] = block(k, @__native__[k], v)
      else
        @__native__[k] = v

    this


  # Searches through the hash comparing obj with the value using ==. Returns the first key-value pair (two-element array) that matches. See also Array#rassoc.
  #
  # @example
  #     a = R.hashify({1: "one", 2 : "two", 3 : "three", ii: "two"})
  #     a.rassoc("two")    #=> [2, "two"]
  #     a.rassoc("four")   #=> nil
  #
  # @return [R.Array]
  #
  rassoc: (needle) ->
    needle = R(needle)

    arr = []
    if needle.rubyjs?
      for own k, v of @__native__
        if needle.equals(v)
          return new R.Array([k, v])
    else
      for own k, v of @__native__
        if needle == v
          return new R.Array([k, v])

    null




  reject: (block) ->
    return @to_enum('reject') unless block?.call?

    dup = {}
    for own k,v of @__native__
      if !block(k, v)
        dup[k] = v
    new R.Hash(dup)


  reject_bang: (block) ->
    return @to_enum('reject_bang') unless block?.call?

    changed = false
    for own k,v of @__native__
      if !block(k, v)
        delete this.__native__[k]
        changed = true

    if changed then this else null

  # Returns a new hash consisting of entries for which the block returns true.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     h = { "a" => 100, "b" => 200, "c" => 300 }
  #     h.select {|k,v| k > "a"}  #=> {"b" => 200, "c" => 300}
  #     h.select {|k,v| v < 200}  #=> {"a" => 100}
  select: (block) ->
    return @to_enum('select') unless block?.call?

    dup = {}
    for own k,v of @__native__
      if block(k, v)
        dup[k] = v

    new R.Hash(dup)

  select_bang: (block) ->
    return @to_enum('select_bang') unless block?.call?

    changed = false
    for own k,v of @__native__
      if block(k, v)
        delete this.__native__[k]
        changed = true

    if changed then this else null


  # Element Assignment—Associates the value given by value with the key given
  # by key. key should not have its value changed while it is in use as a key
  # (a String passed as a key will be duplicated and frozen).
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200 })
  #     h.set("a", 9)
  #     h.set("c", 4)
  #     h   #=> {"a": 9, "b": 200, "c": 4}
  #
  # @param [Object] key hash key
  # @param [Object] value
  # @return [Object] value
  #
  set: (key, value) ->
    @__native__[key] = value


  store: @prototype.set

  # Returns the number of key-value pairs in the hash.
  #
  # @example
  #     h = R.hashify({ d: 100, a: 200, v: 300, e: 400 })
  #     h.size()        #=> 4
  #     h.delete("a")   #=> 200
  #     h.size()        #=> 3
  #
  # @return [R.Fixnum]
  #
  size: ->
    counter = 0

    for own k, v of @__native__
      counter += 1

    new R.Fixnum(counter)


  # Converts hsh to a nested array of [ key, value ] arrays.
  #
  # @example
  #     h = { c: 300, a: 100, d: 400, c: 300  }
  #     h.to_a()   #=> [["c", 300], ["a", 100], ["d", 400]]
  #
  # @return [R.Array]
  #
  to_a: ->
    arr = for own k, v of @__native__
      [k, v]
    new R.Array(arr)


  # Returns self.
  #
  # @return [R.Hash]
  #
  to_hash: -> this


  to_h: @prototype.to_hash


  # @return [Object]
  #
  to_native: ->
    @__native__


  update: @prototype.merge_bang


  # Returns a new array populated with the values from hsh. See also
  # Hash#keys.
  #
  # @example
  #     h = R.hashify({ a: 100, b: 200, c: 300 })
  #     h.values()   #=> [100, 200, 300]
  #
  # @return [R.Array]
  #
  values: ->
    arr = for own k, v of @__native__
      v
    new R.Array(arr)

  values_at: (keys) ->
    arr = for k in arguments
      @get(k)
    R(arr)

  # ---- Aliases --------------------------------------------------------------


R.hashify = (obj, default_value) ->
  new R.Hash(obj, default_value)

R.h = R.hashify
