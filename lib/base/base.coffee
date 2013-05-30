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
