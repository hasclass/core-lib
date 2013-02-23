#
#
#
#
class RubyJS.Float extends RubyJS.Numeric
  @include RubyJS.Comparable

  # FIXME: this should ideally be rubyjs.Floats
  @INFINITY:   1.0/0.0
  @NAN:        0.0/0.0
  @DIG:        15
  @EPSILON:    0.0000000000000002220446049250313080847263336181640625
  @MANT_DIG:   53
  @MAX_10_EXP: 308
  @MIN_10_EXP:-307
  @MAX_EXP:    1024
  @MIN_EXP:   -1021
  @MAX:        179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368
  @MANT_DIG:   53
  @MIN:        2.225073858507201383090232717332404064219215980462331830553327416887204434813918195854283159012511020564067339731035811005152434161553460108856012385377718821130777993532002330479610147442583636071921565046942503734208375250806650616658158948720491179968591639648500635908770118304874799780887753749949451580451605050915399856582470818645113537935804992115981085766051992433352114352390148795699609591288891602992641511063466313393663477586513029371762047325631781485664350872122828637642044846811407613911477062801689853244110024161447421618567166150540154285084716752901903161322778896729707373123334086988983175067838846926092773977972858659654941091369095406136467568702398678315290680984617210924625396728515625e-308
  @RADIX:      2


  # ---- Constructors ---------------------------------------------------------

  # rubyism
  @new: (f) ->
    new R.Float(f)

  constructor: (@__native__) ->


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_float:   -> true


  @isFloat: (obj) ->
    RubyJS.Numeric.isNumeric(obj) && !RubyJS.Integer.isInteger(obj)


  # ---- Instance methods -----------------------------------------------------


  '<=>': (other) ->
    return null if !@box(other).is_numeric?
    other = CoerceProto.to_num_native(other)

    return  0 if @to_native() == other
    return -1 if @to_native() < other
    return  1 if @to_native() > other


  '==': (other) ->
    other = @box(other)
    @to_native() is other.to_native()


  '+': (other) ->
    new Float(@to_native() + CoerceProto.to_num_native(other))


  '-': (other) ->
    new Float(@to_native() - CoerceProto.to_num_native(other))


  '*': (other) ->
    new Float(@to_native() * CoerceProto.to_num_native(other))


  '/': (other) ->
    new Float(@to_native() / CoerceProto.to_num_native(other))


  '**': (other) ->
    new Float( Math.pow(@to_native(), CoerceProto.to_num_native(other)) + 0)


  '%': (other) ->
    other = @box(other)
    throw new Error("ZeroDivisionError") if other.equals(0)

    return @box(Float.NAN).to_f() if !@finite()

    if inf = other.infinite?()
      return other if inf is -1
      return this  if inf is 1

    div = @['/'](other).floor()
    val = @to_native() - (div.to_native() * other.to_native())

    new Float(val)

  # Returns 0 if the value is positive, pi otherwise.
  #
  # @return [R.Float]
  # @alias #angle, #phase
  #
  arg: ->
    if @nan()
      this
    else if @__native__ < 0.0
      new R.Float(Math.PI)
    else
      new R.Float(0)


  # Returns the smallest Integer greater than or equal to flt.
  #
  # @example
  #
  #    R( 1.2).ceil()      #=> 2
  #    R( 2.0).ceil()      #=> 2
  #    R(-1.2).ceil()      #=> -1
  #    R(-2.0).ceil()      #=> -2
  #
  # @return [R.Fixnum]
  #
  ceil: ->
    new RubyJS.Fixnum(Math.ceil(@to_native()))


  inspect: () ->
    @to_s()


  dup: -> Float.new(@to_native())


  # Returns true only if obj is a Float with the same value as flt. Contrast
  # this with Float#==, which performs type conversions.
  #
  # @example
  #
  #     new R.Float(1.0).eql(1)   #=> false
  #
  # @return [Boolean]
  #
  eql: (other) ->
    other = @box(other)
    return false unless other.is_float?
    @equals(other)


  # Returns true if flt is a valid IEEE floating point number (it is not
  # infinite, and nan? is false).
  #
  # @return [Boolean]
  #
  finite: ->
    !(@infinite() || @nan())


  # Returns nil, -1, or +1 depending on whether flt is finite, -infinity, or
  # +infinity.
  #
  # @example
  #
  #     new R.Float(0.0).infinite()        #=> nil
  #     new R.Float(-1.0/0.0).infinite()   #=> -1
  #     new R.Float(+1.0/0.0).infinite()   #=> 1
  #
  # @return [Boolean]
  #
  infinite: ->
    if @to_native() is Float.INFINITY
      1
    else if @to_native() is -Float.INFINITY
      -1
    else
      null


  # Returns true if flt is an invalid IEEE floating point number.
  #
  # @example
  #
  #     a = new R.Float(-1.0)      #=> -1.0
  #     a.nan()                    #=> false
  #     a = new R.Float(0.0/0.0)   #=> NaN
  #     a.nan()                    #=> true
  #
  # @return [Boolean]
  #
  nan: ->
    isNaN(@to_native())


  # As flt is already a float, returns self.
  to_f: -> @dup()


  # Returns flt truncated to an Integer.
  #
  # @return [R.Fixnum]
  to_i: ->
    if @to_native() < 0
      @ceil()
    else
      @floor()


  # Returns the largest integer less than or equal to flt.
  #
  # @example
  #
  #     new R.Float(1.2).floor()    #=> 1
  #     new R.Float(2.0).floor()    #=> 2
  #     new R.Float(-1.2).floor()   #=> -2
  #     new R.Float(-2.0).floor()   #=> -2
  #
  # @return [R.Fixnum]
  #
  floor: ->
    new R.Fixnum(Math.floor(@__native__))


  # Returns float / numeric.
  #
  # @return [R.Float]
  #
  quo: (other) ->
    @__ensure_args_length(arguments, 1)

    other = @box(other)
    @divide(other)


  # Rounds flt to a given precision in decimal digits (default 0 digits).
  # Precision may be negative. Returns a floating point number when ndigits is
  # more than zero.
  #
  # @example
  #
  #     R(1.4).round()      #=> 1
  #     R(1.5).round()      #=> 2
  #     R(1.6).round()      #=> 2
  #     R(-1.5).round()     #=> -2
  #     R(1.234567).round(2)  #=> 1.23
  #     R(1.234567).round(3)  #=> 1.235
  #     R(1.234567).round(4)  #=> 1.2346
  #     R(1.234567).round(5)  #=> 1.23457
  #     R(34567.89).round(-5) #=> 0
  #     R(34567.89).round(-4) #=> 30000
  #     R(34567.89).round(-3) #=> 35000
  #     R(34567.89).round(-2) #=> 34600
  #     R(34567.89).round(-1) #=> 34570
  #     R(34567.89).round(0)  #=> 34568
  #     R(34567.89).round(1)  #=> 34567.9
  #     R(34567.89).round(2)  #=> 34567.89
  #     R(34567.89).round(3)  #=> 34567.89
  #
  # @return [R.Fixnum, R.Float]
  #
  round: (n = 0) ->
    n = CoerceProto.to_int_native(n)

    throw new TypeError("FloatDomainError") if @infinite()
    throw new TypeError("RangeError")       if @nan()

    return new RubyJS.Fixnum(Math.round(@to_native())) if n is 0

    multiplier = Math.pow(10, n)
    rounded    = Math.round(@to_native() * multiplier) / multiplier
    if n > 0
      new RubyJS.Float(rounded)
    else
      new RubyJS.Fixnum(rounded)


  # Returns a string containing a representation of self. As well as a fixed
  # or exponential form of the number, the call may return “NaN”, “Infinity”,
  # and “-Infinity”.
  #
  # @return [R.String]
  #
  to_s: ->
    v = ""+@to_native()
    if @nan()
      v = "NaN"
    else if inf = @infinite()
      v = "-Infinity" if inf is -1
      v = "Infinity" if inf is  1
    else if v.indexOf('.') < 0
      v += ".0"

    @$String(v)


  # ---- Javascript primitives --------------------------------------------------

  # @return [String]
  toString: ->
    @to_native().toString()


  # @return [String]
  valueOf: () ->
    @__native__


  # @return [String]
  to_native: ->
    @__native__


  # @private
  unbox: @prototype.to_native


  # ---- Aliases --------------------------------------------------------------

  angle:      @prototype.arg
  fdiv:       @prototype.quo

  # Returns the absolute value of flt.
  #
  # @example
  #
  #     R(-34.56).abs()     #=> 34.56
  #     R(-34.56).abs()     #=> 34.56
  #
  # @return [R.Float]
  # @alias #abs
  #
  magnitude:  @prototype.abs
  phase:      @prototype.arg
  to_int:     @prototype.to_i
  truncate:   @prototype.to_i

  '===': @prototype['==']
  @__add_default_aliases__(@prototype)

