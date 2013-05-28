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
      if root[name]?
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
  proc: (key, args...) ->
    if args.length == 0
      (el) ->
        fn = el[key]
        if typeof fn is 'function' then fn.call(el) else fn
    else
      (el) -> el[key].apply(el, args)


  fn: (func, args...) ->
    (el) ->
      func.apply(null, [el].concat(args))


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
        a == b
    else if typeof b is 'object'
      if b.equals?
        b.equals(a)
      else if b['==']?
        b['=='](a)
      else
        a == b
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
for own name, method of RubyJS.Base.prototype
  RubyJS[name] = method
