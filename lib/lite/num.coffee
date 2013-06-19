
class NumericMethods

  cmp: (num, other) ->
    if num is other then 0 else null

  # Returns the absolute value of num.
  #
  # @example
  #     _n.abs(12)          #=> 12
  #     _n.abs(-34.56)      #=> 34.56
  #
  # @return [Numeric]
  #
  abs: (num) ->
    if num < 0 then (- num) else num

  # Returns square of num.
  #
  # @example
  #     _n.abs2(2)          #=> 4
  #     _n.abs2(-4)         #=> 16
  #
  # @return [Numeric]
  #
  abs2: (num) ->
    return num if @nan?(num)
    Math.pow(num, 2)

  # Returns the smallest Integer greater than or equal to num. Class Numeric achieves this by converting itself to
  # a Float then invoking Float#ceil.
  #
  # @example
  #     _n.ceil(1)      #=> 1
  #     _n.ceil(1.2)    #=> 2
  #     _n.ceil(-1.2)   #=> -1
  #     _n.ceil(-1)     #=> -1
  #
  # @return [Fixnum]
  #
  ceil: (num) ->
    Math.ceil(num)


  divmod: (num, other) ->
    quotient = Math.floor(num / other)
    modulus  = num % other

    [quotient, modulus]


  downto: (num, stop, block) ->
    return __enumerate(_num.downto, [num, stop]) unless block?.call?
    stop = Math.ceil(stop)

    idx = num
    while idx >= stop
      block( idx )
      idx -= 1

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

  #   if !mod.equals(0) and ((@lt(0) && other.gt(0)) or (@gt(0) && other['lt'](0)))
  #     mod.minus(other)
  #   else
  #     mod



  step: (num, limit, step = 1, block) ->
    unless block?.call? or step?.call?
      return __enumerate(_num.step, [num, limit, step])


    unless block?.call?
      block = step
      step  = 1


    if step is 0
      _err.throw_argument()

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
    return __enumerate(_num.upto, [num, stop]) unless block?.call?
    stop = Math.floor(stop)

    idx = num
    while idx <= stop
      block( idx )
      idx += 1

    num

  zero: (num) ->
    num is 0


  even: (num) ->
    num % 2 == 0


  gcd: (num, other) ->
    t = null
    other = __int(other)
    while (other != 0)
      t = other
      other = num % other
      num = t

    if num < 0 then (- num) else num


  # Returns an array; [int.gcd(int2), int.lcm(int2)].
  #
  # @example
  #
  #     _n.gcdlcm(2,  2)                   #=> [2, 2]
  #     _n.gcdlcm(3, -7)                   #=> [1, 21]
  #     _n.gcdlcm((1<<31)-1, (1<<61)-1)    #=> [1, 4951760154835678088235319297]
  #
  # @return [Array<Number, Number>]
  #
  gcdlcm: (num, other) ->
    other = __int(other)
    [_num.gcd(num, other), _num.lcm(num, other)]


  # Returns the least common multiple (always positive). 0.lcm(x) and x.lcm(0) return zero.
  #
  # @example
  #
  #     _n.lcm(2,  2)                   #=> 2
  #     _n.lcm(3, -7)                   #=> 21
  #     _n.lcm((1<<31)-1, (1<<61)-1)    #=> 4951760154835678088235319297
  #
  # @return [Number]
  #
  lcm: (num, other) ->
    other = __int(other)

    lcm = num * other / _num.gcd(num, other)
    _num.numerator(lcm)


  numerator: (num) ->
    if num < 0 then (- num) else num


  # Returns true if int is an odd number.
  #
  # @return [Boolean]
  #
  odd: (num) ->
    num % 2 == 1


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

    multiplier = Math.pow(10, __int(n))
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
    return __enumerate(_num.times, [num]) unless block?.call?
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