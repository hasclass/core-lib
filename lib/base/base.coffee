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
      args = ['w', 'fn', '_str', '_arr', '_itr', '_hsh', '_time', '_num', 'proc', 'puts', 'truthy', 'falsey', 'inspect']
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
      _itr:  '_i'
      _hsh:  '_h'
      _time:  '_t'

    for k,v of shortcuts
      root[v] = root[k]


  # Adds RubyJS methods to JS native classes.
  #
  #     RubyJS.i_am_feeling_evil()
  #     ['foo', 'bar'].rb_map(proc('rb_reverse')).rb_sort()
  #     # =>['oof', 'rab']
  #
  god_mode: (prefix = 'rb_', overwrite = false) ->
    overwrites = [
      [Array.prototype,  _arr],
      [Number.prototype, _num],
      [String.prototype, _str],
      [Date.prototype,   _time]
    ]

    for [proto, methods] in overwrites
      for name, func of methods
        new_name = prefix + name

        if typeof func == 'function'
          if overwrite or proto[new_name] is undefined
            do (new_name, func) ->
              # The following is 100x faster than slicing.
              proto[new_name] = callFunctionWithThis(func)
          else
            console.log("#{proto}.#{new_name} exists. skipped.")


  i_am_feeling_evil: ->
    @god_mode('', true)
    "harr harr"


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
  proc: (key) ->
    if arguments.length == 1
      # Wrapper block doesnt need to mangle arguments
      (el) ->
        fn = el[key]
        if typeof fn is 'function'
          fn.call(el)
        else if fn is undefined
          # RELOADED: dont use R()
          R(el)[key]().valueOf()
        else
          fn
    else
      args = nativeSlice.call(arguments, 1)
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


  respond_to: (obj, function_name) ->
    obj[function_name] != undefined


  # Compares to objects.
  #
  #      // => true
  #      R.is_equal(1,1)
  #      R.is_equal(1, new Number(1))
  #      R.is_equal(1, {valueOf: function () {return 1;}})
  #      R.is_equal(1, {equals: function (n) {return n === 1;}})
  #
  is_equal: (a, b) ->
    return true if a is b

    if typeof a is 'object'
      if a.equals?
        a.equals(b)
      else if __isArr(a)
        _arr.equals(a,b)
      else if a.valueOf?
        a.valueOf() is b.valueOf()
      else
        false
    else if typeof b is 'object'
      if b.equals?
        b.equals(a)
      else if __isArr(b)
        _arr.equals(a,b)
      else if b.valueOf?
        b.valueOf() is a.valueOf()
      else
        false
    else
      # for elements that are literals
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



  # helper method to get an arguments object
  argify: -> arguments




# adds all methods to the global R object
for own name, method of RubyJS.Base.prototype
  RubyJS[name] = method


__falsey = R.falsey
__truthy = R.truthy
__equals = R.is_equal

