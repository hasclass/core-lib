class R.Fixnum extends RubyJS.Integer
  @include R.Comparable


  # ---- Constructors & Typecast ----------------------------------------------


  constructor: (@__native__) ->

  # __memoized_fixnums__: []

  @new: (val) ->
    # memo = @__memoized_fixnums__[val]
    # return memo if memo
    new R.Fixnum(val)


  @try_convert: (obj) ->
    obj = R(obj)
    throw R.TypeError.new() unless obj.to_int?
    obj

  # Fixnums are unchangeable. Cache them for later use.
  #
  @__cache_fixnums__: (from = -1, to = 256) ->
    for i in [from..to]
      @__memoized_fixnums__[i] = new R.Fixnum(i)


  # ---- RubyJSism ------------------------------------------------------------

  is_fixnum: -> true


  valueOf: -> @__native__


  # ---- Javascript primitives --------------------------------------------------

  to_native: ->
    @__native__

  valueOf: @prototype.to_native

  unbox: @prototype.to_native


  # ---- Instance methods -----------------------------------------------------

  dup:   ->
    Fixnum.new(@to_native())

  # Return true if fix equals other numerically.
  #
  # @example
  #     R(1).equals 2      #=> false
  #     R(1).equals 1.0    #=> true
  #
  # @alias #equals
  #
  equals: (other) ->
    if !R(other).is_fixnum?
      R(other).equals(this)
    else
      @cmp(other) == 0

  # Return true if fix equals other numerically.
  #
  # @example
  #     1 == 2      #=> false
  #     1 == 1.0    #=> true
  #
  '===': @prototype.equals


  # Returns -1, 0, +1 or nil depending on whether fix is less
  # than, equal to, or greater than numeric. This is the basis for the
  # tests in Comparable.
  #
  cmp: (other) ->
    unless typeof other is 'number'
      other = R(other)
      return null                  unless other.is_numeric?
      throw R.TypeError.new() unless other.to_int?
      other = other.to_native()

    if @to_native() < other
      -1
    else if @to_native() > other
      1
    else
      0

  # Performs addition: the class of the resulting object depends on the class
  # of numeric and on the magnitude of the result.
  #
  # @example
  #     R(1).plus(1)   # => 2     <R.Fixnum>
  #     R(1).plus(1.5) # => 2.t   <R.Float>
  #
  # @alias #plus
  #
  plus: (other) ->
    R.Numeric.typecast(@to_native() + RCoerce.to_num_native(other))

  # Performs subtraction: the class of the resulting object depends on the
  # class of numeric and on the magnitude of the result.
  #
  # @example
  #     R(1).minux(1)   # => 0     <R.Fixnum>
  #     R(1).minux(1.5) # => 0.5   <R.Float>
  #
  # @alias #minus
  #
  minus: (other) ->
    R.Numeric.typecast(@to_native() - RCoerce.to_num_native(other))

  # Performs division: the class of the resulting object depends on the class
  # of numeric and on the magnitude of the result.
  #
  # @example
  #     R(1).divide(2) # => 0
  #     R(1).divide(R.f(2)) # => 0.5
  #
  # @alias #divide
  #
  '/': (other) ->
    other = Fixnum.try_convert(other)
    if other.is_float? && other.zero()
      if @to_native() > 0
        R('Infinity')
      else
        R('-Infinity')
    else if +other == 0
      throw R.ZeroDivisionError.new()
    else
      val = R.Numeric.typecast(@to_native() / other.to_native())
      if other.is_float? then val else val.floor()


  # Performs multiplication: the class of the resulting object depends on the
  # class of numeric and on the magnitude of the result.
  #
  # @alias #multiply
  #
  '*': (other) ->
    R.Numeric.typecast(@to_native() * RCoerce.to_num_native(other))

  # Raises fix to the numeric power, which may be negative or fractional.
  #
  # @example
  #     R(2)['**'] 3      #=> 8
  #     R(2)['**'] -1     #=> 0.5
  #     R(2)['**'] 0.5    #=> 1.4142135623731
  #
  '**': (other) ->
    other = @box(other)
    val   = @box Math.pow(@to_native(), other.to_native())
    if other.is_float? then val.to_f() else val.to_i()

  # Returns fix modulo other. See numeric.divmod for more information.
  #
  # @alias #modulo
  #
  '%': (other) ->
    is_float  = @box(other).is_float?
    fixnum    = Fixnum.try_convert(other)
    throw R.ZeroDivisionError.new() if fixnum.zero()
    fixnum   = fixnum.to_int()
    division = @['/'](fixnum)
    val      = @minus division.multiply(fixnum)

    if is_float then val.to_f() else val.to_i()

  # Returns the floating point result of dividing fix by numeric.
  #
  # @example
  #     R(654321).fdiv(13731)      #=> 47.6528293642124
  #     R(654321).fdiv(13731.24)   #=> 47.6519964693647
  #
  fdiv: (other) ->
    other = R(other)
    throw R.TypeError.new() unless other.is_numeric?
    __ensure_args_length(arguments, 1)
    @to_f().divide(other.to_f())


  object_id: ->
    @__native__ * 2 + 1


  # Converts fix to a Float.
  to_f: -> @$Float(@to_native())


  # Returns a string containing the representation of fix radix base (between
  # 2 and 36).
  #
  # @example
  #     R(12345).to_s()     #=> "12345"
  #     R(12345).to_s(2)    #=> "11000000111001"
  #     R(12345).to_s(8)    #=> "30071"
  #     R(12345).to_s(10)   #=> "12345"
  #     R(12345).to_s(16)   #=> "3039"
  #     R(12345).to_s(36)   #=> "9ix"
  #
  to_s: (base = 10) ->
    base = @box(base)
    throw R.ArgumentError.new() if base.lt(2) || base.gt(36)
    @box("#{@to_native().toString(base.to_native())}")


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)


RFixnum = R.Fixnum