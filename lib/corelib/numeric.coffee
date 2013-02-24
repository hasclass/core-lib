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

  '<=>': (other) ->
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
    throw RubyJS.TypeError.new() if other is null or other is false or other is undefined
    other = @box(other)
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
    quotient = @div(other).floor()
    modulus  = @minus(quotient.multiply(other))

    new R.Array([quotient, modulus])


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
  fdiv: (other) ->
    other = CoerceProto.to_num_native(other)
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


  # @alias #abs
  magnitude: ->
    @abs()


  # @alias #divmod
  modulo: (other) ->
    other = @box(other)
    # self - other * self.div(other)
    @['-']( other['*']( @div(other)) )


  # Returns self if num is not zero, nil otherwise. This behavior is useful
  # when chaining comparisons:
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


  remainder: (other) ->
    other = @box(other)
    mod = @['%'](other)

    if !mod['=='](0) and ((@['<'](0) && other['>'](0)) or (@['>'](0) && other['<'](0)))
      mod['-'](other)
    else
      mod


  round: (n) -> @to_f().round(n)


  step: (limit, step = 1, block) ->
    # ported from rubinius
    limit = @box(limit)
    if block?.call?
    else
      block = step
      step  = 1
    step = @box(step)

    return @to_enum('step', limit, step) unless block?.call?
    throw new R.ArgumentError("ArgumentError") if step.equals(0)

    value = this

    # eps = 0.0000000000000002220446049250313080847263336181640625
    if value.is_float? or limit.is_float? or step.is_float?
      # For some reason the following ported code is not needed.
      # it appears to work properly in js withouth the Float::EPSILON
      # value = value.to_f()
      # limit = limit.to_f()
      # step  = step.to_f()
      # err = (value.abs().plus(limit.abs()).plus(limit.minus(value).abs()).divide(step.abs())).multiply(eps)
      # err = 0.5 if err.gt(0.5)
      # n   = (limit.minus(value)).divide(step.plus(err)).floor()
      n   = (limit.to_f().minus(value)).divide(step)
      i   = R(0).to_f()
      if step.gt(0)
        while i.lteq(n)
          d = i.multiply(step).plus(value)
          d = limit if limit.lt(d)
          block(d)
          i = i.plus(1)
      else
        while i.lteq(n)
          d = i.multiply(step).plus(value)
          d = limit if limit.gt(d)
          block(d)
          i = i.plus(1)
    else
      if step.gt(0)
        until value.gt(limit)
          block(value)
          value = value.plus(step)
      else
        until value.lt(limit)
          block(value)
          value = value.plus(step)
    this


  to_int: ->
    @to_i()


  truncate: ->
    @to_f().truncate()


  uminus: ->
    @multiply(-1)


  zero: ->
    @['=='](0)


