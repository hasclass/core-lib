

class RubyJS.Object
  @include: (mixin, replace = false) ->
    for name, method of mixin.prototype
      if replace
        @prototype[name] = method
      else
        @prototype[name] = method unless @prototype[name]
    mixin



  # Adds default aliases to symbol method names.
  #
  # @example Aliases used throughout RubyJS
  #
  #     <<  append
  #     ==  equals
  #     === equal_case
  #     <=> cmp
  #     %   modulo
  #     +   plus
  #     -   minus
  #     *   multiply
  #     **  exp
  #     /   divide
  #
  # @example Useage, at the end of your class:
  #
  #     class Foo extends RubyJS.Object
  #        # ...
  #        @__add_default_aliases__(@prototype)
  #
  @__add_default_aliases__: (proto) ->
    proto.append     = proto['<<']  if proto['<<']?
    proto.equals     = proto['==']  if proto['==']?
    proto.equal_case = proto['==='] if proto['===']?
    proto.cmp        = proto['<=>'] if proto['<=>']?
    proto.modulo     = proto['%']   if proto['%']?
    proto.plus       = proto['+']   if proto['+']?
    proto.minus      = proto['-']   if proto['-']?
    proto.multiply   = proto['*']   if proto['*']?
    proto.exp        = proto['**']  if proto['**']?
    proto.divide     = proto['/']   if proto['/']?

    proto.equalCase  = proto.equal_case  if proto.equal_case?
    proto.equalValue = proto.equal_value if proto.equal_value?
    proto.toA        = proto.to_a        if proto.to_a?
    proto.toF        = proto.to_f        if proto.to_f?
    proto.toI        = proto.to_i        if proto.to_i?
    proto.toInt      = proto.to_int      if proto.to_int?
    proto.toS        = proto.to_s        if proto.to_s?
    proto.toStr      = proto.to_str      if proto.to_str?
    proto.toEnum     = proto.to_enum     if proto.to_enum?
    proto.toNative   = proto.to_native   if proto.to_native?

  @include RubyJS.Kernel


  # RubyJS specific helper methods
  # @private
  __ensure_args_length: (args, length) ->
    throw RubyJS.ArgumentError.new() unless args.length is length


  # @private
  __ensure_numeric: (obj) ->
    throw RubyJS.TypeError.new() unless obj?.is_numeric?


  # @private
  __ensure_string: (obj) ->
    throw RubyJS.TypeError.new() unless obj?.is_string?

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


  send: (method_name, args...) ->
    @[method_name](args)


  respond_to: (method_name) ->
    this[method_name]?
    #this[function_name] != undefined


  to_enum: (iter = "each", args...) ->
    new RubyJS.Enumerator(this, iter, args)


  tap: (block) ->
    block(this)
    this

