
class RubyJS.Kernel

  # A method to easily check whether an object is a RubyJS object with CoffeeScript.
  #
  #     foo.rubyjs?
  #
  rubyjs: -> true


  # TODO: find a better name for box.
  # TODO: handle the case when calling R(true, -> ), R({}, -> )
  box: (obj, recursive, block) ->
    # R(null) should simply return null. At a later point maybe an
    # instance of NilClass
    return obj unless obj?

    # typeof with JS primitive is very fast. Handle primitives first
    # for performance reasons.

    if typeof obj is 'object'
      # Is obj already a RubyJS object? Check if rubyjs method exists.
      # has to be after typeof, checking for a member/method on a primitive
      # will "convert it to an object", what makes it slow.
      return obj if obj.rubyjs?

      _v = obj.valueOf()
      if typeof _v isnt 'object'
        # take care of [object String] and [object Number]
        obj = _v
      else
        if R.Array.isNativeArray(obj)
          # Small performance improvement. which probably should be somewhere else.
          object_type = '[object Array]'
        else
          object_type = _toString_.call(obj)

    # check primitives first
    if typeof obj is 'number'
      # Numeric.typecast returns a float or fixnum.
      obj = RubyJS.Numeric.typecast(obj)

    else if typeof obj is 'string'
      obj = new R.String(obj)

    # To stay lean we do not wrap booleans for now:
    # else if primitive_type is 'boolean'

    # Array and Regexp should be the first to be checked. String and
    # Numbers are in most cases already taken care for, but have to be checked
    # again in case a primitive wrappers are passed.
    else if object_type is '[object Array]'
      obj = new R.Array(obj, recursive is true)

    else if object_type is '[object RegExp]'
      obj = R.Regexp.try_convert(obj)

    # TODO: if at this point obj is not rubyjs, raise error.
    # Handles the case R(1, -> )
    if typeof recursive is 'function'
      block = recursive
      recursive = false

    if typeof block is 'function'
      # Call the block with obj as receiver, so that the block has context
      # of the just converted obj. R('a', -> @capitalize()).
      obj = block.call(obj)

      if obj is null or obj is undefined
        # specifically convert undefined to null
        obj = null
      else if obj.to_native?
        obj = obj.to_native(true)
      # else it is a native object or primitive, and should be left alone.

    return obj


  # Equivalent to %w[] in Ruby
  #
  # Creates an R.Array of R.String for every word separated by space.
  #
  # @example:
  #      R.w('foo bar   baz') # => ['foo', 'bar', 'baz']
  #      R.w('foo\nbar')      # => ['foo\nbar']
  #      R.w('')              # => ['']
  #
  w: (str) ->
    new R.String(str).split(/\s+/)

  # Shortcut for creating a R.Range.
  #
  # @example
  #      R.r(0,4)        # => (0..4)
  #      R.r(0,4, true)  # => (0...4)
  #
  # @alias #rng
  #
  r: (a,b,excluding) ->
    if excluding is true # note: true not truethy
      R.Range.new(a,b, true)
    else
      R.Range.new(a,b)


  # Shortcut for creating floats
  f: (flt) ->
    new R.Float(flt)


  # Shortcut for creating Ranges
  rng: @prototype.r

  # Returns primitive from an object, returns obj otherwise.
  #
  # @example
  #      str = R('rubyjs')
  #      R.l(str)        # => 'rubyjs'
  #      R.l('js_str')   # => 'js_str'
  #
  l: (obj, recursive = false) ->
    if typeof obj is 'object'
      if obj.to_native? then obj.to_native(true) else obj
    else
      obj

  catch_break: (block, context = this) ->
    breaker  = new R.Breaker()
    try
      return block.call(context, breaker)
    catch e
      return breaker.handle_break(e)

  $Array:   (obj, recursive = false) ->
    if recursive is true
      R.Array.new( @box(e) for e in obj )
    else
      R.Array.new(obj)

  # TODO: Remove from code
  $Array_r: (obj) ->
    @$Array(obj, true)

  $Float: (obj) ->
    obj = @box(obj)
    throw R.TypeError.new() if obj == null
    throw R.TypeError.new() unless obj.to_f?

    if obj.is_float?
      obj
    else if obj.is_string?
      stripped = obj.strip()
      if stripped.valid_float()
        new R.Float(+stripped.to_native().replace(/_/g, ''))
      else
        throw R.ArgumentError.new()
    else if obj.rubyjs?
      new R.Float(obj.to_native())
    else # is not a R object
      new R.Float(obj)

  $Integer: (obj) ->
    obj = R(obj)
    throw R.TypeError.new() unless obj?
    # throw R.TypeError.new() unless obj.to_i?

    if obj.is_integer?
      obj
    else if obj.is_string?
      stripped = obj.strip()
      if stripped.valid_float()
        new R.Fixnum(Math.floor(+stripped.to_native().replace(/_/g, '')))
      else
        throw R.ArgumentError.new()
    else if obj.rubyjs?
      # throw R.TypeError.new() unless obj.to_i?
      new R.Fixnum(Math.floor(obj.to_native()))
    else # is not a R object
      new R.Fixnum(Math.floor(obj))

  $Integer: @prototype.$Integer


  $String:  (obj) -> R.String.try_convert(obj) or throw(R.TypeError.new())


  $Range: (start,end,exclusive) ->
    R.Range.new(start,end,exclusive)


  puts: (obj) ->
    console.log(obj.valueOf())


  rand: (limit) ->
    r = R(Math.random())
    if limit then r.multiply(limit).to_i() else r



  # RubyJS specific helper methods
  # @private
  __ensure_args_length: (args, length) ->
    throw R.ArgumentError.new() unless args.length is length


  # @private
  __ensure_numeric: (obj) ->
    throw R.TypeError.new() unless obj?.is_numeric?


  # @private
  __ensure_string: (obj) ->
    throw R.TypeError.new() unless obj?.is_string?


  # Finds, removes and returns the last block/function in arguments list.
  # This is a destructive method.
  #
  # @example Use like this
  #   foo = (args...) ->
  #     console.log( args.length )     # => 2
  #     block = @__extract_block(args)
  #     console.log( args.length )     # => 1
  #     other = args[0]
  #
  # @private
  #
  __extract_block: (args) ->
    idx = args.length
    while --idx >= 0
      return args.pop() if args[idx]?.call?
    null