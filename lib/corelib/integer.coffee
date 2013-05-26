# Integer is a module for Integer number formats. The actual implementation is
# Fixnum.
#
# @mixin
class RubyJS.Integer extends RubyJS.Numeric

  # ---- Constructors & Typecast ----------------------------------------------

  @new: (value) ->
    new R.Integer(value)


  @isInteger: (obj) ->
    @isNumeric(obj) && (obj % 1 is 0)


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_integer: -> true


  # ---- Javascript primitives --------------------------------------------------

  # @private
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

  # Iterates block, passing decreasing values from int down to and including
  # limit.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #    R(5).downto(1, function (n) { R.puts(n + ".. ") }
  #    # => 5.. 4.. 3.. 2.. 1..
  #
  # @param [Number] stop
  # @return [this]
  #
  downto: (stop, block) ->
    try
      stop = RCoerce.to_num_native(stop)
    catch err
      throw R.ArgumentError.new()

    unless block?.call?
      return R.Enumerator.new(this, 'downto', stop)

    _num.downto(@__native__, stop, block)
    this


  # Returns true if int is an even number.
  #
  # @return [Boolean]
  #
  even: ->
    @to_native() % 2 == 0


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
  #
  # @return [R.Fixnum,this]
  #
  numerator: ->
    if @lt(0)
      new R.Fixnum(@to_native() * -1)
    else
      this

  # Returns true if int is an odd number.
  #
  # @return [Boolean]
  #
  odd:  -> !@even()


  # Returns the int itself.
  #
  #      a.ord    #=> 97
  #
  # This method is intended for compatibility to character constant in Ruby
  # 1.9. For example, ?a.ord returns 97 both in 1.8 and 1.9.
  #
  # @return [this]
  #
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
    n = RCoerce.to_int_native(n)
    if n > 0
      @to_f()
    else if n is 0
      this
    else
      multiplier = Math.pow(10, n)
      new R.Fixnum(Math.round(@to_native() * multiplier) / multiplier)


  succ:  @prototype.next


  # Iterates block int times, passing in values from zero to int - 1.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #     R(5).times(function(i) { R.puts(i) })
  #     # => 0 1 2 3 4
  #
  # @return [this]
  #
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


  # As int is already an Integer, all these methods simply return the receiver
  # @return [this]
  to_i:   -> this


  # Iterates block, passing in integer values from int up to and including
  # limit.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #
  #     R(5).upto(10, function (i) { R.puts(i + " " })
  #     # => 5 6 7 8 9 10
  #
  # @param [Number] stop
  # @return [this]
  #
  upto: (stop, block) ->
    try
      stop = RCoerce.to_num_native(stop)
    catch err
      throw R.ArgumentError.new()

    unless block?.call?
      return R.Enumerator.new(this, 'upto', stop)

    _num.upto(@__native__, stop, block)


  # @return [String]
  toString: -> "#{@to_native()}"


  # ---- Private methods ------------------------------------------------------

  # @private
  __ensure_integer__: (other) ->
    throw RubyJS.TypeError.new() unless other?.is_integer?


  # ---- Aliases --------------------------------------------------------------


  to_int:   @prototype.to_i
  truncate: @prototype.to_i


