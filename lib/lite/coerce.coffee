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
_coerce =

  native: (obj) ->
    if typeof obj != 'object'
      obj
    else
      obj.valueOf()


  str: (obj) ->
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid string") unless typeof obj is 'string'
    throw R.TypeError.new() unless typeof obj is 'string'
    obj


  num: (obj) ->
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid num") unless typeof obj is 'number'
    throw R.TypeError.new() unless typeof obj is 'number'
    obj


  int: (obj) ->
    obj = obj.valueOf() if typeof obj is 'object'
    # throw new R.TypeError("#{obj} is not a valid int") unless typeof obj is 'number'
    throw R.TypeError.new() unless typeof obj is 'number'
    Math.floor(obj)


  isArray: nativeArray.isArray or (obj) ->
    nativeToString.call(obj) is '[object Array]'


  is_arr: (obj) ->
    typeof obj is 'object' && obj != null && _coerce.isArray(obj.valueOf())


  arr: (obj) ->
    throw R.TypeError.new() if typeof obj != 'object'
    obj = obj.valueOf()
    throw R.TypeError.new() unless _coerce.isArray(obj)
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

__str = _coerce.str
__int = _coerce.int
__num = _coerce.num
__arr = _coerce.arr
__isArr = _coerce.is_arr
