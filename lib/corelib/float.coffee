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

  is_float:   -> true


  # ---- Javascript primitives --------------------------------------------------

  toString: ->
    @to_native().toString()


  valueOf: () ->
    @__native__


  to_native: ->
    @__native__


  unbox: @prototype.to_native


  @isFloat: (obj) ->
    RubyJS.Numeric.isNumeric(obj) && !RubyJS.Integer.isInteger(obj)


  # ---- Instance methods -----------------------------------------------------


  arg: ->
    if @nan()
      this
    else if @lt(0.0)
      @$Float(Math.PI)
    else
      @$Float 0


  ceil: ->
    new RubyJS.Fixnum(Math.ceil(@to_native()))


  inspect: () ->
    @to_s()


  '<=>': (other) ->
    return null if !@box(other).is_numeric?
    other = CoerceProto.to_num_native(other)

    return  0 if @to_native() == other
    return -1 if @to_native() < other
    return  1 if @to_native() > other


  dup: -> Float.new(@to_native())


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


  eql: (other) ->
    other = @box(other)
    return false unless other.is_float?
    @equals(other)


  finite: ->
    !(@infinite() || @nan())


  infinite: ->
    if @to_native() is Float.INFINITY
      1
    else if @to_native() is -Float.INFINITY
      -1
    else
      null


  nan: ->
    isNaN(@to_native())


  to_f: -> @dup()


  to_i: ->
    if @to_native() < 0
      @ceil()
    else
      @floor()


  floor: ->
    new R.Fixnum(Math.floor(@__native__))


  quo: (other) ->
    @__ensure_args_length(arguments, 1)

    other = @box(other)
    @divide(other)


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



  # ---- Aliases --------------------------------------------------------------

  angle:      @prototype.arg
  fdiv:       @prototype.quo
  magnitude:  @prototype.abs
  phase:      @prototype.arg
  to_int:     @prototype.to_i
  truncate:   @prototype.to_i

  '===': @prototype['==']
  @__add_default_aliases__(@prototype)

