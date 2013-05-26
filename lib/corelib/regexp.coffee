class RubyJS.Regexp extends RubyJS.Object
  # TODO: remove and document this. not needed/making sense in JS.
  IGNORECASE: 1
  EXTENDED:   2
  MULTILINE:  4

  # ---- Constructors & Typecast ----------------------------------------------

  constructor: (@__native__) ->


  @new: (arg) ->
    if typeof arg is 'string'
      # optimize R.Regexp.new("foo") with string primitive
      arg = @__compile__( arg )
    else if R.Regexp.isRegexp(arg)
    else if arg.is_regexp?
      arg = arg.to_native()
    else
      arg = @__compile__( RCoerce.to_str_native(arg))

    new R.Regexp(arg)


  @compile: @new


  @try_convert: (obj) ->
    if obj is null
      null
    else if @isRegexp(obj)
      new R.Regexp(obj)
    else if obj.to_regexp?
      obj.to_regexp()
    else
      null


  @isRegexp: (obj) ->
    _toString_.call(obj) is '[object RegExp]' or obj.is_regexp?


  # ---- RubyJSism ------------------------------------------------------------


  # ---- Javascript primitives --------------------------------------------------

  is_regexp: ->
    true


  to_native: ->
    @__native__


  # ---- Instance methods -----------------------------------------------------

  # @todo escaping of forward slashes: \
  inspect: ->
    src = @source().to_native()
    R("/#{src}/#{@__flags__()}")


  # Equality—Two regexps are equal if their patterns are identical, they have
  # the same character set code, and their casefold? values are the same.
  #
  # @todo Check ruby-docs
  #
  # @example Basics (wrong online doc in ruby-doc.org)
  #
  #     R(/abc/)['=='](/abc/)   #=> false
  #     R(/abc/)['=='](/abc/)   #=> false
  #     R(/abc/)['=='](/abc/)   #=> false
  #     R(/abc/)['=='](/abc/)   #=> false
  #
  # @example aliased by #equals
  #
  #     R(/abc/).equals(/abc/)   #=> false
  #     R(/abc/).equals(/abc/)   #=> false
  #
  # @alias #equals, #eql
  #
  '==': (other) ->
    other = R(other)
    (other.to_native().source is @to_native().source) and (other.casefold() is @casefold())


  # Case Equality—Synonym for Regexp#=~ used in case statements.
  #
  #     a = "HELLO"
  #     R(/^[a-z]*$/)['==='](a) # => false
  #     R(/^[a-z]*$/)['==='](a) # => false
  #     R(/^[A-Z]*$/)['==='](a) # => true
  #
  # @alias #equal_case
  #
  '===': (other) ->
    @match(other) != null


  '=~': (str, offset) ->
    matches = @match(str, offset)
    matches?.begin(0)


  # Returns the value of the case-insensitive flag.
  #
  # @example
  #
  #     R(/a/).casefold()           #=> false
  #     R(/a/i).casefold()          #=> true
  #
  # @example Unsupported Ruby syntax
  #
  #     R(/(?i:a)/).casefold()      #=> false
  #
  casefold: ->
    @to_native().ignoreCase


  # @unsupported currently no support for encodings in RubyJS
  encoding: ->
    throw R.NotSupportedError.new()


  # @alias to #==
  eql: -> @['=='].apply(this, arguments)


  # @unsupported currently no support for encodings in RubyJS
  fixed_encoding: ->
    throw R.NotSupportedError.new()


  # @unsupported currently no support for hash in RubyJS
  hash: ->
    throw R.NotSupportedError.new()


  # Returns a MatchData object describing the match, or nil if there was no
  # match. This is equivalent to retrieving the value of the special variable
  # $~ following a normal match. If the second parameter is present, it
  # specifies the position in the string to begin the search.
  #
  # @example
  #     R(/(.)(.)(.)/).match("abc")[2]   # => "b"
  #     R(/(.)(.)/).match("abc", 1)[2]   # => "c"
  #
  # If a block is given, invoke the block with MatchData if match succeed, so that you can write
  #
  #     pat.match(str) {|m| ...}
  #
  # instead of
  #
  #     if m = pat.match(str)
  #       ...
  #     end
  #
  # The return value is a value from block execution in this case.
  #
  # @todo:
  #     R(/(.)(.)?(.)/).match("fo")
  #     # should => ["fo" 1:"f" 2:nil 3:"o">']
  #     # but => ["fo" 1:"f" 2:undefined 3:"o">']
  #
  # @example Parameters
  #     match(str) → matchdata or nil
  #     match(str,pos) → matchdata or nil
  #
  match: (str, offset) ->
    block   = @__extract_block(_slice_.call(arguments))

    if str is null
      R['$~'] = null
    else
      str = RCoerce.to_str_native(str)
      opts = {string: str, regexp: this}

      if offset
        opts.offset = offset
        str = str[offset..-1]

      if matches = str.match(@to_native())
        R['$~'] = new R.MatchData(matches, opts)
      else
        R['$~'] = null

    result = R['$~']

    if block
      if result then block(result) else new R.Array([])
    else
      result


  quote: (pattern) ->
    R.Regexp.quote(pattern)


  # Returns the original string of the pattern.
  #
  #     R(/ab+c/i).source()   #=> "ab+c"
  #
  # Note that escape sequences are retained as is.
  #
  #     R(/\x20\+/).source()  #=> "\\x20\\+"
  #
  source: () ->
    R(@to_native().source)


  # Returns a string containing the regular expression and its options (using the (?opts:source) notation. This string can be fed back in to Regexp::new to a regular expression with the same semantics as the original. (However, Regexp#== may not return true when comparing the two, as the source of the regular expression itself may differ, as the example shows). Regexp#inspect produces a generally more readable version of rxp.
  #
  # @example
  #     r1 = R(/ab+c/)           #=> /ab+c/
  #     s1 = r1.to_s()           #=> "(ab+c)"
  #     r2 = Regexp.new(s1)      #=> /(ab+c)/
  #     r1 == r2                 #=> false
  #     r1.source()              #=> "ab+c"
  #     r2.source()              #=> "(ab+c)"
  #
  # @example Ruby difference
  #
  #     r1 = R(/ab+c/i)           #=> /ab+c/i
  #     s1 = r1.to_s()            #=> "(ab+c)"
  #     # i option is lost!
  #     # Ruby:
  #     /ab+c/i.to_s              #=> "(?i-mx:ab+c)"
  #
  to_s: () ->
    R("(#{@source()})")


  # ---- Class methods --------------------------------------------------------

  # The first form returns the MatchData object generated by the last
  # successful pattern match. Equivalent to reading the global variable $~.
  # The second form returns the nth field in this MatchData object. n can be a
  # string or symbol to reference a named capture.
  #
  # Note that the last_match is local to the thread and method scope of the
  # method that did the pattern match.
  #
  # @example
  #     R(/c(.)t/)['=~'] 'cat'        #=> 0
  #     Regexp.last_match()     #=> #<MatchData "cat" 1:"a">
  #     Regexp.last_match(0)    #=> "cat"
  #     Regexp.last_match(1)    #=> "a"
  #     Regexp.last_match(2)    #=> null
  #
  # @example Edge cases
  #     R(/nomatch/)['=~'] 'foo'
  #     Regexp.last_match(2)    #=> null
  #
  # @example Unsupported Ruby Syntax: named captures
  #     # /(?<lhs>\w+)\s*=\s*(?<rhs>\w+)/ =~ "var = val"
  #     # R.Regexp.last_match()       #=> #<MatchData "var = val" lhs:"var" rhs:"val">
  #     # R.Regexp.last_match(:lhs) #=> "var"
  #     # R.Regexp.last_match(:rhs) #=> "val"
  #
  # @example Parameters
  #    R.Regexp.last_match() → matchdata click to toggle source
  #    R.Regexp.last_match(n) → str
  #
  @last_match: (n) ->
    if (n and R['$~']) then R['$~'][n] else R['$~']


  # @see Regexp.escape
  #
  @quote: (pattern) ->
    @escape(pattern)

  # Escapes any characters that would have special meaning in a regular
  # expression. Returns a new escaped string, or self if no characters are
  # escaped. For any string, Regexp.new(Regexp.escape(str))=~str will be true.
  #
  # @example
  #      R.Regexp.escape('\*?{}.')   #=> \\\*\?\{\}\.
  #
  # @alias Regexp.quote
  #
  @escape: (pattern) ->
    pattern = pattern + ''
    pattern.replace(/([.?*+^$[\](){}|-])/g, "\\$1")
      # .replace(/[\\]/g, '\\\\')
      # .replace(/[\"]/g, '\\\"')
      # .replace(/[\/]/g, '\\/')
      # .replace(/[\b]/g, '\\b')
      .replace(/[\f]/g, '\\f')
      .replace(/[\n]/g, '\\n')
      .replace(/[\r]/g, '\\r')
      .replace(/[\t]/g, '\\t')
      .replace(/[\s]/g, '\\ ') # This must been an empty space ' '


  # Return a Regexp object that is the union of the given patterns, i.e., will
  # match any of its parts. The patterns can be Regexp objects, in which case
  # their options will be preserved, or Strings. If no patterns are given,
  # returns /(?!)/. The behavior is unspecified if any given pattern contains
  # capture.
  #
  # @example
  #     R.Regexp.union()                       #=> /(?!)/
  #     R.Regexp.union("penzance")             #=> /penzance/
  #     R.Regexp.union("a+b*c")                #=> /a\+b\*c/
  #     R.Regexp.union("skiing", "sledding")   #=> /skiing|sledding/
  #     R.Regexp.union(["skiing", "sledding"]) #=> /skiing|sledding/
  #     R.Regexp.union(/dogs/, /cats/)        #=> /(dogs)|(cats)/
  #
  # @example Ruby difference
  #
  #     RubyJS.Regexp.union(/dogs/, /cats/)   # => /(dogs)|(cats)/
  #     # Ruby:
  #     Regexp.union(/dogs/, /cats/)          # => /(?-mix:dogs)|(?i-mx:cats)/
  #
  # @example Edge cases
  #     R.Regexp.union(["skiing", "sledding"], 'foo') #=> TypeError!
  #
  # @example Parameters
  #     R.Regexp.union(pat1, pat2, ...) → new_regexp
  #     R.Regexp.union(pats_ary) → new_regexp
  #
  @union: (args...) ->
    return R(/(?!)/) if args.length == 0

    first_arg = R(args[0])
    if first_arg.is_array? and args.length == 1
      args = first_arg

    sources = for arg in args
      arg = R(arg)
      if arg.is_regexp? then arg.to_s() else RCoerce.to_str(arg)

    # TODO: use proper Regexp.compile/new method
    new R.Regexp(
      new nativeRegExp( sources.join('|') ))


  # ---- Private methods ------------------------------------------------------

  # @see Regexp.new
  @__compile__: (arg) ->
    try
      return new nativeRegExp(arg)
    catch error
      throw R.RegexpError.new()


  __flags__: ->
    if @casefold() then 'i' else ''


  # ---- Unsupported methods --------------------------------------------------

  # @unsupported named captures are not supported in JS
  names: ->
    throw R.NotSupportedError.new()


  # @unsupported named captures are not supported in JS
  named_captures: ->
    throw R.NotSupportedError.new()


  # @unsupported JS options are different from Ruby options.
  options: ->
    throw R.NotSupportedError.new()


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  fixedEncoding: @prototype.fixed_encoding
