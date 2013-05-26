root = global ? window
root.EnumerableSpecs = {}

class EnumerableSpecs.Numerous extends RubyJS.Object
  @include RubyJS.Enumerable

  @new: (list...) -> new EnumerableSpecs.Numerous(list...)

  constructor: (list...) ->
    if list.length != 0
      @list = R.$Array_r(list)
    else
      @list = R.$Array_r([2, 5, 3, 6, 1, 4])

  each: (func) ->
    func.single_mode_block_arg = true if func

    if func && func.call?
      @list.each( (i) -> func(i) )
    else
      @list.unbox() # @to_enum('each')

  to_native: ->
    @list.__native__


class EnumerableSpecs.NumerousLiteral extends RubyJS.Object
  @include RubyJS.Enumerable
  @new: (list...) -> new EnumerableSpecs.NumerousLiteral(list...)
  constructor: (list...) ->
    if list.length != 0
      @list = R(list)
    else
      @list = R([2, 5, 3, 6, 1, 4])

  each: (func) ->
    func.single_mode_block_arg = true if func
    if func && func.call?
      @list.each( (i) -> func(i) )
    else
      @list.unbox() # @to_enum('each')

  to_native: ->
    @list.__native__

class EnumerableSpecs.ComparesByVowelCount
  @wrap: (args...) ->
    R.$Array(args).map (element) -> new ComparesByVowelCount(element)

  constructor: (@value) ->
    all_vowels = ['a', 'e' , 'i' , 'o', 'u']
    @vowels = R(@value.replace(/[^aeiou]/g,'').length)

  '<=>': (other) ->
    @vowels['<=>'] other.vowels

  unbox: -> @value
  to_native: -> @value

class EnumerableSpecs.Empty extends RubyJS.Object
  @include RubyJS.Enumerable

  @new: () -> new EnumerableSpecs.Empty()
  each: () -> R([])


class EnumerableSpecs.ThrowingEach extends RubyJS.Object
  @include RubyJS.Enumerable

  @new: () -> new EnumerableSpecs.ThrowingEach()
  each: () -> throw "RuntimeError"


#   class EachCounter < Numerous
#     attr_reader :times_called, :times_yielded, :arguments_passed
#     def initialize(*list)
#       super(*list)
#       @times_yielded = @times_called = 0
#     end

#     def each(*arg)
#       @times_called += 1
#       @times_yielded = 0
#       @arguments_passed = arg
#       @list.each do |i|
#         @times_yielded +=1
#         yield i
#       end
#     end
#   end

#   class NoEach
#     include Enumerable
#   end

#   # (Legacy form rubycon)
#   class EachDefiner

#     include Enumerable

#     attr_reader :arr

#     def initialize(*arr)
#       @arr = arr
#     end

#     def each
#       i = 0
#       loop do
#         break if i == @arr.size
#         yield @arr[i]
#         i += 1
#       end
#     end

#   end

#   class SortByDummy
#     def initialize(s)
#       @s = s
#     end

#     def s
#       @s
#     end
#   end


#   class InvalidComparable
#     def <=>(other)
#       "Not Valid"
#     end
#   end

class EnumerableSpecs.ArrayConvertable extends RubyJS.Object
  constructor: (values...) ->
    @values = values

  to_a: ->
    @called = 'to_a'
    R(@values)

  to_ary: ->
    @called = 'to_ary'
    R(@values)

class EnumerableSpecs.EnumConvertable extends RubyJS.Object
  constructor: (@delegate) ->

  to_enum: (@sym) ->
    @called = 'to_enum'
    @delegate.to_enum(@sym)


#   class Equals
#     def initialize(obj)
#       @obj = obj
#     end
#     def ==(other)
#       @obj == other
#     end
#   end

class EnumerableSpecs.YieldsMulti extends RubyJS.Object
  @include R.Enumerable

  each: (block) ->
    block(1,2)
    block(3,4,5)
    block(6,7,8,9)

class EnumerableSpecs.YieldsMultiWithFalse extends RubyJS.Enumerable
  each: (block) ->
    block(false,2)
    block(false,4,5)
    block(false,7,8,9)

class EnumerableSpecs.YieldsMultiWithSingleTrue extends RubyJS.Enumerable
  each: (block) ->
    block(false,2)
    block(true,4,5)
    block(false,7,8,9)

class EnumerableSpecs.YieldsMixed extends RubyJS.Enumerable
  each: (block) ->
    block(1 )
    block([2] )
    block(3,4 )
    block(5,6,7 )
    block([8,9] )
    block(null )
    block([] )

#   class ReverseComparable
#     include Comparable
#     def initialize(num)
#       @num = num
#     end

#     attr_accessor :num

#     # Reverse comparison
#     def <=>(other)
#       other.num <=> @num
#     end
#   end

#   class ComparableWithFixnum
#     include Comparable
#     def initialize(num)
#       @num = num
#     end

#     def <=>(fixnum)
#       @num <=> fixnum
#     end
#   end

#   class Uncomparable
#     def <=>(obj)
#       nil
#     end
#   end

#   class Undupable
#     attr_reader :initialize_called, :initialize_dup_called
#     def dup
#       raise "Can't, sorry"
#     end

#     def clone
#       raise "Can't, either, sorry"
#     end

#     def initialize
#       @initialize_dup = true
#     end

#     def initialize_dup(arg)
#       @initialize_dup_called = true
#     end
#   end
# end # EnumerableSpecs utility classes
