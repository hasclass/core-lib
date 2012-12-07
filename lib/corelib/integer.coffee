# Integer is a module for Integer number formats. The actual implementation is
# Fixnum.
#
# @mixin
class RubyJS.Integer extends RubyJS.Numeric

  # ---- Constructors & Typecast ----------------------------------------------

  @new: (value) ->
    new Integer(value)


  @isInteger: (obj) ->
    @isNumeric(obj) && (obj % 1 is 0)


  # ---- RubyJSism ------------------------------------------------------------

  is_integer: -> true


  # ---- Javascript primitives --------------------------------------------------

  unbox: -> @to_native()


  # ---- Instance methods -----------------------------------------------------


  chr: ->
    new R.String(String.fromCharCode(@to_native()))


  denominator: ->
    new R.Fixnum(1)


  # TODO: remove dog food
  upto: (stop, block) ->
    stop = R(stop)

    throw RubyJS.ArgumentError.new() unless stop?.to_int?
    return RubyJS.Enumerator.new(this, 'upto', stop) unless block && block.call?

    stop = stop.floor().to_native()
    return this unless @to_native() <= stop

    idx = @to_native()
    while idx <= stop
      block( new R.Fixnum(idx) ) #for i in [@to_native()..stop]
      idx += 1

    this


  downto: (stop, block) ->
    stop = R(stop)

    throw RubyJS.ArgumentError.new() unless stop?.to_int?
    return RubyJS.Enumerator.new(this, 'downto', stop) unless block && block.call?

    stop = Math.ceil(stop.to_native())
    return this unless @to_native() >= stop

    idx  = @to_native()
    while idx >= stop
      block( new R.Fixnum(idx) )
      idx = idx - 1

    this


  even: -> @to_native() % 2 == 0


  gcd: (other) ->
    other = @box(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    a = @to_native()
    b = other.to_native()
    t = null
    while (b != 0)
      t = b
      b = a % b
      a = t
    new R.Fixnum(a).numerator()


  gcdlcm: (other) ->
    other = @box(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    new R.Array([@gcd(other), @lcm(other)])


  lcm: (other) ->
    other = R(other)
    @__ensure_args_length(arguments, 1)
    @__ensure_integer__(other)

    lcm = new R.Fixnum(@to_native() * other.to_native() / @gcd(other))
    lcm.numerator()


  numerator: ->
    if @lt(0)
      @$Integer(@to_native() * -1)
    else
      this


  odd:  -> !@even()


  ord:  ->
    this


  next: ->
    @plus(1)


  pred: ->
    @minus(1)


  round: (n) ->
    return this if n is undefined
    n = CoerceProto.to_int_native(n)
    if n > 0
      @to_f()
    else if n is 0
      this
    else
      multiplier = Math.pow(10, n)
      new R.Fixnum(Math.round(@to_native() * multiplier) / multiplier)


  succ:  @prototype.next


  times: (block) ->
    return @to_enum('times') unless block?.call?

    len = @to_native()
    if len > 0
      idx = 0
      while idx < len
        block( new R.Fixnum(idx) )
        idx = idx + 1
      this
    else
      this


  to_i:   -> this


  toString: -> "#{@to_native()}"


  # ---- Private methods ------------------------------------------------------

  __ensure_integer__: (other) ->
    throw RubyJS.TypeError.new() unless other?.is_integer?


  # ---- Aliases --------------------------------------------------------------


  to_int:   @prototype.to_i
  truncate: @prototype.to_i


