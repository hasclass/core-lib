# Methods in Base are added to `R`.
#
class RubyJS.Base extends RubyJS.Object
  @include R.Kernel

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
  pollute_global: ->
    if arguments.length is 0
      args = ['_str', '_arr', '_enum', 'proc', 'puts', 'truthy', 'falsey', 'inspect']
    else
      args = arguments

    for method in args
      if root[method]?
        R.puts("pollute_global(): #{method} already exists.")
      else
        root[method] = @[method]

    null


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
  proc: (key, args...) ->
    if args.length == 0
      (el) -> el[key]()
    else
      (el) -> el[key].apply(el, args)


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
      a.equals(b)
    else if typeof b is 'object'
      b.equals(a)
    else
      a == b

  is_eql: (a, b) ->
    if typeof a is 'object'
      a.eql(b)
    else if typeof b is 'object'
      b.eql(a)
    else
      a == b


  extend: (obj, mixin) ->
    obj[name] = method for name, method of mixin
    obj


# adds all methods to the global R object
for name, method of RubyJS.Base.prototype
  RubyJS[name] = method
