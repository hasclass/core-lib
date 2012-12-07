# Is a wrapper around Regexp returns that acts like Rubys MatchData.
# This is only partially complete due to missing features in JS Regexp.
#
# @todo MatchData only works properly when calling through Regexp#match.
#    String#scan, #match to be done.
#
class RubyJS.MatchData extends RubyJS.Object

  # ---- Constructors & Typecast ----------------------------------------------

  constructor: (@__native__, opts = {}) ->
    for m, i in @__native__
      this[i] = m

    @__offset__ = opts.offset || 0
    @__source__ = opts.string
    @__regexp__ = opts.regexp

  # ---- RubyJSism ------------------------------------------------------------

  is_match_data: -> true

  # ---- Javascript primitives --------------------------------------------------

  # ---- Instance methods -----------------------------------------------------


  # Equality—Two matchdata are equal if their target strings, patterns, and
  # matched positions are identical.
  #
  # @alias #eql, #equals
  #
  '==': (other) ->
    return false if !other.is_match_data?

    @regexp()['=='](other.regexp()) &&
      @string()['=='](other.string()) &&
      @__offset__ == other.__offset__


  # Returns the offset of the start of the nth element of the match array in
  # the string. n can be a string or symbol to reference a named capture.
  #
  # @example
  #
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.begin(0)       #=> 1
  #     m.begin(2)       #=> 2
  #
  # @example unsupported Ruby syntax
  #
  #     # m = R/(?<foo>.)(.)(?<bar>.)/.match("hoge")
  #     # m.begin(:foo)  #=> 0
  #     # m.begin(:bar)  #=> 2
  #
  begin: (offset) ->
    @__ensure_args_length(1)
    R(@__source__[@__offset__..-1].indexOf(@__native__[offset]) + @__offset__)


  # Returns the array of captures; equivalent to mtch.to_a[1..-1].
  #
  # @example
  #
  #     capt = R(/(.)(.)(\d+)(\d)/).match("THX1138.").captures()
  #     capt[0]    #=> "H"
  #     capt[1]    #=> "X"
  #     capt[2]    #=> "113"
  #     capt[3]    #=> "8"
  #
  # @example Additional examples, edge cases
  #
  #     R(/foo/).match("foo").captures() #=> []
  #
  captures: ->
    R(@__native__[1..-1])


  end: (offset) ->
    @__ensure_args_length(1)
    R(@__source__[@__offset__..-1].indexOf(@__native__[offset]) + @__offset__ + @__native__[offset].length)


  # @see #==
  #
  eql: (other) ->
    @['=='](other)

  # Match Reference—MatchData acts as an array, and may be accessed using the
  # normal array indexing techniques. mtch is equivalent to the special
  # variable $&, and returns the entire matched string. mtch, mtch, and so on
  # return the values of the matched backreferences (portions of the pattern
  # between parentheses).
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m          #=> #<MatchData "HX1138" 1:"H" 2:"X" 3:"113" 4:"8">
  #     m.get(0)       #=> "HX1138"
  #     m.get(1, 2)    #=> ["H", "X"]
  #     # m.get(1..3)    #=> ["H", "X", "113"]
  #     m.get(-3, 2)   #=> ["X", "113"]
  #
  # @example accessing with [] is supported only for single arguments.
  #     m[0]           #=> "HX1138"
  #
  # @example Unsupported Ruby Syntax (named captures)
  #     # m = /(?<foo>a+)b/.match("ccaaab")
  #     # m          #=> #<MatchData "aaab" foo:"aaa">
  #     # m["foo"]   #=> "aaa"
  #     # m[:foo]    #=> "aaa"
  #
  # @example Parameters and return types
  #     mtch[i] → str or nil
  #     mtch[start, length] → array
  #     mtch[range] → array
  #     # mtch[name] → str or nil
  #
  get: (args...) ->
    arr = @to_a()
    arr.get.apply(arr, arguments)

  # Returns a printable version of mtch.
  #
  # @example
  #
  #     puts /.$/.match("foo").inspect()
  #     #=> #<MatchData "o">
  #
  #     puts /(.)(.)(.)/.match("foo").inspect()
  #     #=> #<MatchData "foo" 1:"f" 2:"o" 3:"o">
  #
  #     puts /(.)(.)?(.)/.match("fo").inspect()
  #     #=> #<MatchData "fo" 1:"f" 2:nil 3:"o">
  #
  # @example Unsupported Ruby Syntax
  #
  #     puts /(?<foo>.)(?<bar>.)(?<baz>.)/.match("hoge").inspect()
  #     #=> #<MatchData "hog" foo:"h" bar:"o" baz:"g">
  #
  inspect: ->
    results = R(["\"#{@[0]}\""])
    results.concat @captures().each_with_index().map((w, i) -> "#{i+1}:\"#{w}\"")

    new R.String("#<MatchData #{results.join(" ")}>")


  # Returns the number of elements in the match array.
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.length()   #=> 5
  #     m.size()     #=> 5
  #
  # @alias #size()
  #
  length: ->
    R(@__native__.length)


  # TODO: check types
  offset: (offset) ->
    b = @begin(offset)
    R([b.to_native(), b + @__native__[offset].length])


  post_match: ->
    @__source__[@end(0)..-1]


  pre_match: ->
    @__source__[0...@begin(0)]


  regexp: ->
    R(@__regexp__)


  # @alias #length()
  # @see #length
  size: ->
    @length()


  string: ->
    R(@__source__)


  # Returns the array of matches.
  #
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.to_a()   #=> ["HX1138", "H", "X", "113", "8"]
  #
  # Because to_a is called when expanding *variable, there’s a useful
  # assignment shortcut for extracting matched fields. This is slightly slower
  # than accessing the fields directly (as an intermediate array is
  # generated).
  #
  to_a: ->
    R(@__native__)


  # Returns the entire matched string.
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138.")
  #     m.to_s()   #=> "HX1138"
  #
  to_s: ->
    R(@__native__[0])


  # values_at([index]*) → array click to toggle source
  # Uses each index to access the matching values, returning an array of the corresponding matches.
  #
  # @example
  #     m = R(/(.)(.)(\d+)(\d)/).match("THX1138: The Movie")
  #     m.to_a()                #=> ["HX1138", "H", "X", "113", "8"]
  #     m.values_at(0, 2, -2)   #=> ["HX1138", "X", "113"]
  #
  values_at: (indices...) ->
    arr = @to_a()
    arr.values_at.apply(arr, indices)


  # ---- Unsupported methods --------------------------------------------------

  # @unsupported extracting names is not supported in Javascript
  names: ->
    throw RubyJS.NotSupportedError.new()


  # ---- Private methods ------------------------------------------------------


  # ---- Aliases --------------------------------------------------------------

  postMatch: @prototype.post_match
  preMatch:  @prototype.pre_match
  valuesAt:  @prototype.values_at


