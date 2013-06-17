R.Support = {}

# Creates a wrapper method that calls a functional style
# method with this as the first arguments
#
#     callFunctionWithThis(_s.ljust)
#     // creates a function similar to this:
#     // function (len, pad) {
#     //    return _s.ljust(this, len, pad)
#     // }
#
# This can be used to extend native classes/prototypes with functional
# methods.
#
#     String.prototype.capitalize = callFunctionWithThis(_s.capitalize)
#     "foo".capitalize() // => "Foo"
#
callFunctionWithThis = (func) ->
  (a, b, c, d, e, f) ->
    idx = arguments.length
    while idx--
      break if arguments[idx] isnt undefined

    val = this.valueOf()
    switch idx + 1
      when 0 then func(val)
      when 1 then func(val, a)
      when 2 then func(val, a, b)
      when 3 then func(val, a, b, c)
      when 4 then func(val, a, b, c, d)
      when 5 then func(val, a, b, c, d, e)
      when 6 then func(val, a, b, c, d, e, f)
      # Slow fallback when passed more than 6 arguments.
      else func.apply(null, [val].concat(nativeSlice.call(arguments, 0)))

R.Support.callFunctionWithThis = callFunctionWithThis