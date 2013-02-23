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


  # Returns true if int is an even number.
  #
  # @return [Boolean]
  #
  even: -> @to_native() % 2 == 0


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
  numerator: ->
    if @lt(0)
      @$Integer(@to_native() * -1)
    else
      this

  # Returns true if int is an odd number.
  #
  # @return [Boolean]
  #
  odd:  -> !@even()


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


