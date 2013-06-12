# The Comparable mixin is used by classes whose objects may be ordered. The
# class must define the <=> operator, which compares the receiver against
# another object, returning -1, 0, or +1 depending on whether the receiver is
# less than, equal to, or greater than the other object. If the other object
# is not comparable then the <=> operator should return nil. Comparable uses
# <=> to implement the conventional comparison operators (<, <=, ==, >=, and
# >) and the method between?.
#
class RubyJS.Comparable

  '<': (other) ->
    cmp = @['cmp'](other)
    throw R.TypeError.new() if cmp is null
    cmp < 0

  '>': (other) ->
    cmp = @['cmp'](other)
    throw R.TypeError.new() if cmp is null
    cmp > 0

  '<=': (other) ->
    cmp = @['cmp'](other)
    throw R.TypeError.new() if cmp is null
    cmp <= 0

  '>=': (other) ->
    cmp = @['cmp'](other)
    throw R.TypeError.new() if cmp is null
    cmp >= 0

  # Returns false if obj <=> min is less than zero or if anObject <=> max is
  # greater than zero, true otherwise.
  #
  # @example
  #     R(3).between(1, 5)               # => true
  #     R(6).between(1, 5)               # => false
  #     R(3).between(3, 3)               # => true
  #     R('cat').between('ant', 'dog')   # => true
  #     R('gnu').between('ant', 'dog')   # => false
  #
  between: (min, max) ->
    @['>='](min) and @['<='](max)

  # Equivalent of calling
  # R(a).cmp(b) but faster for natives.
  @cmp: (a, b) ->
    if typeof a isnt 'object' and typeof a is typeof b
      if a is b
        0
      else
        if a < b then -1 else 1
    else
      a = R(a)
      throw 'NoMethodError' unless a['cmp']?
      a['cmp'](b)


  # Same as cmp, but throws ArgumentError if it cannot
  # coerce elements.
  @cmpstrict: (a, b) ->
    if typeof a is typeof b and typeof a isnt 'object'
      if a is b
        0
      else
        if a < b then -1 else 1
    else
      a = R(a)
      throw 'NoMethodError' unless a['cmp']?
      cmp = a['cmp'](b)
      throw R.ArgumentError.new() if cmp is null
      cmp



  # aliases
  lt:   @prototype['<']
  lteq: @prototype['<=']
  gt:   @prototype['>']
  gteq: @prototype['>=']