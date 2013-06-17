# Breaker is a class for adding support to breaking out of functions
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
  constructor: (@return_value = null) ->

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
    @return_value = return_value
    throw this


  handle_break: (e) ->
    if this is e
      return (e.return_value)
    else
      throw e
