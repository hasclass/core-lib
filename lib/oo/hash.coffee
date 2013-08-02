#
# Unsupported: #value?() use @has_value?
#
class RubyJS.Hash extends RubyJS.Object
  @include R.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  @new: () ->
    new R.Hash()

  constructor: (hsh, default_value) ->
    @__native__  = hsh
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
    val = _hsh.assoc(@__native__, needle)
    if val is null then null else new RArray(val)



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
    _hsh.delete(@__native__, key, block)


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
    return @to_enum('delete_if') unless block?.call?
    _hsh.delete_if(@__native__, block)
    this



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
    return @to_enum('each') unless block?

    _hsh.each(@__native__, block)
    this





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
    return @to_enum('each_key') unless block?
    _hsh.each_key(@__native__, block)
    this


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
    return @to_enum('each_value') unless block?
    _hsh.each_value(@__native__, block)
    this


  # Returns true if hsh contains no key-value pairs.
  #
  #     R.hashify({}).empty()   #=> true
  #
  # @return [Boolean]
  #
  empty: ->
    _hsh.empty(@__native__)


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
    __call(_hsh.fetch, @__native__, arguments)


  flatten: (recursion = 1) ->
    new RArray(_hsh.flatten(@__native__, recursion))


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
    _hsh.has_value(@__native__, val)


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
    _hsh.has_key(@__native__, key)


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
    _hsh.keep_if(@__native__, block)
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
    _hsh.key(@__native__, value)


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
    new R.Hash(_hsh.invert(@__native__))


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
    new R.Array(_hsh.keys(@__native__))


  merge: (other, block) ->
    new R.Hash(_hsh.merge(@__native__, other, block))


  merge_bang: (other, block) ->
    _hsh.merge$(@__native__, other, block)
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
    val = _hsh.rassoc(@__native__, needle)
    if val is null then null else new RArray(val)


  reject: (block) ->
    return @to_enum('reject') unless block?.call?
    new R.Hash(_hsh.reject(@__native__, block))


  reject_bang: (block) ->
    return @to_enum('reject_bang') unless block?.call?
    val = _hsh.reject$(@__native__, block)
    if changed is null then null else this


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
    dup = _hsh.select(@__native__, block)
    new R.Hash(dup)


  select_bang: (block) ->
    return @to_enum('select_bang') unless block?.call?
    val = _hsh.select$(@__native__, block)
    if val is null then null  else this


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


  sort: (block) ->
    new RArray(_hsh.sort(@__native__, block))


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
    new R.Fixnum(_hsh.size(@__native__))


  # Converts hsh to a nested array of [ key, value ] arrays.
  #
  # @example
  #     h = { c: 300, a: 100, d: 400, c: 300  }
  #     h.to_a()   #=> [["c", 300], ["a", 100], ["d", 400]]
  #
  # @return [R.Array]
  #
  to_a: ->
    new R.Array(_hsh.to_a(@__native__))


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
    new RArray(_hsh.values(@__native__))


  values_at: ->
    arr = __call(_hsh.values_at, @__native__, arguments)
    new RArray(arr)


  valueOf: ->
    @__native__


  # ---- Aliases --------------------------------------------------------------

RHash = R.Hash

R.hashify = (obj, default_value) ->
  new R.Hash(obj, default_value)

R.h = R.hashify
