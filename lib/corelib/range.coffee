# R.Range.new()
#
# @include RubyJS.Enumerable
#
class RubyJS.Range extends RubyJS.Object
  @include R.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  # TODO: .new should BOX here:
  @new: (start, end, exclusive = false) ->
    new R.Range(start, end, exclusive)

  # TODO: do not box here...
  constructor: (start, end, @exclusive = false) ->
    @__start__ = @box(start)
    @__end__   = @box(end)

    unless @__start__.is_fixnum? and @__end__.is_fixnum?
      try
        # ERROR_MSG: bad value for range
        throw R.ArgumentError.new() if @__start__.cmp(@__end__) is null
      catch err
        throw R.ArgumentError.new()

    @comparison = if @exclusive then 'lt' else 'lteq'


  # ---- RubyJSism ------------------------------------------------------------

  # @private
  is_range: -> true


  # @private
  iterator: () ->
    arr = []
    @each (e) -> arr.push(e)
    arr


  # ---- Javascript primitives --------------------------------------------------


  # ---- Instance methods -----------------------------------------------------

  # Returns true only if obj is a Range, has equivalent beginning and end items
  # (by comparing them with ==), and has the same exclude_end? setting as rng.
  #
  #     R.rng(0, 2).equals( R.r(0,2) )            #=> true
  #     R.rng(0, 2).equals( R.Range.new(0,2) )    #=> true
  #     R.rng(0, 2).equals( R.r(0, 2, true)       #=> false # -> (0...2)
  #
  # @param other
  # @alias #equals
  # @return true, false
  #
  equals: (other) ->
    return false unless other instanceof R.Range
    @__end__.equals(other.end()) and @__start__.equals(other.start()) and @exclusive is other.exclude_end()

  # Returns true only if obj is a Range, has equivalent beginning and end items
  # (by comparing them with ==), and has the same exclude_end? setting as rng.
  #
  #     R.rng(0, 2).equals( R.r(0,2) )            #=> true
  #     R.rng(0, 2).equals( R.Range.new(0,2) )    #=> true
  #     R.rng(0, 2).equals( R.r(0, 2, true)       #=> false # -> (0...2)
  #
  # @param other
  # @alias #equals
  # @return true, false
  #
  equals: @prototype.equals

  # Returns the first object in rng
  #
  # @return obj
  #
  begin: (obj) ->
    @__start__

  # Returns true if obj is between beg and end, i.e beg <= obj <= end (or end
  # exclusive when exclude_end? is true).
  #
  #     R.rng("a", "z").cover("c")    #=> true
  #     R.rng("a", "z").cover("5")    #=> false
  #
  # @param other
  #
  cover: (obj) ->
    throw R.ArgumentError.new() if arguments.length != 1
    obj = obj
    return false if obj is null
    @equal_case(obj)

  '===': (other) ->
    other = R(other)
    s = other.cmp(@__start__)
    e = other.cmp(@__end__)
    return false if s is null and e is null
    # other was compared to self (other <=> self), so negate results to get
    # behaviour of self <=> other
    s = -s
    e = -e
    s <= 0 && (if @exclusive then e > 0 else e >= 0)


  # Iterates over the elements rng, passing each in turn to the block. You can
  # only iterate if the start object of the range supports the succ method
  # (which means that you can’t iterate over ranges of Float objects).
  #
  # If no block is given, an enumerator is returned instead.
  #
  #     R.rng(10, 15).each (n) ->
  #        console.log n, ' '
  #
  #     # 10 11 12 13 14 15
  #
  # @return [Range, Enumerator]
  #
  # @todo Untested single_block_args
  #
  each: (block) ->
    return @to_enum('each') unless block and block.call?

    throw R.TypeError.new("can't iterate from #{@begin()}") unless @begin().succ?
    iterator = @__start__.dup()

    while iterator[@comparison](@__end__)
      # OPTIMIZE
      block(iterator.valueOf())
      iterator = iterator.succ()

    this

  # Returns the object that defines the end of rng.
  #
  #     R.rng(1,10).end()        #=> 10
  #     R.rng(1,10, true).end()  #=> 10
  #
  # @return obj
  #
  end: () ->
    @__end__


  # Returns true if rng excludes its end value.
  # @return [true, false]
  exclude_end: ->
    @exclusive


  # Returns the first object in rng, or the first n elements.
  #
  # @return [obj, Array<obj>]
  # @todo #first(n) not yet implemented
  #
  first: (n) ->
    @begin()

  # Convert this range object to a printable form (using inspect to convert the
  # start and end objects).
  #
  # @return [String]
  #
  inspect: () ->
    sep = if @exclude_end() then "..." else ".."
    "#{@start().inspect()}#{sep}#{@end().inspect()}"


  #     min → obj
  #     min {| a,b | block } → obj
  #
  # Returns the minimum value in rng. The second uses the block to compare
  # values. Returns nil if the first value in range is larger than the last
  # value
  min: (block) ->
    return R.Enumerable.prototype.min.call(this, block) if block?.call?
    b = @begin()
    e = @end()
    return null if e['lt'](b) || (@exclusive && e.equals(b))
    return b.valueOf() if b.is_float?
    R.Enumerable.prototype.min.call(this)



  # Returns the maximum value in rng. The second uses the block to compare
  # values. Returns nil if the first value in range is larger than the last
  # value.
  #
  # @return obj
  #
  max: (block) ->
    return R.Enumerable.prototype.max.call(this, block) if block?.call?
    b = @begin()
    e = @end()
    return null if e['lt'](b) || (@exclusive && e.equals(b))
    return e.valueOf() if e.is_float? || (e.is_float? && !@exclusive)
    R.Enumerable.prototype.max.call(this)


  start: () ->
    @__start__

  # Iterates over rng, passing each nth element to the block. If the range
  # contains numbers, n is added for each iteration. Otherwise step invokes
  # succ to iterate through range elements. The following code uses class Xs,
  # which is defined in the class-level documentation.
  #
  # If no block is given, an enumerator is returned instead.
  #
  #    R.rng('a', 'f').step(2, (x) -> puts x) # => a c e
  #    R.rng('a', 'f').step(3).to_a()         # => [a, d]
  #
  # @todo fix imprecision when using floats as step_sizes
  #
  # @return [Range, Enumerator] returns self or Enumerator if no block given.
  #
  step: (step_size=1, block) ->
    # return this if block is undefined and step_size.call?
    if arguments.length == 1 && step_size.call?
      block = step_size
      step_size = 1

    unless block && block.call?
      return @to_enum('step', step_size)

    step_size = R(step_size)
    first     = @begin()
    last      = @end()

    if step_size?.is_float? or first.is_float? or last.is_float?
      # TODO: Use Float() equivalent instead
      step_size = step_size.to_f()
      first     = first.to_f()
      last      = last.to_f()
    else
      step_size = RCoerce.to_int_native(step_size)

    if step_size <= 0
      throw R.ArgumentError.new() if step_size < 0 # step can't be negative
      throw R.ArgumentError.new() # step can't be negative or zero

    cnt = first
    cmp = if @exclude_end() then 'lt' else 'lteq'
    if first.is_float?
      # TODO: add float math error check
      while cnt[cmp](last)
        block(cnt.valueOf())
        cnt = cnt.plus(step_size)
    else if first.is_fixnum?
      while cnt[cmp](last)
        block(cnt.valueOf())
        cnt = cnt.plus(step_size)
    else
      # no numeric, typically a string
      cnt = 0
      @each (o) ->
        block(o) if cnt % step_size is 0
        cnt += 1

    this


  to_a: () ->
    throw R.TypeError.new() if @__end__.is_float? && @__start__.is_float?
    R.Enumerable.prototype.to_a.apply(this)


  to_s: @prototype.inspect


  # ---- Private methods ------------------------------------------------------


  # ---- Unsupported methods --------------------------------------------------


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  # @alias #==
  eql:        @prototype.equals

  # @alias #===
  include:    @prototype['===']

  # @alias #end
  last:       @prototype.end

  # @alias #include
  member:     @prototype.include

  excludeEnd: @prototype.exclude_end