class RubyJS.Numeric extends RubyJS.Object

  # ---- Constructors & Typecast ----------------------------------------------

  # true for:
  #   - number primitive
  #   - native Number object
  #   - valueOf() returns a number primitive
  @isNumeric = (obj) ->
    # Returns early if obj for any primitive except number
    return true  if typeof obj is 'number'
    return false if typeof obj != 'object'
    return false if obj == null
    # Number implements valueOf and returns a primitive.
    # RubyJS Numerics also implement valueOf()
    (obj.valueOf? and typeof obj.valueOf() is 'number')



  @try_convert = (obj) ->
    return null unless @isNumeric(obj)
    @new(obj)
    # if RubyJS.Float.isFloat(obj)
    #   RubyJS.Float.new(obj)
    # else if RubyJS.Integer.isInteger(obj) # should be Fixnum really..
    #   RubyJS.Fixnum.new(obj)
    # else
    #   null

  @new: (value) ->
    if (value % 1 is 0) then new R.Fixnum(value) else new R.Float(value)


  @typecast: (value) ->
    if (value % 1 is 0) then new R.Fixnum(value) else new R.Float(value)


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_numeric: -> true


  # ---- Instance methods -----------------------------------------------------

  cmp: (other) ->
    if this is other then 0 else null


  # Returns the absolute value of num.
  #
  # @example
  #     R(12).abs()         #=> 12
  #     (-34.56).abs()      #=> 34.56
  #     R(-34.56).abs()     #=> 34.56
  #
  # @return [R.Numeric]
  #
  abs: ->
    if @['<'](0) then @uminus() else this


  # Returns square of self.
  #
  # @return [R.Numeric]
  #
  abs2: ->
    return this if @nan?()
    @abs()['**'](2)


  # Returns the smallest Integer greater than or equal to num. Class Numeric achieves this by converting itself to a Float then invoking Float#ceil.
  #
  # @example
  #     R(1).ceil()      #=> 1
  #     R(1.2).ceil()    #=> 2
  #     R(-1.2).ceil()   #=> -1
  #     R(-1.0).ceil()   #=> -1
  #
  # @return [R.Fixnum]
  #
  ceil: () ->
    @to_f().ceil()


  # If a Numeric is the same type as num, returns an array containing aNumeric
  # and num. Otherwise, returns an array with both aNumeric and num
  # represented as Float objects. This coercion mechanism is used by Ruby to
  # handle mixed-type numeric operations: it is intended to find a compatible
  # common type between the two operands of the operator.
  #
  # @example
  #     R(1).coerce(2.5)   #=> [2.5, 1.0]
  #     R(1.2).coerce(3)   #=> [3.0, 1.2]
  #     R(1).coerce(2)     #=> [2, 1]
  #
  # @todo this needs some serious love
  #
  coerce: (other) ->
    throw RubyJS.TypeError.new() if !other? or other is false
    other = R(other)
    # throw RubyJS.TypeError.new() unless other.to_f?
    if      other.is_string?    then @$Array [@$Float(other), @to_f()]
    else if other.constructor.prototype is @constructor.prototype then @$Array([other, this])
    else if other.is_float?     then @$Array [other, @to_f()]
    else if other.is_fixnum?    then @$Array [other, this]
    else if other.is_numeric?   then @$Array [other.to_f(), this.to_f()]
    else
      throw RubyJS.TypeError.new()


  # Uses / to perform division, then converts the result to an integer.
  # numeric does not define the / operator; this is left to subclasses.
  #
  # Equivalent to num.divmod(aNumeric).
  #
  # See {R.Numeric#divmod}
  #
  # @return [R.Float]
  #
  div: (other) ->
    other = @box(other)
    throw RubyJS.TypeError.new() unless other.to_int?
    throw new Error("ZeroDivisionError") if other.zero()
    @divide(other).floor()


  divmod: (other) ->
    # TODO: CLEANUP
    quotient = @div(other).floor()
    modulus  = @minus(quotient.multiply(other))

    new RArray([quotient.valueOf(), modulus.valueOf()])


  # Returns true if num and numeric are the same type and have equal values.
  #
  # @example
  #     new R.Fixnum(1).equals(new R.Float(1.0))  #=> true
  #     new R.Fixnum(1).eql(new R.Float(1.0))     #=> false
  #     new R.Float(1).eql(new R.Float(1.0))      #=> true
  #
  # @return [Boolean]
  #
  eql: (other) ->
    other = @box(other)
    return false unless other
    return false unless @__proto__ is other.__proto__
    if @['=='](other) then true else false


  # @return [R.String]
  inspect: -> new R.String(""+@to_native())

  # Returns float division.
  #
  # @return [R.Float]
  #
  fdiv: (other) ->
    other = RCoerce.to_num_native(other)
    @to_f()['/'](other)


  # Returns the largest integer less than or equal to num. Numeric implements this by converting anInteger to a Float and invoking Float#floor.
  #
  # @example
  #     R( 1).floor()   #=> 1
  #     R(-1).floor()   #=> -1
  #
  # @return [R.Fixnum]
  #
  floor: () ->
    @to_f().floor()


  # Returns the absolute value of num.
  #
  # @alias #abs
  #
  magnitude: ->
    @abs()

  # Alias to {#divmod}
  #
  # @alias #divmod
  modulo: (other) ->
    other = @box(other)
    # self - other * self.div(other)
    @['-']( other['*']( @div(other)) )


  # Returns self if num is not zero, nil otherwise. This behavior is useful
  # when chaining comparisons:
  #
  # @return [null, this]
  #
  nonzero: ->
    if @zero() then null else this


  # Returns most exact division (rational for integers, float for floats).
  quo: (other) ->
    other = @box(other)
    throw new Error("ZeroDivisionError") if other.zero()
    arr = @coerce(other)
    @['/'](arr.first())


  # Returns an array; [num, 0].
  rect: ->
    throw R.ArgumentError.new() if arguments.length > 0
    new R.Array([this, new R.Fixnum(0)])


  rectangular: @prototype.rect


  # x.remainder(y) means x-y*(x/y).truncate
  #
  # @see {R.Numeric#divmod}
  #
  remainder: (other) ->
    other = @box(other)
    mod = @['%'](other)

    if !mod['=='](0) and ((@['<'](0) && other['>'](0)) or (@['>'](0) && other['<'](0)))
      mod['-'](other)
    else
      mod


  # Rounds num to a given precision in decimal digits (default 0 digits).
  # Precision may be negative. Returns a floating point number when ndigits is
  # more than zero. Numeric implements this by converting itself to a Float
  # and invoking Float#round.
  #
  # @return [R.Numeric]
  #
  round: (n) ->
    @to_f().round(n)


  # Invokes block with the sequence of numbers starting at num, incremented by
  # step (default 1) on each call. The loop finishes when the value to be
  # passed to the block is greater than limit (if step is positive) or less
  # than limit (if step is negative). If all the arguments are integers, the
  # loop operates using an integer counter. If any of the arguments are
  # floating point numbers, all are converted to floats, and the loop is
  # executed floor(n + n*epsilon)+ 1 times, where n = (limit - num)/step.
  # Otherwise, the loop starts at num, uses either the < or > operator to
  # compare the counter against limit, and increments itself using the +
  # operator.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R(1).step(10, 2, function (i) { R.puts(i)} )
  #     R(Math.E).step(Math.PI, 0.2, function (i) { R.puts(i)} )
  #     # produces:
  #     # 1 3 5 7 9
  #     # 2.71828182845905 2.91828182845905 3.11828182845905
  #
  # @return [this, R.Enumerator]
  #
  step: (limit, step = 1, block) ->
    unless block?.call?
      return @to_enum('step', limit, step) unless step?.call?

    _num.step(@__native__, limit, step, block)
    this


  # @private
  to_int: ->
    @to_i()


  # Returns num truncated to an integer. Numeric implements this by converting
  # its value to a float and invoking Float#truncate.
  #
  # @return [R.Fixnum]
  #
  truncate: ->
    @to_f().truncate()


  # Unary Minus—Returns the receiver’s value, negated.
  #
  # @return [R.Numeric]
  #
  uminus: ->
    @multiply(-1)


  # Returns true if num has a zero value.
  #
  # @return [Boolean]
  zero: ->
    @['=='](0)


