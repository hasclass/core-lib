###
RubyJS Alpha 0.7.2
Copyright (c) 2012 Sebastian Burkhard
All rights reserved.
http://www.rubyjs.org/LICENSE.txt
###

root = global ? window

# TODO: link rubyjs/_r directly to RubyJS.RubyJS.prototype.box
#       this is a suboptimal solution as of now.
root.RubyJS = (obj, recursive, block) ->
  RubyJS.Base.prototype.box(obj, recursive, block)

RubyJS.VERSION = '0.7.2'

# noConflict mode for R
previousR = root.R if root.R?

RubyJS.noConflict = ->
  root.R = previousR
  RubyJS

# Alias to RubyJS
root.R  = RubyJS



RubyJS.extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin
  obj

RubyJS.include = (mixin, replace = false) ->
  for name, method of mixin.prototype
    if replace
      @prototype[name] = method
    else
      @prototype[name] = method unless @prototype[name]
  mixin

if typeof(exports) != 'undefined'
  exports.R = R
  exports.RubyJS = RubyJS



# Native classes, to avoid naming conflicts inside RubyJS classes.
nativeArray  = Array
nativeNumber = Number
nativeObject = Object
nativeRegExp = RegExp
nativeString = String

ObjProto = Object.prototype
StrProto = String.prototype
ArrProto = Array.prototype

_toString_ = ObjProto.toString
_slice_    = ArrProto.slice

str_slice   = StrProto.slice
str_match   = StrProto.match
arr_join    = ArrProto.join
arr_sort    = ArrProto.sort
arr_slice   = ArrProto.slice
arr_unshift = ArrProto.unshift

# TODO: create BlockNone class that coerces multiple yield arguments into array.

# @abstract
class Block
  # Block.create returns a different implementation of Block (BlockMulti,
  # BlockSingle) depending on the arity of block.
  #
  # If no block is given returns a BlockArgs callback, that returns
  # a single block argument.
  #
  @create: (block, thisArg) ->
    if block && block.call? #block_given
      if block.length != 1
        new BlockMulti(block, thisArg)
      else
        new BlockSingle(block, thisArg)
    else
      new BlockArgs(block, thisArg)

  # if block has multiple arguments, returns a wrapper
  # function that applies arguments to block instead of passing.
  # Otherwise it returns the block itself.
  #
  @supportMultipleArgs: (block) ->
    if block.length is 1
      block
    else
      (item) ->
        if typeof item is 'object' && R.Array.isNativeArray(item)
          block.apply(this, item)
        else
          block(item)


  invoke: () ->
    throw "Calling #invoke on an abstract Block instance"

  # Use invokeSplat applies the arguments to the block.
  #
  # E.g.
  #
  #     each_with_object: (obj) ->
  #        @each (el) ->
  #          callback.invokeSplat(el, obj)
  #
  invokeSplat: ->
    throw "Calling #invokeSplat on an abstract Block instance"

  # @abstract
  args: () ->
    throw "Calling #args on an abstract Block instance"

# @private
class BlockArgs
  constructor: (@block, @thisArg) ->

  invoke: (args) ->
    RCoerce.single_block_args(args, @block)

# @private
class BlockMulti
  constructor: (@block, @thisArg) ->

  args: (args) ->
    if args.length > 1 then _slice_.call(args) else args[0]

  # @param args array or arguments
  invoke: (args) ->
    if args.length > 1
      @block.apply(@thisArg, args)
    else
      arg = args[0]
      if typeof arg is 'object' && R.Array.isNativeArray(arg)
        @block.apply(@thisArg, arg)
      else
        @block.call(@thisArg, arg)

  invokeSplat: ->
    @block.apply(@thisArg, arguments)


# for blocks with arity 1
# @private
class BlockSingle
  constructor: (@block, @thisArg) ->

  args: (args) ->
    args[0]

  invoke: (args) ->
    @block.call(@thisArg, args[0])

  invokeSplat: ->
    @block.apply(@thisArg, arguments)

R.Block = Block
R.blockify = _blockify = Block.create

# Breaker is a R class for adding support to breaking out of functions
# that act like loops. Because we mimick ruby block/procs/lambdas by passing
# functions, so neither break nor return would work in JS.
#
# @see RubyJS.Kernel#catch_break
#
# @example Breaking loops
#    sum = R('')
#    R.catch_break( breaker ) -> # breaker is a new Breaker instance
#      R('a').upto('f') (chr) ->
#        breaker.break() if chr.equals('d')
#        sum.append(chr)
#    # => 'abc'
#
# @example Breaking out and return a value
#    R.catch_break( breaker ) -> # breaker is a new Breaker instance
#      R(1).upto(100) (i) ->
#        breaker.break('foo') if i.equals(81)
#    # => 'foo'
#
#
#
class RubyJS.Breaker
  constructor: (@return_value = null, @broken = false) ->

  # Breaks out of the loop by throwing itself. Accepts a return value.
  #
  # @example Breaking out and return a value
  #      R.catch_break( breaker )
  #        breaker.break('foo')
  #      # => 'foo'
  #
  # @param value Return value
  #
  break: (return_value) ->
    @broken = true
    @return_value = return_value
    throw this

  handle_break: (e) ->
    if this is e
      return (e.return_value)
    else
      throw e



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


  arr_r: (obj) ->
    new RArray(R(e) for e in obj)


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

# Methods in Base are added to `R`.
#
class RubyJS.Base
  RubyJS.include.call(this, R.Kernel)

  #
  '$~': null

  #
  '$,': null

  #
  '$;': "\n"

  #
  '$/': "\n"


  inspect: (obj) ->
    if obj is null or obj is 'undefined'
      'null'
    else if obj.inspect?
      obj.inspect()
    else if R.Array.isNativeArray(obj)
      "[#{obj}]"
    else
      obj


  # Adds useful methods to the global namespace.
  #
  # e.g. proc, puts, truthy, inspect, falsey
  #
  # TODO: TEST
  pollute_global: (prefix = "_") ->
    if arguments.length is 0
      args = ['w', 'fn', '_str', '_arr', '_enum', '_num', 'proc', 'puts', 'truthy', 'falsey', 'inspect']
    else
      args = arguments

    for method in args
      name = prefix + method.replace(/_/, '')
      if root[name]? && root[name] isnt @[method]
        R.puts("RubyJS.pollute_global(): #{name} already exists.")
      else
        root[name] = @[method]

    null


  pollute_more: ->
    shortcuts =
      _arr:  '_a'
      _num:  '_n'
      _str:  '_s'
      _enum: '_e'
      _hsh:  '_h'

    for k,v of shortcuts
      root[v] = root[k]


  # Adds RubyJS methods to JS native classes.
  #
  #     RubyJS.i_am_feeling_evil()
  #     ['foo', 'bar'].rb_map(proc('rb_reverse')).rb_sort()
  #     # =>['oof', 'rab']
  #
  i_am_feeling_evil: (prefix = 'rb_', overwrite = false) ->
    overwrites = [[Array.prototype, _arr], [Number.prototype, _num], [String.prototype, _str]]

    for [proto, methods] in overwrites
      for name, func of methods
        new_name = prefix + name

        if typeof func == 'function'
          if overwrite or proto[new_name] is undefined
            do (new_name, name, methods) ->
              proto[new_name] = ->
                # use this.valueOf() to get the literal back.
                args = [this.valueOf()].concat(_slice_.call(arguments, 0))
                methods[name].apply(methods, args)
          else
            console.log("#{proto}.#{new_name} exists. skipped.")

    "harr harr"


  god_mode: ->
    @i_am_feeling_evil('', true)


  # proc() is the equivalent to symbol to proc functionality of Ruby.
  #
  # proc accepts additional arguments which are passed to the block.
  #
  # @note proc() calls methods and not properties
  #
  # @example
  #
  #     R.w('foo bar').map( R.proc('capitalize') )
  #     R.w('foo bar').map( R.proc('ljust', 10) )
  #
  proc:  ->
    key = arguments[0]
    # OPTIMIZE: dont use args... but arguments instead
    if arguments.length == 1
      # Wrapper block doesnt need to mangle arguments
      (el) ->
        fn = el[key]
        if typeof fn is 'function'
          fn.call(el)
        else if fn is undefined
          R(el)[key]().valueOf()
        else
          fn
    else
      args = arr_slice.call(arguments, 1)
      # Wrapper block that mangles arguments
      (el) ->
        fn = el[key]
        if typeof fn is 'function'
          el[key].apply(el, args)
        else
          # no method found, now check if it exists in rubyjs equivalent
          el = R(el)
          el[key].apply(el, args).valueOf()


  fn: (func) ->
    (el) ->
      arguments[0] = el
      func.apply(null, arguments)




  # Check wether an obj is falsey according to Ruby
  #
  falsey: (obj) -> obj is false or obj is null or obj is undefined


  # Check wether an obj is truthy according to Ruby
  #
  truthy: (obj) ->
    !@falsey(obj)


  unbox: (obj, recursive = false) ->
    obj.unbox(recursive)


  respond_to: (obj, function_name) ->
    obj[function_name] != undefined


  # Optimized version of calling a.equals(b).
  # Takes care of non rubyjs objects.
  is_equal: (a, b) ->
    if typeof a is 'object'
      if a.equals?
        a.equals(b)
      else if a['==']?
        a['=='](b)
      else
        a is b
    else if typeof b is 'object'
      if b.equals?
        b.equals(a)
      else if b['==']?
        b['=='](a)
      else
        a is b
    else
      a is b

  is_eql: (a, b) ->
    if typeof a is 'object'
      a.eql(b)
    else if typeof b is 'object'
      b.eql(a)
    else
      a is b


  extend: (obj, mixin) ->
    obj[name] = method for name, method of mixin
    obj


  camelCase: ->


  # helper method to get an arguments object
  argify: -> arguments

# adds all methods to the global R object
for own name, method of RubyJS.Base.prototype
  RubyJS[name] = method


# Singleton class for type coercion inside RubyJS.
#
# to_int(obj) converts obj to R.Fixnum
#
# to_int_native(obj) converts obj to a JS number primitive through R(obj).to_int() if not already one.
#
# There is a shortcut for Coerce.prototype: RCoerce.
#
#     RCoerce.to_num_native(1)
#
# @private
RCoerce = R._coerce =
  # TODO: replace class with some more lightweight.

  # Mimicks rubys single block args behaviour
  single_block_args: (args, block) ->
    if block
      if block.length != 1
        if args.length > 1 then _slice_.call(args) else args[0]
      else
        args[0]
    else
      if args.length != 1 then _slice_.call(args) else args[0]


  # @example
  #      __coerce_to__(1, 'to_int')
  coerce: (obj, to_what, skip_native) ->
    if skip_native isnt undefined and skip_native is typeof obj
      obj
    else
      if obj is null or obj is undefined
        throw new R.TypeError.new()

      obj = R(obj)

      unless obj[to_what]?
        throw R.TypeError.new("TypeError: cant't convert ... into String")

      if skip_native isnt undefined
        obj[to_what]().to_native()
      else
        obj[to_what]()


  to_native: (obj) ->
    if typeof obj != 'object'
      obj
    else
      obj.valueOf()

  # Coerces element to a Number primitive.
  #
  # Throws error if typecasted RubyJS object is not a numeric.
  to_num_native: (obj) ->
    # TODO allow custom error types
    if typeof obj is 'number'
      obj
    else
      obj = R(obj)
      throw R.TypeError.new() if !obj.is_numeric?
      obj.to_native()


  to_int: (obj) ->
    RCoerce.coerce(obj, 'to_int')


  to_int_native: (obj) ->
    if typeof obj is 'number' && (obj % 1 is 0)
      obj
    else
      RCoerce.coerce(obj, 'to_int').to_native()


  to_str: (obj) ->
    RCoerce.coerce(obj, 'to_str')


  to_str_native: (obj) ->
    RCoerce.coerce(obj, 'to_str', 'string')


  to_ary: (obj) ->
    @coerce(obj, 'to_ary')

  to_ary_native: (obj) ->
    if RArray.isNativeArray(obj)
      obj
    else
      RCoerce.coerce(obj, 'to_ary').to_native()


R.RCoerce = RCoerce



class RubyJS.Object
  @include: RubyJS.include

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


  @include RubyJS.Kernel


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


  value: ->
    @to_native.apply(this, arguments)


