_num = R._num =

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


  round: (num, n) ->
    num.round(n)


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



_num.magnitude = _num.abs