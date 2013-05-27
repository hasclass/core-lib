class NumericMethods
  cmp: (num, other) ->
    if num is other then 0 else null


  abs: (num) ->
    if num < 0 then (- num) else num


  abs2: (num) ->
    return num if @nan(num)
    Math.pow(num, 2)


  ceil: (num) ->
    Math.ceil(num)


  divmod: (num, other) ->
    quotient = Math.floor(num / other)
    modulus  = num % other

    [quotient, modulus]


  downto: (num, stop, block) ->
    stop = Math.ceil(stop)

    while num >= stop
      block( num )
      num -= 1

    num


  eql: (num, other) ->
    num == other


  floor: (num) ->
    Math.floor(num)


  nonzero: (num) ->
    if num is 0 then null else num


  # remainder: (other) ->
  #   other = @box(other)
  #   mod = @['%'](other)

  #   if !mod['=='](0) and ((@['<'](0) && other['>'](0)) or (@['>'](0) && other['<'](0)))
  #     mod['-'](other)
  #   else
  #     mod



  step: (num, limit, step = 1, block) ->
    unless block?.call?
      block = step
      step  = 1

    if step is 0
      throw new R.ArgumentError("ArgumentError")

    float_mode = num % 1 is 0 or limit % 1 is 0 or step % 1 is 0
    # eps = 0.0000000000000002220446049250313080847263336181640625
    if float_mode
      # For some reason the following ported code is not needed.
      # it appears to work properly in js withouth the Float::EPSILON
      # err = (num.abs().plus(limit.abs()).plus(limit.minus(num).abs()).divide(step.abs())).multiply(eps)
      # err = 0.5 if err.gt(0.5)
      # n   = (limit.minus(num)).divide(step.plus(err)).floor()
      n = (limit - num) / step
      i = 0
      if step > 0
        while i <= n
          d = i * step + num
          d = limit if limit < d
          block(d)
          i += 1
      else
        while i <= n
          d = i * step + num
          d = limit if limit > d
          block(d)
          i += 1
    else
      if step > 0
        until num > limit
          block(num)
          num += step
      else
        until num < limit
          block(num)
          num += step
    this



  # truncate: (num) ->
  #   @to_f().truncate()


  upto: (num, stop, block) ->
    stop = Math.floor(stop)

    while num <= stop
      block( num ) #for i in [@to_native()..stop]
      num += 1

    num

  zero: (num) ->
    num is 0


  even: (num) ->
    num % 2 == 0


  gcd: (num, other) ->
    t = null
    while (other != 0)
      t = other
      other = num % other
      num = t

    if num < 0 then (- num) else num


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


  numerator: (num) ->
    if num < 0 then (- num) else num


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
  next: (num) ->
    num + 1


  # Returns the Integer equal to int - 1.
  #
  # @example
  #
  #     R(1).pred()    #=> 0
  #     R(-1).pred()   #=> -2
  #
  # @return [R.Fixnum]
  #
  pred: (num) ->
    num - 1


  round: (num, n) ->
    return num if n is undefined

    multiplier = Math.pow(10, n)
    Math.round(num * multiplier) / multiplier


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
  times: (num, block) ->
    # return @to_enum('times') unless block?.call?
    if num > 0
      idx = 0
      while idx < num
        block( idx )
        idx = idx + 1
      num
    else
      num


  magnitude: @prototype.abs

  succ: @prototype.next

_num = R._num = new NumericMethods()