class NumericMethods
  cmp: (num, other) ->
    if num is other then 0 else null


  abs: (num) ->
    if num < 0 then (- num) else num


  abs2: (num) ->
    return num if @nan(num)
    Math.pow(num, 2)


  ceil: (num) ->
    Math.ceil(num)


  divmod: (num, other) ->
    quotient = Math.floor(num / other)
    modulus  = num % other

    [quotient, modulus]


  downto: (num, stop, block) ->
    stop = Math.ceil(stop)

    while num >= stop
      block( num )
      num -= 1

    num


  eql: (num, other) ->
    num == other


  floor: (num) ->
    Math.floor(num)


  nonzero: (num) ->
    if num is 0 then null else num


  # remainder: (other) ->
  #   other = @box(other)
  #   mod = @['%'](other)

  #   if !mod['=='](0) and ((@['<'](0) && other['>'](0)) or (@['>'](0) && other['<'](0)))
  #     mod['-'](other)
  #   else
  #     mod



  step: (num, limit, step = 1, block) ->
    unless block?.call?
      block = step
      step  = 1

    if step is 0
      throw new R.ArgumentError("ArgumentError")

    float_mode = num % 1 is 0 or limit % 1 is 0 or step % 1 is 0
    # eps = 0.0000000000000002220446049250313080847263336181640625
    if float_mode
      # For some reason the following ported code is not needed.
      # it appears to work properly in js withouth the Float::EPSILON
      # err = (num.abs().plus(limit.abs()).plus(limit.minus(num).abs()).divide(step.abs())).multiply(eps)
      # err = 0.5 if err.gt(0.5)
      # n   = (limit.minus(num)).divide(step.plus(err)).floor()
      n = (limit - num) / step
      i = 0
      if step > 0
        while i <= n
          d = i * step + num
          d = limit if limit < d
          block(d)
          i += 1
      else
        while i <= n
          d = i * step + num
          d = limit if limit > d
          block(d)
          i += 1
    else
      if step > 0
        until num > limit
          block(num)
          num += step
      else
        until num < limit
          block(num)
          num += step
    this



  # truncate: (num) ->
  #   @to_f().truncate()


  upto: (num, stop, block) ->
    stop = Math.floor(stop)

    while num <= stop
      block( num ) #for i in [@to_native()..stop]
      num += 1

    num

  zero: (num) ->
    num is 0


  even: (num) ->
    num % 2 == 0


  gcd: (num, other) ->
    t = null
    while (other != 0)
      t = other
      other = num % other
      num = t

    if num < 0 then (- num) else num


  # Returns an array; [int.gcd(int2), int.lcm(int2)].
  #
  # @example
  #
  #     R(2).gcdlcm(2)                    #=> [2, 2]
  #     R(3).gcdlcm(-7)                   #=> [1, 21]
  #     R((1<<31)-1).gcdlcm((1<<61)-1)    #=> [1, 4951760154835678088235319297]
  #
  # @return [R.Array<R.Fixnum, R.Fixnum>]
  #
  gcdlcm: (other) ->
    other = @box(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    new R.Array([@gcd(other), @lcm(other)])

  # Returns the least common multiple (always positive). 0.lcm(x) and x.lcm(0) return zero.
  #
  # @example
  #
  #     R(2).lcm(2)                    #=> 2
  #     R(3).lcm(-7)                   #=> 21
  #     R((1<<31)-1).lcm((1<<61)-1)    #=> 4951760154835678088235319297
  #
  # @return [R.Fixnum]
  #
  lcm: (other) ->
    other = R(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    lcm = new R.Fixnum(@to_native() * other.to_native() / @gcd(other))
    lcm.numerator()


  numerator: (num) ->
    if num < 0 then (- num) else num


  # Returns true if int is an odd number.
  #
  # @return [Boolean]
  #
  odd: (num) ->
    num % 2 == 1


  # Returns the int itself.
  #
  #      a.ord    #=> 97
  #
  # This method is intended for compatibility to character constant in Ruby
  # 1.9. For example, ?a.ord returns 97 both in 1.8 and 1.9.
  #
  # @return [this]
  #
  ord:  ->
    this


  # Returns the Integer equal to int + 1.
  #
  # @example
  #
  #     R(1).next(     #=> 2
  #     R(-1).next()   #=> 0
  #
  # @return [R.Fixnum]
  # @alias #succ
  #
  next: (num) ->
    num + 1


  # Returns the Integer equal to int - 1.
  #
  # @example
  #
  #     R(1).pred()    #=> 0
  #     R(-1).pred()   #=> -2
  #
  # @return [R.Fixnum]
  #
  pred: (num) ->
    num - 1


  round: (num, n) ->
    return num if n is undefined

    multiplier = Math.pow(10, n)
    Math.round(num * multiplier) / multiplier


  # Iterates block int times, passing in values from zero to int - 1.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #     R(5).times(function(i) { R.puts(i) })
  #     # => 0 1 2 3 4
  #
  # @return [this]
  #
  times: (num, block) ->
    return R(num).to_enum('times') unless block?.call?
    if num > 0
      idx = 0
      while idx < num
        block( idx )
        idx = idx + 1
      num
    else
      num


  magnitude: @prototype.abs

  succ: @prototype.next

_num = R._num = new NumericMethods()

# Module
class EnumerableMethods
  catch_break: R.Kernel.prototype.catch_break


  to_enum: (args...) ->
    new RubyJS.Enumerator(args...)


  each: (coll, block) ->
    if coll.each?
      coll.each(block)
    else if RArray.isNativeArray(coll)
      _arr.each(coll, block)
    else
      for own k,v of coll
        block(k,v)
    coll


  all: (coll, block) ->
    @catch_break (breaker) ->
      callback = _blockify(block, coll)
      @each coll, ->
        result = callback.invoke(arguments)
        breaker.break(false) if R.falsey(result)
      true


  any: (coll, block) ->
    @catch_break (breaker) ->
      callback = _blockify(block, coll)
      @each coll, ->
        result = callback.invoke(arguments)
        breaker.break(true) unless R.falsey( result )
      false


  collect_concat: (coll, block = null) ->
    callback = _blockify(block, this)

    ary = []
    @each coll, ->
      ary.push(callback.invoke(arguments))

    _arr.flatten(ary, 1)


  flat_map: @collect_concat


  count: (coll, block) ->
    counter = 0
    if block is undefined
      @each coll, -> counter += 1
    else if block is null
      @each coll, (el) -> counter += 1 if el is null
    else if block.call?
      callback = _blockify(block, coll)
      @each coll, ->
        result = callback.invoke(arguments)
        counter += 1 unless R.falsey(result)
    else
      countable = R(block)
      @each coll, (el) ->
        counter += 1 if countable['=='](el)
    counter


  cycle: (coll, n, block) ->
    unless block
      if n && n.call?
        block = n
        n     = null

    if !(n is null or n is undefined)
      many  = RCoerce.to_int_native(n)
      return null if many <= 0
    else
      many = null

    return coll.to_enum('cycle', n) unless block

    callback = _blockify(block, coll)

    cache = new R.Array([])
    @each coll, ->
      args = callback.args(arguments)
      cache.append args
      callback.invoke(arguments)

    return null if cache.empty()

    if many > 0                                  # cycle(2, () -> ... )
      i = 0
      many -= 1
      while many > i
        # OPTIMIZE use normal arrays and for el in cache
        cache.each ->
          callback.invoke(arguments)
          i += 1
    else
      while true                                 # cycle(() -> ... )
        cache.each ->
          callback.invoke(arguments)


  drop: (coll, n) ->
    # TODO use splice when implemented
    ary = []
    @each_with_index coll, (el, idx) ->
      ary.push(el) if n <= idx
    ary


  drop_while: (coll, block) ->
    callback = _blockify(block, coll)

    ary = []
    dropping = true

    @each coll, ->
      unless dropping && callback.invoke(arguments)
        dropping = false
        ary.push(callback.args(arguments))

    ary



  each_cons: (coll, n, block) ->
    # TODO: use callback
    callback = _blockify(block, coll)
    len = block.length
    ary = []
    @each coll, ->
      ary.push(BlockMulti.prototype.args(arguments))
      ary.shift() if ary.length > n
      if ary.length is n
        if len > 1
          block.apply(coll, ary.slice(0))
        else
          block.call(coll, ary.slice(0))

    null


  each_entry: (coll, block) ->
    # hard code BlockMulti because each_entry converts multiple
    # yields into an array
    callback = new BlockMulti(block, coll)
    len = block.length
    @each coll, ->
      args = callback.args(arguments)
      if len > 1 and R.Array.isNativeArray(args)
        block.apply(coll, args)
      else
        block.call(coll, args)

    coll


  each_slice: (coll, n, block) ->
    callback = _blockify(block, coll)
    len      = block.length
    ary      = []

    @each coll, ->
      ary.push( BlockMulti.prototype.args(arguments) )
      if ary.length == n
        args = ary.slice(0)
        if len > 1
          block.apply(coll, args)
        else
          block.call(coll, args)
        ary = []

    unless ary.length == 0
      args = ary.slice(0)
      if len > 1
        block.apply(coll, args)
      else
        block.call(coll, args)

    null


  each_with_index: (coll, block) ->
    callback = _blockify(block, coll)

    idx = 0
    @each coll, ->
      val = callback.invokeSplat(callback.args(arguments), idx)
      idx += 1
      val

    coll


  each_with_object: (coll, obj, block) ->
    callback = _blockify(block, coll)

    @each coll, ->
      args = BlockMulti.prototype.args(arguments)
      callback.invokeSplat(args, obj)

    obj


  find: (coll, ifnone, block = null) ->
    if block == null
      block  = ifnone
      ifnone = null

    callback = _blockify(block, this)
    @catch_break (breaker) ->
      @each coll, ->
        unless R.falsey(callback.invoke(arguments))
          breaker.break(callback.args(arguments))

      ifnone?()


  find_all: (coll, block) ->
    ary = []
    callback = _blockify(block, coll)
    @each coll, ->
      unless R.falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    ary


  find_index: (coll, value) ->
    if value.call?
      block = value
    else
      block = (el) -> R.is_equal(value, el)

    idx = 0
    callback = _blockify(block, coll)
    @catch_break (breaker) ->
      @each coll, ->
        breaker.break(idx) if callback.invoke(arguments)
        idx += 1

      null


  first: (coll, n = null) ->
    if n != null
      throw new R.ArgumentError('ArgumentError') if n < 0
      @take(coll, n)
    else
      @take(coll, 1)[0]


  # FIXME: This a very unfortunate solution just to enable the use of '=='
  include: (coll, other) ->
    other = R(other)

    @catch_break (breaker) ->
      @each coll, (el) ->
        # TODO: this is special. we're trying to typecast el, so we can
        # call == on it. This needs to be fixed, most probably with an R.equalss(a, b)
        # which takes care of non-R objects.
        el = R(el)
        breaker.break(true) if el['==']?(other) or other['==']?(el) or el is other
      false


  # @private
  __inject_args__: (initial, sym, block) ->
    if sym?.call?
      block = sym
    else if sym
      # for [1,2,3].inject(5, (memo, i) -> )
      block = (memo, el) -> memo[sym](el)
    else if R(initial)?.is_string?
      # for [1,2,3].inject('-')
      _method = "#{initial}"
      block   = (memo, el) -> memo[_method](el)
      initial = undefined
    else if initial.call?
      # for inject (memo,i) ->
      block = initial
      initial = undefined

    [initial, sym, block]



  inject: (coll, init, sym, block) ->
    [init, sym, block] = @__inject_args__(init, sym, block)

    callback = R.blockify(block, coll)
    @each coll, ->
      if init is undefined
        init = callback.args(arguments)
      else
        args = BlockMulti.prototype.args(arguments)
        init = callback.invokeSplat(init, args)

    init


  grep: (coll, pattern, block) ->
    ary      = []
    pattern  = R(pattern)
    callback = R.blockify(block, coll)
    if block
      @each coll, (el) ->
        if pattern['==='](el)
          ary.push(callback.invoke(arguments))
    else
      @each coll, (el) ->
        ary.push(el) if pattern['==='](el)
    ary


  group_by: (coll, block) ->
    callback = R.blockify(block, coll)

    h = {}
    @each coll, ->
      args = callback.args(arguments)
      key  = callback.invoke(arguments)

      h[key] ||= []
      h[key].push(args)

    h


  map: (coll, block) ->
    callback = R.blockify(block, coll)

    arr = []
    @each coll, ->
      arr.push(callback.invoke(arguments))

    arr


  max: (coll, block) ->
    max = undefined

    block ||= R.Comparable.cmp

    # # Following Optimization won't complain if:
    # # [1,2,'3']
    # #
    # # optimization for elements that are arrays
    # #
    # if @__samesame__?()
    #   arr = @__native__
    #   if arr.length < 65535
    #     _max = Math.max.apply(Math, arr)
    #     return _max if _max isnt NaN

    @each coll, (item) ->
      if max is undefined
        max = item
      else
        comp = block(item, max)
        throw R.ArgumentError.new() if comp is null
        max = item if comp > 0

    max or null


  max_by: (coll, block) ->
    max = undefined
    # OPTIMIZE: use sorted element
    @each coll, (item) ->
      if max is undefined
        max = item
      else
        cmp = R.Comparable.cmpstrict(block(item), block(max))
        max = item if cmp > 0
    max or null


  min: (coll, block) ->
    min = undefined
    block ||= R.Comparable.cmp

    # Following Optimization won't complain if:
    # [1,2,'3']
    #
    # optimization for elements that are arrays

    @each coll, (item) ->
      if min is undefined
        min = item
      else
        comp = block.call(this, item, min)
        throw R.ArgumentError.new() if comp is null
        min = item if comp < 0

    min or null



  min_by: (coll, block) ->
    min = undefined
    # OPTIMIZE: use sorted element
    @each coll, (item) ->
      if min is undefined
        min = item
      else
        cmp = R.Comparable.cmpstrict(block(item), block(min))
        min = item if cmp < 0
    min or null


  minmax: (coll, block) ->
    # TODO: optimize
    [@min(coll, block), @max(coll, block)]


  minmax_by: (coll, block) ->
    [@min_by(coll, block), @max_by(coll, block)]


  none: (coll, block) ->
    @catch_break (breaker) ->
      callback = R.blockify(block, coll)
      @each coll, (args) ->
        result = callback.invoke(arguments)
        breaker.break(false) unless R.falsey(result)
      true


  one: (coll, block) ->
    counter  = 0

    @catch_break (breaker) ->
      callback = R.blockify(block, coll)
      @each coll, (args) ->
        result = callback.invoke(arguments)
        counter += 1 unless R.falsey(result)
        breaker.break(false) if counter > 1
      counter is 1



  partition: (coll, block) ->
    left  = []
    right = []

    callback = R.blockify(block, coll)

    @each coll, ->
      args = BlockMulti.prototype.args(arguments)

      if callback.invokeSplat(args)
        left.push(args)
      else
        right.push(args)

    [left, right]


  reject: (coll, block) ->
    callback = R.blockify(block, coll)

    ary = []
    @each coll, ->
      if R.falsey(callback.invoke(arguments))
        ary.push(callback.args(arguments))

    ary


  reverse_each: (coll, block) ->
    # There is no other way then to convert to an array first.
    # Because Enumerable depends only on #each (through #to_a)
    _arr.reverse_each(@to_a(coll), block )
    coll

  slice_before: (args...) ->
    # TODO
    # block = @__extract_block(args)
    # # throw R.ArgumentError.new() if args.length == 1
    # arg   = R(args[0])

    # if block
    #   has_init = !(arg is undefined)
    # else
    #   block = (elem) -> arg['==='] elem

    # self = this
    # R.Enumerator.create (yielder) ->
    #   accumulator = null
    #   self.each (elem) ->
    #     start_new = if has_init then block(elem, arg.dup()) else block(elem)
    #     if start_new
    #       yielder.yield accumulator if accumulator
    #       accumulator = R([elem])
    #     else
    #       accumulator ||= new RArray([])
    #       accumulator.append elem
    #   yielder.yield accumulator if accumulator


  sort: (coll, block) ->
    # TODO: throw Error when comparing different values.
    block ||= R.Comparable.cmpstrict
    coll = coll.to_native() if coll.to_native?
    arr_sort.call(coll, block)


  sort_by: (coll, block) ->
    callback = R.blockify(block, coll)

    ary = []
    @each coll, (value) ->
      ary.push new MYSortedElement(value, callback.invoke(arguments))

    ary = _arr.sort(ary, R.Comparable.cmpstrict)
    _arr.map(ary, (se) -> se.value)


  take: (coll, n) ->
    throw R.ArgumentError.new() if n < 0
    ary = []
    @catch_break (breaker) ->
      @each coll, ->
        breaker.break() if ary.length is n
        ary.push(BlockMulti.prototype.args(arguments))

    ary



  take_while: (coll, block) ->
    ary = []

    @catch_break (breaker) ->
      @each coll, ->
        breaker.break() if R.falsey block.apply(coll, arguments)
        ary.push(BlockMulti.prototype.args(arguments))

    ary


  to_a: (coll) ->
    ary = []

    @each coll, ->
      # args = if arguments.length == 1 then arguments[0] else _slice_.call(arguments)
      ary.push(BlockMulti.prototype.args(arguments))
      null

    ary


  to_enum: (iter = "each", args...) ->
    new R.Enumerator(this, iter, args)


  zip: (coll, others) ->
    # TODO



  # --- Aliases ---------------------------------------------------------------
  detect: @prototype.find
  select: @prototype.find_all
  collectConcat: @prototype.collect_concat
  dropWhile: @prototype.drop_while
  eachCons: @prototype.each_cons
  eachEntry: @prototype.each_entry
  eachSlice: @prototype.each_slice
  eachWithIndex: @prototype.each_with_index
  eachWithObject: @prototype.each_with_object
  findAll: @prototype.find_all
  findIndex: @prototype.find_index
  flatMap: @prototype.flat_map
  groupBy: @prototype.group_by
  maxBy: @prototype.max_by
  minBy: @prototype.min_by
  minmaxBy: @prototype.minmax_by
  reverseEach: @prototype.reverse_each
  sliceBefore: @prototype.slice_before
  sortBy: @prototype.sort_by
  takeWhile: @prototype.take_while
  toA: @prototype.to_a

  collect: @prototype.map
  member: @prototype.include
  reduce: @prototype.inject
  entries: @prototype.to_a


# `value` is the original element and `sort_by` the one to be sorted by
#
# @private
class MYSortedElement
  constructor: (@value, @sort_by) ->

  '<=>': (other) ->
    @sort_by?['<=>'](other.sort_by)


_itr = R._itr = _enum = R._enum = new EnumerableMethods()


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

class StringMethods
  capitalize: (str) ->
    return "" if str.length == 0
    b = _str.downcase(str)
    a = _str.upcase(str[0])
    a + str_slice.call(b, 1)


  center: (str, length, padString = ' ') ->
    throw R.ArgumentError.new() if padString.length == 0

    size = str.length
    return str if size >= length

    lft       = Math.floor((length - size) / 2)
    rgt       = length - size - lft
    max       = if lft > rgt then lft else rgt
    padString = _str.multiply(padString, max)

    padString[0...lft] + str + padString[0...rgt]


  chars: (str, block) ->
    idx = -1
    len = str.length
    while ++idx < len
      block(str[idx])
    str


  chomp: (str, sep = null) ->
    if sep == null
      if _str.empty(str) then "" else null
    else
      sep = RCoerce.to_str_native(sep)
      if sep.length == 0
        regexp = /((\r\n)|\n)+$/
      else if sep is "\n" or sep is "\r" or sep is "\r\n"
        ending = str_match.call(str, /((\r\n)|\n|\r)$/)?[0] || "\n"
        regexp = new RegExp("(#{R.Regexp.escape(ending)})$")
      else
        regexp = new RegExp("(#{R.Regexp.escape(sep)})$")
      str.replace(regexp, '')


  chop: (str) ->
    return str if str.length == 0

    if str.lastIndexOf("\r\n") == str.length - 2
      str.replace(/\r\n$/, '')
    else
      _str.slice str, 0, str.length - 1


  count: (str, args...) ->
    throw R.ArgumentError.new("String.count needs arguments") if args.length == 0

    _str.__matched__(str, args).length


  'delete': (str, args...) ->
    throw R.ArgumentError.new() if args.length == 0
    trash = _str.__matched__(str, args)
    str.replace(new RegExp("[#{trash}]", 'g'), '')


  each_line: (str, separator, block) ->
    unless block?
      if separator?
        if separator.call?
          block = separator
          separator = null
      else
        block(str)
        return


    # unless separator?
    separator ||= R['$/']

    # TODO: Use RCoerce?
    # throw R.TypeError.new() unless separator.to_str?
    if separator.length is 0
      separator = "\n\n"

    lft = 0
    rgt = null
    dup = str # allows the string to be changed with bang methods
    while (rgt = _str.index(dup, separator, lft)) != null
      rgt = rgt + 1
      str = _str.slice(dup, lft, rgt - lft)
      lft = rgt
      block(str)

    remainder = str_slice.call(dup, lft)
    if remainder?
      block(remainder) unless remainder.length == 0

    this


  downcase: (str) ->
    return str unless str_match.call(str, /[A-Z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    _arr.map(str.split(''), (c) ->
      if str_match.call(c, /[A-Z]/) then c.toLowerCase() else c
    ).join('')


  empty: (str) ->
    str.length == 0


  end_with: (str, needles...) ->
    for w in needles
      if str.lastIndexOf(w) + w.length is str.length
        return true
    false


  gsub: (str, pattern, replacement) ->
    throw R.TypeError.new() if pattern is null

    pattern_lit = R.String.string_native(pattern)
    if pattern_lit isnt null
      pattern = new RegExp(R.Regexp.escape(pattern_lit), 'g')

    unless R.Regexp.isRegexp(pattern)
      throw R.TypeError.new()

    unless pattern.global
      throw "String#gsub: #{pattern} has not set the global flag 'g'. #{pattern}g"

    str.replace(pattern, replacement)

  include: (str, other) ->

    str.indexOf(other) >= 0


  index: (str, needle, offset) ->
    if offset?
      offset = str.length + offset if offset < 0

    # unless needle.is_string? or needle.is_regexp? or needle.is_fixnum?
    #   throw R.TypeError.new()

    if offset? && (offset > str.length or offset < 0)
      return null

    idx = str.indexOf(needle, offset)
    if idx < 0
      null
    else
      idx


  insert: (str, idx, other) ->
    if idx < 0
      # On negative count
      idx = str.length - Math.abs(idx) + 1

    if idx < 0 or idx > str.length
      throw R.IndexError.new()

    chrs = str.split("")

    # TODO: OPTIMIZE!
    before = chrs[0...idx]
    insert = other.split("")
    after  = chrs.slice(idx)
    before.concat(insert).concat(after).join('')


  ljust: (str, width, padString = " ") ->
    len = str.length
    if len >= width
      str
    else
      throw R.ArgumentError.new() if padString.length == 0
      pad_length = width - len
      idx = -1
      out = ""
      # TODO refactor
      out += padString while ++idx <= pad_length
      str + out[0...pad_length]


  lstrip: (str) ->
    str.replace(/^[\s\n\t]+/g, '')


  match: (str, pattern, offset = null, block) ->
    unless block?
      if offset?.call?
        block = offset
        offset = null

    # unless RString.isString(pattern) or R.Regexp.isRegexp(pattern)
    #   throw R.TypeError.new()

    opts = {}

    if offset?
      opts = {string: str, offset: offset}
      str = str_slice.call(str, offset)
      matches = str_match.call(str, pattern, offset)
    else
      # Firefox breaks if you'd pass str.match(..., undefined)
      matches = str_match.call(str, pattern)

    result = if matches
      new R.MatchData(matches, opts)
    else
      null

    R['$~'] = result

    if block
      if result then block(result) else []
    else
      result


  multiply: (str, num) ->
    throw R.ArgumentError.new() if num < 0
    out = ""
    out += str for n in [0...num]
    out


  partition: (str, pattern) ->
    # TODO: regexps
    idx = _str.index(str, pattern)
    unless idx is null
      start = idx + pattern.length
      a = _str.slice(str, 0, idx) || ''
      b = pattern
      c = str_slice.call(str, start)
      [a,b,c]
    else
      [str, '', '']


  reverse: (str) ->
    str.split("").reverse().join("")


  rindex: (str, needle, offset) ->
    if offset != undefined
      offset = offset + str.length if offset < 0
      return null if offset < 0

      if typeof needle is 'string'
        offset = offset + needle.length
        ret = str[0...offset].lastIndexOf(needle)
      else
        ret = _str.__rindex_with_regexp__(str, needle, offset)
    else
      if typeof needle is 'string'
        ret = str.lastIndexOf(needle)
      else
        ret = _str.__rindex_with_regexp__(str, needle)

    if ret is -1 then null else ret


  # @private
  # @param needle R.Regexp
  # @param offset [number]
  __rindex_with_regexp__: (str, needle, offset) ->
    idx = 0
    len = str.length
    # if regexp starts with /^ do not iterate.
    # however this is wrong behaviour, it should match from \n.
    match_begin = needle.match(R(/\/\^/)) != null

    ret         = -1
    # TODO: FIX!
    while match = str[idx..-1].match(R(needle))
      break if offset && offset < (idx + match.index)
      ret = idx
      idx = idx + 1
      break if match_begin or idx > length

    ret


  rjust: (str, width, pad_str = " ") ->
    len = str.length
    if len >= width
      str
    else
      throw R.ArgumentError.new() if pad_str.length == 0
      pad_len = width - len
      _str.multiply(pad_str, pad_len)[0...pad_len] + str


  rstrip: (str) ->
    str.replace(/[\s\n\t]+$/g, '')


  squeeze: (str, pattern...) ->
    trash = _str.__matched__(str, pattern)
    chars = str.split("")
    len   = str.length
    i     = 1
    j     = 0
    last  = chars[0]
    all   = pattern.length == 0
    while i < len
      c = chars[i]
      unless c == last and (all || trash.indexOf(c) >= 0)
        chars[j+=1] = last = c
      i += 1

    if (j + 1) < len
      chars = chars[0..j]

    chars.join('')


  strip: (str) ->
    _str.rstrip(_str.lstrip(str))


  sub: (str, pattern, replacement) ->
    throw R.TypeError.new() if pattern is null

    pattern_lit = R.String.string_native(pattern)
    if pattern_lit isnt null
      pattern = new RegExp(R.Regexp.escape(pattern_lit))

    unless R.Regexp.isRegexp(pattern)
      throw R.TypeError.new()

    if pattern.global
      throw "String#sub: #{pattern} has set the global flag 'g'. #{pattern}g"

    str.replace(pattern, replacement)



  succ: (str) ->
    return '' if str.length == 0

    codes      = (c.charCodeAt(0) for c in str.split(""))
    carry      = null               # for "z".succ => "aa", carry is 'a'
    last_alnum = 0                  # last alpha numeric
    start      = codes.length - 1
    while start >= 0
      s = codes[start]
      if nativeString.fromCharCode(s).match(/[a-zA-Z0-9]/) != null
        carry = 0

        if (48 <= s && s < 57) || (97 <= s && s < 122) || (65 <= s && s < 90)
          codes[start] = codes[start]+1
        else if s == 57              # 9
          codes[start] = 48          # 0
          carry = 49                 # 1
        else if s == 122             # z
          codes[start] = carry = 97  # a
        else if s == 90              # Z
          codes[start] = carry = 65  # A

        break if carry == 0
        last_alnum = start
      start -= 1

    if carry == null
      start = codes.length - 1
      carry = 1

      while start >= 0
        s = codes[start]
        if s >= 255
          codes[start] = 0
        else

          codes[start] = codes[start]+1
          break
        start -= 1

    chars = (String.fromCharCode(c) for c in codes)
    if start < 0
      chars[last_alnum] = nativeString.fromCharCode(carry, codes[last_alnum])

    chars.join("")


  slice: (str, index, other) ->
    throw R.TypeError.new() if index is null
    # TODO: This methods needs some serious refactoring

    size = str.length
    unless other is undefined
      if index.is_regexp?
        throw R.NotImplementedError.new()
        # match, str = subpattern(index, other)
        # Regexp.last_match = match
        # return str
      else
        length = other
        start  = index
        start += size if start < 0

        return null if length < 0 or start < 0 or start > size

        return str_slice.call(str, start, start + length)

    if index.is_regexp?
      throw R.NotImplementedError.new()
      # match_data = index.search_region(self, 0, _str.num_bytes, true)
      # Regexp.last_match = match_data
      # if match_data
      #   result = match_data.to_s
      #   result.taint if index.tainted?
      #   return result

    else if typeof index == 'string'
      return if _str.include(str, index) then index else null

    else if index.is_range?
      start   = RCoerce.to_int_native index.begin()
      length  = RCoerce.to_int_native index.end()

      start += size if start < 0

      length += size if length < 0
      length += 1 unless index.exclude_end()

      return "" if start is size
      return null if start < 0 || start > size

      length = size if length > size
      length = length - start
      length = 0 if length < 0

      return str_slice.call(str, start, start + length)
    else
      index += size if index < 0
      return null if index < 0 or index >= size
      return str[index]


  split: (str, pattern = " ", limit) ->
    # pattern string or regexp
    pattern = pattern.valueOf() if typeof pattern isnt 'string'
    # TODO: implement limit

    ary = str.split(pattern)

    # remove trailing empty fields
    while R.truthy(str = ary[ary.length - 1])
      break unless str.length == 0
      ary.pop()

    if pattern is ' '
      tmp = []
      for el in ary
        tmp.push(el) if el != ''
      ary = tmp

    # TODO: if regexp does not include non-matching captures in the result array

    ary


  start_with: (str, needles...) ->
    for needle in needles
      return true if str.indexOf(needle) is 0
    false


  swapcase: (str) ->
    return str unless str.match(/[a-zA-Z]/)

    chars = str.split('')
    # TODO optimize using charCodeAt
    for c,i in chars
      # TODO: optimize using new String(c) to avoid shadow wrappers
      # c = new String(c)
      if c.match(/[a-z]/)
        chars[i] = c.toUpperCase()
      else if c.match(/[A-Z]/)
        chars[i] = c.toLowerCase()

    chars.join('')


  upcase: (str) ->
    return str unless str.match(/[a-z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    _arr.map(str.split(''), (c) ->
      if c.match(/[a-z]/) then c.toUpperCase() else c
    ).join('')


  upto: (str, stop, exclusive, block) ->
    exclusive ||= false
    if block is undefined and exclusive?.call?
      block = exclusive
      exclusive = false

    orig = str
    stop_size = stop.length
    exclusive = exclusive is true

    while (str < stop || (!exclusive && str == stop)) && !(str.length > stop_size)
      block( str )
      str = _str.succ(str)

    orig



  __matched__: (str, args) ->
    for el in args
      rgx = _str.__to_regexp__(el)
      str = (str_match.call(str, rgx) || []).join('')
    str


  # creates a regexp from the "a-z", "^ab" arguments used in #count
  __to_regexp__: (str) ->
    r = ""

    if str.length == 0
      r = "(?!)"
    else if str == '^'
      r = "\\^"
    else
      if str.lastIndexOf("^") >= 1
        str = str[0] + str[1..-1].replace("^", "\\^")
      r = "[#{str}]"

    try
      return new RegExp(r, 'g')
    catch e
      throw R.ArgumentError.new()


_str = R._str = new StringMethods()


class HashMethods extends EnumerableMethods



_hsh = R._hsh = new HashMethods()

errors = [
  'ArgumentError'
  'RegexpError'
  'TypeError'
  'KeyError'
  'IndexError'
  'FloatDomainError'
  'RangeError'
  'StandardError'
  'ZeroDivisionError'
  'NotSupportedError'
  'NotImplementedError'
]

for error in errors
  do (error) ->
    errorClass     = class extends Error
    errorClass.new = -> new RubyJS[error](error)
    RubyJS[error]  = errorClass


# The Comparable mixin is used by classes whose objects may be ordered. The
# class must define the <=> operator, which compares the receiver against
# another object, returning -1, 0, or +1 depending on whether the receiver is
# less than, equal to, or greater than the other object. If the other object
# is not comparable then the <=> operator should return nil. Comparable uses
# <=> to implement the conventional comparison operators (<, <=, ==, >=, and
# >) and the method between?.
#
class RubyJS.Comparable

  '<': (other) ->
    cmp = @['<=>'](other)
    throw R.TypeError.new() if cmp is null
    cmp < 0

  '>': (other) ->
    cmp = @['<=>'](other)
    throw R.TypeError.new() if cmp is null
    cmp > 0

  '<=': (other) ->
    cmp = @['<=>'](other)
    throw R.TypeError.new() if cmp is null
    cmp <= 0

  '>=': (other) ->
    cmp = @['<=>'](other)
    throw R.TypeError.new() if cmp is null
    cmp >= 0

  # Returns false if obj <=> min is less than zero or if anObject <=> max is
  # greater than zero, true otherwise.
  #
  # @example
  #     R(3).between(1, 5)               # => true
  #     R(6).between(1, 5)               # => false
  #     R(3).between(3, 3)               # => true
  #     R('cat').between('ant', 'dog')   # => true
  #     R('gnu').between('ant', 'dog')   # => false
  #
  between: (min, max) ->
    @['>='](min) and @['<='](max)

  # Equivalent of calling
  # R(a).cmp(b) but faster for natives.
  @cmp: (a, b) ->
    if typeof a isnt 'object' and typeof a is typeof b
      if a is b
        0
      else
        if a < b then -1 else 1
    else
      a = R(a)
      throw 'NoMethodError' unless a['<=>']?
      a['<=>'](b)


  # Same as cmp, but throws ArgumentError if it cannot
  # coerce elements.
  @cmpstrict: (a, b) ->
    if typeof a is typeof b and typeof a isnt 'object'
      if a is b
        0
      else
        if a < b then -1 else 1
    else
      a = R(a)
      throw 'NoMethodError' unless a['<=>']?
      cmp = a['<=>'](b)
      throw R.ArgumentError.new() if cmp is null
      cmp



  # aliases
  cmp:  @prototype['<=>']
  lt:   @prototype['<']
  lteq: @prototype['<=']
  gt:   @prototype['>']
  gteq: @prototype['>=']

# Enumerable is a module of iterator methods that all rely on #each for
# iterating. Classes that include Enumerable are Enumerator, Range, Array.
# However for performance reasons they are typically re-implemented in them
# to avoid the extra method calls through #each.
#
#
# @mixin
class RubyJS.Enumerable

  # Passes each element of the collection to the given block. The method
  # returns true if the block never returns false or nil. If the block is not
  # given, Ruby adds an implicit block of {|obj| obj} (that is all? will
  # return true only if none of the collection members are false or nil.)
  #
  # @example
  #     R.w('ant bear cat').all (word) -> word.length >= 3   # => true
  #     R.w('ant bear cat').all (word) -> word.length >= 4   # => false
  #     R([ null, true, 99 ]).all()                          # => false
  #
  all: (block) ->
    _enum.all(this, block)



  # Passes each element of the collection to the given block. The method
  # returns true if the block ever returns a value other than false or nil. If
  # the block is not given, Ruby adds an implicit block of {|obj| obj} (that
  # is any? will return true if at least one of the collection members is not
  # false or nil.
  #
  #     R.w('ant bear cat').any (word) -> word.length >= 3   # => true
  #     R.w('ant bear cat').any (word) -> word.length >= 4   # => true
  #     R([ null, true, 99 ]).any()                          # => true
  #
  any: (block) ->
    _enum.any(this, block)


  # Returns a new array with the concatenated results of running block once
  # for every element in enum.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @alias #flat_map
  #
  # @example
  #    R([[1,2],[3,4]]).flat_map (i) -> i   #=> [1, 2, 3, 4]
  #
  collect_concat: (block = null) ->
    return @to_enum('collect_concat') unless block && block.call?
    new RArray(_enum.collect_concat(this, block))


  flat_map: @prototype.collect_concat

  # Returns the number of items in enum, where size is called if it responds
  # to it, otherwise the items are counted through enumeration. If an argument
  # is given, counts the number of items in enum, for which equals to item. If
  # a block is given, counts the number of elements yielding a true value.
  #
  # @execute
  #     ary = R([1, 2, 4, 2])
  #     ary.count()                #=> 4
  #     ary.count(2)               #=> 2
  #     ary.count (x) -> x%2 == 0  #=> 3
  #
  count: (block) ->
    new R.Fixnum(_enum.count(this, block))

  # this makes my head spin.
  # chunk: (initial_state = null, original_block) ->
  #   throw RubyJS.ArgumentError.new() unless original_block || initial_state
  #   new RubyJS.Enumerator (yielder) ->
  #     previous = null
  #     accumulate = R []
  #     # @each (val) ->
  #       # accumulate.push(original_block(val))
  #     accumulate


  # Calls block for each element of enum repeatedly n times or forever if none
  # or nil is given. If a non-positive number is given or the collection is
  # empty, does nothing. Returns nil if the loop has finished without getting
  # interrupted.
  #
  # #cycle saves elements in an internal array so changes to enum after the
  # #first pass have no effect.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R(["a", "b", "c"])
  #     a.cycle (x) -> R.puts x      # print, a, b, c, a, b, c,.. forever.
  #     a.cycle(2) (x) -> R.puts x   # print, a, b, c, a, b, c.
  #
  # @todo does not rescue StopIteration
  #
  cycle: (n, block) ->
    throw R.ArgumentError.new() if arguments.length > 2

    _enum.cycle(this, n, block)

  # Drops first n elements from enum, and returns rest elements in an array.
  #
  # @example
  #     a = R([1, 2, 3, 4, 5, 0])
  #     a.drop(3)             #=> [4, 5, 0]
  #
  drop: (n) ->
    @__ensure_args_length(arguments, 1)
    n = RCoerce.to_int_native(n)
    throw R.ArgumentError.new() if n < 0

    new RArray(_enum.drop(this, n))


  # Drops elements up to, but not including, the first element for which the
  # block returns nil or false and returns an array containing the remaining
  # elements.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([1, 2, 3, 4, 5, 0])
  #     a.drop_while (i) -> i < 3    #=> [3, 4, 5, 0]
  #
  drop_while: (block) ->
    return @to_enum('drop_while') unless block && block.call?
    new RArray(_enum.drop_while(this, block))


  # Iterates the given block for each array of consecutive <n> elements. If no
  # block is given, returns an enumerator.
  #
  # @example
  #      R.rng(1,6).each_cons 3, (a) -> R.puts a
  #      # output:
  #      # [1, 2, 3]
  #      # [2, 3, 4]
  #      # [3, 4, 5]
  #      # [4, 5, 6]
  #
  each_cons: (args...) ->
    block = @__extract_block(args)
    return @to_enum('each_cons', args...) unless block && block.call?
    @__ensure_args_length(args, 1)
    n = RCoerce.to_int_native(args[0])
    throw R.ArgumentError.new() unless n > 0

    _enum.each_cons(this, n, block)

  # Calls block once for each element in self, passing that element as a
  # parameter, converting multiple values from yield to an array.
  #
  # If no block is given, an enumerator is returned instead.
  #
  each_entry: (block) ->
    throw R.ArgumentError.new() if arguments.length > 1
    return @to_enum('each_entry') unless block && block.call?

    _enum.each_entry(this, block)

  # Iterates the given block for each slice of <n> elements. If no block is
  # given, returns an enumerator.
  #
  # @example
  #     (1..10).each_slice(3) {|a| p a}
  #     # outputs below
  #     [1, 2, 3]
  #     [4, 5, 6]
  #     [7, 8, 9]
  #     [10]
  #
  each_slice: (n, block) ->
    throw R.ArgumentError.new() unless n
    n = RCoerce.to_int_native(n)

    throw R.ArgumentError.new() if n <= 0                  #each_slice(-1)
    throw R.ArgumentError.new() if block && !block.call?   #each_slice(1, block)

    return @to_enum('each_slice', n) if block is undefined #each_slice(1) # => enum

    _enum.each_slice(this, n, block)


  # # TODO: I'm not quite sure wether this is smart or stupid
  # each_with_context: (context = null, block) ->
  #   return @to_enum('each_with_context', context) unless block && block.call?
  #
  #   @each (el...) ->
  #     el = el[0] if el.length == 1
  #     # call the block in the context or the iterated element.
  #     context ||= el
  #     block.call(context, el, context)
  #
  #   this


  # Calls block with two arguments, the item and its index, for each item in
  # enum. Given arguments are passed through to each().
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     hsh = {}
  #     R.w('cat dog wombat').each_with_index (item, index) ->
  #       hsh[item] = index
  #     hsh   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}
  #
  each_with_index: (block) ->
    return @to_enum('each_with_index') unless block && block.call?
    _enum.each_with_index(this, block)


  # Iterates the given block for each element with an arbitrary object given,
  # and returns the initially given object.
  #
  # If no block is given, returns an enumerator.
  #
  # @example
  #     evens = R.rng(1,10).each_with_object [], (i, a) -> a.push(i*2)
  #     #=> [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  #
  each_with_object: (obj, block) ->
    return @to_enum('each_with_object', obj) unless block && block.call?
    _enum.each_with_object(this, obj, block)

  # Passes each entry in enum to block. Returns the first for which block is not
  # false. If no object matches, calls ifnone and returns its result when it is
  # specified, or returns nil otherwise.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1, 10 ).detect (i) -> i % 5 == 0 and i % 7 == 0   #=> nil
  #     R.rng(1, 100).detect (i) -> i % 5 == 0 and i % 7 == 0   #=> 35
  #
  # @alias #detect
  #
  find: (ifnone, block = null) ->
    _enum.find(this, ifnone, block)


  # @alias #find
  #
  detect: @prototype.find


  # Returns an array containing all elements of enum for which block is not
  # false (see also Enumerable#reject).
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1,10).find_all (i) ->  i % 3 == 0    #=> [3, 6, 9]
  #
  find_all: (block) ->
    return @to_enum('find_all') unless block && block.call?
    new RArray(_enum.select(this, block))

  select: @prototype.find_all

  # Compares each entry in enum with value or passes to block. Returns the index
  # for the first for which the evaluated value is non-false. If no object
  # matches, returns nil
  #
  # If neither block nor argument is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1,10).find_index  (i) -> i % 5 == 0 and i % 7 == 0   #=> nil
  #     R.rng(1,100).find_index (i) -> i % 5 == 0 and i % 7 == 0   #=> 34
  #     R.rng(1,100).find_index(50)                                #=> 49
  #
  find_index: (value) ->
    return @to_enum('find_index') if arguments.length == 0
    val = _enum.find_index(this, value)
    if val != null
      new R.Fixnum(val)
    else
      val

  # Returns the first element, or the first n elements, of the enumerable. If
  # the enumerable is empty, the first form returns nil, and the second form
  # returns an empty array.
  #
  # @example
  #     R.w('foo bar baz').first()   #=> "foo"
  #     R.w('foo bar baz').first(2)  #=> ["foo", "bar"]
  #     R.w('foo bar baz').first(10) #=> ["foo", "bar", "baz"]
  #     new R.Array([]).first()                  #=> null
  #
  first: (n) ->
    if n is null or n is undefined
      _enum.first(this, null)
    else
      n = RCoerce.to_int_native(n)
      new RArray(_enum.first(this, n))


  # Returns true if any member of enum equals obj. Equality is tested using ==.
  include: (other) ->
    _enum.include(this, other)


  # Combines all elements of enum by applying a binary operation, specified by
  # a block or a symbol that names a method or operator.
  #
  # If you specify a block, then for each element in enum the block is passed
  # an accumulator value (memo) and the element. If you specify a symbol
  # instead, then each element in the collection will be passed to the named
  # method of memo. In either case, the result becomes the new value for memo.
  # At the end of the iteration, the final value of memo is the return value
  # for the method.
  #
  # If you do not explicitly specify an initial value for memo, then uses the
  # first element of collection is used as the initial value of memo.
  #
  # @example
  #
  #     # Sum some numbers
  #     # R.rng(5, 10).reduce(:+)                            #=> 45
  #     # Same using a block and inject
  #     R.rng(5, 10).inject {|sum, n| sum + n }            #=> 45
  #     # Multiply some numbers
  #     R.rng(5, 10).reduce(1, :*)                         #=> 151200
  #     # Same using a block
  #     R.rng(5, 10).inject(1) {|product, n| product * n } #=> 151200
  #     # find the longest word
  #     longest = R.w('cat sheep bear').inject (memo,word) ->
  #        if memo.length > word.length then memo else word
  #     # longest                                       #=> "sheep"
  #
  # @todo implement inject('+')
  #
  inject: (init, sym, block) ->
    _enum.inject(this, init, sym, block)


  # _ruby: returns an object that works with
  # for .. in ..
  # @private
  iterator: () ->
    @each()

  # Returns an array of every element in enum for which Pattern === element. If the optional block is supplied, each matching element is passed to it, and the block’s result is stored in the output array.
  #
  # @example
  #     R.rng(1, 100).grep R.rng(38,44)   #=> [38, 39, 40, 41, 42, 43, 44]
  #
  grep: (pattern, block) ->
    new RArray(_enum.grep(this, pattern, block))


  # Returns a hash, which keys are evaluated result from the block, and values
  # are arrays of elements in enum corresponding to the key.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #      R.rng(1, 6).group_by (i) -> i%3
  #      #=> {0=>[3, 6], 1=>[1, 4], 2=>[2, 5]}
  #
  group_by: (block) ->
    return @to_enum('group_by') unless block?.call?
    _enum.group_by(this, block)


  # Returns a new array with the results of running block once for every
  # element in enum.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R.rng(1, 4).collect (i) -> i*i   #=> [1, 4, 9, 16]
  #     R.rng(1, 4).collect -> "cat"     #=> ["cat", "cat", "cat", "cat"]
  #
  # @example #map with an enumerator:
  #
  #    en = R(['a']).each_with_index() #=> ['a', 0]
  #    en.map (x) ->   # x: 'a'
  #    en.map (x,i) -> # x: 'a', i: 0
  #    en.map (x...) -> # x: ['a', 0]
  #
  # @alias #collect
  #
  map: (block) ->
    return @to_enum('map') unless block?.call?

    callback = R.blockify(block, this)

    arr = []
    @each ->
      arr.push(callback.invoke(arguments))

    new RArray(arr)


  # @alias #map
  collect: @prototype.map


  # @alias #member
  member:  @prototype.include


  # Returns the object in enum with the maximum value. The first form assumes
  # all objects implement Comparable; the second uses the block to return a
  # <=> b.
  #
  # @return
  #     a = R.w('albatross dog horse')
  #     a.max()                                #=> "horse"
  #     # Not recommended at the moment:
  #     a.max (a,b) -> R(a.length)['<=>'] b.length }   #=> "albatross"
  #
  max: (block) ->
    _enum.max(this, block)


  # Returns the object in enum that gives the maximum value from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R.w('albatross dog horse')
  #     a.max_by (x) -> x.length    #=> "albatross"
  #
  max_by: (block) ->
    return @to_enum('max_by') unless block?.call?
    _enum.max_by(this, block)


  # Returns the object in enum with the minimum value. The first form assumes
  # all objects implement Comparable; the second uses the block to return a
  # <=> b.
  #
  #     a = R.w('albatross dog horse')
  #     a.min()                                  #=> "albatross"
  #     # Not recommended at the moment:
  #     a.min (a,b) -> R(a.length)['<=>'] b.length }   #=> "dog"
  #
  min: (block) ->
    _enum.min(this, block)


  # Returns the object in enum that gives the minimum value from the given
  # block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R.w('albatross dog horse')
  #     a.min_by (x) -> x.length   #=> "dog"
  #
  min_by: (block) ->
    return @to_enum('min_by') unless block?.call?
    _enum.min_by(this, block)


  # Returns two elements array which contains the minimum and the maximum
  # value in the enumerable. The first form assumes all objects implement
  # Comparable; the second uses the block to return a <=> b.
  #
  # @example
  #     a = R.w('albatross dog horse')
  #     a.minmax()                                  #=> ["albatross", "horse"]
  #     a.minmax (a,b) -> a.length <=> b.length }   #=> ["dog", "albatross"]
  #
  minmax: (block) ->
    new RArray(_enum.minmax(this, block))


  minmax_by: (block) ->
    return @to_enum('minmax_by') unless block?.call?
    new RArray(_enum.minmax_by(this, block))

  # Passes each element of the collection to the given block. The method returns true if the block never returns true for all elements. If the block is not given, none? will return true only if none of the collection members is true.
  #
  # @example
  #     R.w('ant bear cat').none (word) -> word.length == 5   # => true
  #     R.w('ant bear cat').none (word) -> word.length >= 4   # => false
  #     new R.Array([]).none()                                          # => true
  #     R([nil]).none()                                       # => true
  #     R([nil,false]).none()                                 # => true
  #
  none: (block) ->
    _enum.none(this, block)


  # Passes each element of the collection to the given block. The method
  # returns true if the block returns true exactly once. If the block is not
  # given, one? will return true only if exactly one of the collection members
  # is true.
  #
  # @example
  #     R.w('ant bear cat').one (word) -> word.length == 4   # => true
  #     R.w('ant bear cat').one (word) -> word.length > 4    # => false
  #     R.w('ant bear cat').one (word) -> word.length < 4    # => false
  #     R([ nil, true, 99 ]).one()                           # => false
  #     R([ nil, true, false ]).one()                        # => true
  #
  one: (block) ->
    _enum.one(this, block)


  partition: (block) ->
    return @to_enum('partition') unless block && block.call?
    ary = _enum.partition(this, block)
    new RArray([new RArray(ary[0]), new RArray(ary[1])])

  reduce: @prototype.inject

  reject: (block) ->
    return @to_enum('reject') unless block && block.call?
    new RArray(_enum.reject(this, block))


  reverse_each: (block) ->
    return @to_enum('reverse_each') unless block && block.call?
    _enum.reverse_each(this, block)


  slice_before: (args...) ->
    block = @__extract_block(args)
    # throw R.ArgumentError.new() if args.length == 1
    arg   = R(args[0])

    if block
      has_init = !(arg is undefined)
    else
      block = (elem) -> arg['==='] elem

    self = this
    R.Enumerator.create (yielder) ->
      accumulator = null
      self.each (elem) ->
        start_new = if has_init then block(elem, arg.dup()) else block(elem)
        if start_new
          yielder.yield accumulator if accumulator
          accumulator = R([elem])
        else
          accumulator ||= new RArray([])
          accumulator.append elem
      yielder.yield accumulator if accumulator


  sort: (block) ->
    # TODO: throw Error when comparing different values.
    new RArray(_enum.sort(this, block))


  sort_by: (block) ->
    return @to_enum('sort_by') unless block && block.call?
    new RArray(_enum.sort_by(this, block))


  take: (n) ->
    @__ensure_args_length(arguments, 1)
    n = RCoerce.to_int_native(n)
    throw R.ArgumentError.new() if n < 0

    new RArray(_enum.take(this, n))


  take_while: (block) ->
    return @to_enum('take_while') unless block && block.call?
    new RArray(_enum.take_while(this, block))


  to_a: () ->
    new RArray(_enum.to_a(this))


  to_enum: (iter = "each", args...) ->
    new R.Enumerator(this, iter, args)


  entries: @prototype.to_a

  # Takes one element from enum and merges corresponding elements from each
  # args. This generates a sequence of n-element arrays, where n is one more
  # than the count of arguments. The length of the resulting sequence will be
  # enum#size. If the size of any argument is less than enum#size, nil values
  # are supplied. If a block is given, it is invoked for each output array,
  # otherwise an array of arrays is returned.
  #
  # @example
  #     a = R([ 4, 5, 6 ])
  #     b = R([ 7, 8, 9 ])
  #     R([1,2,3]).zip(a, b)      #=> [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  #     R([1,2]  ).zip(a,b)       #=> [[1, 4, 7], [2, 5, 8]]
  #     a.zip([1,2],[8])           #=> [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
  #
  # @todo recursive arrays Untested
  # @todo uses #each to extract arguments' elements when #to_ary fails
  #
  # @todo dont yield R.Arrays
  zip: (others...) ->
    # TODO: fix specs
    block = @__extract_block(others)

    others = R(others).map (other) ->
      o = R(other)
      if o.to_ary? then o.to_ary() else o.to_enum('each')

    results = new R.Array([])
    idx     = 0
    @each (el) ->
      inner = R([el])
      others.each (other) ->
        el = if other.is_array? then other.at(idx) else other.next()
        el = null if el is undefined
        inner.append(el)

      block( inner ) if block
      results.append( inner )
      idx += 1

    if block then null else results

  # --- Aliases ---------------------------------------------------------------

  collectConcat:   @prototype.collect_concat
  dropWhile:       @prototype.drop_while
  eachCons:        @prototype.each_cons
  eachEntry:       @prototype.each_entry
  eachSlice:       @prototype.each_slice
  eachWithIndex:   @prototype.each_with_index
  eachWithObject:  @prototype.each_with_object
  findAll:         @prototype.find_all
  findIndex:       @prototype.find_index
  flatMap:         @prototype.flat_map
  groupBy:         @prototype.group_by
  maxBy:           @prototype.max_by
  minBy:           @prototype.min_by
  minmaxBy:        @prototype.minmax_by
  reverseEach:     @prototype.reverse_each
  sliceBefore:     @prototype.slice_before
  sortBy:          @prototype.sort_by
  takeWhile:       @prototype.take_while
  toA:             @prototype.to_a


# `value` is the original element and `sort_by` the one to be sorted by
#
# @private
class RubyJS.Enumerable.SortedElement
  constructor: (@value, @sort_by) ->

  '<=>': (other) ->
    @sort_by?['<=>'](other.sort_by)



REnumerable = RubyJS.Enumerable

class RubyJS.Enumerator extends RubyJS.Object
  @include RubyJS.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  @new: (obj, iter, args...) -> new RubyJS.Enumerator(obj, iter, args)


  # Creates an Enumerator. Pass optional arguments as an array instead of
  # splatted argument.
  #
  # new R.Enumerator([], 'each')
  # new R.Enumerator([], 'each_with_object', ['foo'])
  #
  constructor: (@object, @iter = 'each', @args = []) ->
    @generator = null
    @length = @object.length
    @idx = 0


  @create: (args...) ->
    if block = R.__extract_block(args)
      object = new RubyJS.Enumerator.Generator(block)
      iter = 'each'
      return Enumerator.new(object, iter)


  # ---- RubyJSism ------------------------------------------------------------

  is_enumerator: -> true


  # ---- Javascript primitives --------------------------------------------------


  # ---- Instance methods -----------------------------------------------------

  each: (block) ->
    @object[@iter](@args..., block)


  # Same as Enumerable, but without returning this
  each_with_index: (block) ->
    return @to_enum('each_with_index') unless block && block.call?

    callback = R.blockify(block, this)

    idx = 0
    @each ->
      args = BlockMulti.prototype.args(arguments)
      val  = callback.invokeSplat(args, idx)
      idx += 1
      val


  size: -> @object.length


  iterator: () ->
    @to_a().to_native()

  native_array: () ->
    @arr ||= @iterator()

  next: ->
    idx = @idx
    @idx += 1
    @native_array()[idx]

  to_enum: (iter = "each", args...) ->
    new RubyJS.Enumerator(this, iter, args)


  valueOf: ->
    @to_a().valueOf()


  eachWithIndex: @prototype.each_with_index



  # ---- Aliases --------------------------------------------------------------


# @private
class RubyJS.Enumerator.Yielder extends RubyJS.Object
  constructor: (@proc) ->
    throw 'LocalJumpError' unless @proc.call?

   yield: () ->
     @proc.apply(this, arguments)

   '<<': (value) ->
      @yield(value)
      this

# @private
class RubyJS.Enumerator.Generator extends RubyJS.Object
  constructor: (@proc) ->
    throw 'LocalJumpError' unless @proc.call?

  each: (block) ->
    # Confused? This is how your grand-parents feel when you explain them the internet.
    # TODO: document, taken straight from Rubinius.
    enclosed_yield = () ->
      block.apply(this, arguments)
    @proc( new RubyJS.Enumerator.Yielder( enclosed_yield ) )




# Array wraps a javascript array.
#
# @todo No proper support for handling recursive arrays. (e.g. a = [], a.push(a)).
#   Look for ArraySpecs.recursive_array in the specs.
#
# @todo The methods #taint, #trust, #freeze do nothing
#
# @method #equals(other)
#   Alias for {#==}  - Two arrays are equal if they contain the same number of elements
#   and if each element is equal to (according to {R.Object#==}) the corresponding
#   element in the other array.
#   @example
#      R(["a", "c"]   ).equals(["a", "c", 7])     #=> false
#      R(["a", "c", 7]).equals(["a", "c", 7])     #=> true
#      R(["a", "c", 7]).equals(["a", "d", "f"])   #=> false
#      # #equals is an alias to #==
#      R(["a", "c"]   )['=='](["a", "c", 7])     #=> false
#   @return [Boolean]
#   @alias #==
#
# @method #append(obj)
#   Alias for {#<<} - Pushes the given object on to the end of this array. This
#   expression returns the array itself, so several appends may be chained
#   together.
#   @example
#      R([ 1, 2 ]).append("c").append("d").append([3, 4])
#      #=> [ 1, 2, "c", "d", [ 3, 4 ] ]
#   @param [Object] obj
#   @return [R.Array]
#
# @method #intersection(other)
#   Alias for {#&} - Returns a new array containing elements common to the two
#   arrays, with no duplicates.
#   @example
#     R([ 1, 1, 3, 5 ]).intersection [ 1, 2, 3 ]
#     #=> [ 1, 3 ]
#   @alias #&
#   @param [Array] other
#   @return [R.Array]
#   @todo Slow implementation, slight deviation Ruby implementation of equality check
#
# @method #cmp(other)
#   Alias for {#<=>} - Returns an integer (-1, 0, or +1) if this array is less than,
#   equal to, or greater than other_ary. Each object in each array is compared
#   (using <=>). If any value isn’t equal, then that inequality is the return
#   value. If all the values found are equal, then the return is based on a
#   comparison of the array lengths. Thus, two arrays are “equal” according to
#   {R.Array#<=>} if and only if they have the same length and the value of each
#   element is equal to the value of the corresponding element in the other
#   array.
#   @example
#     R([ "a", "a", "c" ]   )['<=>'] [ "a", "b", "c" ]   #=> -1
#     R([ 1, 2, 3, 4, 5, 6 ])['<=>'] [ 1, 2 ]            #=> +1
#   @param [Array] other
#   @return [R.Array]
#
class RubyJS.Array extends RubyJS.Object
  @include R.Enumerable

  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_array: -> true

  # @private
  iterator: () ->
    @__native__


  # ---- Constructors & Typecast ----------------------------------------------

  # Creates a new R.Array with a clone of the given array.
  #
  constructor: (@__native__ = [], recursive ) ->
    if recursive is true
      idx = -1
      len = @__native__.length
      while ++idx < len
        @__native__[idx] = R(@__native__[idx], recursive)

  # Returns a new array. In the first form, the new array is empty. In the
  # second it is created with size copies of obj (that is, size references to
  # the same obj). The third form creates a copy of the array passed as a
  # parameter (the array is generated by calling #to_ary on the parameter). In
  # the last form, an array of the given size is created. Each element in this
  # array is calculated by passing the element’s index to the given block and
  # storing the return value.
  #
  # @example
  #     R.Array.new()                  # => []
  #     R.Array.new(2)                 # => [null, null]
  #     R.Array.new(3, "A")            # => ['A','A','A']
  #     # only one copy of the object is created
  #     a = R.Array.new(2, R('a') )   # => ['a', 'a']
  #     a[0].capitalize_bang()
  #     a                             # => ['A', 'A']
  #     # here multiple copies are created
  #     a = R.Array.new(2, -> R('a'))
  #     squares = R.Array.new(5, (i) -> i.multiply(i)
  #     copy = R.Array.new(squares)
  #
  @new: (args...) ->
    block = R.__extract_block(args)
    throw R.ArgumentError.new() if args.length >= 3
    size = args[0]
    obj  = args[1]

    return new R.Array([])  if size is undefined
    throw R.TypeError.new() if obj isnt undefined && (@isNativeArray(size) || size.is_array?)

    return new R.Array(size) if @isNativeArray(size)
    return size.to_ary()     if size.to_ary? && obj is undefined

    size = RCoerce.to_int_native(size)
    throw R.ArgumentError.new() if size < 0
    obj = null if obj is undefined

    ary = []
    idx = -1
    while ++idx < size
      ary[idx] = if block then block(R(idx)) else obj
    return new R.Array(ary)

  # @private
  @typecast: (arr, recursive) ->
    new R.Array(arr, recursive)

  # @private
  @isNativeArray: nativeArray.isArray or (obj) ->
    _toString_.call(obj) is '[object Array]'


  # Try to convert obj into an array, using to_ary method. Returns converted
  # array or nil if obj cannot be converted for any reason. This method can be
  # used to check if an argument is an array.
  #
  # @example
  #     R.Array.try_convert([1])      # => [1]
  #     R.Array.try_convert(R([1]))   # => [1]
  #     R.Array.try_convert("1")      # => null
  #
  # @todo Does currently not check if value from to_ary() is an Array
  #
  @try_convert: (obj) ->
    return obj          if obj.is_array?
    return @new(obj)    if @isNativeArray(obj)

    if obj.to_ary?
      # the correct behaviour currently breaks some tests.
      obj.to_ary() #.tap (a) -> throw R.TypeError.new() if a.is_array?
    else
      null

  # ---- Javascript primitives --------------------------------------------------

  # Returns native array.
  #
  # @return Array
  valueOf: ->
    @__native__


  # Returns native array.
  #
  # @param [boolean] recursive if set to true array and its elements are unboxed
  # @return Array
  #
  to_native: (recursive = false) ->
    if recursive
      # explicitly coded for performance reasons
      [idx,len,ary] = @__iter_vars__()
      while (++idx < len)
        el = @__native__[idx]
        el = el.to_native(true) if el && el.to_native?
        ary[idx] = el
      ary
    else
      # Clone array to avoid confusion
      @__native__.slice(0)


  # @private
  unbox: @prototype.to_native

  to_native_clone: -> @__native__.slice(0)


  __iter_vars__: (no_array) ->
    len = @__native__.length
    if no_array
      [-1, len]
    else
      [-1, len, nativeArray(len)]

  # ---- Instance methods -----------------------------------------------------

  '==': (other) ->
    other = R(other)
    unless other.is_array?
      return false unless other.to_ary?
      return other.equals(this)

    _arr.equals(@__native__, other.__native__)


  '<<': (obj) ->
    @__native__.push(obj)
    this


  '&': (other) ->
    other = RCoerce.to_ary(other)
    arr   = new R.Array([])
    # TODO suboptimal solution.
    @each (el) -> arr.push(el) if other.include(el)
    arr.uniq()


  # @private
  '<=>': (other) ->
    return null unless other?
    try
      other = RCoerce.to_ary(other)
    catch e
      return null
    return 0    if @equals(other)

    other_total = other.size()
    # Thread.detect_recursion self, other do
    i = 0
    total = if other_total.lt(@size()) then other_total else @size()

    while total.gt(i)
      diff = R(@__native__[i])['<=>'] other.__native__[i]
      return diff unless diff == 0
      i += 1

    # subtle: if we are recursing on that pair, then let's
    # no go any further down into that pair;
    # any difference will be found elsewhere if need be
    @size()['<=>'] other_total


  # Returns the element at index. A negative index counts from the end of
  # self. Returns nil if the index is out of range. See also Array#[].
  #
  # @example
  #     a = R([ "a", "b", "c", "d", "e" ])
  #     a.at(0)     #=> "a"
  #     a.at(-1)    #=> "e"
  #
  # @return [Object]
  #
  at: (index) ->
    # UNSUPPORTED: @__ensure_args_length(arguments, 1)
    index = RCoerce.to_int_native(index)
    _arr.at(@__native__, index)


  # Removes all elements from self.
  #
  # @example
  #     a = R([ "a", "b", "c", "d", "e" ])
  #     a.clear()    #=> [ ]
  #
  # @return [R.Array]
  #
  clear: () ->
    @__ensure_args_length(arguments, 0)
    @__native__.length = 0
    @replace @__native__
    this


  # @todo does not copy the singleton class of the copied object
  clone: () ->
    @dup()


  # Invokes the block once for each element of self, replacing the element
  # with the value returned by block. See also Enumerable#collect.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([ "a", "b", "c", "d" ])
  #     a.collect_bang (x) -> x+"!"
  #     a
  #     #=>  [ "a!", "b!", "c!", "d!" ]
  #
  # @alias #map_bang
  # @return self
  # @note some edge-cases not handled when breaking out from block.
  #
  collect_bang: (block) ->
    return @to_enum('collect_bang') unless block?.call?
    @replace _arr.collect(@__native__, block)


  # When invoked with a block, yields all combinations of length n of elements
  # from ary and then returns ary itself. The implementation makes no
  # guarantees about the order in which the combinations are yielded.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([1, 2, 3, 4])
  #     a.combination(1).to_a()  #=> [[1],[2],[3],[4]]
  #     a.combination(2).to_a()  #=> [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
  #     a.combination(3).to_a()  #=> [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
  #     a.combination(4).to_a()  #=> [[1,2,3,4]]
  #     a.combination(0).to_a()  #=> [[]] # one combination of length 0
  #     a.combination(5).to_a()  #=> []   # no combinations of length 5
  #     R([1, 2, 3, 4]).combination(3).to_a()
  #
  # @return R.Array
  #
  combination: (args...) ->
    block = @__extract_block(args)
    num   = RCoerce.to_int_native args[0]
    return @to_enum('combination', num) unless block?.call?
    _arr.combination(@__native__, num, block)
    this


  # Returns a copy of self with all nil elements removed.
  #
  # @example
  #     R([ "a", nil, "b", nil, "c", nil ]).compact()
  #     #=> [ "a", "b", "c" ]
  #
  # @return [R.Array]
  #
  compact: ->
    new RArray(_arr.compact(@__native__))


  # Removes nil elements from the array. Returns nil if no changes were made,
  # otherwise returns ary.
  #
  # @example
  #
  #     R([ "a", nil, "b", nil, "c" ]).compact_bang()
  #     # => [ "a", "b", "c" ]
  #     R([ "a", "b", "c" ]).compact_bang()
  #     # => null
  #
  # @return self or null if nothing changed
  #
  compact_bang: ->
    len = @__native__.length
    ary = _arr.compact(@__native__)
    @replace ary
    if len == ary.length then null else this


  # Appends the elements of other_ary to self.
  #
  # @example
  #     R([ "a", "b" ]).concat( ["c", "d"] )
  #     #=> [ "a", "b", "c", "d" ]
  #
  # @return R.Array
  #
  concat: (other) ->
    other = RCoerce.to_ary_native(other)
    @replace @__native__.concat(other)


  # Deletes items from self that are equal to obj. If any items are found,
  # returns obj. If the item is not found, returns nil. If the optional code
  # block is given, returns the result of block if the item is not found. (To
  # remove nil elements and get an informative return value, use compact!)
  #
  # @example
  #     a = R([ "a", "b", "b", "b", "c" ])
  #     a.delete("b")                   #=> "b"
  #     a                               #=> ["a", "c"]
  #     a.delete("z")                   #=> nil
  #     a.delete("z", -> 'not found')   #=> "not found"
  #
  delete: (args...) ->
    block   = @__extract_block(args)
    _arr.delete(@__native__, args[0], block)


  # Deletes the element at the specified index, returning that element, or nil
  # if the index is out of range. See also Array#slice!.
  #
  # @example
  #    a = R.w('ant bat cat dog')
  #    a.delete_at(2)    #=> "cat"
  #    a                 #=> ["ant", "bat", "dog"]
  #    a.delete_at(99)   #=> null
  #
  # @return obj or null
  #
  delete_at: (idx) ->
    idx = RCoerce.to_int_native(idx)
    _arr.delete_at(@__native__, idx)



  # Deletes every element of self for which block evaluates to true. The array
  # is changed instantly every time the block is called and not after the
  # iteration is over. See also Array#reject!
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([ "a", "b", "c" ])
  #     a.delete_if (x) -> x >= "b"
  #     #=> ["a"]
  #
  # @return [R.Array, R.Enumerator] when no block
  #
  delete_if: (block) ->
    @replace @reject(block)


  dup: () -> new RubyJS.Array(@__native__.slice(0))


  # @todo should not call #to_ary on its argument, but it does through boxing, Array.try_convert
  eql: (other) ->
    return true if @equals(other)
    other = R(other)
    return false unless other.is_array?
    return false unless @size().equals other.size()

    # TODO: no nested loop detection
    other_arr = other.to_native()
    @catch_break (breaker) ->
      i = 0
      @each (x) ->
        breaker.break(false) unless R(x).eql(other_arr[i])
        i += 1
      true


  # Same as Array#each, but passes the index of the element instead of the
  # element itself.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([ "a", "b", "c" ])
  #     a.each_index (x) -> R.puts "#{x} -- "
  #     # out: 0 -- 1 -- 2 --
  #
  each_index: (block) ->
    if block && block.call?
      idx = -1
      len = @__native__.length
      while ++idx < len
        block(idx)
      this
    else
      @to_enum('each_index')


  # Calls block once for each element in self, passing that element as a
  # parameter.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([ "a", "b", "c" ])
  #     a.each (x) -> R.puts "#{x} -- "
  #     # out: a -- b -- c --
  #
  # @alias #each
  #
  each: (block) ->
    return @to_enum() unless block?.call?
    _arr.each(@__native__, block)
    this




  # Alias for R.Array#[] R.Array#slice
  #
  # Element Reference—Returns the element at index, or returns a subarray
  # starting at start and continuing for length elements, or returns a
  # subarray specified by range. Negative indices count backward from the end
  # of the array (-1 is the last element). Returns nil if the index (or
  # starting index) are out of range.
  #
  # @example
  #     a = R([ "a", "b", "c", "d", "e" ])
  #     a.get(2) +  a.get(0) + a.get(1)    #=> "cab"
  #     a.get(6)                   #=> nil
  #     a.get(1, 2)                #=> [ "b", "c" ]
  #     a.get(R.rng(1,3))          #=> [ "b", "c", "d" ]
  #     a.get(R.rng(4,7))          #=> [ "e" ]
  #     a.get(R.rng(6,10))         #=> nil
  #     a.get(-3, 3)               #=> [ "c", "d", "e" ]
  #     # special cases
  #     a.get(5)                   #=> nil
  #     a.get(5, 1)                #=> []
  #     a.get(R.rng(5,10))         #=> []
  #
  get: (a, b) ->
    @slice(a,b)


  # TODO: IMPLEMENT remaining arguments!!
  #
  #
  set: (idx, obj) ->
    if idx.is_range?
      return @set$range(idx, obj)
    if arguments.length is 3
      return @set$int$int.apply(this, arguments)

    idx = RCoerce.to_int_native(idx)
    @__native__[idx] = obj

    obj


  # @private
  set$range: (rng, obj) ->
    throw R.NotImplementedError.new()


  # @private
  set$int$int: (start, length, obj) ->
    throw R.NotImplementedError.new()


  # Returns true if self contains no elements.
  #
  #
  empty: () ->
    @__native__.length is 0

  # Tries to return the element at position index. If the index lies outside
  # the array, the first form throws an IndexError exception, the second form
  # returns default, and the third form returns the value of invoking the
  # block, passing in the index. Negative values of index count from the end
  # of the array.
  #
  # @example
  #     a = R([ 11, 22, 33, 44 ])
  #     a.fetch(1)               #=> 22
  #     a.fetch(-1)              #=> 44
  #     a.fetch(4, 'cat')        #=> "cat"
  #     a.fetch(4, (i) -> i*i))  #=> 16
  #
  fetch: (idx, default_or_block) ->
    idx = RCoerce.to_int_native(idx)
    _arr.fetch(@__native__, idx, default_or_block)


  # Fills array with obj or block.
  #
  #     fill(obj) → ary
  #     fill(obj, start [, length]) → ary
  #     fill(obj, range ) → ary
  #     fill (index) -> block  → ary
  #     fill(start [, length],  (index) -> block  → ary
  #     # not yet implemented:
  #     fill(range, (index) -> block ) → ary
  #
  # The first three forms set the selected elements of self (which may be the
  # entire array) to obj. A start of nil is equivalent to zero. A length of
  # nil is equivalent to self.length. The last three forms fill the array with
  # the value of the block. The block is passed the absolute index of each
  # element to be filled. Negative values of start count from the end of the
  # array.
  #
  # @example
  #     a = R([ "a", "b", "c", "d" ])
  #     a.fill("x")               #=> ["x", "x", "x", "x"]
  #     a.fill("z", 2, 2)         #=> ["x", "x", "z", "z"]
  #     # a.fill("y", 0..1)         #=> ["y", "y", "z", "z"]
  #     a.fill (i) -> i*i         #=> [0, 1, 4, 9]
  #     a.fill(-2) (i) -> i*i*i   #=> [0, 1, 8, 27]
  #
  # @todo implement fill(range, ...)
  #
  fill: (args...) ->
    throw R.ArgumentError.new() if args.length == 0

    block = @__extract_block(args)

    if block
      throw R.ArgumentError.new() if args.length >= 3
      one = args[0]; two = args[1]
    else
      throw R.ArgumentError.new() if args.length > 3
      obj = args[0]; one = args[1]; two = args[2]

    size = @__size__()

    if one?.is_range?
      # TODO: implement fill with range
      throw R.NotImplementedError.new()

    else if one isnt undefined && one isnt null
      left = RCoerce.to_int_native(one)
      left = left + size    if left < 0
      left = 0              if left < 0

      if two isnt undefined && two isnt null
        try
          right = RCoerce.to_int_native(two)
        catch e
          throw R.ArgumentError.new("second argument must be a Fixnum")
        return this if right is 0
        right = right + left
      else
        right = size
    else
      left  = 0
      right = size

    total = right

    if right > size # pad with nul if length is greater than array
      fill = @__native_array_with__(right - size, null)
      @concat( fill )
      total = right

    i = left
    if block
      while total > i
        v = block.call(this, i)
        @__native__[i] = if v is undefined then null else v
        i += 1
    else
      while total > i
        @__native__[i] = obj
        i += 1
    this


  # Returns a new array that is a one-dimensional flattening of this array
  # (recursively). That is, for every element that is an array, extract its
  # elements into the new array. If the optional level argument determines the
  # level of recursion to flatten.
  #
  # @example
  #     s = R([ 1, 2, 3 ])           #=> [1, 2, 3]
  #     t = R([ 4, 5, 6, [7, 8] ])   #=> [4, 5, 6, [7, 8]]
  #     a = R([ s, t, 9, 10 ])       #=> [[1, 2, 3], [4, 5, 6, [7, 8]], 9, 10]
  #     a.flatten()                  #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #     a = R([ 1, 2, [3, [4, 5] ] ])
  #     a.flatten(1)                 #=> [1, 2, 3, [4, 5]]
  #
  # TODO: IMPORTANT!
  # @todo fails for [undefined, null]
  # @todo do not typecast elements!
  #
  flatten: (recursion = -1) ->
    new RArray(_arr.flatten(@__native__, recursion))


  # Inserts the given values before the element with the given index (which
  # may be negative).
  #
  # @example
  #     a = R.w('a b c d')
  #     a.insert(2, 99)         #=> ["a", "b", 99, "c", "d"]
  #     a.insert(-2, 1, 2, 3)   #=> ["a", "b", 99, "c", 1, 2, 3, "d"]
  #
  insert: (idx, items...) ->
    throw R.ArgumentError.new() if idx is undefined
    return this if items.length == 0
    # Adjust the index for correct insertion
    idx = RCoerce.to_int_native(idx)

    ary = _arr.insert.apply(_arr, [@__native__, idx].concat(items))
    this


  # Creates a string representation of self.
  #
  # Also aliased as: {#to_s}
  #
  # @example
  #     R([1,2]).inspect()     # => '[1, 2]'
  #
  inspect: () ->
    R("[#{@map((e) -> R.inspect(e) ).join(', ')}]")


  # Returns a string created by converting each element of the array to a
  # string, separated by sep.
  #
  # @example
  #     R([ "a", "b", "c"]).join()      # => "abc"
  #     R([ "a", "b", "c"]).join(null)  # => "abc"
  #     R([ "a", "b", "c"]).join("-")   # => "a-b-c"
  #     # joins nested arrays
  #     R([1,[2,[3,4]]]).join('.')      # => '1.2.3.4'
  #     # Default separator R['$,'] (in ruby: $,)
  #     R['$,']                        # => null
  #     R([ "a", "b", "c"]).join()      # => "abc"
  #     R['$,'] = '|'                  # => '|'
  #     R([ "a", "b", "c"]).join()      # => "a|b|c"
  #
  # @todo Does not ducktype via #to_str, #to_ary, #to_s or throw error
  #
  join: (sep) ->
    sep = RCoerce.to_str_native(sep) if sep?
    new RString(_arr.join(@__native__, sep))


  # Deletes every element of self for which block evaluates to false. See also
  # Array#select!
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([1,2,3,4])
  #     a.keep_if (v) -> i < 3   # => [1,2,3]
  #     a.keep_if  -> true       # => a # returns self if not changed
  #
  keep_if: (block) ->
    return @to_enum('keep_if') unless block?.call?

    ary = []
    # TODO: use while
    @each (el) ->
      ary.push(el) unless R.falsey(block(el))

    if @__size__() is ary.length then this else @replace(ary)

  # Array Difference - Returns a new array that is a copy of the original
  # array, removing any items that also appear in other_ary. (If you need set-
  # like behavior, see the library class Set.)
  #
  # @note minus checks for identity using other.include(el), which differs slightly
  #   from the reference which uses #hash and #eql?
  #
  # @example
  #     R([ 1, 1, 2, 2, 3, 3, 4, 5 ]) - [ 1, 2, 4 ]  #=>  [ 3, 3, 5 ]
  #
  # @todo recursive arrays not tested
  #
  minus: (other) ->
    other = RCoerce.to_ary(other)

    ary = []
    @each (el) ->
      ary.push(el) unless other.include(el)

    new R.Array(ary)


  # Repetition—With a String argument, equivalent to self.join(str).
  # Otherwise, returns a new array built by concatenating the int copies of
  # self.
  #
  # @example
  #     R([ 1, 2, 3 ]).multiply 3    # => [ 1, 2, 3, 1, 2, 3, 1, 2, 3 ]
  #     R([ 1, 2, 3 ]).multiply ","  # => "1,2,3"
  #
  multiply: (multiplier) ->
    @__ensure_args_length(arguments, 1)
    throw R.TypeError.new() if multiplier is null

    multiplier = R(multiplier)
    if multiplier.to_str?
      return @join(multiplier)
    else
      multiplier = RCoerce.to_int_native(multiplier)

      throw R.ArgumentError.new("count cannot be negative") if multiplier < 0

      total = @__size__()
      if total is 0
        return new R.Array([])
      else if total is 1
        return @dup()

      ary = []
      arr = @__native__

      idx = -1
      while ++idx < multiplier
        ary = ary.concat(arr)

      return new R.Array(ary)

  # Returns the last element(s) of self. If the array is empty, the first form
  # returns nil.
  #
  # @example
  #     a = R([ "w", "x", "y", "z" ])
  #     a.last()     #=> "z"
  #     a.last(2)    #=> ["y", "z"]
  #
  last: (n) ->
    len = @__size__()
    if len < 1
      return null if n is undefined
      return new R.Array([])

    return @at(-1) if n is undefined

    n = RCoerce.to_int_native(n)
    return new R.Array([]) if n is 0

    throw R.ArgumentError.new("count must be positive") if n < 0

    n = len if n > len
    new R.Array( @__native__[-n.. -1] )


  # @private
  # @todo Not yet implemented
  permutation: (args...) ->
    throw R.NotImplementedError.new()
  #   block = @__extract_block(args)
  #   num   = args[0]
  #   return @to_enum('permutation', num) unless block?.call?

  #   num = if num is undefined then @size() else RCoerce.to_int(num)

  #   if num.lt(0) || @size().lt num
  #     # no permutations, yield nothing
  #   else if num.equals 0
  #     # exactly one permutation: the zero-length array
  #     block.call(this, new R.Array([]))
  #   else if num.equals 1
  #     # this is a special, easy case
  #     @each (val) -> block.call(this, R([val]))
  #   else
  #     # this is the general case
  #     perm = R.Array.make(num)
  #     used = R.Array.make(@size(), false)

  #     if block
  #       # offensive (both definitions) copy.
  #       offensive = @dup()
  #       offensive.__permute__(num, perm, R(0), used, block)
  #     # else
  #     #   @__permute__(num, perm, R(0), used)

  #   this

  # # @private
  # __permute__: (num, perm, index, used, block) ->
  #   # Recursively compute permutations of r elements of the set [0..n-1].
  #   # When we have a complete permutation of array indexes, copy the values
  #   # at those indexes into a new array and yield that array.
  #   #
  #   # num: the number of elements in each permutation
  #   # p: the array (of size num) that we're filling in
  #   # index: what index we're filling in now
  #   # used: an array of booleans: whether a given index is already used
  #   #
  #   # Note: not as efficient as could be for big num.
  #   self = this
  #   @size().times (i) ->
  #     unless used[i]
  #       perm[index] = i
  #       if index.lt(num.minus 1)
  #         used[i] = true
  #         self.__permute__(num, perm, index.plus(1), used, block)
  #         used[i] = false
  #       else
  #         block.apply(this, self.values_at(perm...)...)


  # Concatenation—Returns a new array built by concatenating the two arrays
  # together to produce a third array.
  #
  # @example
  #     R([ 1, 2, 3 ]).plus [ 3, 4 ]     #=> [ 1, 2, 3, 3, 4 ]
  #     R([ 1, 2, 3 ])['+']([ 3, 4 ])    #=> [ 1, 2, 3, 3, 4 ]
  #
  # @note recursive arrays untested.
  #
  plus: (other) ->
    @concat(other)


  # Removes the last element from self and returns it, or nil if the array is empty.
  #
  # If a number n is given, returns an array of the last n elements (or less)
  # just like array.slice!(-n, n) does.
  #
  # @example
  #     a = R([ "a", "b", "c", "d" ])
  #     a.pop()     # => "d"
  #     a.pop(2)    # => ["b", "c"]
  #     a           # => ["a"]
  #
  # @todo check for recursive arrays
  #
  pop: (many) ->
    throw R.ArgumentError.new() if arguments.length > 1

    if many is undefined
      @__native__.pop()
    else
      many = RCoerce.to_int_native(many)
      throw R.ArgumentError.new("negative array size") if many < 0
      first = @__size__() - many
      first = 0 if first < 0
      @slice_bang(first, many)


  # Returns an array of all combinations of elements from all arrays. The
  # length of the returned array is the product of the length of self and the
  # argument arrays. If given a block, product will yield all combinations and
  # return self instead.
  #
  # @example
  #     R( [1,2,3] ).product([4,5])       #=> [[1,4],[1,5],[2,4],[2,5],[3,4],[3,5]]
  #     R( [1,2]   ).product([1,2])       #=> [[1,1],[1,2],[2,1],[2,2]]
  #     R( [1,2]   ).product([3,4],[5,6]) #=> [[1,3,5],[1,3,6],[1,4,5],[1,4,6],
  #                                       #     [2,3,5],[2,3,6],[2,4,5],[2,4,6]]
  #     R( [1,2] ).product()              #=> [[1],[2]]
  #     R( [1,2] ).product([])            #=> []
  #
  # @todo does not check if the result size will fit in an Array.
  #
  product: (args...) ->
    block = @__extract_block(args)
    args = R.$Array_r(args).reverse()
    throw R.TypeError.new() unless args.all (a) -> a.to_ary?
    args.map_bang (a) -> a.to_ary()
    result = new R.Array([])
    args.push(this)

    # Implementation notes: We build a block that will generate all the
    # combinations by building it up successively using "inject" and starting
    # with one responsible to append the values.
    outer = args.inject result.push, (trigger, values) ->
      (partial) ->
        values.each (val) ->
          trigger.call(result, partial.dup().append(val))

    outer( new R.Array([]) )
    if block
      block_result = this
      result.each (v) ->
        block_result.append block(v)
      block_result
    else
      result

  # Append—Pushes the given object(s) on to the end of this array. This
  # expression returns the array itself, so several appends may be chained
  # together.
  #
  # @example
  #     a = R([ "a", "b", "c" ])
  #     a.push("d", "e", "f")
  #     #=> ["a", "b", "c", "d", "e", "f"]
  #
  push: ->
    @__native__.push.apply(@__native__, arguments)
    this


  # Searches through the array whose elements are also arrays. Compares obj
  # with the second element of each contained array using ==. Returns the
  # first contained array that matches. See also Array#assoc.
  #
  # @example
  #     a = R([ [ 1, "one"], [2, "two"], [3, "three"], ["ii", "two"] ])
  #     a.rassoc("two")    #=> [2, "two"]
  #     a.rassoc("four")   #=> nil
  #
  rassoc: (obj) ->
    obj = R(obj)

    @catch_break (breaker) ->
      @each (elem) ->
        if elem.is_array? and R(elem.at(1))?['=='](obj)
          breaker.break(elem)
      null

  # Returns the index of the last object in self == to obj. If a block is
  # given instead of an argument, returns index of first object for which
  # block is true, starting from the last object. Returns nil if no match is
  # found. See also Array#index.
  #
  # If neither block nor argument is given, an enumerator is returned instead.
  #
  # @example
  #     a = R([ "a", "b", "b", "b", "c" ])
  #     a.rindex("b")             # => 3
  #     a.rindex("z")             # => nil
  #     a.rindex (x) -> x == "b"  # => 3
  #
  # @note does not check if array has changed.
  #
  rindex: (other) ->
    return @to_enum('rindex') if other is undefined

    if other.call?
      block = other
      len   = @__size__()
      ridx  = @catch_break (breaker) ->
        idx = -1
        @reverse_each (el) ->
          idx += 1
          unless R.falsey(block(el))
            breaker.break(idx)
        null
    else
      # TODO: 2012-11-06 use a while loop with idx counting down
      ridx = @catch_break (breaker) ->
        idx = -1
        @reverse_each (el) ->
          idx += 1
          if R(el)['=='](other)
            breaker.break(idx)
        null

    if ridx is null then null else R(@__size__() - ridx - 1)

  # Choose a random element or n random elements from the array. The elements
  # are chosen by using random and unique indices into the array in order to
  # ensure that an element doesn’t repeat itself unless the array already
  # contained duplicate elements. If the array is empty the first form returns
  # nil and the second form returns an empty array.
  #
  # If rng is given, it will be used as the random number generator.
  #
  #     R([1,2,3]).sample()    # => 2
  #     R([1,2,3]).sample(2)   # => [3,1]
  #     R([1,2,3]).sample(4)   # => [2,1,3]
  #
  sample: (n, range = undefined) ->
    return @at(@rand(@size())) if n is undefined

    n = RCoerce.to_int_native(n)
    throw R.ArgumentError.new() if n < 0

    size = @__size__()
    n    = size if n > size
    ary  = @to_native_clone()

    idx = -1
    while ++idx < n
      ridx = idx + R.rand(size - idx) # Random idx
      tmp  = ary[idx]
      ary[idx]  = ary[ridx]
      ary[ridx] = tmp

    new R.Array(ary).slice(0, n)

  # Equivalent to Array#delete_if, deleting elements from self for which the
  # block evaluates to true, but returns nil if no changes were made. The array
  # is changed instantly every time the block is called and not after the
  # iteration is over. See also Enumerable#reject and Array#delete_if.
  #
  # If no block is given, an enumerator is returned instead.
  #
  reject_bang: (block) ->
    return @to_enum('reject_bang') unless block?.call?
    ary = @reject(block)
    if ary.__size__() is @__size__() then null else @replace(ary)

  # Replaces the contents of self with the contents of other_ary, truncating
  # or expanding if necessary.
  #
  # @example
  #     a = R([ "a", "b", "c", "d", "e" ])
  #     a.replace([ "x", "y", "z" ])   # => ["x", "y", "z"]
  #     a                              # => ["x", "y", "z"]
  #     a.replace(R([1]))             # => [1]
  #
  replace: (val) ->
    @__ensure_args_length(arguments, 1)
    # TODO: Use RCoerce.to_ary_native
    @__native__ = if val.to_ary? then val.to_ary().to_native().slice(0) else val.slice(0)
    this


  # Returns a new array containing self‘s elements in reverse order.
  #
  #     R([ "a", "b", "c" ]).reverse()   #=> ["c", "b", "a"]
  #     R([ 1 ]).reverse()               #=> [1]
  #
  reverse: () ->
    @dup().tap (w) -> w.reverse_bang()


  # Reverses self in place.
  #
  #     a = R([ "a", "b", "c" ])
  #     a.reverse_bang()   #=> ["c", "b", "a"]
  #     a                  #=> ["c", "b", "a"]
  #
  reverse_bang: () ->
    @replace @__native__.reverse()
    this

  # Same as Array#each, but traverses self in reverse order.
  #
  #     a = R([ "a", "b", "c" ])
  #     a.reverse_each (x) -> R.puts "#{x} "
  #     # out: c b a
  #
  reverse_each: (block) ->
    return @to_enum('reverse_each') unless block && block.call?
    _arr.reverse_each(@__native__, block)
    this


  # Returns new array by rotating self so that the element at cnt in self is
  # the first element of the new array. If cnt is negative then it rotates in
  # the opposite direction.
  #
  # @example
  #     a = R([ "a", "b", "c", "d" ])
  #     a.rotate()       # => ["b", "c", "d", "a"]
  #     a                # => ["a", "b", "c", "d"]
  #     a.rotate(2)      # => ["c", "d", "a", "b"]
  #     a.rotate(-3)     # => ["b", "c", "d", "a"]
  #
  rotate: (cnt) ->
    cnt = 1 if cnt is undefined
    cnt = RCoerce.to_int_native(cnt)

    ary = @dup()
    return ary             if @__size__() is 1
    return new R.Array([]) if @empty()

    idx = cnt % ary.__size__()

    sliced = ary.slice(R.rng(0, idx, true))
    ary.slice(R.rng(idx,-1)).concat(sliced)

  # Rotates self in place so that the element at cnt comes first, and returns
  # self. If cnt is negative then it rotates in the opposite direction.
  #
  #     a = R([ "a", "b", "c", "d" ])
  #     a.rotate_bang()      # => ["b", "c", "d", "a"]
  #     a                    # => ["b", "c", "d", "a"]
  #     a.rotate_bang(2)     # => ["d", "a", "b", "c"]
  #     a.rotate_bang(-3)    # => ["a", "b", "c", "d"]
  #
  rotate_bang: (cnt) ->
    if cnt is undefined
      cnt = 1
      @replace @rotate(cnt)
    else
      cnt = RCoerce.to_int_native(cnt)
      return this if cnt is 0 or cnt is 1
      @replace @rotate(cnt)


  # Invokes the block passing in successive elements from self, deleting
  # elements for which the block returns a false value. It returns self if
  # changes were made, otherwise it returns nil. See also Array#keep_if
  #
  # If no block is given, an enumerator is returned instead.
  select_bang: (block) ->
    return @to_enum('select_bang') unless block?.call?
    ary = @select(block)
    if ary.__size__() is @__size__() then null else @replace(ary)


  # Invokes the block passing in successive elements from self, returning an
  # array containing those elements for which the block returns a true value
  # (equivalent to Enumerable#select).
  #
  # If no block is given, an enumerator is returned instead.
  #
  #     a = R.w('a b c d e f')
  #     a.select (v) -> v.match /[aeiou]/   #=> ["a", "e"]
  #
  #

  # Returns the first element of self and removes it (shifting all other
  # elements down by one). Returns nil if the array is empty.
  #
  # If a number n is given, returns an array of the first n elements (or less)
  # just like array.slice!(0, n) does.
  #
  #     args = R([ "-m", "-q", "filename" ])
  #     args.shift()     #=> "-m"
  #     args             #=> ["-q", "filename"]
  #
  #     args = R([ "-m", "-q", "filename" ])
  #     args.shift(2)  #=> ["-m", "-q"]
  #     args           #=> ["filename"]
  #
  shift: (n) ->
    throw R.ArgumentError.new() if arguments.length > 1

    if n is undefined
      el = @__native__[0]
      @replace @__native__.slice(1)
      el
    else
      n = RCoerce.to_int_native(n)
      throw R.ArgumentError.new() if n < 0
      ret  = @first(n)
      @replace @__native__.slice(n)
      ret


  # Returns a new array with elements of this array shuffled.
  #
  #     a = [ 1, 2, 3 ]           #=> [1, 2, 3]
  #     a.shuffle()                 #=> [2, 3, 1]
  #
  shuffle: ->
    @dup().tap (ary) -> ary.shuffle_bang()

  # Shuffles elements in self in place. If rng is given, it will be used as
  # the random number generator.
  #
  shuffle_bang: ->
    size = @__size__()
    arr  = @__native__

    idx = -1
    while ++idx < size
      rnd = idx + R.rand(size - idx)
      tmp = arr[idx]
      arr[idx] = arr[rnd]
      arr[rnd] = tmp
    this

  # Length of array
  size: ->
    R(@__native__.length)


  # Length of array as literal
  __size__: ->
    @__native__.length


  # Element Reference—Returns the element at index, or returns a subarray
  # starting at start and continuing for length elements, or returns a
  # subarray specified by range. Negative indices count backward from the end
  # of the array (-1 is the last element). Returns null if the index (or
  # starting index) are out of range.
  #
  # @example
  #     a = R([ "a", "b", "c", "d", "e" ])
  #     a.slice(2) +  a[0] + a[1]    #=> "cab"
  #     a.slice(6)                   #=> null
  #     a.slice(1, 2)                #=> [ "b", "c" ]
  #     a.slice(1..3)                #=> [ "b", "c", "d" ]
  #     a.slice(4..7)                #=> [ "e" ]
  #     a.slice(6..10)               #=> null
  #     a.slice(-3, 3)               #=> [ "c", "d", "e" ]
  #     # special cases
  #     a.slice(5)                   #=> null
  #     a.slice(5, 1)                #=> []
  #     a.slice(5..10)               #=> []
  #
  slice: (idx, length) ->
    throw new R.TypeError.new() if idx is null
    size = @__size__()

    # TODO: implement ranges

    if idx?.is_range?
      range = idx
      range_start = RCoerce.to_int_native(range.begin())
      range_end   = RCoerce.to_int_native(range.end()  )
      range_start = range_start + size if range_start < 0

      if range_end < 0
        range_end = range_end + size
      # else if range_end >= size
      #   range_end = size - 1

      range_end   = range_end + 1 unless range.exclude_end()
      range_lenth = range_end - range_start
      return null if range_start > size  or range_start < 0
      return new R.Array(@__native__.slice(range_start, range_end))
    else
      idx = RCoerce.to_int_native(idx)

    idx = size + idx if idx < 0
    # return @$String('') if is_range and idx.lteq(size) and idx.gt(length)

    if length is undefined
      return null if idx < 0 or idx >= size
      @at(idx)
    else
      length = RCoerce.to_int_native(length)
      return null if idx < 0 or idx > size or length < 0
      new R.Array(@__native__.slice(idx, length + idx))


  # Deletes the element(s) given by an index (optionally with a length) or by
  # a range. Returns the deleted object (or objects), or null if the index is
  # out of range.
  #
  # @example
  #     a = R([ "a", "b", "c" ])
  #     a.slice_bang(1)     # => "b"
  #     a                   # => ["a", "c"]
  #     a.slice_bang(-1)    # => "c"
  #     a                   # => ["a"]
  #     a.slice_bang(100)   # => null
  #     a                   # => ["a"]
  #
  slice_bang: (idx, length) ->
    throw new R.TypeError.new() if idx is null

    ary  = null
    size = @__size__()

    if idx.is_range?
      range = idx
      ary   = @slice(range)
      rng_start = RCoerce.to_int_native(range.begin())
      rng_end   = RCoerce.to_int_native(range.end()  )
      rng_start = rng_start + size if rng_start < 0

      if rng_end < 0
        rng_end = rng_end + size
      else if rng_end >= size
        rng_end >= size

      rng_length = rng_end - rng_start
      rng_length = rng_length + 1 unless range.exclude_end()

      # possible bug? in rubinius rng_end.lteq(size) is rng_end < @total
      if rng_start < size && rng_start >= 0 && rng_end <= size && rng_end >= 0 && rng_length > 0
        @__delete_range(rng_start, rng_length)

    else if length isnt undefined
      idx    = RCoerce.to_int_native(idx)
      length = RCoerce.to_int_native(length)

      return null if idx > size
      return new R.Array([]) if length is 0

      ary = @slice(idx, length)
      @__delete_range(idx, length)

    else
      idx = RCoerce.to_int_native(idx)
      ary = @delete_at(idx)

    ary

  # @private
  __delete_range: (start, length) ->
    size = @__size__()
    return null if start > size or start < 0

    if size < (start + length)
      new_ary = new R.Array([])
    else
      new_ary = @slice(0, start).concat(@slice(start + length, size) || [])

    @replace(new_ary) unless new_ary.__size__() is @__size__()


  # Sorts self. Comparisons for the sort will be done using the <=> operator
  # or using an optional code block. The block implements a comparison between
  # a and b, returning -1, 0, or +1.
  #
  # @see Enumerable#sort_by
  # @note Suboptimally implemented, by replacing it with Enumerable#sort().to_native()
  #
  sort_bang: (block) ->
    @replace @sort(block)

  # Sorts self in place using a set of keys generated by mapping the values in
  # self through the given block.
  #
  # If no block is given, an enumerator is returned instead.
  #
  sort_by_bang: (block) ->
    return @to_enum('sort_by_bang') unless block?.call?
    @replace @sort_by(block)


  # Assumes that self is an array of arrays and transposes the rows and columns.
  #
  # @example
  #     a = R([[1,2], [3,4], [5,6]])
  #     a.transpose()   # => [[1, 3, 5], [2, 4, 6]]
  #
  transpose: ->
    return new R.Array([]) if @empty()

    out = new R.Array([])
    max = null

    # TODO: dogfood
    @each (ary) ->
      ary = RCoerce.to_ary(ary)
      max ||= ary.size()

      # Catches too-large as well as too-small (for which #fetch would suffice)
      # throw R.IndexError.new("All arrays must be same length") if ary.size != max
      throw R.IndexError.new() unless ary.size().equals(max)

      idx = -1
      len = ary.__size__()
      while ++idx < len
        out.append(new R.Array([])) unless out.at(idx)
        entry = out.at(idx)
        entry.append ary.at(idx)
    out

  # Returns a new array by removing duplicate values in self.
  #
  # @example
  #     a = R([ "a", "a", "b", "b", "c" ])
  #     a.uniq()   # => ["a", "b", "c"]
  #     # Not yet implemented:
  #     c = R([ "a:def", "a:xyz", "b:abc", "b:xyz", "c:jkl" ])
  #     c.uniq (s) -> s[/^\w+/]  #=> [ "a:def", "b:abc", "c:jkl" ]
  #
  # @note Not yet correctly implemented. should use #eql on objects, but uses @include().
  #
  uniq: () ->
    arr = new R.Array([])
    @each (el) ->
      arr.push(el) unless arr.include(el)
    arr


  # Removes duplicate elements from self. Returns null if no changes are made
  # (that is, no duplicates are found).
  #
  # @example
  #     a = R([ "a", "a", "b", "b", "c" ])
  #     a.uniq!   # => ["a", "b", "c"]
  #     b = R([ "a", "b", "c" ])
  #     b.uniq!   # => null
  #     # Not yet implemented:
  #     c = R([ "a:def", "a:xyz", "b:abc", "b:xyz", "c:jkl" ])
  #     c.uniq (s) -> s[/^\w+/]  #=> [ "a:def", "b:abc", "c:jkl" ]
  #
  # @note Not yet correctly implemented. should use #eql on objects, but uses @include().
  #
  uniq_bang: (block) ->
    ary = @uniq()
    if ary.__size__() is @__size__() then null else @replace(ary)


  # Prepends objects to the front of self, moving other elements upwards.
  #
  # @example
  #     a = R([ "b", "c", "d"])
  #     a.unshift("a")   #=> ["a", "b", "c", "d"]
  #     a.unshift(1, 2)  #=> [ 1, 2, "a", "b", "c", "d"]
  #
  unshift: (args...) ->
    @replace(args.concat(@__native__))


  # Set Union—Returns a new array by joining this array with other_ary,
  # removing duplicates.
  #
  #     R([ "a", "b", "c" ]).union [ "c", "d", "a" ]
  #       #=> [ "a", "b", "c", "d" ]
  #
  union: (other) ->
    @plus(other).uniq()


  to_a: ->
    @dup()


  # find a better way for this.
  to_enum: (iter = "each", args...) ->
    new R.Enumerator(this, iter, args)


  to_ary: () -> this


  # Returns an array containing the elements in self corresponding to the
  # given selector(s). The selectors may be either integer indices or ranges.
  # See also Array#select.
  #
  # @example
  #     a = R(['a', 'b', 'c', 'd', 'e', 'f'])
  #     a.values_at(1, 3, 5)
  #     a.values_at(1, 3, 5, 7)
  #     a.values_at(-1, -3, -5, -7)
  #     a.values_at(1..3, 2...5)
  #
  # @todo not working with ranges
  #
  values_at: (args...) ->
    ary = for idx in args
      @at(RCoerce.to_int_native(idx)) || null

    new R.Array(ary)


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  # @alias collect_bang
  map_bang:     @prototype.collect_bang

  # @alias find_index
  index:        @prototype.find_index

  # @alias each
  each_for:     @prototype.each


  # @alias union
  '|':          @prototype.union

  to_s:         @prototype.inspect

  # @alias &
  intersection: @prototype['&']


  deleteAt:     @prototype.delete_at
  deleteIf:     @prototype.delete_if
  dropWhile:    @prototype.drop_while
  eachIndex:    @prototype.each_index
  equalValue:   @prototype.equal_value
  findIndex:    @prototype.find_index
  intersection: @prototype.intersection
  keepIf:       @prototype.keep_if
  reverse_each: @prototype.reverse_each
  sortBy:       @prototype.sort_by
  takeWhile:    @prototype.take_while
  toA:          @prototype.to_a
  toAry:        @prototype.to_ary
  toS:          @prototype.to_s
  tryConvert:   @prototype.try_convert
  valuesAt:     @prototype.values_at

  # ---- Private --------------------------------------------------------------

  __native_array_with__: (size, obj) ->
    ary = nativeArray(RCoerce.to_int_native(size))
    idx = -1
    while ++idx < size
      ary[idx] = obj
    ary


RArray = R.Array = RubyJS.Array
R._arr = _arr



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
    # value = R(value)

    if value.rubyjs?
      for own k, v of @__native__
        return k if value.equals(v)
    else
      for own k, v of @__native__
        return k if v.valueOf() == value

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


  flatten: (recursion = 1) ->
    recursion = RCoerce.to_int_native(recursion)
    @to_a().flatten(recursion)

  sort: (block) ->
    @to_a().sort(block)



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


  valueOf: ->
    @__native__


  # ---- Aliases --------------------------------------------------------------


R.hashify = (obj, default_value) ->
  new R.Hash(obj, default_value)

R.h = R.hashify


# R.Range.new()
#
# @include RubyJS.Enumerable
#
class RubyJS.Range extends RubyJS.Object
  @include R.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  # TODO: .new should BOX here:
  @new: (start, end, exclusive = false) ->
    new R.Range(start, end, exclusive)

  # TODO: do not box here...
  constructor: (start, end, @exclusive = false) ->
    @__start__ = @box(start)
    @__end__   = @box(end)

    unless @__start__.is_fixnum? and @__end__.is_fixnum?
      try
        # ERROR_MSG: bad value for range
        throw R.ArgumentError.new() if @__start__['<=>'](@__end__) is null
      catch err
        throw R.ArgumentError.new()

    @comparison = if @exclusive then '<' else '<='


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_range: -> true


  # @private
  iterator: () ->
    arr = []
    @each (e) -> arr.push(e)
    arr


  # ---- Javascript primitives --------------------------------------------------


  # ---- Instance methods -----------------------------------------------------

  # Returns true only if obj is a Range, has equivalent beginning and end items
  # (by comparing them with ==), and has the same exclude_end? setting as rng.
  #
  #     R.rng(0, 2).equals( R.r(0,2) )            #=> true
  #     R.rng(0, 2).equals( R.Range.new(0,2) )    #=> true
  #     R.rng(0, 2).equals( R.r(0, 2, true)       #=> false # -> (0...2)
  #
  # @param other
  # @alias #equals
  # @return true, false
  #
  '==': (other) ->
    return false unless other instanceof R.Range
    @__end__['=='](other.end()) and @__start__['=='](other.start()) and @exclusive is other.exclude_end()

  # Returns true only if obj is a Range, has equivalent beginning and end items
  # (by comparing them with ==), and has the same exclude_end? setting as rng.
  #
  #     R.rng(0, 2).equals( R.r(0,2) )            #=> true
  #     R.rng(0, 2).equals( R.Range.new(0,2) )    #=> true
  #     R.rng(0, 2).equals( R.r(0, 2, true)       #=> false # -> (0...2)
  #
  # @param other
  # @alias #equals
  # @return true, false
  #
  equals: @prototype['==']

  # Returns the first object in rng
  #
  # @return obj
  #
  begin: (obj) ->
    @__start__

  # Returns true if obj is between beg and end, i.e beg <= obj <= end (or end
  # exclusive when exclude_end? is true).
  #
  #     R.rng("a", "z").cover("c")    #=> true
  #     R.rng("a", "z").cover("5")    #=> false
  #
  # @param other
  #
  cover: (obj) ->
    throw R.ArgumentError.new() if arguments.length != 1
    obj = obj
    return false if obj is null
    @equal_case(obj)

  '===': (other) ->
    other = R(other)
    s = other['<=>'](@__start__)
    e = other['<=>'](@__end__)
    return false if s is null and e is null
    # other was compared to self (other <=> self), so negate results to get
    # behaviour of self <=> other
    s = -s
    e = -e
    s <= 0 && (if @exclusive then e > 0 else e >= 0)


  # Iterates over the elements rng, passing each in turn to the block. You can
  # only iterate if the start object of the range supports the succ method
  # (which means that you can’t iterate over ranges of Float objects).
  #
  # If no block is given, an enumerator is returned instead.
  #
  #     R.rng(10, 15).each (n) ->
  #        console.log n, ' '
  #
  #     # 10 11 12 13 14 15
  #
  # @return [Range, Enumerator]
  #
  # @todo Untested single_block_args
  #
  each: (block) ->
    return @to_enum('each') unless block and block.call?

    throw R.TypeError.new("can't iterate from #{@begin()}") unless @begin().succ?
    iterator = @__start__.dup()

    while iterator[@comparison](@__end__)
      block(iterator)
      iterator = iterator.succ()

    this

  # Returns the object that defines the end of rng.
  #
  #     R.rng(1,10).end()        #=> 10
  #     R.rng(1,10, true).end()  #=> 10
  #
  # @return obj
  #
  end: () ->
    @__end__


  # Returns true if rng excludes its end value.
  # @return [true, false]
  exclude_end: ->
    @exclusive


  # Returns the first object in rng, or the first n elements.
  #
  # @return [obj, Array<obj>]
  # @todo #first(n) not yet implemented
  #
  first: (n) ->
    @begin()

  # Convert this range object to a printable form (using inspect to convert the
  # start and end objects).
  #
  # @return [String]
  #
  inspect: () ->
    sep = if @exclude_end() then "..." else ".."
    "#{@start().inspect()}#{sep}#{@end().inspect()}"


  #     min → obj
  #     min {| a,b | block } → obj
  #
  # Returns the minimum value in rng. The second uses the block to compare
  # values. Returns nil if the first value in range is larger than the last
  # value
  min: (block) ->
    return R.Enumerable.prototype.min.call(this, block) if block?.call?
    b = @begin()
    e = @end()
    return null if e['<'](b) || (@exclusive && e.equals(b))
    return b if b.is_float?
    R.Enumerable.prototype.min.call(this)



  # Returns the maximum value in rng. The second uses the block to compare
  # values. Returns nil if the first value in range is larger than the last
  # value.
  #
  # @return obj
  #
  max: (block) ->
    return R.Enumerable.prototype.max.call(this, block) if block?.call?
    b = @begin()
    e = @end()
    return null if e['<'](b) || (@exclusive && e.equals(b))
    return e if e.is_float? || (e.is_float? && !@exclusive)
    R.Enumerable.prototype.max.call(this)


  start: () ->
    @__start__

  # Iterates over rng, passing each nth element to the block. If the range
  # contains numbers, n is added for each iteration. Otherwise step invokes
  # succ to iterate through range elements. The following code uses class Xs,
  # which is defined in the class-level documentation.
  #
  # If no block is given, an enumerator is returned instead.
  #
  #    R.rng('a', 'f').step(2, (x) -> puts x) # => a c e
  #    R.rng('a', 'f').step(3).to_a()         # => [a, d]
  #
  # @todo fix imprecision when using floats as step_sizes
  #
  # @return [Range, Enumerator] returns self or Enumerator if no block given.
  #
  step: (step_size=1, block) ->
    # return this if block is undefined and step_size.call?
    if arguments.length == 1 && step_size.call?
      block = step_size
      step_size = 1

    unless block && block.call?
      return @to_enum('step', step_size)

    step_size = R(step_size)
    first     = @begin()
    last      = @end()

    if step_size?.is_float? or first.is_float? or last.is_float?
      # TODO: Use Float() equivalent instead
      step_size = step_size.to_f()
      first     = first.to_f()
      last      = last.to_f()
    else
      step_size = RCoerce.to_int_native(step_size)

    if step_size <= 0
      throw R.ArgumentError.new() if step_size < 0 # step can't be negative
      throw R.ArgumentError.new() # step can't be negative or zero

    cnt = first
    cmp = if @exclude_end() then '<' else '<='
    if first.is_float?
      # TODO: add float math error check
      while cnt[cmp](last)
        block(cnt)
        cnt = cnt.plus(step_size)
    else if first.is_fixnum?
      while cnt[cmp](last)
        block(cnt)
        cnt = cnt.plus(step_size)
    else
      # no numeric, typically a string
      cnt = 0
      @each (o) ->
        block(R(o)) if cnt % step_size is 0
        cnt += 1

    this

  to_a: () ->
    throw R.TypeError.new() if @__end__.is_float? && @__start__.is_float?
    R.Enumerable.prototype.to_a.apply(this)


  to_s: @prototype.inspect


  # ---- Private methods ------------------------------------------------------


  # ---- Unsupported methods --------------------------------------------------


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  # @alias #==
  eql:        @prototype['==']

  # @alias #===
  include:    @prototype['===']

  # @alias #end
  last:       @prototype.end

  # @alias #include
  member:     @prototype.include

  excludeEnd: @prototype.exclude_end

# Is a wrapper around Regexp returns that acts like Rubys MatchData.
# This is only partially complete due to missing features in JS Regexp.
#
# @todo MatchData only works properly when calling through Regexp#match.
#    String#scan, #match to be done.
#
class RubyJS.MatchData extends RubyJS.Object

  # ---- Constructors & Typecast ----------------------------------------------

  constructor: (@__native__, opts = {}) ->
    for m, i in @__native__
      this[i] = m

    @__offset__ = opts.offset || 0
    @__source__ = opts.string
    @__regexp__ = opts.regexp

  # ---- RubyJSism ------------------------------------------------------------

  is_match_data: -> true

  # ---- Javascript primitives --------------------------------------------------

  # ---- Instance methods -----------------------------------------------------


  # Equality—Two matchdata are equal if their target strings, patterns, and
  # matched positions are identical.
  #
  # @alias #eql, #equals
  #
  '==': (other) ->
    return false if !other.is_match_data?

    @regexp()['=='](other.regexp()) &&
      @string()['=='](other.string()) &&
      @__offset__ == other.__offset__


  # Returns the offset of the start of the nth element of the match array in
  # the string. n can be a string or symbol to reference a named capture.
  #
  # @example
  #
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.begin(0)       #=> 1
  #     m.begin(2)       #=> 2
  #
  # @example unsupported Ruby syntax
  #
  #     # m = R/(?<foo>.)(.)(?<bar>.)/.match("hoge")
  #     # m.begin(:foo)  #=> 0
  #     # m.begin(:bar)  #=> 2
  #
  begin: (offset) ->
    @__ensure_args_length(1)
    R(@__source__[@__offset__..-1].indexOf(@__native__[offset]) + @__offset__)


  # Returns the array of captures; equivalent to mtch.to_a[1..-1].
  #
  # @example
  #
  #     capt = R(/(.)(.)(\d+)(\d)/).match("THX1138.").captures()
  #     capt[0]    #=> "H"
  #     capt[1]    #=> "X"
  #     capt[2]    #=> "113"
  #     capt[3]    #=> "8"
  #
  # @example Additional examples, edge cases
  #
  #     R(/foo/).match("foo").captures() #=> []
  #
  captures: ->
    R(@__native__[1..-1])


  end: (offset) ->
    @__ensure_args_length(1)
    R(@__source__[@__offset__..-1].indexOf(@__native__[offset]) + @__offset__ + @__native__[offset].length)


  # @see #==
  #
  eql: (other) ->
    @['=='](other)

  # Match Reference—MatchData acts as an array, and may be accessed using the
  # normal array indexing techniques. mtch is equivalent to the special
  # variable $&, and returns the entire matched string. mtch, mtch, and so on
  # return the values of the matched backreferences (portions of the pattern
  # between parentheses).
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m          #=> #<MatchData "HX1138" 1:"H" 2:"X" 3:"113" 4:"8">
  #     m.get(0)       #=> "HX1138"
  #     m.get(1, 2)    #=> ["H", "X"]
  #     # m.get(1..3)    #=> ["H", "X", "113"]
  #     m.get(-3, 2)   #=> ["X", "113"]
  #
  # @example accessing with [] is supported only for single arguments.
  #     m[0]           #=> "HX1138"
  #
  # @example Unsupported Ruby Syntax (named captures)
  #     # m = /(?<foo>a+)b/.match("ccaaab")
  #     # m          #=> #<MatchData "aaab" foo:"aaa">
  #     # m["foo"]   #=> "aaa"
  #     # m[:foo]    #=> "aaa"
  #
  # @example Parameters and return types
  #     mtch[i] → str or nil
  #     mtch[start, length] → array
  #     mtch[range] → array
  #     # mtch[name] → str or nil
  #
  get: (args...) ->
    arr = @to_a()
    arr.get.apply(arr, arguments)

  # Returns a printable version of mtch.
  #
  # @example
  #
  #     puts /.$/.match("foo").inspect()
  #     #=> #<MatchData "o">
  #
  #     puts /(.)(.)(.)/.match("foo").inspect()
  #     #=> #<MatchData "foo" 1:"f" 2:"o" 3:"o">
  #
  #     puts /(.)(.)?(.)/.match("fo").inspect()
  #     #=> #<MatchData "fo" 1:"f" 2:nil 3:"o">
  #
  # @example Unsupported Ruby Syntax
  #
  #     puts /(?<foo>.)(?<bar>.)(?<baz>.)/.match("hoge").inspect()
  #     #=> #<MatchData "hog" foo:"h" bar:"o" baz:"g">
  #
  inspect: ->
    results = R(["\"#{@[0]}\""])
    results.concat @captures().each_with_index().map((w, i) -> "#{i+1}:\"#{w}\"")

    new R.String("#<MatchData #{results.join(" ")}>")


  # Returns the number of elements in the match array.
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.length()   #=> 5
  #     m.size()     #=> 5
  #
  # @alias #size()
  #
  length: ->
    R(@__native__.length)


  # TODO: check types
  offset: (offset) ->
    b = @begin(offset)
    R([b.to_native(), b + @__native__[offset].length])


  post_match: ->
    @__source__[@end(0)..-1]


  pre_match: ->
    @__source__[0...@begin(0)]


  regexp: ->
    R(@__regexp__)


  # @alias #length()
  # @see #length
  size: ->
    @length()


  string: ->
    R(@__source__)


  # Returns the array of matches.
  #
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.to_a()   #=> ["HX1138", "H", "X", "113", "8"]
  #
  # Because to_a is called when expanding *variable, there’s a useful
  # assignment shortcut for extracting matched fields. This is slightly slower
  # than accessing the fields directly (as an intermediate array is
  # generated).
  #
  to_a: ->
    R(@__native__)


  # Returns the entire matched string.
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.to_s()   #=> "HX1138"
  #
  to_s: ->
    R(@__native__[0])


  # values_at([index]*) → array click to toggle source
  # Uses each index to access the matching values, returning an array of the corresponding matches.
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138: The Movie")
  #     m.to_a()                #=> ["HX1138", "H", "X", "113", "8"]
  #     m.values_at(0, 2, -2)   #=> ["HX1138", "X", "113"]
  #
  values_at: (indices...) ->
    arr = @to_a()
    arr.values_at.apply(arr, indices)


  # ---- Unsupported methods --------------------------------------------------

  # @unsupported extracting names is not supported in Javascript
  names: ->
    throw R.NotSupportedError.new()


  # ---- Private methods ------------------------------------------------------


  # ---- Aliases --------------------------------------------------------------

  postMatch: @prototype.post_match
  preMatch:  @prototype.pre_match
  valuesAt:  @prototype.values_at




# make String accessible within R.String
nativeString = root.String

class RubyJS.String extends RubyJS.Object
  @include R.Comparable
  @fromCharCode: (obj) -> nativeString.fromCharCode(obj)

  # ---- Constructors & Typecast ----------------------------------------------

  # @todo make .new subclasseable
  # @todo follow
  @new: (str = '') ->
    new R.String(str)


  constructor: (primitive = "") ->
    unless typeof primitive is 'string'
      primitive = primitive.valueOf()
    @replace(primitive)


  @isString: (obj) ->
    return false unless obj?
    return true  if typeof obj == 'string'
    return false if typeof obj != 'object'
    return true  if obj.is_string?
    _toString_.call(obj) is '[object String]'


  @try_convert: (obj) ->
    return null unless @isString(obj) or obj.to_str?

    if obj.to_str?
      obj = obj.to_str()
      return null if obj is null or obj is undefined
      # TODO: does not cover returning new String()
      # obj = new R.String(obj) if typeof obj is 'string'
      throw R.TypeError.new() unless obj.is_string? #or typeof obj is 'string'
      obj
    else
      @new(obj)


  @string_native: (obj) ->
    return obj if typeof obj is 'string'
    obj = R(obj)
    if obj.to_str?
      obj.to_str().to_native()
    else
      null


  # ---- RubyJSism ------------------------------------------------------------

  is_string: ->
    true


  # ---- Javascript primitives --------------------------------------------------

  to_native: ->
    @__native__


  valueOf:  -> @__native__


  toString: -> @to_native()


  unbox: -> @__native__


  # ---- Instance methods -----------------------------------------------------


  initialize_copy: ->


  clone: ->
    new @constructor(@to_native()+"")


  # Not yet implemented
  '%': (num) ->
    throw R.NotImplementedError.new()


  # Copy—Returns a new String containing integer copies of the receiver.
  #
  # @example
  #     R("Ho! ").multiply(3)   #=> "Ho! Ho! Ho! "
  #
  '*': (num) ->
    num = RCoerce.to_int_native(num)
    new RString(_str.multiply(@__native__, num))


  # Concatenation—Returns a new String containing other_str concatenated to
  # str.
  #
  # @example
  #      R("Hello from ").plus("self")
  #      #=> "Hello from main"
  #
  '+': (other) ->
    other = RCoerce.to_str_native(other)
    new R.String(@to_native() + other) # don't return subclasses


  # Comparison—Returns -1 if other_str is greater than, 0 if other_str is
  # equal to, and +1 if other_str is less than str. If the strings are of
  # different lengths, and the strings are equal when compared up to the
  # shortest length, then the longer string is considered greater than the
  # shorter one. In older versions of Ruby, setting $= allowed case-
  # insensitive comparisons; this is now deprecated in favor of using
  # String#casecmp.
  #
  # <=> is the basis for the methods <, <=, >, >=, and between?, included from
  # <=> module Comparable. The method String#== does not use Comparable#==.
  #
  #     R("abcdef").cmp "abcde"     #=> 1
  #     R("abcdef").cmp "abcdef"    #=> 0
  #     R("abcdef").cmp "abcdefg"   #=> -1
  #     R("abcdef").cmp "ABCDEF"    #=> 1
  #
  # @alias #cmp
  #
  '<=>': (other) ->
    other = R(other)
    return null unless other.to_str?
    return null unless other['<=>']?

    if other.is_string?
      other = other.to_native()
      if @to_native() == other
        0
      else if @to_native() < other
        -1
      else
        1
    else
      - other['<=>'](this)

  # Equality—If obj is not a String, returns false. Otherwise, returns true if
  # str <=> obj returns zero.
  #
  # @alias #equals
  #
  '==': (other) ->
    if other.is_string?
      @to_native() == other.to_native()
    else if String.isString(other)
      @to_native() == other
    else if other.to_str?
      other['=='] @to_native()
    else
      false

  # Append—Concatenates the given object to str. If the object is a Integer, it
  # is considered as a codepoint, and is converted to a character before
  # concatenation.
  #
  # @example
  #     a = R("hello ")
  #     a.concat "world"   #=> "hello world"
  #     a.concat(33)       #=> "hello world!"
  #
  # @alias #append, #concat
  #
  '<<': (other) ->
    other = @box(other)
    if other.is_integer?
      throw new Error("RangeError") if other.lt(0)
      other = other.chr()
    throw R.TypeError.new() unless other?.to_str?

    @replace (@to_native() + other.to_str().to_native())


  # Match—If obj is a Regexp, use it as a pattern to match against str,and
  # returns the position the match starts, or nil if there is no match.
  # Otherwise, invokes obj.=~, passing str as an argument. The default =~ in
  # Object returns nil.
  #
  # @example
  #      R("cat o' 9 tails")['=~'] %r\d/   #=> 7
  #      R("cat o' 9 tails")['=~'] 9      #=> nil
  #
  # TODO: find alias
  #
  '=~': (pattern, offset, block) ->
    throw R.TypeError.new() if R(pattern).is_string?
    @match(pattern, offset, block)


  #[]
  #[]=
  #ascii_only?
  #bytes
  #bytesize
  #byteslice


  # Returns a copy of str with the first character converted to uppercase and
  # the remainder to lowercase. Note: case conversion is effective only in
  # ASCII region.
  #
  # @example
  #     R("hello").capitalize()    # => "Hello"
  #     R("HELLO").capitalize()    # => "Hello"
  #     R("äöü").capitalize()      # => "äöü"
  #     R("123ABC").capitalize()   # => "123abc"
  #
  # @note Differs from JS toUpperCase in that it does not uppercase special
  #   characters ä, ö, etc
  #
  capitalize:  ->
    new RString(_str.capitalize(@__native__))


  # Modifies str by converting the first character to uppercase and the
  # remainder to lowercase. Returns nil if no changes are made. Note: case
  # conversion is effective only in ASCII region.
  #
  # @example
  #    str = R('hello')
  #    str.capitalize_bang()         # => "Hello"
  #    str                           # => "Hello"
  #
  # @example Already capitalized
  #    str = R("Already capitals")
  #    str.capitalize_bang()         # => null
  #    str                           # => "Already capitals"
  #
  capitalize_bang: ->
    str = _str.capitalize(@__native__)
    if @__native__ is str then null else @replace(str)


  # Case-insensitive version of String#<=>.
  #
  # @example
  #     R("abcdef").casecmp("abcde")     #=> 1
  #     R("aBcDeF").casecmp("abcdef")    #=> 0
  #     R("abcdef").casecmp("abcdefg")   #=> -1
  #     R("abcdef").casecmp("ABCDEF")    #=> 0
  #
  casecmp: (other) ->
    other = R(other).to_str?()
    throw R.TypeError.new() unless other

    @downcase().cmp(other.downcase())


  # If integer is greater than the length of str, returns a new String of
  # length integer with str centered and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #     R("hello").center(4)         # => "hello"
  #     R("hello").center(20)        # => "       hello        "
  #     R("hello").center(20, '123') # => "1231231hello12312312"
  #
  center: (length, padString = ' ') ->
    # TODO: dogfood
    length    = RCoerce.to_int_native(length)
    padString = RCoerce.to_str_native(padString)

    new RString(_str.center(@__native__, length, padString))

  # Passes each character in str to the given block, or returns an enumerator if
  # no block is given.
  #
  # @example
  #     R("hello").each_char (c) -> R.puts(c + ' ')
  #     # out: h e l l o
  #
  # @note Does *not* typecast chars to R.Strings.
  #
  chars: (block) ->
    return @to_enum('chars') unless block && block.call?
    _str.chars(@__native__, block)
    this


  # Returns a new String with the given record separator removed from the end
  # of str (if present). If $/ has not been changed from the default Ruby
  # record separator, then chomp also removes carriage return characters (that
  # is it will remove \n, \r, and \r\n).
  #
  # @example
  #     R("hello").chomp()            # => "hello"
  #     R("hello\n").chomp()          # => "hello"
  #     R("hello\r\n").chomp()        # => "hello"
  #     R("hello\n\r").chomp()        # => "hello\n"
  #     R("hello\r").chomp()          # => "hello"
  #     R("hello \n there").chomp()   # => "hello \n there"
  #     R("hello").chomp("llo")       # => "he"
  #
  chomp: (sep = null) ->
    if sep is null
      this
    else
      new RString(_str.chomp(@__native__, sep))


  # Modifies str in place as described for String#chomp, returning str, or nil if no modifications were made.  #
  #
  # @todo finish specs
  #
  chomp_bang: (sep = null) ->
    if str = _str.chomp(@__native__, sep)
      @replace(str)
    else
      null


  # Returns a new String with the last character removed. If the string ends
  # with \r\n, both characters are removed. Applying chop to an empty string
  # returns an empty string. String#chomp is often a safer alternative, as it
  # leaves the string unchanged if it doesn’t end in a record separator.
  #
  # @example
  #     R("string\r\n").chop()   # => "string"
  #     R("string\n\r").chop()   # => "string\n"
  #     R("string\n").chop()     # => "string"
  #     R("string").chop()       # => "strin"
  #     R("x").chop().chop()     # => ""
  #
  chop: ->
    new RString(_str.chop(@__native__))


  # TODO: chop_bang

  # Returns a one-character string at the beginning of the string.
  #
  # @example
  #     a = R("hello")
  #     a.chr()                  # => 'h'
  #
  chr: ->
    new RString(@__native__[0] || '')


  # Makes string empty.
  #
  # @example
  #     a = "abcde"
  #     a.clear()    #=> ""
  #
  clear: () ->
    @replace("")


  #codepoints

  # Each other_str parameter defines a set of characters to count. The
  # intersection of these sets defines the characters to count in str. Any
  # other_str that starts with a caret (^) is negated. The sequence c1–c2 means
  # all characters between c1 and c2.
  #
  # @example
  #     a = R("hello world")
  #     a.count "lo"            #=> 5
  #     a.count "lo", "o"       #=> 2
  #     a.count "hello", "^l"   #=> 4
  #     a.count "ej-m"          #=> 4
  #
  # @todo expect( s.count("A-a")).toEqual s.count("A-Z[\\]^_`a")
  #
  count: ->
    args = [@__native__]
    for el, i in arguments
      args.push(RCoerce.to_str_native(el))
    new R.Fixnum(_str.count.apply(_str, args))


  #crypt

  # Returns a copy of str with all characters in the intersection of its
  # arguments deleted. Uses the same rules for building the set of characters as
  # String#count.
  #
  # @example
  #     R("hello").delete "l","lo"        #=> "heo"
  #     R("hello").delete "lo"            #=> "he"
  #     R("hello").delete "aeiou", "^e"   #=> "hell"
  #     R("hello").delete "ej-m"          #=> "ho"
  #
  # @todo expect( R("ABCabc[]").delete("A-a") ).toEqual R("bc")
  #
  delete: ->
    args = arguments
    @dup().tap (s) -> s.delete_bang.apply(s, args)


  # Performs a delete operation in place, returning str, or nil if str was not
  # modified.
  #
  delete_bang: ->
    args = [@__native__]
    for el, i in arguments
      args[i + 1] = RCoerce.to_str_native(el)

    str = _str.delete.apply(null, args)
    if @__native__ is str then null else @replace(str)


  # Returns a copy of str with all uppercase letters replaced with their
  # lowercase counterparts. The operation is locale insensitive—only characters
  # “A” to “Z” are affected. Note: case replacement is effective only in ASCII
  # region.
  #
  # @example
  #     R("hEllO").downcase()   #=> "hello"
  #
  downcase: () ->
    new RString(_str.downcase(@__native__))

  # Downcases the contents of str, returning nil if no changes were made.
  #
  # @note case replacement is effective only in ASCII region.
  #
  downcase_bang: () ->
    return null unless @__native__.match(/[A-Z]/)
    @replace(_str.downcase(@__native__))


  # Produces a version of str with all nonprinting characters replaced by \nnn
  # notation and all special characters escaped.
  #
  dump: ->
    escaped =  @to_native().replace(/[\f]/g, '\\f')
      .replace(/["]/g, "\\\"")
      .replace(/[\n]/g, '\\n')
      .replace(/[\r]/g, '\\r')
      .replace(/[\t]/g, '\\t')
      # .replace(/[\s]/g, '\\ ') # do not
    R("\"#{escaped}\"")


  dup: ->
    dup = @clone()
    dup.initialize_copy(this)
    dup



  #each_byte

  # @alias #chars
  each_char: @prototype.chars


  #each_codepoint

  # Splits str using the supplied parameter as the record separator ($/ by
  # default), passing each substring in turn to the supplied block. If a zero-
  # length record separator is supplied, the string is split into paragraphs
  # delimited by multiple successive newlines.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #    print "Example one\n"
  #    "hello\nworld".each_line {|s| p s}
  #    print "Example two\n"
  #    "hello\nworld".each_line('l') {|s| p s}
  #    print "Example three\n"
  #    "hello\n\n\nworld".each_line('') {|s| p s}
  #    # produces:
  #    # Example one
  #    # "hello\n"
  #    # "world"
  #    # Example two
  #    # "hel"
  #    # "l"
  #    # "o\nworl"
  #    # "d"
  #    # Example three
  #    # "hello\n\n\n"
  #    # "world"
  #
  each_line: (args...) ->
    block = @__extract_block(args)

    return @to_enum('lines', args[0]) unless block && block.call?

    if args[0] is null
      block(this)
      return

    separator = R(if args[0] is undefined then R['$/'] else args[0])
    # TODO: Use RCoerce?
    throw R.TypeError.new() unless separator.to_str?
    separator = separator.to_str()
    separator = "\n\n" if separator.length is 0 # '' goes into "paragraph" mode

    # TODO: simplify dogfood
    lft = 0
    rgt = null
    dup = @dup() # allows the string to be changed with bang methods
    while rgt = dup.index(separator, lft)
      rgt = rgt.succ()
      str = dup.slice(lft, rgt.minus(lft))
      lft = rgt
      block(str)

    if remainder = R(dup.to_native().slice(lft.to_native()))
      block(remainder) unless remainder.empty()

    this

  # Returns true if str has a length of zero.
  #
  # @example
  #     "hello".empty()   #=> false
  #     "".empty()        #=> true
  #     " ".empty()       #=> true
  #
  empty: ->
    _str.empty(@__native__)


  #encode


  #encoding

  # Returns true if str ends with one of the suffixes given.
  #
  end_with: ->
    needles = _arr.select(arguments, (s) -> R(s)?.to_str? )
    neeldes = _arr.map(needles, _fn(RCoerce.to_str_native) )

    _str.end_with(@__native__, needles...)


  # Two strings are equal if they have the same length and content.
  #
  # @example
  #
  #     R("foo").eql('foo')      # => true
  #     R("foo").eql('FOO')      # => false
  #     R("foo").eql(R('foo'))   # => true
  #
  # @return true/false
  #
  eql: (other) ->
    @['<=>'](other) is 0


  #equal?


  #force_encoding


  get: ->
    @slice.apply(this, arguments)


  # @todo idx with count. set(0, 2, "a"), aka [0,2] = 'a'
  # @todo idx as Regexp
  set: (idx, other) ->
    idx   = R(idx)
    other = RCoerce.to_str(other)
    index = null

    if idx.to_int?
      index = idx.to_int().to_native()
      index += @length if index < 0 # On negative count

      if index < 0 or index > @length
        throw R.IndexError.new() # raise IndexError, "index #{index} out of string"

    else if idx.to_str?
      index = @index(idx)
      unless index
        throw R.IndexError.new() # "string not matched"

    chrs = @to_native().split("")
    chrs[index] = other

    @replace(chrs.join(''))

    return other


  #getbyte


  # Returns a copy of str with the all occurrences of pattern substituted for
  # the second argument. The pattern is typically a Regexp; if given as a
  # String, any regular expression metacharacters it contains will be
  # interpreted literally, e.g. '\\d' will match a backlash followed by ‘d’,
  # instead of a digit.
  #
  # If replacement is a String it will be substituted for the matched text. It
  # may contain back-references to the pattern’s capture groups of the form
  # \\d, where d is a group number, or \\k<n>, where n is a group name. If it
  # is a double-quoted string, both back-references must be preceded by an
  # additional backslash. However, within replacement the special match
  # variables, such as &$, will not refer to the current match.
  #
  # If the second argument is a Hash, and the matched text is one of its keys,
  # the corresponding value is the replacement string.
  #
  # In the block form, the current match string is passed in as a parameter,
  # and variables such as $1, $2, $`, $&, and $' will be set appropriately.
  # The value returned by the block will be substituted for the match on each
  # call.
  #
  # The result inherits any tainting in the original string or any supplied
  # replacement string.
  #
  # When neither a block nor a second argument is supplied, an Enumerator is
  # returned.
  #
  # @example
  #     R("hello").gsub(%r[aeiou]/, '*')                  #=> "h*ll*"
  #     R("hello").gsub(%r([aeiou])/, '<\1>')             #=> "h<e>ll<o>"
  #     R("hello").gsub(%r./) {|s| s.ord.to_s + ' '}      #=> "104 101 108 108 111 "
  #     # R("hello").gsub(%r(?<foo>[aeiou])/, '{\k<foo>}')  #=> "h{e}ll{o}"
  #     R('hello').gsub(%r[eo]/, 'e' => 3, 'o' => '*')    #=> "h3ll*"
  #
  # TODO: add hash syntax, properly document supported features
  #
  gsub: (pattern, replacement) ->
    throw R.TypeError.new() if pattern is null
    replacement = RCoerce.to_str_native(replacement)

    gsubbed = _str.gsub(@__native__, pattern, replacement)
    new RString(gsubbed)


  #hash


  #hex

  # Returns true if str contains the given string or character.
  #
  # @example
  #     R("hello").include "lo"   #=> true
  #     R("hello").include "ol"   #=> false
  #     R("hello").include hh     #=> true
  #
  include: (other) ->
    other = RCoerce.to_str_native(other)
    _str.include(@__native__, other)


  # Returns the index of the first occurrence of the given substring or pattern
  # (regexp) in str. Returns nil if not found. If the second parameter is
  # present, it specifies the position in the string to begin the search.
  #
  # @example
  #     R("hello").index('e')             #=> 1
  #     R("hello").index('lo')            #=> 3
  #     R("hello").index('a')             #=> nil
  #     R("hello").index(ee)              #=> 1
  #     R("hello").index(/[aeiou]/, -3)   #=> 4
  #
  # @todo #index(regexp)
  #
  index: (needle, offset) ->
    needle = RCoerce.to_str_native(needle)
    offset = RCoerce.to_int_native(offset) if offset?
    val = _str.index(@__native__, needle, offset)
    if val is null then null else new R.Fixnum(val)


  #initialize_copy


  # Inserts other_str before the character at the given index, modifying str.
  # Negative indices count from the end of the string, and insert after the
  # given character. The intent is insert aString so that it starts at the
  # given index.
  #
  # @example
  #     R("abcd").insert(0, 'X')    # => "Xabcd"
  #     R("abcd").insert(3, 'X')    # => "abcXd"
  #     R("abcd").insert(4, 'X')    # => "abcdX"
  #
  # @example inserts after with negative counts
  #     R("abcd").insert(-3, 'X')   # => "abXcd"
  #     R("abcd").insert(-1, 'X')   # => "abcdX"
  #
  insert: (idx, other) ->
    idx   = RCoerce.to_int_native(idx)
    other = RCoerce.to_str_native(other)

    @replace(_str.insert(@__native__, idx, other))


  # Returns a printable version of str, surrounded by quote marks, with
  # special characters escaped.
  #
  # @example
  #     str = "hello"
  #     str[3] = "\b"
  #     str.inspect       #=> "\"hel\\bo\""
  #
  # @todo For now just an alias to dump
  #
  inspect: -> @dump()


  # @alias #each_line
  lines: @prototype.each_line


  # If integer is greater than the length of str, returns a new String of
  # length integer with str left justified and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #     R("hello").ljust(4)            #=> "hello"
  #     R("hello").ljust(20)           #=> "hello               "
  #     R("hello").ljust(20, '1234')   #=> "hello123412341234123"
  #
  ljust: (width, padString = " ") ->
    width     = RCoerce.to_int_native(width)
    padString = RCoerce.to_str_native(padString)
    new RString(_str.ljust(@__native__, width, padString))


  # Returns a copy of str with leading whitespace removed. See also
  # String#rstrip and String#strip.
  #
  # @example
  #     R("  hello  ").lstrip()   #=> "hello  "
  #     R("hello").lstrip()       #=> "hello"
  #
  lstrip: () ->
    new RString(_str.lstrip(@__native__))


  # Removes leading whitespace from str, returning nil if no change was made.
  # See also String#rstrip! and String#strip!.
  #
  # @example
  #     R("  hello  ").lstrip_bang()  #=> "hello  "
  #     R("hello").lstrip_bang()      #=> nil
  #
  lstrip_bang: ->
    return null unless @to_native().match(/^[\s\n\t]+/)
    @replace(_str.lstrip(@__native__))


  # Converts pattern to a Regexp (if it isn’t already one), then invokes its
  # match method on str. If the second parameter is present, it specifies the
  # position in the string to begin the search.
  #
  # If a block is given, invoke the block with MatchData if match succeed, so
  # that you can write
  #
  # @example
  #     R('hello').match('(.)\1')      #=> #<MatchData "ll" 1:"l">
  #     R('hello').match('(.)\1')[0]   #=> "ll"
  #     R('hello').match(/(.)\1/)[0]   #=> "ll"
  #     R('hello').match('xx')         #=> nil
  #
  # @example with block:
  #     str.match(pat) {|m| ...}
  #     # instead of:
  #     if m = str.match(pat)
  #       ...
  #     end
  #
  # The return value is a value from block execution in this case.
  #
  match: (pattern, offset, block) ->
    _str.match(@__native__, pattern, offset, block)


  # Searches sep or pattern (regexp) in the string and returns the part before
  # it, the match, and the part after it. If it is not found, returns two
  # empty strings and str.
  #
  # @example
  #     R("hello").partition("l")         # => ["he", "l", "lo"]
  #     R("hello").partition("x")         # => ["hello", "", ""]
  #     R("hello").partition(/.l/)        # => ["h", "el", "lo"]
  #
  # @example headers
  #     partition(sep) -> [head, sep, tail]
  #     partition(regexp) -> [head, match, tail]
  #
  # @todo does not yet accept regexp as pattern
  # @todo does not yet affect R['$~']
  #
  partition: (pattern) ->
    # TODO: regexps
    pattern = RCoerce.to_str_native(pattern)
    new RArray(_str.partition(@__native__, pattern))


  # Prepend the given string to str.
  #
  # @example
  #     a = R(“world” )
  #     a.prepend(“hello ”) #=> “hello world”
  #     a #=> “hello world”
  #
  prepend: (other) ->
    other = RCoerce.to_str_native(other)
    @replace(other + @__native__)


  # Replaces the contents and taintedness of str with the corresponding values
  # in other_str.
  #
  # @todo Does not copy taintedness
  #
  # @example
  #
  #     s = R("hello")            #=> "hello"
  #     s.replace "world"         #=> "world"
  #     s.replace R("world")      #=> "world"
  #
  replace: (val) ->
    unless typeof val is 'string'
      val = R(val)
      throw R.TypeError.new() unless val.to_str?
      val = val.to_str().valueOf()

    @__native__ = val
    @length     = val.length
    this


  # Returns a new string with the characters from str in reverse order.
  #
  # @example
  #     R("stressed").reverse()   #=> "desserts"
  #
  reverse: ->
    new RString(_str.reverse(@__native__))


  # Reverses str in place.
  reverse_bang: ->
    @replace(_str.reverse(@__native__))

  # Returns the index of the last occurrence of the given substring or pattern
  # (regexp) in str. Returns nil if not found. If the second parameter is
  # present, it specifies the position in the string to end the
  # search—characters beyond this point will not be considered.
  #
  # @example
  #     R("hello").rindex('e')             #=> 1
  #     R("hello").rindex('l')             #=> 3
  #     R("hello").rindex('a')             #=> nil
  #     R("hello").rindex(ee)              #=> 1
  #     R("hello").rindex(/[aeiou]/, -2)   #=> 1
  #
  # @todo #rindex(/.../) does not add matches to R['$~'] as it should
  # @todo #rindex(needle, offset) does not use respond_to?(:to_int) for offset
  #       to convert it to_int.
  #
  rindex: (needle, offset) ->
    throw R.TypeError.new('TypeError') if offset is null

    needle = R(needle)

    # TODO: extract to coerce_to(:to_str, :regexp, ...) function
    if needle.to_str?          then needle = needle.to_str()
    else if needle.is_regexp?  then needle = needle #.to_regexp()
    else                       throw R.TypeError.new('TypeError')

    # FIXME:
    offset = R(offset)?.to_int().valueOf()
    needle = needle.valueOf()

    val = _str.rindex(@__native__, needle, offset)
    if val is null then null else new R.Fixnum(val)


  # If integer is greater than the length of str, returns a new String of
  # length integer with str right justified and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #     R("hello").rjust(4)            #=> "hello"
  #     R("hello").rjust(20)           #=> "               hello"
  #     R("hello").rjust(20, '1234')   #=> "123412341234123hello"
  #
  rjust: (width, padString = " ") ->
    width     = RCoerce.to_int_native(width)
    padString = RCoerce.to_str_native(padString)
    new RString(_str.rjust(@__native__, width, padString))


  # Searches sep or pattern (regexp) in the string from the end of the string,
  # and returns the part before it, the match, and the part after it. If it is
  # not found, returns two empty strings and str.
  #
  # @example
  #     R("hello").rpartition("l")         #=> ["hel", "l", "o"]
  #     R("hello").rpartition("x")         #=> ["", "", "hello"]
  #
  # @example edge cases
  #     R("hello").rpartition("x")         #=> ["", "", "hello"]
  #     R("hello").rpartition("hello")     #=> ["", "hello", ""]
  #
  # @example todo:
  #     R("hello").rpartition(/.l/)        #=> ["he", "ll", "o"]
  #
  # @todo does not yet accept regexp as pattern
  # @todo does not yet affect R['$~']
  rpartition: (pattern) ->
    # TODO: regexps
    pattern = RCoerce.to_str(pattern).to_str()

    if idx = @rindex(pattern)
      start = idx + pattern.length
      len = @size() -  start
      a = @slice(0,idx)
      b = pattern.dup()
      c = R(@to_native().slice(start))

    a ||= R("")
    b ||= R("")
    c ||= this

    return R([a,b,c])


  # Returns a copy of str with trailing whitespace removed. See also
  # String#lstrip and String#strip.
  #
  # @example
  #     R("  hello  ").rstrip()   #=> "  hello"
  #     R("hello").rstrip()       #=> "hello"
  #
  rstrip: () ->
    @dup().tap (s) -> s.rstrip_bang()


  # Removes trailing whitespace from str, returning nil if no change was made.
  # See also String#lstrip! and String#strip!.
  #
  # @example
  #     R("  hello  ").rstrip_bang()  #=> "  hello"
  #     R("hello").rstrip_bang()      #=> nil
  #
  rstrip_bang: ->
    return null unless @__native__.match(/[\s\n\t]+$/)
    @replace(_str.rstrip(@__native__))


  # Both forms iterate through str, matching the pattern (which may be a
  # Regexp or a String). For each match, a result is generated and either
  # added to the result array or passed to the block. If the pattern contains
  # no groups, each individual result consists of the matched string, $&. If
  # the pattern contains groups, each individual result is itself an array
  # containing one entry per group.
  #
  # @example
  #     a = R("cruel world")
  #     a.scan(/\w+/)        #=> ["cruel", "world"]
  #     a.scan(/.../)        #=> ["cru", "el ", "wor"]
  #     a.scan(/(...)/)      #=> [["cru"], ["el "], ["wor"]]
  #     a.scan(/(..)(..)/)   #=> [["cr", "ue"], ["l ", "wo"]]
  #     #And the block form:
  #     a.scan(/\w+/, (w) -> R.puts "<<#{w}>> ")
  #     print "\n"
  #     a.scan(/(.)(.)/, (x,y) -> R.puts y, x )
  #     print "\n"
  #     # produces:
  #     # <<cruel>> <<world>>
  #     # rceu lowlr
  #
  # @todo some untested specs
  #
  scan: (pattern, block = null) ->
    unless R.Regexp.isRegexp(pattern)
      pattern = RCoerce.to_str_native(pattern)
      pattern = R.Regexp.quote(pattern)

    index = 0

    R['$~'] = null
    match_arr = if block != null then this else []

    # FIXME: different from rubinius implementation
    while match = @__native__[index..-1].match(pattern)
      fin  = index + match.index + match[0].length
      fin += 1 if match[0].length == 0

      R['$~'] = new R.MatchData(match, {offset: index, string: @__native__})

      if match.length > 1
        val = new R.Array(new R.String(m) for m in match[1...match.length])
      else
        val = new R.Array([new R.String(match[0])])

      if block != null
        block(val)
      else
        val = val.first() if match.length == 1
        match_arr.push val

      index = fin
      break if index > this.length

    # return this if block was passed
    if block != null then this else (new R.Array(match_arr))

  #setbyte

  size: ->
    @$Integer(@to_native().length)


  # Element Reference—If passed a single Fixnum, returns a substring of one
  # character at that position. If passed two Fixnum objects, returns a
  # substring starting at the offset given by the first, and with a length
  # given by the second. If passed a range, its beginning and end are
  # interpreted as offsets delimiting the substring to be returned. In all
  # three cases, if an offset is negative, it is counted from the end of str.
  # Returns nil if the initial offset falls outside the string or the length
  # is negative.
  #
  # If a Regexp is supplied, the matching portion of str is returned. If a
  # numeric or name parameter follows the regular expression, that component
  # of the MatchData is returned instead. If a String is given, that string is
  # returned if it occurs in str. In both cases, nil is returned if there is
  # no match.
  #
  # @example
  #     a = R("hello there")
  #     a.slice(1)                      #=> "e"
  #     a.slice(2, 3)                   #=> "llo"
  #     a.slice(R.rng(2, 3))            #=> "ll"
  #     a.slice(-3, 2)                  #=> "er"
  #     a.slice(R.rng(7, -2))           #=> "her"
  #     a.slice(R.rng(-4, -2))          #=> "her"
  #     a.slice(R.rng(-2, -4))          #=> ""
  #     a.slice(R.rng(12, -1))          #=> null
  #     a.slice(/[aeiou](.)\11//)       #=> "ell"
  #     a.slice(/[aeiou](.)\11//, 0)    #=> "ell"
  #     a.slice(/[aeiou](.)\11//, 1)    #=> "l"
  #     a.slice(/[aeiou](.)\11//, 2)    #=> null
  #     a.slice("lo")                   #=> "lo"
  #     a.slice("bye")                  #=> null
  #
  # @todo Implement support for ranges slice(R.Range.new(...))
  # @todo regexp
  #
  slice: (index, other) ->
    throw R.TypeError.new() if index is null

    index = R(index)
    unless other is undefined
      if index.is_regexp?
        throw R.NotImplementedError.new()
      else
        index = RCoerce.to_int_native(index)
        other = RCoerce.to_int_native(other)
        val   = _str.slice(@__native__, index, other)
        return if val? then new RString(val) else null


    if index.is_regexp?
      throw R.NotImplementedError.new()
    else if index.is_string?
      index = RCoerce.to_str_native(index)
    else if index.is_range?
      # nothing
    else
      index = RCoerce.to_int_native(index)

    val   = _str.slice(@__native__, index)
    if val? then new RString(val) else null





  # Divides str into substrings based on a delimiter, returning an array of
  # these substrings.
  #
  # If pattern is a String, then its contents are used as the delimiter when
  # splitting str. If pattern is a single space, str is split on whitespace,
  # with leading whitespace and runs of contiguous whitespace characters
  # ignored.
  #
  # If pattern is a Regexp, str is divided where the pattern matches. Whenever
  # the pattern matches a zero-length string, str is split into individual
  # characters. If pattern contains groups, the respective matches will be
  # returned in the array as well.
  #
  # If pattern is omitted, the value of $; is used. If $; is nil (which is the
  # default), str is split on whitespace as if ` ‘ were specified.
  #
  # If the limit parameter is omitted, trailing null fields are suppressed. If
  # limit is a positive number, at most that number of fields will be returned
  # (if limit is 1, the entire string is returned as the only entry in an
  # array). If negative, there is no limit to the number of fields returned,
  # and trailing null fields are not suppressed.
  #
  # @example
  #     R(" now's  the time").split()      #=> ["now's", "the", "time"]
  #     R(" now's  the time").split(' ')   #=> ["now's", "the", "time"]
  #     R(" now's  the time").split(/ /)   #=> ["", "now's", "", "the", "time"]
  #     R("1, 2.34,56, 7").split(%r{,\s*}) #=> ["1", "2.34", "56", "7"]
  #     R("hello").split(//)               #=> ["h", "e", "l", "l", "o"]
  #     # R("hello").split(//, 3)            #=> ["h", "e", "llo"]
  #     R("hi mom").split(%r{\s*})         #=> ["h", "i", "m", "o", "m"]
  #
  #     R("mellow yellow").split("ello")   #=> ["m", "w y", "w"]
  #     R("1,2,,3,4,,").split(',')         #=> ["1", "2", "", "3", "4"]
  #     # R("1,2,,3,4,,").split(',', 4)      #=> ["1", "2", "", "3,4,,"]
  #     # R("1,2,,3,4,,").split(',', -4)     #=> ["1", "2", "", "3", "4", "", ""]
  #
  # split(pattern=$;, [limit]) → anArray
  #
  # @todo limit is not yet supported
  #
  split: (pattern = " ", limit) ->
    unless R.Regexp.isRegexp(pattern)
      pattern = RCoerce.to_str_native(pattern)

    new RArray(_str.split(@__native__, pattern, limit))


  # @todo Not yet implemented
  squeeze_bang: ->
    throw new R.NotImplementedError()


  # Builds a set of characters from the other_str parameter(s) using the
  # procedure described for String#count. Returns a new string where runs of
  # the same character that occur in this set are replaced by a single
  # character. If no arguments are given, all runs of identical characters are
  # replaced by a single character.
  #
  # @example
  #     R("yellow moon").squeeze()                #=> "yelow mon"
  #     R("  now   is  the").squeeze(" ")         #=> " now is the"
  #     R("putters shoot balls").squeeze("m-z")   #=> "puters shot balls"
  #
  # @todo Fix A-a bug
  #
  squeeze: ->
    args = [@__native__]
    for el, i in arguments
      args.push(RCoerce.to_str_native(el))
    new RString(_str.squeeze.apply(_str, args))


  # Returns true if str starts with one of the prefixes given.
  #
  # @example
  #     R("hello").start_with("hell")               #=> true
  #     # returns true if one of the prefixes matches.
  #     R("hello").start_with("heaven", "hell")     #=> true
  #     R("hello").start_with("heaven", "paradise") #=> false
  #
  start_with: (needles...) ->
    needles = _arr.select(needles, (s) -> R(s)?.to_str? )
    neeldes = _arr.map(needles, _fn(RCoerce.to_str_native) )

    _str.start_with(@__native__, needles...)


  # Returns a copy of str with leading and trailing whitespace removed.
  #
  # @example
  #     R("    hello    ").strip()   #=> "hello"
  #     R("\tgoodbye\r\n").strip()   #=> "goodbye"
  #
  strip: () ->
    @dup().tap (s) -> s.strip_bang()


  # Removes leading and trailing whitespace from str. Returns nil if str was
  # not altered.
  #
  # @return str or null
  #
  strip_bang: () ->
    str = _str.strip(@__native__)
    if str == @__native__
      null
    else
      @replace str


  # Returns a copy of str with the first occurrence of pattern substituted for
  # the second argument. The pattern is typically a Regexp; if given as a
  # String, any regular expression metacharacters it contains will be
  # interpreted literally, e.g. '\\d' will match a backlash followed by ‘d’,
  # instead of a digit.
  #
  # If replacement is a String it will be substituted for the matched text. It
  # may contain back-references to the pattern’s capture groups of the form
  # \\d, where d is a group number, or \\k<n>, where n is a group name. If it
  # is a double-quoted string, both back-references must be preceded by an
  # additional backslash. However, within replacement the special match
  # variables, such as &$, will not refer to the current match.
  #
  # If the second argument is a Hash, and the matched text is one of its keys,
  # the corresponding value is the replacement string.
  #
  # In the block form, the current match string is passed in as a parameter,
  # and variables such as $1, $2, $`, $&, and $' will be set appropriately.
  # The value returned by the block will be substituted for the match on each
  # call.
  #
  # The result inherits any tainting in the original string or any supplied
  # replacement string.
  #
  # @example
  #     R("hello").sub(/[aeiou]/, '*')                  #=> "h*llo"
  #     R("hello").sub(/([aeiou])/, '<\1>')             #=> "h<e>llo"
  #     R("hello").sub(/./, (s) -> s.ord.to_s() + ' ' ) #=> "104 ello"
  #     # R("hello").sub(/(?<foo>[aeiou])/, '*\k<foo>*')  #=> "h*e*llo"
  #
  # @todo #sub does not yet add matches to R['$~'] as it should
  # @todo String#sub with pattern and block
  sub: (pattern, replacement) ->
    @dup().tap (dup) -> dup.sub_bang(pattern, replacement)


  # Performs the substitutions of String#sub in place, returning str, or nil
  # if no substitutions were performed.
  #
  sub_bang: (pattern, replacement) ->
    throw R.TypeError.new() if pattern is null
    replacement = RCoerce.to_str_native(replacement)
    @replace(_str.sub(@__native__, pattern, replacement))


  # Returns the successor to str. The successor is calculated by incrementing
  # characters starting from the rightmost alphanumeric (or the rightmost
  # character if there are no alphanumerics) in the string. Incrementing a
  # digit always results in another digit, and incrementing a letter results
  # in another letter of the same case. Incrementing nonalphanumerics uses the
  # underlying character set’s collating sequence.
  #
  # If the increment generates a “carry,” the character to the left of it is
  # incremented. This process repeats until there is no carry, adding an
  # additional character if necessary.
  #
  # @example
  #     R("abcd").succ()        #=> "abce"
  #     R("THX1138").succ()     #=> "THX1139"
  #     R("<<koala>>").succ()   #=> "<<koalb>>"
  #     R("1999zzz").succ()     #=> "2000aaa"
  #     R("ZZZ9999").succ()     #=> "AAAA0000"
  #     R("***").succ()         #=> "**+"
  #
  # @alias #next
  #
  succ: ->
    new RString(_str.succ(@__native__))


  # Equivalent to String#succ, but modifies the receiver in place.
  #
  # @alias #next_bang
  #
  succ_bang: ->
    str = _str.succ(@__native__)
    @replace(str)


  # @alias #succ
  next:      @prototype.succ

  # @alias #succ_bang
  next_bang: @prototype.succ_bang


  #sum

  # Returns a copy of str with uppercase alphabetic characters converted to
  # lowercase and lowercase characters converted to uppercase. Note: case
  # conversion is effective only in ASCII region.
  #
  # @example
  #     R("Hello").swapcase()          #=> "hELLO"
  #     R("cYbEr_PuNk11").swapcase()   #=> "CyBeR_pUnK11"
  #
  swapcase: () ->
    @dup().tap (s) -> s.swapcase_bang()


  # Equivalent to String#swapcase, but modifies the receiver in place,
  # returning str, or nil if no changes were made. Note: case conversion is
  # effective only in ASCII region.
  #
  swapcase_bang: () ->
    return null unless @__native__.match(/[a-zA-Z]/)
    @replace _str.swapcase(@__native__)


  #to_c


  # @private
  valid_float: () ->
    number_match = @to_native().match(/^([\+\-]?\d[_\d]*)(\.\d*)?([eE][\+\-]?[\d_]+)?$/)
    number_match?[0]?


  # Returns the result of interpreting leading characters in str as a floating point number. Extraneous characters past the end of a valid number are ignored. If there is not a valid number at the start of str, 0.0 is returned. This method never raises an exception.
  #
  # @example
  #     R("123.45e1").to_f()        #=> 1234.5
  #     R("45.67 degrees").to_f()   #=> 45.67
  #     R("thx1138").to_f()         #=> 0.0
  #
  # @todo Some exotic formats not yet fully supported.
  #
  to_f: ->
    # TODO
    number_match  = @to_native().match(/^([\+\-]?[_\d\.]+)([Ee\+\-\d]+)?/)
    number_string = number_match?[0] ? "0.0"
    @$Float Number(number_string.replace(/_/g, ''))


  # @BASE_IDENTIFIER:
  #   '0b': 2
  #   '0d': 10
  #   '0o': 8
    # '0x': 16

  # @BASE_REGEXP:
  #   2:  /01/
  #   4:  /[0-3]/
  #   8:  /[0-7]/
  #   10: /\d/
  #   16: /[\dA-Fa-f]/
  #   36: /[\dA-Za-z]/


  # Returns the result of interpreting leading characters in str as an integer
  # base base (between 2 and 36). Extraneous characters past the end of a valid
  # number are ignored. If there is not a valid number at the start of str, 0 is
  # returned. This method never raises an exception when base is valid.
  #
  # @example
  #     R("12345").to_i()           #=> 12345
  #     R("1_23_45").to_i()           #=> 12345
  #     R("99 red balloons").to_i() #=> 99
  #     R("0a").to_i()              #=> 0
  #     R("0a").to_i(16)            #=> 10
  #     R("hello").to_i()           #=> 0
  #     R("1100101").to_i(2)        #=> 101
  #     R("1100101").to_i(8)        #=> 294977
  #     R("1100101").to_i(10)       #=> 1100101
  #     R("1100101").to_i(16)       #=> 17826049
  #     # but:
  #     R("_12345").to_i()          #=> 0
  #     # TODO:
  #     R("0b10101").to_i(0)        #=> 21
  #     R("0b1010134").to_i(2)      #=> 21
  #
  # @todo #to_i(base) does not remove invalid characters:
  #       - e.g: R("1012").to_i(2) should return 5, but due to 2 being invalid it retunrs 0 now.
  # @todo #to_i(0) does not auto-detect base
  to_i: (base) ->
    # TODO
    base = 10 if base is undefined
    base = RCoerce.to_int_native(base)

    if base < 0 or base > 36 or base is 1
      throw R.ArgumentError.new()

    # ignore whitespace
    lit = @strip().to_native()

    # ([\+\-]?) matches +\- prefixes if any
    # ([^\+^\-_]+) matches everything after, except '_'.
    unless lit.match(/^([\+\-]?)([^\+^\-_]+)/)
      return R(0)

    # replace after check, so that _123 is invalid
    lit = lit.replace(/_/g, '')

    # if base > 0
    #   return R(0) unless BASE_IDENTIFIER[lit[0..1]] is base
    # else if base is 0
    #   base_str = if lit[0].match(/[\+\-]/) then lit[1..2] else lit[0..1]
    #   base = R.String.BASE_IDENTIFIER[base_str]

    @$Integer parseInt(lit, base)


  #to_r


  # Returns the receiver.
  to_s: -> this


  # Returns the receiver.
  to_str: @prototype.to_s


  #to_sym


  # Returns a copy of str with the characters in from_str replaced by the
  # corresponding characters in #to_str. If #to_str is shorter than from_str,
  # it is padded with its last character in order to maintain the
  # correspondence.
  #
  #     R("hello").tr('el', 'ip')      #=> "hippo"
  #     R("hello").tr('aeiou', '*')    #=> "h*ll*"
  #
  # Both strings may use the c1-c2 notation to denote ranges of characters,
  # and from_str may start with a ^, which denotes all characters except those
  # listed.
  #
  #     R("hello").tr('a-y', 'b-z')    #=> "ifmmp"
  #     R("hello").tr('^aeiou', '*')   #=> "*e**o"
  #
  tr: (from_str, to_str) ->
    @dup().tap (s) -> s.tr_bang(from_str, to_str)


  # Translates str in place, using the same rules as `String#tr`. Returns `str`,
  # or `nil` if no changes were made.
  #
  tr_bang: (from_str, to_str) ->
    throw R.NotImplementedError.new()


  # Processes a copy of str as described under String#tr, then removes
  # duplicate characters in regions that were affected by the translation.
  #
  # @example
  #     R("hello").tr_s('l', 'r')     #=> "hero"
  #     R("hello").tr_s('el', '*')    #=> "h*o"
  #     R("hello").tr_s('el', 'hx')   #=> "hhxo"
  #
  # @todo Implement
  #
  tr_s: ->
    throw R.NotImplementedError.new()


  # Returns a copy of str with all lowercase letters replaced with their
  # uppercase counterparts. The operation is locale insensitive—only
  # characters “a” to “z” are affected. Note: case replacement is effective
  # only in ASCII region.
  #
  # @example
  #     R("hEllO").upcase()   #=> "HELLO"
  #
  upcase: () ->
    new RString(_str.upcase(@__native__))


  # Upcases the contents of str, returning nil if no changes were made. Note:
  # case replacement is effective only in ASCII region.
  #
  upcase_bang: () ->
    return null unless @__native__.match(/[a-z]/)
    @replace(_str.upcase(@__native__))


  # Iterates through successive values, starting at str and ending at
  # other_str inclusive, passing each value in turn to the block. The
  # String#succ method is used to generate each value. If optional second
  # argument exclusive is omitted or is false, the last value will be
  # included; otherwise it will be excluded.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R("a8").upto("b6", (s) -> R.puts(s, ''))
  #     # out: a8 a9 b0 b1 b2 b3 b4 b5 b6
  #
  # If str and other_str contains only ascii numeric characters, both are recognized as decimal numbers. In addition, the width of string (e.g. leading zeros) is handled appropriately.
  #
  # @example
  #     R("9").upto("11").to_a()   #=> ["9", "10", "11"]
  #     R("25").upto("5").to_a()   #=> []
  #     R("07").upto("11").to_a()  #=> ["07", "08", "09", "10", "11"]
  #
  # @todo R('a').upto('c').to_a() should return ['a', 'b', 'c'] (include 'c')
  #
  upto: (stop, exclusive, block) ->
    stop = RCoerce.to_str_native(stop)
    if block is undefined and exclusive?.call?
      block = exclusive
      exclusive = false

    # throw R.TypeError.new() unless stop?.is_string?
    return R.Enumerator.new(this, 'upto', stop, exclusive) unless block && block.call?

    _str.upto(@__native__, stop, exclusive, block)

    this

  # used for the remaining missing test
  # _rubyjs_ascii_succ: ->
  #   @$Integer(@to_native().charCodeAt(0)).succ().chr()


  #valid_encoding?


  # ---- Class methods --------------------------------------------------------


  # ---- Private methods ------------------------------------------------------

  # @private
  __char_natives__: ->
    @__native__.split('')


  # ---- Unsupported methods --------------------------------------------------


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  # @alias #<<
  concat:   @prototype['<<']





RString = RubyJS.String


class RubyJS.Regexp extends RubyJS.Object
  # TODO: remove and document this. not needed/making sense in JS.
  IGNORECASE: 1
  EXTENDED:   2
  MULTILINE:  4

  # ---- Constructors & Typecast ----------------------------------------------

  constructor: (@__native__) ->


  @new: (arg) ->
    if typeof arg is 'string'
      # optimize R.Regexp.new("foo") with string primitive
      arg = @__compile__( arg )
    else if R.Regexp.isRegexp(arg)
    else if arg.is_regexp?
      arg = arg.to_native()
    else
      arg = @__compile__( RCoerce.to_str_native(arg))

    new R.Regexp(arg)


  @compile: @new


  @try_convert: (obj) ->
    if obj is null
      null
    else if @isRegexp(obj)
      new R.Regexp(obj)
    else if obj.to_regexp?
      obj.to_regexp()
    else
      null


  @isRegexp: (obj) ->
    obj?.is_regexp? or _toString_.call(obj) is '[object RegExp]'


  # ---- RubyJSism ------------------------------------------------------------


  # ---- Javascript primitives --------------------------------------------------

  is_regexp: ->
    true


  to_native: ->
    @__native__


  # ---- Instance methods -----------------------------------------------------

  # @todo escaping of forward slashes: \
  inspect: ->
    src = @source().to_native()
    R("/#{src}/#{@__flags__()}")


  # Equality—Two regexps are equal if their patterns are identical, they have
  # the same character set code, and their casefold? values are the same.
  #
  # @todo Check ruby-docs
  #
  # @example Basics (wrong online doc in ruby-doc.org)
  #
  #     R(/abc/)['=='](/abc/)   #=> false
  #     R(/abc/)['=='](/abc/)   #=> false
  #     R(/abc/)['=='](/abc/)   #=> false
  #     R(/abc/)['=='](/abc/)   #=> false
  #
  # @example aliased by #equals
  #
  #     R(/abc/).equals(/abc/)   #=> false
  #     R(/abc/).equals(/abc/)   #=> false
  #
  # @alias #equals, #eql
  #
  '==': (other) ->
    other = R(other)
    (other.to_native().source is @to_native().source) and (other.casefold() is @casefold())


  # Case Equality—Synonym for Regexp#=~ used in case statements.
  #
  #     a = "HELLO"
  #     R(/^[a-z]*$/)['==='](a) # => false
  #     R(/^[a-z]*$/)['==='](a) # => false
  #     R(/^[A-Z]*$/)['==='](a) # => true
  #
  # @alias #equal_case
  #
  '===': (other) ->
    @match(other) != null


  '=~': (str, offset) ->
    matches = @match(str, offset)
    matches?.begin(0)


  # Returns the value of the case-insensitive flag.
  #
  # @example
  #
  #     R(/a/).casefold()           #=> false
  #     R(/a/i).casefold()          #=> true
  #
  # @example Unsupported Ruby syntax
  #
  #     R(/(?i:a)/).casefold()      #=> false
  #
  casefold: ->
    @to_native().ignoreCase


  # @unsupported currently no support for encodings in RubyJS
  encoding: ->
    throw R.NotSupportedError.new()


  # @alias to #==
  eql: -> @['=='].apply(this, arguments)


  # @unsupported currently no support for encodings in RubyJS
  fixed_encoding: ->
    throw R.NotSupportedError.new()


  # @unsupported currently no support for hash in RubyJS
  hash: ->
    throw R.NotSupportedError.new()


  # Returns a MatchData object describing the match, or nil if there was no
  # match. This is equivalent to retrieving the value of the special variable
  # $~ following a normal match. If the second parameter is present, it
  # specifies the position in the string to begin the search.
  #
  # @example
  #     R(/(.)(.)(.)/).match("abc")[2]   # => "b"
  #     R(/(.)(.)/).match("abc", 1)[2]   # => "c"
  #
  # If a block is given, invoke the block with MatchData if match succeed, so that you can write
  #
  #     pat.match(str) {|m| ...}
  #
  # instead of
  #
  #     if m = pat.match(str)
  #       ...
  #     end
  #
  # The return value is a value from block execution in this case.
  #
  # @todo:
  #     R(/(.)(.)?(.)/).match("fo")
  #     # should => ["fo" 1:"f" 2:nil 3:"o">']
  #     # but => ["fo" 1:"f" 2:undefined 3:"o">']
  #
  # @example Parameters
  #     match(str) → matchdata or nil
  #     match(str,pos) → matchdata or nil
  #
  match: (str, offset) ->
    block   = @__extract_block(_slice_.call(arguments))

    if str is null
      R['$~'] = null
    else
      str = RCoerce.to_str_native(str)
      opts = {string: str, regexp: this}

      if offset
        opts.offset = offset
        str = str[offset..-1]

      if matches = str.match(@to_native())
        R['$~'] = new R.MatchData(matches, opts)
      else
        R['$~'] = null

    result = R['$~']

    if block
      if result then block(result) else new R.Array([])
    else
      result


  quote: (pattern) ->
    R.Regexp.quote(pattern)


  # Returns the original string of the pattern.
  #
  #     R(/ab+c/i).source()   #=> "ab+c"
  #
  # Note that escape sequences are retained as is.
  #
  #     R(/\x20\+/).source()  #=> "\\x20\\+"
  #
  source: () ->
    R(@to_native().source)


  # Returns a string containing the regular expression and its options (using the (?opts:source) notation. This string can be fed back in to Regexp::new to a regular expression with the same semantics as the original. (However, Regexp#== may not return true when comparing the two, as the source of the regular expression itself may differ, as the example shows). Regexp#inspect produces a generally more readable version of rxp.
  #
  # @example
  #     r1 = R(/ab+c/)           #=> /ab+c/
  #     s1 = r1.to_s()           #=> "(ab+c)"
  #     r2 = Regexp.new(s1)      #=> /(ab+c)/
  #     r1 == r2                 #=> false
  #     r1.source()              #=> "ab+c"
  #     r2.source()              #=> "(ab+c)"
  #
  # @example Ruby difference
  #
  #     r1 = R(/ab+c/i)           #=> /ab+c/i
  #     s1 = r1.to_s()            #=> "(ab+c)"
  #     # i option is lost!
  #     # Ruby:
  #     /ab+c/i.to_s              #=> "(?i-mx:ab+c)"
  #
  to_s: () ->
    R("(#{@source()})")


  valueOf: ->
    @__native__

  # ---- Class methods --------------------------------------------------------

  # The first form returns the MatchData object generated by the last
  # successful pattern match. Equivalent to reading the global variable $~.
  # The second form returns the nth field in this MatchData object. n can be a
  # string or symbol to reference a named capture.
  #
  # Note that the last_match is local to the thread and method scope of the
  # method that did the pattern match.
  #
  # @example
  #     R(/c(.)t/)['=~'] 'cat'        #=> 0
  #     Regexp.last_match()     #=> #<MatchData "cat" 1:"a">
  #     Regexp.last_match(0)    #=> "cat"
  #     Regexp.last_match(1)    #=> "a"
  #     Regexp.last_match(2)    #=> null
  #
  # @example Edge cases
  #     R(/nomatch/)['=~'] 'foo'
  #     Regexp.last_match(2)    #=> null
  #
  # @example Unsupported Ruby Syntax: named captures
  #     # /(?<lhs>\w+)\s*=\s*(?<rhs>\w+)/ =~ "var = val"
  #     # R.Regexp.last_match()       #=> #<MatchData "var = val" lhs:"var" rhs:"val">
  #     # R.Regexp.last_match(:lhs) #=> "var"
  #     # R.Regexp.last_match(:rhs) #=> "val"
  #
  # @example Parameters
  #    R.Regexp.last_match() → matchdata click to toggle source
  #    R.Regexp.last_match(n) → str
  #
  @last_match: (n) ->
    if (n and R['$~']) then R['$~'][n] else R['$~']


  # @see Regexp.escape
  #
  @quote: (pattern) ->
    @escape(pattern)

  # Escapes any characters that would have special meaning in a regular
  # expression. Returns a new escaped string, or self if no characters are
  # escaped. For any string, Regexp.new(Regexp.escape(str))=~str will be true.
  #
  # @example
  #      R.Regexp.escape('\*?{}.')   #=> \\\*\?\{\}\.
  #
  # @alias Regexp.quote
  #
  @escape: (pattern) ->
    pattern = pattern + ''
    pattern.replace(/([.?*+^$[\](){}|-])/g, "\\$1")
      # .replace(/[\\]/g, '\\\\')
      # .replace(/[\"]/g, '\\\"')
      # .replace(/[\/]/g, '\\/')
      # .replace(/[\b]/g, '\\b')
      .replace(/[\f]/g, '\\f')
      .replace(/[\n]/g, '\\n')
      .replace(/[\r]/g, '\\r')
      .replace(/[\t]/g, '\\t')
      .replace(/[\s]/g, '\\ ') # This must been an empty space ' '


  # Return a Regexp object that is the union of the given patterns, i.e., will
  # match any of its parts. The patterns can be Regexp objects, in which case
  # their options will be preserved, or Strings. If no patterns are given,
  # returns /(?!)/. The behavior is unspecified if any given pattern contains
  # capture.
  #
  # @example
  #     R.Regexp.union()                       #=> /(?!)/
  #     R.Regexp.union("penzance")             #=> /penzance/
  #     R.Regexp.union("a+b*c")                #=> /a\+b\*c/
  #     R.Regexp.union("skiing", "sledding")   #=> /skiing|sledding/
  #     R.Regexp.union(["skiing", "sledding"]) #=> /skiing|sledding/
  #     R.Regexp.union(/dogs/, /cats/)        #=> /(dogs)|(cats)/
  #
  # @example Ruby difference
  #
  #     RubyJS.Regexp.union(/dogs/, /cats/)   # => /(dogs)|(cats)/
  #     # Ruby:
  #     Regexp.union(/dogs/, /cats/)          # => /(?-mix:dogs)|(?i-mx:cats)/
  #
  # @example Edge cases
  #     R.Regexp.union(["skiing", "sledding"], 'foo') #=> TypeError!
  #
  # @example Parameters
  #     R.Regexp.union(pat1, pat2, ...) → new_regexp
  #     R.Regexp.union(pats_ary) → new_regexp
  #
  @union: (args...) ->
    return R(/(?!)/) if args.length == 0

    first_arg = R(args[0])
    if first_arg.is_array? and args.length == 1
      args = first_arg

    sources = for arg in args
      arg = R(arg)
      if arg.is_regexp? then arg.to_s() else RCoerce.to_str(arg)

    # TODO: use proper Regexp.compile/new method
    new R.Regexp(
      new nativeRegExp( sources.join('|') ))


  # ---- Private methods ------------------------------------------------------

  # @see Regexp.new
  @__compile__: (arg) ->
    try
      return new nativeRegExp(arg)
    catch error
      throw R.RegexpError.new()


  __flags__: ->
    if @casefold() then 'i' else ''


  # ---- Unsupported methods --------------------------------------------------

  # @unsupported named captures are not supported in JS
  names: ->
    throw R.NotSupportedError.new()


  # @unsupported named captures are not supported in JS
  named_captures: ->
    throw R.NotSupportedError.new()


  # @unsupported JS options are different from Ruby options.
  options: ->
    throw R.NotSupportedError.new()


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  fixedEncoding: @prototype.fixed_encoding


class RubyJS.Numeric extends RubyJS.Object

  # ---- Constructors & Typecast ----------------------------------------------

  # true for:
  #   - number primitive
  #   - native Number object
  #   - valueOf() returns a number primitive
  @isNumeric = (obj) ->
    # Returns early if obj for any primitive except number
    return true  if typeof obj is 'number'
    return false if typeof obj != 'object'
    return false if obj == null
    # Number implements valueOf and returns a primitive.
    # RubyJS Numerics also implement valueOf()
    (obj.valueOf? and typeof obj.valueOf() is 'number')



  @try_convert = (obj) ->
    return null unless @isNumeric(obj)
    @new(obj)
    # if RubyJS.Float.isFloat(obj)
    #   RubyJS.Float.new(obj)
    # else if RubyJS.Integer.isInteger(obj) # should be Fixnum really..
    #   RubyJS.Fixnum.new(obj)
    # else
    #   null

  @new: (value) ->
    if (value % 1 is 0) then new R.Fixnum(value) else new R.Float(value)


  @typecast: (value) ->
    if (value % 1 is 0) then new R.Fixnum(value) else new R.Float(value)


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_numeric: -> true


  # ---- Instance methods -----------------------------------------------------

  '<=>': (other) ->
    if this is other then 0 else null


  # Returns the absolute value of num.
  #
  # @example
  #     R(12).abs()         #=> 12
  #     (-34.56).abs()      #=> 34.56
  #     R(-34.56).abs()     #=> 34.56
  #
  # @return [R.Numeric]
  #
  abs: ->
    if @['<'](0) then @uminus() else this


  # Returns square of self.
  #
  # @return [R.Numeric]
  #
  abs2: ->
    return this if @nan?()
    @abs()['**'](2)


  # Returns the smallest Integer greater than or equal to num. Class Numeric achieves this by converting itself to a Float then invoking Float#ceil.
  #
  # @example
  #     R(1).ceil()      #=> 1
  #     R(1.2).ceil()    #=> 2
  #     R(-1.2).ceil()   #=> -1
  #     R(-1.0).ceil()   #=> -1
  #
  # @return [R.Fixnum]
  #
  ceil: () ->
    @to_f().ceil()


  # If a Numeric is the same type as num, returns an array containing aNumeric
  # and num. Otherwise, returns an array with both aNumeric and num
  # represented as Float objects. This coercion mechanism is used by Ruby to
  # handle mixed-type numeric operations: it is intended to find a compatible
  # common type between the two operands of the operator.
  #
  # @example
  #     R(1).coerce(2.5)   #=> [2.5, 1.0]
  #     R(1.2).coerce(3)   #=> [3.0, 1.2]
  #     R(1).coerce(2)     #=> [2, 1]
  #
  # @todo this needs some serious love
  #
  coerce: (other) ->
    throw RubyJS.TypeError.new() if !other? or other is false
    other = R(other)
    # throw RubyJS.TypeError.new() unless other.to_f?
    if      other.is_string?    then @$Array [@$Float(other), @to_f()]
    else if other.constructor.prototype is @constructor.prototype then @$Array([other, this])
    else if other.is_float?     then @$Array [other, @to_f()]
    else if other.is_fixnum?    then @$Array [other, this]
    else if other.is_numeric?   then @$Array [other.to_f(), this.to_f()]
    else
      throw RubyJS.TypeError.new()


  # Uses / to perform division, then converts the result to an integer.
  # numeric does not define the / operator; this is left to subclasses.
  #
  # Equivalent to num.divmod(aNumeric).
  #
  # See {R.Numeric#divmod}
  #
  # @return [R.Float]
  #
  div: (other) ->
    other = @box(other)
    throw RubyJS.TypeError.new() unless other.to_int?
    throw new Error("ZeroDivisionError") if other.zero()
    @divide(other).floor()


  divmod: (other) ->
    quotient = @div(other).floor()
    modulus  = @minus(quotient.multiply(other))

    new R.Array([quotient, modulus])


  # Returns true if num and numeric are the same type and have equal values.
  #
  # @example
  #     new R.Fixnum(1).equals(new R.Float(1.0))  #=> true
  #     new R.Fixnum(1).eql(new R.Float(1.0))     #=> false
  #     new R.Float(1).eql(new R.Float(1.0))      #=> true
  #
  # @return [Boolean]
  #
  eql: (other) ->
    other = @box(other)
    return false unless other
    return false unless @__proto__ is other.__proto__
    if @['=='](other) then true else false


  # @return [R.String]
  inspect: -> new R.String(""+@to_native())

  # Returns float division.
  #
  # @return [R.Float]
  #
  fdiv: (other) ->
    other = RCoerce.to_num_native(other)
    @to_f()['/'](other)


  # Returns the largest integer less than or equal to num. Numeric implements this by converting anInteger to a Float and invoking Float#floor.
  #
  # @example
  #     R( 1).floor()   #=> 1
  #     R(-1).floor()   #=> -1
  #
  # @return [R.Fixnum]
  #
  floor: () ->
    @to_f().floor()


  # Returns the absolute value of num.
  #
  # @alias #abs
  #
  magnitude: ->
    @abs()

  # Alias to {#divmod}
  #
  # @alias #divmod
  modulo: (other) ->
    other = @box(other)
    # self - other * self.div(other)
    @['-']( other['*']( @div(other)) )


  # Returns self if num is not zero, nil otherwise. This behavior is useful
  # when chaining comparisons:
  #
  # @return [null, this]
  #
  nonzero: ->
    if @zero() then null else this


  # Returns most exact division (rational for integers, float for floats).
  quo: (other) ->
    other = @box(other)
    throw new Error("ZeroDivisionError") if other.zero()
    arr = @coerce(other)
    @['/'](arr.first())


  # Returns an array; [num, 0].
  rect: ->
    throw R.ArgumentError.new() if arguments.length > 0
    new R.Array([this, new R.Fixnum(0)])


  rectangular: @prototype.rect


  # x.remainder(y) means x-y*(x/y).truncate
  #
  # @see {R.Numeric#divmod}
  #
  remainder: (other) ->
    other = @box(other)
    mod = @['%'](other)

    if !mod['=='](0) and ((@['<'](0) && other['>'](0)) or (@['>'](0) && other['<'](0)))
      mod['-'](other)
    else
      mod


  # Rounds num to a given precision in decimal digits (default 0 digits).
  # Precision may be negative. Returns a floating point number when ndigits is
  # more than zero. Numeric implements this by converting itself to a Float
  # and invoking Float#round.
  #
  # @return [R.Numeric]
  #
  round: (n) ->
    @to_f().round(n)


  # Invokes block with the sequence of numbers starting at num, incremented by
  # step (default 1) on each call. The loop finishes when the value to be
  # passed to the block is greater than limit (if step is positive) or less
  # than limit (if step is negative). If all the arguments are integers, the
  # loop operates using an integer counter. If any of the arguments are
  # floating point numbers, all are converted to floats, and the loop is
  # executed floor(n + n*epsilon)+ 1 times, where n = (limit - num)/step.
  # Otherwise, the loop starts at num, uses either the < or > operator to
  # compare the counter against limit, and increments itself using the +
  # operator.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R(1).step(10, 2, function (i) { R.puts(i)} )
  #     R(Math.E).step(Math.PI, 0.2, function (i) { R.puts(i)} )
  #     # produces:
  #     # 1 3 5 7 9
  #     # 2.71828182845905 2.91828182845905 3.11828182845905
  #
  # @return [this, R.Enumerator]
  #
  step: (limit, step = 1, block) ->
    unless block?.call?
      return @to_enum('step', limit, step) unless step?.call?

    _num.step(@__native__, limit, step, block)
    this


  # @private
  to_int: ->
    @to_i()


  # Returns num truncated to an integer. Numeric implements this by converting
  # its value to a float and invoking Float#truncate.
  #
  # @return [R.Fixnum]
  #
  truncate: ->
    @to_f().truncate()


  # Unary Minus—Returns the receiver’s value, negated.
  #
  # @return [R.Numeric]
  #
  uminus: ->
    @multiply(-1)


  # Returns true if num has a zero value.
  #
  # @return [Boolean]
  zero: ->
    @['=='](0)




# Integer is a module for Integer number formats. The actual implementation is
# Fixnum.
#
# @mixin
class RubyJS.Integer extends RubyJS.Numeric

  # ---- Constructors & Typecast ----------------------------------------------

  @new: (value) ->
    new R.Integer(value)


  @isInteger: (obj) ->
    @isNumeric(obj) && (obj % 1 is 0)


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_integer: -> true


  # ---- Javascript primitives --------------------------------------------------

  # @private
  unbox: -> @to_native()


  # ---- Instance methods -----------------------------------------------------

  # Returns a string containing the character represented by the receiver’s value according to encoding.
  #
  # @example
  #
  #     R(65).chr()                   #=> "A"
  #     R(230).chr()                  #=> "\346"
  #     R(255).chr(Encoding::UTF_8)   #=> "\303\277"
  #
  # @return [R.String]
  #
  chr: ->
    new R.String(String.fromCharCode(@to_native()))

  # Returns 1.
  #
  # @return [R.Fixnum]
  #
  denominator: ->
    new R.Fixnum(1)

  # Iterates block, passing decreasing values from int down to and including
  # limit.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #    R(5).downto(1, function (n) { R.puts(n + ".. ") }
  #    # => 5.. 4.. 3.. 2.. 1..
  #
  # @param [Number] stop
  # @return [this]
  #
  downto: (stop, block) ->
    try
      stop = RCoerce.to_num_native(stop)
    catch err
      throw R.ArgumentError.new()

    unless block?.call?
      return R.Enumerator.new(this, 'downto', stop)

    _num.downto(@__native__, stop, block)
    this


  # Returns true if int is an even number.
  #
  # @return [Boolean]
  #
  even: ->
    @to_native() % 2 == 0


  # Returns the greatest common divisor (always positive). 0.gcd(x) and x.gcd(0) return abs(x).
  #
  # @example
  #
  #     R(2).gcd(2)                    #=> 2
  #     R(3).gcd(-7)                   #=> 1
  #     R((1<<31)-1).gcd((1<<61)-1)    #=> 1
  #
  # @return [R.Fixnum]
  #
  gcd: (other) ->
    other = R(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    n = _num.gcd(@__native__, other.to_native())
    new R.Fixnum(n)

  # Returns an array; [int.gcd(int2), int.lcm(int2)].
  #
  # @example
  #
  #     R(2).gcdlcm(2)                    #=> [2, 2]
  #     R(3).gcdlcm(-7)                   #=> [1, 21]
  #     R((1<<31)-1).gcdlcm((1<<61)-1)    #=> [1, 4951760154835678088235319297]
  #
  # @return [R.Array<R.Fixnum, R.Fixnum>]
  #
  gcdlcm: (other) ->
    other = @box(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    new R.Array([@gcd(other), @lcm(other)])

  # Returns the least common multiple (always positive). 0.lcm(x) and x.lcm(0) return zero.
  #
  # @example
  #
  #     R(2).lcm(2)                    #=> 2
  #     R(3).lcm(-7)                   #=> 21
  #     R((1<<31)-1).lcm((1<<61)-1)    #=> 4951760154835678088235319297
  #
  # @return [R.Fixnum]
  #
  lcm: (other) ->
    other = R(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    lcm = new R.Fixnum(@to_native() * other.to_native() / @gcd(other))
    lcm.numerator()


  # Returns self.
  #
  # @return [R.Fixnum,this]
  #
  numerator: ->
    new R.Fixnum(_num.numerator(@__native__))

  # Returns true if int is an odd number.
  #
  # @return [Boolean]
  #
  odd:  -> !@even()


  # Returns the int itself.
  #
  #      a.ord    #=> 97
  #
  # This method is intended for compatibility to character constant in Ruby
  # 1.9. For example, ?a.ord returns 97 both in 1.8 and 1.9.
  #
  # @return [this]
  #
  ord:  ->
    this


  # Returns the Integer equal to int + 1.
  #
  # @example
  #
  #     R(1).next(     #=> 2
  #     R(-1).next()   #=> 0
  #
  # @return [R.Fixnum]
  # @alias #succ
  #
  next: ->
    @plus(1)


  # Returns the Integer equal to int - 1.
  #
  # @example
  #
  #     R(1).pred()    #=> 0
  #     R(-1).pred()   #=> -2
  #
  # @return [R.Fixnum]
  #
  pred: ->
    @minus(1)


  # Rounds to a given precision in decimal digits (default 0 digits). Precision may be negative. Returns a floating point number when ndigits is positive, self for zero, and round down for negative.
  #
  # @example
  #
  #     R(1).round()      #=> 1
  #     R(1).round(2)     #=> 1.0
  #     R(15).round(-1)   #=> 20
  #
  # @return [R.Fixnum]
  #
  round: (n) ->
    return this if n is undefined
    n = RCoerce.to_int_native(n)
    if n > 0
      @to_f()
    else if n is 0
      this
    else
      new R.Fixnum(_num.round(@__native__, n))


  succ:  @prototype.next


  # Iterates block int times, passing in values from zero to int - 1.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #     R(5).times(function(i) { R.puts(i) })
  #     # => 0 1 2 3 4
  #
  # @return [this]
  #
  times: (block) ->
    return @to_enum('times') unless block?.call?
    new R.Fixnum(_num.times(@__native__, block))

  # As int is already an Integer, all these methods simply return the receiver
  # @return [this]
  to_i:   -> this


  # Iterates block, passing in integer values from int up to and including
  # limit.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #     R(5).upto(10, function (i) { R.puts(i + " " })
  #     # => 5 6 7 8 9 10
  #
  # @param [Number] stop
  # @return [this]
  #
  upto: (stop, block) ->
    try
      stop = RCoerce.to_num_native(stop)
    catch err
      throw R.ArgumentError.new()

    unless block?.call?
      return R.Enumerator.new(this, 'upto', stop)

    _num.upto(@__native__, stop, block)


  # @return [String]
  toString: -> "#{@to_native()}"


  # ---- Private methods ------------------------------------------------------

  # @private
  __ensure_integer__: (other) ->
    throw RubyJS.TypeError.new() unless other?.is_integer?


  # ---- Aliases --------------------------------------------------------------


  to_int:   @prototype.to_i
  truncate: @prototype.to_i




class RubyJS.Fixnum extends RubyJS.Integer
  @include R.Comparable


  # ---- Constructors & Typecast ----------------------------------------------


  constructor: (@__native__) ->

  # __memoized_fixnums__: []

  @new: (val) ->
    # memo = @__memoized_fixnums__[val]
    # return memo if memo
    new R.Fixnum(val)


  @try_convert: (obj) ->
    obj = R(obj)
    throw R.TypeError.new() unless obj.to_int?
    obj

  # Fixnums are unchangeable. Cache them for later use.
  #
  @__cache_fixnums__: (from = -1, to = 256) ->
    for i in [from..to]
      @__memoized_fixnums__[i] = new R.Fixnum(i)


  # ---- RubyJSism ------------------------------------------------------------

  is_fixnum: -> true


  valueOf: -> @__native__


  # ---- Javascript primitives --------------------------------------------------

  to_native: ->
    @__native__

  valueOf: @prototype.to_native

  unbox: @prototype.to_native


  # ---- Instance methods -----------------------------------------------------

  dup:   ->
    Fixnum.new(@to_native())

  # Return true if fix equals other numerically.
  #
  # @example
  #     R(1).equals 2      #=> false
  #     R(1).equals 1.0    #=> true
  #
  # @alias #equals
  #
  '==': (other) ->
    if !R(other).is_fixnum?
      R(other)['=='](this)
    else
      @['<=>'](other) == 0

  # Return true if fix equals other numerically.
  #
  # @example
  #     1 == 2      #=> false
  #     1 == 1.0    #=> true
  #
  '===': @prototype['==']


  # Returns -1, 0, +1 or nil depending on whether fix is less
  # than, equal to, or greater than numeric. This is the basis for the
  # tests in Comparable.
  #
  '<=>': (other) ->
    unless typeof other is 'number'
      other = R(other)
      return null                  unless other.is_numeric?
      throw R.TypeError.new() unless other.to_int?
      other = other.to_native()

    if @to_native() < other
      -1
    else if @to_native() > other
      1
    else
      0

  # Performs addition: the class of the resulting object depends on the class
  # of numeric and on the magnitude of the result.
  #
  # @example
  #     R(1).plus(1)   # => 2     <R.Fixnum>
  #     R(1).plus(1.5) # => 2.t   <R.Float>
  #
  # @alias #plus
  #
  '+': (other) ->
    R.Numeric.typecast(@to_native() + RCoerce.to_num_native(other))

  # Performs subtraction: the class of the resulting object depends on the
  # class of numeric and on the magnitude of the result.
  #
  # @example
  #     R(1).minux(1)   # => 0     <R.Fixnum>
  #     R(1).minux(1.5) # => 0.5   <R.Float>
  #
  # @alias #minus
  #
  '-': (other) ->
    R.Numeric.typecast(@to_native() - RCoerce.to_num_native(other))

  # Performs division: the class of the resulting object depends on the class
  # of numeric and on the magnitude of the result.
  #
  # @example
  #     R(1).divide(2) # => 0
  #     R(1).divide(R.f(2)) # => 0.5
  #
  # @alias #divide
  #
  '/': (other) ->
    other = Fixnum.try_convert(other)
    if other.is_float? && other.zero()
      if @to_native() > 0
        R('Infinity')
      else
        R('-Infinity')
    else if +other == 0
      throw R.ZeroDivisionError.new()
    else
      val = R.Numeric.typecast(@to_native() / other.to_native())
      if other.is_float? then val else val.floor()


  # Performs multiplication: the class of the resulting object depends on the
  # class of numeric and on the magnitude of the result.
  #
  # @alias #multiply
  #
  '*': (other) ->
    R.Numeric.typecast(@to_native() * RCoerce.to_num_native(other))

  # Raises fix to the numeric power, which may be negative or fractional.
  #
  # @example
  #     R(2)['**'] 3      #=> 8
  #     R(2)['**'] -1     #=> 0.5
  #     R(2)['**'] 0.5    #=> 1.4142135623731
  #
  '**': (other) ->
    other = @box(other)
    val   = @box Math.pow(@to_native(), other.to_native())
    if other.is_float? then val.to_f() else val.to_i()

  # Returns fix modulo other. See numeric.divmod for more information.
  #
  # @alias #modulo
  #
  '%': (other) ->
    is_float  = @box(other).is_float?
    fixnum    = Fixnum.try_convert(other)
    throw R.ZeroDivisionError.new() if fixnum.zero()
    fixnum   = fixnum.to_int()
    division = @['/'](fixnum)
    val      = @minus division.multiply(fixnum)

    if is_float then val.to_f() else val.to_i()

  # Returns the floating point result of dividing fix by numeric.
  #
  # @example
  #     R(654321).fdiv(13731)      #=> 47.6528293642124
  #     R(654321).fdiv(13731.24)   #=> 47.6519964693647
  #
  fdiv: (other) ->
    other = R(other)
    throw R.TypeError.new() unless other.is_numeric?
    @__ensure_args_length(arguments, 1)
    @to_f().divide(other.to_f())


  object_id: ->
    @__native__ * 2 + 1


  # Converts fix to a Float.
  to_f: -> @$Float(@to_native())


  # Returns a string containing the representation of fix radix base (between
  # 2 and 36).
  #
  # @example
  #     R(12345).to_s()     #=> "12345"
  #     R(12345).to_s(2)    #=> "11000000111001"
  #     R(12345).to_s(8)    #=> "30071"
  #     R(12345).to_s(10)   #=> "12345"
  #     R(12345).to_s(16)   #=> "3039"
  #     R(12345).to_s(36)   #=> "9ix"
  #
  to_s: (base = 10) ->
    base = @box(base)
    throw R.ArgumentError.new() if base.lt(2) || base.gt(36)
    @box("#{@to_native().toString(base.to_native())}")


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)


#
#
#
#
class RubyJS.Float extends RubyJS.Numeric
  @include R.Comparable

  # FIXME: this should ideally be rubyjs.Floats
  @INFINITY:   1.0/0.0
  @NAN:        0.0/0.0
  @DIG:        15
  @EPSILON:    0.0000000000000002220446049250313080847263336181640625
  @MANT_DIG:   53
  @MAX_10_EXP: 308
  @MIN_10_EXP:-307
  @MAX_EXP:    1024
  @MIN_EXP:   -1021
  @MAX:        179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368
  @MANT_DIG:   53
  @MIN:        2.225073858507201383090232717332404064219215980462331830553327416887204434813918195854283159012511020564067339731035811005152434161553460108856012385377718821130777993532002330479610147442583636071921565046942503734208375250806650616658158948720491179968591639648500635908770118304874799780887753749949451580451605050915399856582470818645113537935804992115981085766051992433352114352390148795699609591288891602992641511063466313393663477586513029371762047325631781485664350872122828637642044846811407613911477062801689853244110024161447421618567166150540154285084716752901903161322778896729707373123334086988983175067838846926092773977972858659654941091369095406136467568702398678315290680984617210924625396728515625e-308
  @RADIX:      2


  # ---- Constructors ---------------------------------------------------------

  # rubyism
  @new: (f) ->
    new R.Float(f)

  constructor: (@__native__) ->


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_float:   -> true


  @isFloat: (obj) ->
    R.Numeric.isNumeric(obj) && !R.Integer.isInteger(obj)


  # ---- Instance methods -----------------------------------------------------


  '<=>': (other) ->
    return null if !@box(other).is_numeric?
    other = RCoerce.to_num_native(other)

    return  0 if @to_native() == other
    return -1 if @to_native() < other
    return  1 if @to_native() > other


  '==': (other) ->
    other = @box(other)
    @to_native() is other.to_native()


  '+': (other) ->
    new Float(@to_native() + RCoerce.to_num_native(other))


  '-': (other) ->
    new Float(@to_native() - RCoerce.to_num_native(other))


  '*': (other) ->
    new Float(@to_native() * RCoerce.to_num_native(other))


  '/': (other) ->
    new Float(@to_native() / RCoerce.to_num_native(other))


  '**': (other) ->
    new Float( Math.pow(@to_native(), RCoerce.to_num_native(other)) + 0)


  '%': (other) ->
    other = @box(other)
    throw new Error("ZeroDivisionError") if other.equals(0)

    return @box(Float.NAN).to_f() if !@finite()

    if inf = other.infinite?()
      return other if inf is -1
      return this  if inf is 1

    div = @['/'](other).floor()
    val = @to_native() - (div.to_native() * other.to_native())

    new Float(val)

  # Returns 0 if the value is positive, pi otherwise.
  #
  # @return [R.Float]
  # @alias #angle, #phase
  #
  arg: ->
    if @nan()
      this
    else if @__native__ < 0.0
      new R.Float(Math.PI)
    else
      new R.Float(0)


  # Returns the smallest Integer greater than or equal to flt.
  #
  # @example
  #
  #    R( 1.2).ceil()      #=> 2
  #    R( 2.0).ceil()      #=> 2
  #    R(-1.2).ceil()      #=> -1
  #    R(-2.0).ceil()      #=> -2
  #
  # @return [R.Fixnum]
  #
  ceil: ->
    new R.Fixnum(Math.ceil(@to_native()))


  inspect: () ->
    @to_s()


  dup: -> Float.new(@to_native())


  # Returns true only if obj is a Float with the same value as flt. Contrast
  # this with Float#==, which performs type conversions.
  #
  # @example
  #
  #     new R.Float(1.0).eql(1)   #=> false
  #
  # @return [Boolean]
  #
  eql: (other) ->
    other = @box(other)
    return false unless other.is_float?
    @equals(other)


  # Returns true if flt is a valid IEEE floating point number (it is not
  # infinite, and nan? is false).
  #
  # @return [Boolean]
  #
  finite: ->
    !(@infinite() || @nan())


  # Returns nil, -1, or +1 depending on whether flt is finite, -infinity, or
  # +infinity.
  #
  # @example
  #
  #     new R.Float(0.0).infinite()        #=> nil
  #     new R.Float(-1.0/0.0).infinite()   #=> -1
  #     new R.Float(+1.0/0.0).infinite()   #=> 1
  #
  # @return [Boolean]
  #
  infinite: ->
    if @to_native() is Float.INFINITY
      1
    else if @to_native() is -Float.INFINITY
      -1
    else
      null


  # Returns true if flt is an invalid IEEE floating point number.
  #
  # @example
  #
  #     a = new R.Float(-1.0)      #=> -1.0
  #     a.nan()                    #=> false
  #     a = new R.Float(0.0/0.0)   #=> NaN
  #     a.nan()                    #=> true
  #
  # @return [Boolean]
  #
  nan: ->
    isNaN(@to_native())


  # As flt is already a float, returns self.
  to_f: -> @dup()


  # Returns flt truncated to an Integer.
  #
  # @return [R.Fixnum]
  to_i: ->
    if @to_native() < 0
      @ceil()
    else
      @floor()


  # Returns the largest integer less than or equal to flt.
  #
  # @example
  #
  #     new R.Float(1.2).floor()    #=> 1
  #     new R.Float(2.0).floor()    #=> 2
  #     new R.Float(-1.2).floor()   #=> -2
  #     new R.Float(-2.0).floor()   #=> -2
  #
  # @return [R.Fixnum]
  #
  floor: ->
    new R.Fixnum(Math.floor(@__native__))


  # Returns float / numeric.
  #
  # @return [R.Float]
  #
  quo: (other) ->
    @__ensure_args_length(arguments, 1)

    other = @box(other)
    @divide(other)


  # Rounds flt to a given precision in decimal digits (default 0 digits).
  # Precision may be negative. Returns a floating point number when ndigits is
  # more than zero.
  #
  # @example
  #
  #     R(1.4).round()      #=> 1
  #     R(1.5).round()      #=> 2
  #     R(1.6).round()      #=> 2
  #     R(-1.5).round()     #=> -2
  #     R(1.234567).round(2)  #=> 1.23
  #     R(1.234567).round(3)  #=> 1.235
  #     R(1.234567).round(4)  #=> 1.2346
  #     R(1.234567).round(5)  #=> 1.23457
  #     R(34567.89).round(-5) #=> 0
  #     R(34567.89).round(-4) #=> 30000
  #     R(34567.89).round(-3) #=> 35000
  #     R(34567.89).round(-2) #=> 34600
  #     R(34567.89).round(-1) #=> 34570
  #     R(34567.89).round(0)  #=> 34568
  #     R(34567.89).round(1)  #=> 34567.9
  #     R(34567.89).round(2)  #=> 34567.89
  #     R(34567.89).round(3)  #=> 34567.89
  #
  # @return [R.Fixnum, R.Float]
  #
  round: (n = 0) ->
    n = RCoerce.to_int_native(n)

    throw new TypeError("FloatDomainError") if @infinite()
    throw new TypeError("RangeError")       if @nan()

    return new R.Fixnum(Math.round(@to_native())) if n is 0

    multiplier = Math.pow(10, n)
    rounded    = Math.round(@to_native() * multiplier) / multiplier
    if n > 0
      new R.Float(rounded)
    else
      new R.Fixnum(rounded)


  # Returns a string containing a representation of self. As well as a fixed
  # or exponential form of the number, the call may return “NaN”, “Infinity”,
  # and “-Infinity”.
  #
  # @return [R.String]
  #
  to_s: ->
    v = ""+@to_native()
    if @nan()
      v = "NaN"
    else if inf = @infinite()
      v = "-Infinity" if inf is -1
      v = "Infinity" if inf is  1
    else if v.indexOf('.') < 0
      v += ".0"

    @$String(v)


  # ---- Javascript primitives --------------------------------------------------

  # @return [String]
  toString: ->
    @to_native().toString()


  # @return [String]
  valueOf: () ->
    @__native__


  # @return [String]
  to_native: ->
    @__native__


  # @private
  unbox: @prototype.to_native


  # ---- Aliases --------------------------------------------------------------

  angle:      @prototype.arg
  fdiv:       @prototype.quo

  # Returns the absolute value of flt.
  #
  # @example
  #
  #     R(-34.56).abs()     #=> 34.56
  #     R(-34.56).abs()     #=> 34.56
  #
  # @return [R.Float]
  # @alias #abs
  #
  magnitude:  @prototype.abs
  phase:      @prototype.arg
  to_int:     @prototype.to_i
  truncate:   @prototype.to_i

  '===': @prototype['==']
  @__add_default_aliases__(@prototype)



###

new RubyJS.Time(new Date(), 3600)

JS Date objects have no support for timezones. R.Time emulates timezones using
a second fake object that is offset by the user defined utc_offset.


@example If local timezone is ICT (+07:00)

    t = R.Time.new(2012,12,24,12,0,0, "+01:00")
    t.__native__
    # => Mon Dec 24 2012 18:00:00 GMT+0700 (ICT)
    # t.__native__ has the correct timestamp for the local time.
    #              2012-12-24 12:00 (CET) - "+01:00 (CET)"
    #              2012-12-24 11:00 (UCT) + "+07:00 (ICT)"
    #              2012-12-24 18:00 (ICT)
    #
    t._tzdate
    # => Mon Dec 24 2012 12:00:00 GMT+0700 (ICT)
    #
    # t._tzdate holds the wrong timestamp but is useful to work with native JS
    # methods.
    #
    t.hour()      # => 12 (internally uses _tzdate.getHours())

###


class RubyJS.Time extends RubyJS.Object
  # Internally uses a Date object and an offset to UTC
  #
  # new Date(2012,11,18,16,0,0)
  # new Date(2012,11,18, 8, 0, 0, 7*3600) # UTC
  #
  #
  #     new Time(Date, utc_offset_in_seconds)
  #     Time.new(y,m,d,h,m,s,utc_offset_in_seconds)
  #     Time.now() # in timezone
  #     Time.at() # local_time
  @include R.Comparable

  @LOCALE:
    'DAYS':         ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    'DAYS_SHORT':   ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    'MONTHS':       [null, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    'MONTHS_SHORT': [null, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    'AM': 'AM'
    'PM': 'PM'
    'AM_LOW': 'am'
    'PM_LOW': 'pm'

  @TIME_ZONES =
      'UTC': 0,
      # ISO 8601
      # 'Z': 0,
      # RFC 822
      'UT':   0, 'GMT': 0,
      'EST': -5, 'EDT': -4,
      'CST': -6, 'CDT': -5,
      'MST': -7, 'MDT': -6,
      'PST': -8, 'PDT': -7
      # Skip military zones
      # Following definition of military zones is original one.
      # See RFC 1123 and RFC 2822 for the error in RFC 822.
      # 'A' => +1, 'B' => +2, 'C' => +3, 'D' => +4,  'E' => +5,  'F' => +6,
      # 'G' => +7, 'H' => +8, 'I' => +9, 'K' => +10, 'L' => +11, 'M' => +12,
      # 'N' => -1, 'O' => -2, 'P' => -3, 'Q' => -4,  'R' => -5,  'S' => -6,
      # 'T' => -7, 'U' => -8, 'V' => -9, 'W' => -10, 'X' => -11, 'Y' => -12,


  # ---- Constructors & Typecast ----------------------------------------------

  # when passing utc_offset @__native__ has to be in that timezone as well.
  # utc_offset is in seconds
  #
  # e.g. to create a GMT date:
  #
  #     new R.Time(new Date(), 3600)
  #
  #
  constructor: (@__native__, utc_offset) ->
    if utc_offset?
      @__utc_offset__ = utc_offset
      @_tzdate = R.Time._offset_to_local(@__native__, @__utc_offset__)
    else
      @_tzdate = @__native__
      @__utc_offset__ = R.Time._local_timezone()


  @now: ->
    R.Time.new()


  # new → time click to toggle source
  # new(year, month=nil, day=nil, hour=nil, min=nil, sec=nil, utc_offset=nil) → time
  #
  @new: (year, month, day, hour, min, sec, utc_offset) ->
    if arguments.length == 0
      return new R.Time(new Date())
    if year is null
      throw R.TypeError.new()

    month ||= 1
    day   ||= 1
    hour  ||= 0
    min   ||= 0
    sec   ||= 0

    if month > 12 || day > 31 || hour > 24 || min > 59 || sec > 59 || month < 0 || day < 0   || hour < 0  || min < 0  || sec < 0
       throw R.ArgumentError.new()

    # utc_offset is in seconds
    if utc_offset?
      # utc_offset in seconds is the desired offset.
      utc_offset = @_parse_utc_offset(utc_offset)
      # First get the local date for the specified params
      date = new Date(year, month - 1, day, hour, min, sec)
      date = @_local_to_offset(date, utc_offset)
    else
      date = new Date(year, month - 1, day, hour, min, sec)
      utc_offset = @_local_timezone()

    new R.Time(date, utc_offset)


  @_local_to_offset: (date, utc_offset) ->
    # utc_offset is the desired offset in seconds
    # Adjust the local date to the UTC date
    date = date.valueOf() + R.Time._local_timezone() * 1000
    # remove the utc_offset:
    date = date - utc_offset * 1000
    new Date(date)


  @_offset_to_local: (date, utc_offset) ->
    date = date.valueOf() - R.Time._local_timezone() * 1000
    date += utc_offset * 1000
    new Date(date)


  # @private
  # "+01:30" => 90min * 60 sec
  @_parse_utc_offset: (offset) ->
    return null unless offset?
    offset = R(offset)
    secs = null
    if offset.is_string? or offset.to_str?
      offset = offset.to_str().to_native()
      # msg: "+HH:MM" or "-HH:MM" expected for utc_offset
      return throw R.ArgumentError.new() unless offset.match(/[\+|-]\d\d:\d\d/)
      # strip +/-HH:MM into parts and calculate seconds:
      sign = if offset[0] is '-' then -1 else 1
      [hour, mins] = offset.split(':')
      mins = parseInt(mins)
      hour = parseInt(hour.slice(1))
      secs = sign * (hour * 60 + mins) * 60
    else if offset.is_fixnum? or offset.to_int?
      secs = offset.to_int()
      return throw R.ArgumentError.new() if Math.abs(secs) >= 86400

    else
      throw R.TypeError.new()

    Math.floor(secs)


  # Creates a new time object with the value given by time, the given number
  # of seconds_with_frac, or seconds and microseconds_with_frac from the
  # Epoch. seconds_with_frac and microseconds_with_frac can be Integer, Float,
  # Rational, or other Numeric. non-portable feature allows the offset to be
  # negative on some systems.
  #
  # @example
  #     R.Time.at(0)            #=> 1969-12-31 18:00:00 -0600
  #     R.Time.at(Time.at(0))   #=> 1969-12-31 18:00:00 -0600
  #     R.Time.at(946702800)    #=> 1999-12-31 23:00:00 -0600
  #     R.Time.at(-284061600)   #=> 1960-12-31 00:00:00 -0600
  #     R.Time.at(946684800.2).usec() #=> 200000
  #     R.Time.at(946684800, 123456.789).nsec() #=> 123456789
  #
  @at: (seconds, microseconds) ->
    throw R.TypeError.new() if seconds is null
    if microseconds != undefined
      if microseconds is null or R(microseconds).is_string?
        throw R.TypeError.new()
      else
        microseconds = RCoerce.to_num_native(microseconds)
    else
      microseconds = 0

    seconds = R(seconds)
    if seconds.is_time?
      secs = seconds.to_i()
      msecs = secs * 1000 + microseconds / 1000
      new R.Time(new Date(msecs), time.utc_offset())
    else if seconds.is_numeric?
      secs = seconds.valueOf()
      msecs = secs * 1000 + microseconds / 1000
      new R.Time(new Date(msecs), @_local_timezone())
    else
      throw R.TypeError.new()


  @local: (year, month, day, hour, min, sec) ->
    # date = new Date(year, (month || 1) - 1, day || 1, hour || 0, min || 0, sec || 0)
    R.Time.new(year, month, day, hour, min, sec, @_local_timezone())


  # Creates a time based on given values, interpreted as UTC (GMT). The year
  # must be specified. Other values default to the minimum value for that
  # field (and may be nil or omitted). Months may be specified by numbers from
  # 1 to 12, or by the three-letter English month names. Hours are specified
  # on a 24-hour clock (0..23). Raises an ArgumentError if any values are out
  # of range. Will also accept ten arguments in the order output by Time#to_a.
  # sec_with_frac and usec_with_frac can have a fractional part.
  #
  # @example
  #     R.Time.utc(2000,"jan",1,20,15,1)  #=> 2000-01-01 20:15:01 UTC
  #     R.Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  #
  # @alias #gm
  # @todo unsupported c-style syntax R.Time.gm(1, 15, 20, 1, 1, 2000, 'ignored', 'ignored', 'ignored', 'ignored')
  #
  @utc: (year, month, day, hour, min, sec) ->
    date = new Date(Date.UTC(year, (month || 1) - 1, day || 1, hour || 0, min || 0, sec || 0))
    new R.Time(date, 0)


  # @alias #utc
  #
  @gm: @utc


  # Synonym for Time.new. Returns a Time object initialized to the current
  # system time.
  #
  @now: ->
    R.Time.new()


  # @private
  #
  # ICT: (+07:00) -> 420 * 60 -> 25200
  # GMT: (+01:00) ->  60 * 60 -> 3600
  # UCT: (+00:00) ->          -> 0
  #
  @_local_timezone: ->
    new Date().getTimezoneOffset() * -60


  # ---- RubyJSism ------------------------------------------------------------


  is_time: -> true


  # ---- Javascript primitives --------------------------------------------------


  '<=>': (other) ->
    secs = @valueOf()
    other = other.valueOf()
    if secs < other
      -1
    else if secs > other
      1
    else
      0

  cmp: @prototype['<=>']


  '==': (other) ->
    other = R(other)
    return false unless other.is_time?
    @['<=>'](other) is 0


  # Difference—Returns a new time that represents the difference between two
  # times, or subtracts the given number of seconds in numeric from time.
  #
  # t = Time.now       #=> 2007-11-19 08:23:10 -0600
  # t2 = t + 2592000   #=> 2007-12-19 08:23:10 -0600
  # t2 - t             #=> 2592000.0
  # t2 - 2592000       #=> 2007-11-19 08:23:10 -0600
  #
  '-': (other) ->
    throw R.TypeError.new() unless other?
    other = R(other)

    if other.is_numeric?
      tmstmp = @valueOf() - (other.valueOf() * 1000)
      return new R.Time(new Date(tmstmp), @__utc_offset__)
    else if other.is_time?
      new R.Float((@valueOf() - other.valueOf()) / 1000)
    else
      throw R.TypeError.new()


  # Addition—Adds some number of seconds (possibly fractional) to time and
  # returns that value as a new time.
  #
  # @example
  #
  #     t = Time.now()       #=> 2007-11-19 08:22:21 -0600
  #     t + (60 * 60 * 24)   #=> 2007-11-20 08:22:21 -0600
  #
  '+': (other) ->
    throw R.TypeError.new() unless other?

    tpcast = R(other)
    if typeof other != 'number' || !tpcast.is_numeric?
      if !tpcast.is_time? && other.to_f?
        other = other.to_f()
      else
        throw R.TypeError.new()

    tmstmp = @valueOf() + other.valueOf() * 1000
    new R.Time(new Date(tmstmp), @__utc_offset__)


  # Returns a canonical string representation of time.
  #
  # Time.now.asctime   #=> "Wed Apr  9 08:56:03 2003"
  #
  # @alias #ctime
  #
  asctime: ->
    @strftime("%a %b %e %H:%M:%S %Y")


  # @alias #asctime
  ctime: @prototype.asctime


  dup: ->
    new R.Time(new Date(@__native__), @__utc_offset__)


  year: ->
    # getYear() returns 2 or 3 digit year
    new R.Fixnum(@_tzdate.getFullYear())


  # @alias #mon
  month: ->
    new R.Fixnum(@_tzdate.getMonth() + 1)


  mon: @prototype.month


  monday: ->
    @wday().to_native() is 1


  tuesday: ->
    @wday().to_native() is 2


  wednesday: ->
    @wday().to_native() is 3


  thursday: ->
    @wday().to_native() is 4


  friday: ->
    @wday().to_native() is 5


  saturday: ->
    @wday().to_native() is 6


  sunday: ->
    @wday().to_native() is 0




  # Returns the day of the month (1..n) for time.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-19 08:27:03 -0600
  #     t.day()          #=> 19
  #     t.mday()         #=> 19
  #
  # @alias #mday
  #
  day: ->
    new R.Fixnum(@_tzdate.getDate())


  # @alias #day
  mday: @prototype.day


  # Returns a new new_time object representing time in UTC.
  #
  # @example
  #     t = R.Time.local(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 -0600
  #     t.gmt()                              #=> false
  #     y = t.getgm()                        #=> 2000-01-02 02:15:01 UTC
  #     y.gmt())                             #=> true
  #     t == y                               #=> true
  #
  # @alias #getutc
  #
  getgm: ->
    new R.Time(@__native__, 0)


  getutc: @prototype.getgm


  # Returns true if time represents a time in UTC (GMT).
  #
  # @example
  #
  #     t = Time.now()                      #=> 2007-11-19 08:15:23 -0600
  #     t.utc(                              #=> false
  #     t = Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  #     t.utc()                             #=> true
  #
  #     t = Time.now()                      #=> 2007-11-19 08:16:03 -0600
  #     t.gmt()                             #=> false
  #     t = Time.gm(2000,1,1,20,15,1)       #=> 2000-01-01 20:15:01 UTC
  #     t.gmt()                             #=> true
  #
  # @alias #is_utc
  #
  gmt: ->
    @__utc_offset__ == 0


  # @alias #gmt
  is_utc: @prototype.gmt


  # Returns the offset in seconds between the timezone of time and UTC.
  #
  # @offset
  #     t = R.Time.gm(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  #     t.gmt_offset()                    #=> 0
  #     l = t.getlocal()                  #=> 2000-01-01 14:15:01 -0600
  #     l.gmt_offset()                    #=> -21600
  #
  # @alias #gmtoff, #utc_offset
  #
  # @return R.Fixnum offset in seconds
  #
  gmt_offset: ->
    new R.Fixnum(@__utc_offset__)


  # @alias #gmt_offset
  gmtoff:     @prototype.gmt_offset


  # @alias #gmt_offset
  utc_offset: @prototype.gmt_offset


  # Converts time to UTC (GMT), modifying the receiver.
  #
  # t = Time.now   #=> 2007-11-19 08:18:31 -0600
  # t.gmt?         #=> false
  # t.gmtime       #=> 2007-11-19 14:18:31 UTC
  # t.gmt?         #=> true
  #
  gmtime: ->
    @_tzdate = new Date(@__native__ - @__utc_offset__ * 1000)
    @__utc_offset__ = 0
    this


  hour: ->
    new R.Fixnum(@_tzdate.getHours())


  hour12: ->
    new R.Fixnum(@_tzdate.getHours() % 12)


  inspect: ->
    if @gmt()
      @strftime('%Y-%m-%d %H:%M:%S UTC')
    else
      @strftime('%Y-%m-%d %H:%M:%S %z')

  # Returns the minute of the hour (0..59) for time.
  #
  # @example
  #
  #     t = R.Time.now()   #=> 2007-11-19 08:25:51 -0600
  #     t.min()            #=> 25
  #
  min: ->
    new R.Fixnum(@_tzdate.getMinutes())


  # Returns the second of the minute (0..60)[Yes, seconds really can range
  # from zero to 60. This allows the system to inject leap seconds every now
  # and then to correct for the fact that years are not really a convenient
  # number of hours long.] for time.
  #
  # @example
  #
  #     t = R.Time.now()   #=> 2007-11-19 08:25:02 -0600
  #     t.sec()            #=> 2
  #
  sec: ->
    new R.Fixnum(@_tzdate.getSeconds())


  # @todo: implement %N
  strftime: (format) ->
    locale = R.Time.LOCALE

    fill = @_rjust

    self = this
    out = format.replace /%(.)/g, (_, flag) ->
      switch flag
        when 'a' then locale.DAYS_SHORT[self.wday()]
        when 'A' then locale.DAYS[self.wday()]
        when 'b' then locale.MONTHS_SHORT[self.month()]
        when 'B' then locale.MONTHS[self.month()]
        when 'C' then self.year() % 100
        when 'd' then fill(self.day())
        when 'D' then self.strftime('%m/%d/%y')
        when 'e' then fill(self.day(), ' ') # TODO write spec for this
        when 'F' then self.strftime('%Y-%m-%d')
        when 'h' then locale.MONTHS_SHORT[self.month()]
        when 'H' then fill(self.hour())
        when 'I' then fill(self.hour12())
        when 'j'
          jtime = new Date(self.year(), 0, 1).getTime()
          Math.ceil((self._tzdate.getTime() - jtime) / (1000*60*60*24))
        when 'k' then self.hour().to_s().rjust(2, ' ')
        # when 'L' then pad(Math.floor(d.getTime() % 1000), 3)
        when 'l' then fill(self.hour12(), ' ')
        when 'm' then fill(self.month())
        when 'M' then fill(self.min())
        when 'n' then "\n"
        when 'N' then throw R.NotImplementedError.new()
        when 'p'
          if self.hour() < 12 then locale.AM     else locale.PM
        when 'P'
          if self.hour() < 12 then locale.AM_LOW else locale.PM_LOW
        when 'r' then self.strftime('%I:%M:%S %p')
        when 'R' then self.strftime('%H:%M')
        when 'S' then fill(self.sec())
        # when 's' then Math.floor((d.getTime() - msDelta) / 1000)
        when 't' then "\t"
        when 'T' then self.strftime('%H:%M:%S')
        when 'u'
          day = self.wday().to_native()
          if day == 0 then 7 else day
        when 'v' then self.strftime('%e-%b-%Y')
        when 'w' then self.wday()
        when 'y' then self.year().to_s().slice(-2, 2)
        when 'Y' then self.year()
        when 'x' then self.strftime('%m/%d/%y')
        when 'X' then self.strftime('%H:%M:%S')
        when 'z' then self._offset_str()
        when 'Z' then self.zone()
        else flag

    new R.String(out)


  succ: ->
    R.Time.at(@to_i().succ())


  # Returns the value of time as an integer number of seconds since the Epoch.
  #
  # @example
  #     t = R.Time.now()
  #     "%10.5f" % t.to_f   #=> "1270968656.89607"
  #     t.to_i              #=> 1270968656
  #
  to_i: ->
    R(@__native__.getTime() / 1000).to_i()


  # Returns the value of time as a floating point number of seconds since the
  # Epoch.
  #
  # t = R.Time.now()
  # "%10.5f" % t.to_f   #=> "1270968744.77658"
  # t.to_i              #=> 1270968744
  # Note that IEEE 754 double is not accurate enough to represent number of nanoseconds from the Epoch.
  #
  to_f: ->
    new R.Float(@to_i() + ((@valueOf() % 1000) / 1000))


  to_s: @prototype.inspect


  __tz_delta__: ->
    @__utc_offset__ + R.Time._local_timezone()

  # Return 0 if local timezone matches gmt_offset.
  # otherwise the difference to UTC
  __utc_delta__: ->
    @gmt_offset() + R.Time._local_timezone()


  tv_sec: @prototype.to_i


  # Returns just the number of microseconds for time.
  #
  # @example
  #     t = Time.now        #=> 2007-11-19 08:03:26 -0600
  #     "%10.6f" % t.to_f   #=> "1195481006.775195"
  #     t.usec              #=> 775195
  #
  # @alias #usec
  # @todo implement
  #
  tv_usec: ->
    # valueOf is milliseconds since epochs.
    # get the milliseconds only and convert to microsecs
    new R.Fixnum((@_tzdate.valueOf() % 1000)*1000)


  usec: @prototype.tv_usec


  # Returns an integer representing the day of the week, 0..6, with Sunday == 0.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-20 02:35:35 -0600
  #     t.wday()         #=> 2
  #     t.sunday()      #=> false
  #     t.monday()      #=> false
  #     t.tuesday()     #=> true
  #     t.wednesday()   #=> false
  #     t.thursday()    #=> false
  #     t.friday()      #=> false
  #     t.saturday()    #=> false
  #
  wday: ->
    # time zone adjusted date
    new R.Fixnum(@_tzdate.getDay())


  # Returns an integer representing the day of the year, 1..366.
  #
  # @example
  #     t = Time.now()   #=> 2007-11-19 08:32:31 -0600
  #     t.yday()         #=> 323
  yday: ->
    ytd    = new Date(@year(),0,0)
    secs   = @__native__.getTime() + @gmt_offset() * 1000 - ytd.getTime()
    R(Math.floor(secs / 86400000)) # 24 * 60 * 60 * 1000


  valueOf: ->
    @__native__.valueOf()


  # Returns the name of the time zone used for time. As of Ruby 1.8, returns
  # “UTC” rather than “GMT” for UTC times.
  #
  # @example
  #     t = R.Time.gm(2000, "jan", 1, 20, 15, 1)
  #     t.zone()   #=> "UTC"
  #     t = Time.local(2000, "jan", 1, 20, 15, 1)
  #     t.zone()   #=> "CST"
  # zone: ->
  #   t = Math.floor(@gmt_offset() / 60 * 60)
  #   for own zone, i in R.Time.TIME_ZONES
  #     return R(zone) if t == i
  #   null
  #
  # @todo implement
  zone: ->
    if @gmt()
      new R.String('UTC')
    else
      throw R.NotImplementedError.new("Time#zone only supports UTC/GMT")

  # ---- Private methods ------------------------------------------------------

  _rjust: (fixnum, str = '0') ->
    new R.String(fixnum + "").rjust(2, str)


  _offset_str: ->
    mins = @gmt_offset() / 60
    if mins == 0
      return '+0000'

    sign = if mins > 0 then '+' else '-'
    mins = Math.abs(mins)
    hour = @_rjust(Math.ceil(mins / 60))
    mins = @_rjust(mins % 60)
    (sign+hour+mins)


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  eql: @prototype['==']


# This file is included at the end of the compiled javascript and
# setups the RubyJS environment

RubyJS.pollute_global()
RubyJS.pollute_more()
root.puts = _puts
