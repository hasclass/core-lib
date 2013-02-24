# Not yet implemented
class RubyJS.Hash extends RubyJS.Object
  @include R.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  @new: () ->
    new R.Hash()

  constructor: (obj) ->
    @__native__ = obj

  # ---- RubyJSism ------------------------------------------------------------

  # ---- Javascript primitives --------------------------------------------------

  # ---- Instance methods -----------------------------------------------------

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
      @to_enum()


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
      @to_enum()


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
      @to_enum()

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


  to_native: ->
    @__native__


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

  # ---- Aliases --------------------------------------------------------------


R.hashify = (obj) ->
  new R.Hash(obj)