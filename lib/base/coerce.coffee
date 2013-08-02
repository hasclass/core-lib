# Singleton class for type coercion inside RubyJS.
#
# @private
RubyJS.coerce = _coerce =

  native: (obj) ->
    if typeof obj != 'object'
      obj
    else
      obj.valueOf()


  str: (obj) ->
    _err.throw_type() if obj == null
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid string") unless typeof obj is 'string'
    _err.throw_type() unless typeof obj is 'string'
    obj


  try_str: (obj) ->
    return obj if typeof obj is 'string'
    obj = obj.valueOf() if obj isnt null
    return obj if typeof obj is 'string'
    null


  num: (obj) ->
    _err.throw_type() if obj == null
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid num") unless typeof obj is 'number'
    _err.throw_type() unless typeof obj is 'number'
    obj


  int: (obj) ->
    _err.throw_type() if obj == null
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid int") unless typeof obj is 'number'
    _err.throw_type() unless typeof obj is 'number'
    Math.floor(obj)


  isArray: nativeArray.isArray or (obj) ->
    nativeToString.call(obj) is '[object Array]'


  is_arr: (obj) ->
    typeof obj is 'object' && obj != null && _coerce.isArray(obj.valueOf())


  is_str: (obj) ->
    return true if typeof obj is 'string'
    typeof obj is 'object' && obj != null && typeof obj.valueOf() is 'string'


  is_rgx: (obj) ->
    return false unless obj?
    nativeToString.call(obj.valueOf()) is '[object RegExp]'


  arr: (obj) ->
    _err.throw_type() if obj == null
    _err.throw_type() if typeof obj != 'object'
    obj = obj.valueOf()
    _err.throw_type() unless _coerce.isArray(obj)
    obj


  split_args: (args, offset) ->
    arg_len = args.length

    ary = []
    idx = offset
    while idx < arg_len
      el = args[idx]
      ary.push(el) unless el is undefined
      idx += 1

    ary


  # Use call_with when you want to delegate a method call to a functional one
  # when the original method has flexible length of arguments.
  #
  # @example
  #   class RString
  #     #   new RString("foo").count('o')
  #     #   new RString("foo").count('o', 'of')
  #     count: () ->
  #       __call( _str.count, @__native__, arguments)
  #
  call_with: (func, thisArg, args) ->
    a = args
    switch args.length
      when 0 then func(thisArg)
      when 1 then func(thisArg, a[0])
      when 2 then func(thisArg, a[0], a[1])
      when 3 then func(thisArg, a[0], a[1], a[2])
      when 4 then func(thisArg, a[0], a[1], a[2], a[3])
      when 5 then func(thisArg, a[0], a[1], a[2], a[3], a[4])
      when 6 then func(thisArg, a[0], a[1], a[2], a[3], a[4], a[5])
      # Slow fallback when passed more than 6 arguments.
      else func.apply(null, [thisArg].concat(nativeSlice.call(args, 0)))


  cmp: (a, b) ->
    if typeof a isnt 'object' and typeof a is typeof b
      if a is b
        0
      else
        if a < b then -1 else 1
    else
      if __isArr(a)
        _arr.cmp(a, b)
      else
        a = R(a)
        throw 'NoMethodError' unless a.cmp?
        a.cmp(b)


  cmpstrict: (a, b) ->
    if typeof a is typeof b and typeof a isnt 'object'
      if a is b
        0
      else
        if a < b then -1 else 1
    else
      a = R(a)
      throw 'NoMethodError' unless a.cmp?
      cmp = a.cmp(b)
      _err.throw_argument() if cmp is null
      cmp



__str   = _coerce.str
__int   = _coerce.int
__num   = _coerce.num
__arr   = _coerce.arr
__isArr = _coerce.is_arr
__isStr = _coerce.is_str
__isRgx = _coerce.is_rgx
__call  = _coerce.call_with
__cmp   = _coerce.cmp
__cmpstrict = _coerce.cmpstrict
__try_str   = _coerce.try_str
