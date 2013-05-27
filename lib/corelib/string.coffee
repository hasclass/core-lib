# make String accessible within R.String
nativeString = root.String

class RubyJS.String extends RubyJS.Object
  @include R.Comparable
  @fromCharCode: (obj) -> nativeString.fromCharCode(obj)

  # ---- Constructors & Typecast ----------------------------------------------

  # @todo make .new subclasseable
  # @todo follow
  @new: (str = '') ->
    new R.String(str)


  constructor: (primitive = "") ->
    unless typeof primitive is 'string'
      primitive = primitive.valueOf()
    @replace(primitive)


  @isString: (obj) ->
    return false unless obj?
    return true  if typeof obj == 'string'
    return false if typeof obj != 'object'
    return true  if obj.is_string?
    _toString_.call(obj) is '[object String]'


  @try_convert: (obj) ->
    return null unless @isString(obj) or obj.to_str?

    if obj.to_str?
      obj = obj.to_str()
      return null if obj is null or obj is undefined
      # TODO: does not cover returning new String()
      # obj = new R.String(obj) if typeof obj is 'string'
      throw R.TypeError.new() unless obj.is_string? #or typeof obj is 'string'
      obj
    else
      @new(obj)


  @string_native: (obj) ->
    return obj if typeof obj is 'string'
    obj = R(obj)
    if obj.to_str?
      obj.to_str().to_native()
    else
      null


  # ---- RubyJSism ------------------------------------------------------------

  is_string: ->
    true


  # ---- Javascript primitives --------------------------------------------------

  to_native: ->
    @__native__


  valueOf:  -> @to_native()


  toString: -> @to_native()


  unbox: -> @__native__


  # ---- Instance methods -----------------------------------------------------


  initialize_copy: ->


  clone: ->
    new @constructor(@to_native()+"")


  # Not yet implemented
  '%': (num) ->
    throw R.NotImplementedError.new()


  # Copy—Returns a new String containing integer copies of the receiver.
  #
  # @example
  #     R("Ho! ").multiply(3)   #=> "Ho! Ho! Ho! "
  #
  '*': (num) ->
    num = RCoerce.to_int_native(num)
    new RString(_str.multiply(@__native__, num))


  # Concatenation—Returns a new String containing other_str concatenated to
  # str.
  #
  # @example
  #      R("Hello from ").plus("self")
  #      #=> "Hello from main"
  #
  '+': (other) ->
    other = RCoerce.to_str_native(other)
    new R.String(@to_native() + other) # don't return subclasses


  # Comparison—Returns -1 if other_str is greater than, 0 if other_str is
  # equal to, and +1 if other_str is less than str. If the strings are of
  # different lengths, and the strings are equal when compared up to the
  # shortest length, then the longer string is considered greater than the
  # shorter one. In older versions of Ruby, setting $= allowed case-
  # insensitive comparisons; this is now deprecated in favor of using
  # String#casecmp.
  #
  # <=> is the basis for the methods <, <=, >, >=, and between?, included from
  # <=> module Comparable. The method String#== does not use Comparable#==.
  #
  #     R("abcdef").cmp "abcde"     #=> 1
  #     R("abcdef").cmp "abcdef"    #=> 0
  #     R("abcdef").cmp "abcdefg"   #=> -1
  #     R("abcdef").cmp "ABCDEF"    #=> 1
  #
  # @alias #cmp
  #
  '<=>': (other) ->
    other = R(other)
    return null unless other.to_str?
    return null unless other['<=>']?

    if other.is_string?
      other = other.to_native()
      if @to_native() == other
        0
      else if @to_native() < other
        -1
      else
        1
    else
      - other['<=>'](this)

  # Equality—If obj is not a String, returns false. Otherwise, returns true if
  # str <=> obj returns zero.
  #
  # @alias #equals
  #
  '==': (other) ->
    if other.is_string?
      @to_native() == other.to_native()
    else if String.isString(other)
      @to_native() == other
    else if other.to_str?
      other['=='] @to_native()
    else
      false

  # Append—Concatenates the given object to str. If the object is a Integer, it
  # is considered as a codepoint, and is converted to a character before
  # concatenation.
  #
  # @example
  #     a = R("hello ")
  #     a.concat "world"   #=> "hello world"
  #     a.concat(33)       #=> "hello world!"
  #
  # @alias #append, #concat
  #
  '<<': (other) ->
    other = @box(other)
    if other.is_integer?
      throw new Error("RangeError") if other.lt(0)
      other = other.chr()
    throw R.TypeError.new() unless other?.to_str?

    @replace (@to_native() + other.to_str().to_native())


  # Match—If obj is a Regexp, use it as a pattern to match against str,and
  # returns the position the match starts, or nil if there is no match.
  # Otherwise, invokes obj.=~, passing str as an argument. The default =~ in
  # Object returns nil.
  #
  # @example
  #      R("cat o' 9 tails")['=~'] %r\d/   #=> 7
  #      R("cat o' 9 tails")['=~'] 9      #=> nil
  #
  # TODO: find alias
  #
  '=~': (pattern, offset, block) ->
    throw R.TypeError.new() if R(pattern).is_string?
    @match(pattern, offset, block)


  #[]
  #[]=
  #ascii_only?
  #bytes
  #bytesize
  #byteslice


  # Returns a copy of str with the first character converted to uppercase and
  # the remainder to lowercase. Note: case conversion is effective only in
  # ASCII region.
  #
  # @example
  #     R("hello").capitalize()    # => "Hello"
  #     R("HELLO").capitalize()    # => "Hello"
  #     R("äöü").capitalize()      # => "äöü"
  #     R("123ABC").capitalize()   # => "123abc"
  #
  # @note Differs from JS toUpperCase in that it does not uppercase special
  #   characters ä, ö, etc
  #
  capitalize:  ->
    new RString(_str.capitalize(@__native__))


  # Modifies str by converting the first character to uppercase and the
  # remainder to lowercase. Returns nil if no changes are made. Note: case
  # conversion is effective only in ASCII region.
  #
  # @example
  #    str = R('hello')
  #    str.capitalize_bang()         # => "Hello"
  #    str                           # => "Hello"
  #
  # @example Already capitalized
  #    str = R("Already capitals")
  #    str.capitalize_bang()         # => null
  #    str                           # => "Already capitals"
  #
  capitalize_bang: ->
    str = _str.capitalize(@__native__)
    if @__native__ is str then null else @replace(str)


  # Case-insensitive version of String#<=>.
  #
  # @example
  #     R("abcdef").casecmp("abcde")     #=> 1
  #     R("aBcDeF").casecmp("abcdef")    #=> 0
  #     R("abcdef").casecmp("abcdefg")   #=> -1
  #     R("abcdef").casecmp("ABCDEF")    #=> 0
  #
  casecmp: (other) ->
    other = R(other).to_str?()
    throw R.TypeError.new() unless other

    @downcase().cmp(other.downcase())


  # If integer is greater than the length of str, returns a new String of
  # length integer with str centered and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #     R("hello").center(4)         # => "hello"
  #     R("hello").center(20)        # => "       hello        "
  #     R("hello").center(20, '123') # => "1231231hello12312312"
  #
  center: (length, padString = ' ') ->
    # TODO: dogfood
    length    = RCoerce.to_int_native(length)
    padString = RCoerce.to_str_native(padString)

    new RString(_str.center(@__native__, length, padString))

  # Passes each character in str to the given block, or returns an enumerator if
  # no block is given.
  #
  # @example
  #     R("hello").each_char (c) -> R.puts(c + ' ')
  #     # out: h e l l o
  #
  # @note Does *not* typecast chars to R.Strings.
  #
  chars: (block) ->
    return @to_enum('chars') unless block && block.call?
    _str.chars(@__native__, block)
    this


  # Returns a new String with the given record separator removed from the end
  # of str (if present). If $/ has not been changed from the default Ruby
  # record separator, then chomp also removes carriage return characters (that
  # is it will remove \n, \r, and \r\n).
  #
  # @example
  #     R("hello").chomp()            # => "hello"
  #     R("hello\n").chomp()          # => "hello"
  #     R("hello\r\n").chomp()        # => "hello"
  #     R("hello\n\r").chomp()        # => "hello\n"
  #     R("hello\r").chomp()          # => "hello"
  #     R("hello \n there").chomp()   # => "hello \n there"
  #     R("hello").chomp("llo")       # => "he"
  #
  chomp: (sep = null) ->
    if sep is null
      this
    else
      new RString(_str.chomp(@__native__, sep))


  # Modifies str in place as described for String#chomp, returning str, or nil if no modifications were made.  #
  #
  # @todo finish specs
  #
  chomp_bang: (sep = null) ->
    if str = _str.chomp(@__native__, sep)
      @replace(str)
    else
      null


  # Returns a new String with the last character removed. If the string ends
  # with \r\n, both characters are removed. Applying chop to an empty string
  # returns an empty string. String#chomp is often a safer alternative, as it
  # leaves the string unchanged if it doesn’t end in a record separator.
  #
  # @example
  #     R("string\r\n").chop()   # => "string"
  #     R("string\n\r").chop()   # => "string\n"
  #     R("string\n").chop()     # => "string"
  #     R("string").chop()       # => "strin"
  #     R("x").chop().chop()     # => ""
  #
  chop: ->
    new RString(_str.chop(@__native__))


  # TODO: chop_bang

  # Returns a one-character string at the beginning of the string.
  #
  # @example
  #     a = R("hello")
  #     a.chr()                  # => 'h'
  #
  chr: ->
    c = if @empty() then "" else @to_native()[0]
    @box c


  # Makes string empty.
  #
  # @example
  #     a = "abcde"
  #     a.clear()    #=> ""
  #
  clear: () ->
    @replace("")


  #codepoints

  # Each other_str parameter defines a set of characters to count. The
  # intersection of these sets defines the characters to count in str. Any
  # other_str that starts with a caret (^) is negated. The sequence c1–c2 means
  # all characters between c1 and c2.
  #
  # @example
  #     a = R("hello world")
  #     a.count "lo"            #=> 5
  #     a.count "lo", "o"       #=> 2
  #     a.count "hello", "^l"   #=> 4
  #     a.count "ej-m"          #=> 4
  #
  # @todo expect( s.count("A-a")).toEqual s.count("A-Z[\\]^_`a")
  #
  count: ->
    args = [@__native__]
    for el, i in arguments
      args.push(RCoerce.to_str_native(el))
    new R.Fixnum(_str.count.apply(_str, args))


  #crypt

  # Returns a copy of str with all characters in the intersection of its
  # arguments deleted. Uses the same rules for building the set of characters as
  # String#count.
  #
  # @example
  #     R("hello").delete "l","lo"        #=> "heo"
  #     R("hello").delete "lo"            #=> "he"
  #     R("hello").delete "aeiou", "^e"   #=> "hell"
  #     R("hello").delete "ej-m"          #=> "ho"
  #
  # @todo expect( R("ABCabc[]").delete("A-a") ).toEqual R("bc")
  #
  delete: (args...) ->
    @dup().tap (s) -> s.delete_bang(args...)

  # Performs a delete operation in place, returning str, or nil if str was not
  # modified.
  #
  delete_bang: (args...) ->
    throw R.ArgumentError.new() if R(args.length).equals(0)
    tbl = new CharTable(args)

    # OPTIMIZE:
    str = []
    R(@to_native().split("")).each (chr) ->
      str.push(chr) if !tbl.include(chr)

    str = str.join('')
    return null if @equals(str)
    @replace str

  # Returns a copy of str with all uppercase letters replaced with their
  # lowercase counterparts. The operation is locale insensitive—only characters
  # “A” to “Z” are affected. Note: case replacement is effective only in ASCII
  # region.
  #
  # @example
  #     R("hEllO").downcase()   #=> "hello"
  #
  downcase: () ->
    new RString(_str.downcase(@__native__))

  # Downcases the contents of str, returning nil if no changes were made.
  #
  # @note case replacement is effective only in ASCII region.
  #
  downcase_bang: () ->
    return null unless @__native__.match(/[A-Z]/)
    @replace(_str.downcase(@__native__))

  # Produces a version of str with all nonprinting characters replaced by \nnn
  # notation and all special characters escaped.
  #
  dump: ->
    escaped =  @to_native().replace(/[\f]/g, '\\f')
      .replace(/["]/g, "\\\"")
      .replace(/[\n]/g, '\\n')
      .replace(/[\r]/g, '\\r')
      .replace(/[\t]/g, '\\t')
      # .replace(/[\s]/g, '\\ ') # do not
    R("\"#{escaped}\"")


  dup: ->
    dup = @clone()
    dup.initialize_copy(this)
    dup



  #each_byte

  # @alias #chars
  each_char: @prototype.chars


  #each_codepoint

  # Splits str using the supplied parameter as the record separator ($/ by
  # default), passing each substring in turn to the supplied block. If a zero-
  # length record separator is supplied, the string is split into paragraphs
  # delimited by multiple successive newlines.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #    print "Example one\n"
  #    "hello\nworld".each_line {|s| p s}
  #    print "Example two\n"
  #    "hello\nworld".each_line('l') {|s| p s}
  #    print "Example three\n"
  #    "hello\n\n\nworld".each_line('') {|s| p s}
  #    # produces:
  #    # Example one
  #    # "hello\n"
  #    # "world"
  #    # Example two
  #    # "hel"
  #    # "l"
  #    # "o\nworl"
  #    # "d"
  #    # Example three
  #    # "hello\n\n\n"
  #    # "world"
  #
  each_line: (args...) ->
    block = @__extract_block(args)

    return @to_enum('lines', args[0]) unless block && block.call?

    if args[0] is null
      block(this)
      return

    separator = R(if args[0] is undefined then R['$/'] else args[0])
    # TODO: Use RCoerce?
    throw R.TypeError.new() unless separator.to_str?
    separator = separator.to_str()
    separator = "\n\n" if separator.length is 0 # '' goes into "paragraph" mode

    # TODO: simplify dogfood
    lft = 0
    rgt = null
    dup = @dup() # allows the string to be changed with bang methods
    while rgt = dup.index(separator, lft)
      rgt = rgt.succ()
      str = dup.slice(lft, rgt.minus(lft))
      lft = rgt
      block(str)

    if remainder = R(dup.to_native().slice(lft.to_native()))
      block(remainder) unless remainder.empty()

    this

  # Returns true if str has a length of zero.
  #
  # @example
  #     "hello".empty()   #=> false
  #     "".empty()        #=> true
  #     " ".empty()       #=> true
  #
  empty: ->
    _str.empty(@__native__)


  #encode


  #encoding

  # Returns true if str ends with one of the suffixes given.
  #
  end_with: (needles...) ->
    needles = _arr.select(needles, (s) -> R(s)?.to_str? )
    neeldes = _arr.map(needles, _fn(RCoerce.to_str_native) )

    _str.end_with(@__native__, needles...)


  # Two strings are equal if they have the same length and content.
  #
  # @example
  #
  #     R("foo").eql('foo')      # => true
  #     R("foo").eql('FOO')      # => false
  #     R("foo").eql(R('foo'))   # => true
  #
  # @return true/false
  #
  eql: (other) ->
    @['<=>'](other) is 0


  #equal?


  #force_encoding


  get: ->
    @slice.apply(this, arguments)


  # @todo idx with count. set(0, 2, "a"), aka [0,2] = 'a'
  # @todo idx as Regexp
  set: (idx, other) ->
    idx   = R(idx)
    other = RCoerce.to_str(other)
    index = null

    if idx.to_int?
      index = idx.to_int().to_native()
      index += @length if index < 0 # On negative count

      if index < 0 or index > @length
        throw R.IndexError.new() # raise IndexError, "index #{index} out of string"

    else if idx.to_str?
      index = @index(idx)
      unless index
        throw R.IndexError.new() # "string not matched"

    chrs = @to_native().split("")
    chrs[index] = other

    @replace(chrs.join(''))

    return other


  #getbyte


  # Returns a copy of str with the all occurrences of pattern substituted for
  # the second argument. The pattern is typically a Regexp; if given as a
  # String, any regular expression metacharacters it contains will be
  # interpreted literally, e.g. '\\d' will match a backlash followed by ‘d’,
  # instead of a digit.
  #
  # If replacement is a String it will be substituted for the matched text. It
  # may contain back-references to the pattern’s capture groups of the form
  # \\d, where d is a group number, or \\k<n>, where n is a group name. If it
  # is a double-quoted string, both back-references must be preceded by an
  # additional backslash. However, within replacement the special match
  # variables, such as &$, will not refer to the current match.
  #
  # If the second argument is a Hash, and the matched text is one of its keys,
  # the corresponding value is the replacement string.
  #
  # In the block form, the current match string is passed in as a parameter,
  # and variables such as $1, $2, $`, $&, and $' will be set appropriately.
  # The value returned by the block will be substituted for the match on each
  # call.
  #
  # The result inherits any tainting in the original string or any supplied
  # replacement string.
  #
  # When neither a block nor a second argument is supplied, an Enumerator is
  # returned.
  #
  # @example
  #     R("hello").gsub(%r[aeiou]/, '*')                  #=> "h*ll*"
  #     R("hello").gsub(%r([aeiou])/, '<\1>')             #=> "h<e>ll<o>"
  #     R("hello").gsub(%r./) {|s| s.ord.to_s + ' '}      #=> "104 101 108 108 111 "
  #     # R("hello").gsub(%r(?<foo>[aeiou])/, '{\k<foo>}')  #=> "h{e}ll{o}"
  #     R('hello').gsub(%r[eo]/, 'e' => 3, 'o' => '*')    #=> "h3ll*"
  #
  # TODO: add hash syntax, properly document supported features
  #
  gsub: (pattern, replacement) ->
    throw R.TypeError.new() if pattern is null

    pattern_lit = String.string_native(pattern)
    if pattern_lit isnt null
      pattern = new RegExp(R.Regexp.escape(pattern_lit), 'g')

    unless R.Regexp.isRegexp(pattern)
      throw R.TypeError.new()

    unless pattern.global
      throw "String#gsub: #{pattern} has not set the global flag 'g'. #{pattern}g"

    replacement = RCoerce.to_str(replacement).to_native()
    gsubbed     = @to_native().replace(pattern, replacement)

    new @constructor(gsubbed) # makes String subclasseable


  #hash


  #hex

  # Returns true if str contains the given string or character.
  #
  # @example
  #     R("hello").include "lo"   #=> true
  #     R("hello").include "ol"   #=> false
  #     R("hello").include hh     #=> true
  #
  include: (other) ->
    other = RCoerce.to_str_native(other)
    _str.include(@__native__, other)


  # Returns the index of the first occurrence of the given substring or pattern
  # (regexp) in str. Returns nil if not found. If the second parameter is
  # present, it specifies the position in the string to begin the search.
  #
  # @example
  #     R("hello").index('e')             #=> 1
  #     R("hello").index('lo')            #=> 3
  #     R("hello").index('a')             #=> nil
  #     R("hello").index(ee)              #=> 1
  #     R("hello").index(/[aeiou]/, -3)   #=> 4
  #
  # @todo #index(regexp)
  #
  index: (needle, offset) ->
    needle = RCoerce.to_str_native(needle)
    offset = RCoerce.to_int_native(offset) if offset?
    val = _str.index(@__native__, needle, offset)
    if val is null then null else new R.Fixnum(val)


  #initialize_copy


  # Inserts other_str before the character at the given index, modifying str.
  # Negative indices count from the end of the string, and insert after the
  # given character. The intent is insert aString so that it starts at the
  # given index.
  #
  # @example
  #     R("abcd").insert(0, 'X')    # => "Xabcd"
  #     R("abcd").insert(3, 'X')    # => "abcXd"
  #     R("abcd").insert(4, 'X')    # => "abcdX"
  #
  # @example inserts after with negative counts
  #     R("abcd").insert(-3, 'X')   # => "abXcd"
  #     R("abcd").insert(-1, 'X')   # => "abcdX"
  #
  insert: (idx, other) ->
    idx   = RCoerce.to_int(idx)
    other = RCoerce.to_str(other)
    # TODO: optimize typecast
    idx = idx.to_native()
    if idx < 0
      # On negative count
      idx = @length - Math.abs(idx) + 1

    if idx < 0 or idx > @length
      throw R.IndexError.new()

    chrs = @to_native().split("") # TODO: use @chrs

    before = chrs[0...idx]
    insert = other.to_native().split("")
    after  = chrs.slice(idx)
    @replace(before.concat(insert).concat(after).join(''))


  # Returns a printable version of str, surrounded by quote marks, with
  # special characters escaped.
  #
  # @example
  #     str = "hello"
  #     str[3] = "\b"
  #     str.inspect       #=> "\"hel\\bo\""
  #
  # @todo For now just an alias to dump
  #
  inspect: -> @dump()


  #intern

  # @alias #each_line
  lines: @prototype.each_line


  # If integer is greater than the length of str, returns a new String of
  # length integer with str left justified and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #     R("hello").ljust(4)            #=> "hello"
  #     R("hello").ljust(20)           #=> "hello               "
  #     R("hello").ljust(20, '1234')   #=> "hello123412341234123"
  #
  ljust: (width, padString = " ") ->
    width     = RCoerce.to_int_native(width)
    padString = RCoerce.to_str_native(padString)
    new RString(_str.ljust(@__native__, width, padString))


  # Returns a copy of str with leading whitespace removed. See also
  # String#rstrip and String#strip.
  #
  # @example
  #     R("  hello  ").lstrip()   #=> "hello  "
  #     R("hello").lstrip()       #=> "hello"
  #
  lstrip: () ->
    new RString(_str.lstrip(@__native__))


  # Removes leading whitespace from str, returning nil if no change was made.
  # See also String#rstrip! and String#strip!.
  #
  # @example
  #     R("  hello  ").lstrip_bang()  #=> "hello  "
  #     R("hello").lstrip_bang()      #=> nil
  #
  lstrip_bang: ->
    return null unless @to_native().match(/^[\s\n\t]+/)
    @replace(_str.lstrip(@__native__))


  # Converts pattern to a Regexp (if it isn’t already one), then invokes its
  # match method on str. If the second parameter is present, it specifies the
  # position in the string to begin the search.
  #
  # If a block is given, invoke the block with MatchData if match succeed, so
  # that you can write
  #
  # @example
  #     R('hello').match('(.)\1')      #=> #<MatchData "ll" 1:"l">
  #     R('hello').match('(.)\1')[0]   #=> "ll"
  #     R('hello').match(/(.)\1/)[0]   #=> "ll"
  #     R('hello').match('xx')         #=> nil
  #
  # @example with block:
  #     str.match(pat) {|m| ...}
  #     # instead of:
  #     if m = str.match(pat)
  #       ...
  #     end
  #
  # The return value is a value from block execution in this case.
  #
  match: (pattern, offset, block) ->
    _str.match(@__native__, pattern, offset, block)


  # Searches sep or pattern (regexp) in the string and returns the part before
  # it, the match, and the part after it. If it is not found, returns two
  # empty strings and str.
  #
  # @example
  #     R("hello").partition("l")         # => ["he", "l", "lo"]
  #     R("hello").partition("x")         # => ["hello", "", ""]
  #     R("hello").partition(/.l/)        # => ["h", "el", "lo"]
  #
  # @example headers
  #     partition(sep) -> [head, sep, tail]
  #     partition(regexp) -> [head, match, tail]
  #
  # @todo does not yet accept regexp as pattern
  # @todo does not yet affect R['$~']
  #
  partition: (pattern) ->
    # TODO: regexps
    pattern = RCoerce.to_str_native(pattern)
    new RArray(_str.partition(@__native__, pattern))


  # Prepend the given string to str.
  #
  # @example
  #     a = R(“world” )
  #     a.prepend(“hello ”) #=> “hello world”
  #     a #=> “hello world”
  #
  prepend: (other) ->
    other = RCoerce.to_str_native(other)
    @replace(other + @to_native())


  # Replaces the contents and taintedness of str with the corresponding values
  # in other_str.
  #
  # @todo Does not copy taintedness
  #
  # @example
  #
  #     s = R("hello")            #=> "hello"
  #     s.replace "world"         #=> "world"
  #     s.replace R("world")      #=> "world"
  #
  replace: (val) ->
    unless typeof val is 'string'
      val = R(val)
      throw R.TypeError.new() unless val.to_str?
      val = val.to_str().valueOf()

    @__native__ = val
    @length     = val.length
    this


  # Returns a new string with the characters from str in reverse order.
  #
  # @example
  #     R("stressed").reverse()   #=> "desserts"
  #
  reverse: ->
    new RString(_str.reverse(@__native__))


  # Reverses str in place.
  reverse_bang: ->
    @replace(_str.reverse(@__native__))

  # Returns the index of the last occurrence of the given substring or pattern
  # (regexp) in str. Returns nil if not found. If the second parameter is
  # present, it specifies the position in the string to end the
  # search—characters beyond this point will not be considered.
  #
  # @example
  #     R("hello").rindex('e')             #=> 1
  #     R("hello").rindex('l')             #=> 3
  #     R("hello").rindex('a')             #=> nil
  #     R("hello").rindex(ee)              #=> 1
  #     R("hello").rindex(/[aeiou]/, -2)   #=> 1
  #
  # @todo #rindex(/.../) does not add matches to R['$~'] as it should
  # @todo #rindex(needle, offset) does not use respond_to?(:to_int) for offset
  #       to convert it to_int.
  #
  rindex: (needle, offset) ->
    throw R.TypeError.new('TypeError') if offset is null

    needle = R(needle)

    # TODO: extract to coerce_to(:to_str, :regexp, ...) function
    if needle.to_str?          then needle = needle.to_str()
    else if needle.is_regexp?  then needle = needle #.to_regexp()
    else                       throw R.TypeError.new('TypeError')

    offset = @box(offset)?.to_int()

    if offset != undefined
      offset = offset.plus(@size()) if offset.lt(0)
      return null if offset.lt(0)

      if needle.is_string?
        offset = offset.plus(needle.size())
        ret = @to_native()[0...offset].lastIndexOf(needle.to_native())
      else
        ret = @__rindex_with_regexp__(needle, offset)
    else
      if needle.is_string?
        ret = @to_native().lastIndexOf(needle.to_native())
      else
        ret = @__rindex_with_regexp__(needle)

    if ret is -1 then null else @$Integer(ret)

  # @private
  # @param needle R.Regexp
  # @param offset [number]
  __rindex_with_regexp__: (needle, offset) ->
    needle = needle.to_native()
    offset = @box(offset)

    idx    = 0
    length = @size()
    # if regexp starts with /^ do not iterate.
    # however this is wrong behaviour, it should match from \n.
    match_begin = needle.toString().match(/\/\^/) != null

    ret         = -1
    while match = @to_native()[idx..-1].match(needle)
      break if offset && offset < (idx + match.index)
      ret = idx
      idx = idx + 1
      break if match_begin or idx > length

    ret

  # If integer is greater than the length of str, returns a new String of
  # length integer with str right justified and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #     R("hello").rjust(4)            #=> "hello"
  #     R("hello").rjust(20)           #=> "               hello"
  #     R("hello").rjust(20, '1234')   #=> "123412341234123hello"
  #
  rjust: (width, padString = " ") ->
    width     = RCoerce.to_int_native(width)
    padString = RCoerce.to_str_native(padString)
    new RString(_str.rjust(@__native__, width, padString))


  # Searches sep or pattern (regexp) in the string from the end of the string,
  # and returns the part before it, the match, and the part after it. If it is
  # not found, returns two empty strings and str.
  #
  # @example
  #     R("hello").rpartition("l")         #=> ["hel", "l", "o"]
  #     R("hello").rpartition("x")         #=> ["", "", "hello"]
  #
  # @example edge cases
  #     R("hello").rpartition("x")         #=> ["", "", "hello"]
  #     R("hello").rpartition("hello")     #=> ["", "hello", ""]
  #
  # @example todo:
  #     R("hello").rpartition(/.l/)        #=> ["he", "ll", "o"]
  #
  # @todo does not yet accept regexp as pattern
  # @todo does not yet affect R['$~']
  rpartition: (pattern) ->
    # TODO: regexps
    pattern = RCoerce.to_str(pattern).to_str()

    if idx = @rindex(pattern)
      start = idx + pattern.length
      len = @size() -  start
      a = @slice(0,idx)
      b = pattern.dup()
      c = R(@to_native().slice(start))

    a ||= R("")
    b ||= R("")
    c ||= this

    return R([a,b,c])

  # Returns a copy of str with trailing whitespace removed. See also
  # String#lstrip and String#strip.
  #
  # @example
  #     R("  hello  ").rstrip()   #=> "  hello"
  #     R("hello").rstrip()       #=> "hello"
  #
  rstrip: () ->
    @dup().tap (s) -> s.rstrip_bang()

  # Removes trailing whitespace from str, returning nil if no change was made.
  # See also String#lstrip! and String#strip!.
  #
  # @example
  #     R("  hello  ").rstrip_bang()  #=> "  hello"
  #     R("hello").rstrip_bang()      #=> nil
  #
  rstrip_bang: ->
    return null unless @to_native().match(/[\s\n\t]+$/)
    @replace(@to_native().replace(/[\s\n\t]+$/g, ''))


  # Both forms iterate through str, matching the pattern (which may be a
  # Regexp or a String). For each match, a result is generated and either
  # added to the result array or passed to the block. If the pattern contains
  # no groups, each individual result consists of the matched string, $&. If
  # the pattern contains groups, each individual result is itself an array
  # containing one entry per group.
  #
  # @example
  #     a = R("cruel world")
  #     a.scan(/\w+/)        #=> ["cruel", "world"]
  #     a.scan(/.../)        #=> ["cru", "el ", "wor"]
  #     a.scan(/(...)/)      #=> [["cru"], ["el "], ["wor"]]
  #     a.scan(/(..)(..)/)   #=> [["cr", "ue"], ["l ", "wo"]]
  #     #And the block form:
  #     a.scan(/\w+/, (w) -> R.puts "<<#{w}>> ")
  #     print "\n"
  #     a.scan(/(.)(.)/, (x,y) -> R.puts y, x )
  #     print "\n"
  #     # produces:
  #     # <<cruel>> <<world>>
  #     # rceu lowlr
  #
  # @todo some untested specs
  #
  scan: (pattern, block = null) ->
    unless R.Regexp.isRegexp(pattern)
      pattern = RCoerce.to_str_native(pattern)
      pattern = R.Regexp.quote(pattern)

    index = 0

    R['$~'] = null
    match_arr = if block != null then this else []

    # FIXME: different from rubinius implementation
    while match = @__native__[index..-1].match(pattern)
      fin  = index + match.index + match[0].length
      fin += 1 if match[0].length == 0

      R['$~'] = new R.MatchData(match, {offset: index, string: @__native__})

      if match.length > 1
        val = new R.Array(new R.String(m) for m in match[1...match.length])
      else
        val = new R.Array([new R.String(match[0])])

      if block != null
        block(val)
      else
        val = val.first() if match.length == 1
        match_arr.push val

      index = fin
      break if index > this.length

    # return this if block was passed
    if block != null then this else (new R.Array(match_arr))

  #setbyte

  size: -> @$Integer(@to_native().length)


  # Element Reference—If passed a single Fixnum, returns a substring of one
  # character at that position. If passed two Fixnum objects, returns a
  # substring starting at the offset given by the first, and with a length
  # given by the second. If passed a range, its beginning and end are
  # interpreted as offsets delimiting the substring to be returned. In all
  # three cases, if an offset is negative, it is counted from the end of str.
  # Returns nil if the initial offset falls outside the string or the length
  # is negative.
  #
  # If a Regexp is supplied, the matching portion of str is returned. If a
  # numeric or name parameter follows the regular expression, that component
  # of the MatchData is returned instead. If a String is given, that string is
  # returned if it occurs in str. In both cases, nil is returned if there is
  # no match.
  #
  # @example
  #     a = R("hello there")
  #     a.slice(1)                      #=> "e"
  #     a.slice(2, 3)                   #=> "llo"
  #     a.slice(R.rng(2, 3))            #=> "ll"
  #     a.slice(-3, 2)                  #=> "er"
  #     a.slice(R.rng(7, -2))           #=> "her"
  #     a.slice(R.rng(-4, -2))          #=> "her"
  #     a.slice(R.rng(-2, -4))          #=> ""
  #     a.slice(R.rng(12, -1))          #=> null
  #     a.slice(/[aeiou](.)\11//)       #=> "ell"
  #     a.slice(/[aeiou](.)\11//, 0)    #=> "ell"
  #     a.slice(/[aeiou](.)\11//, 1)    #=> "l"
  #     a.slice(/[aeiou](.)\11//, 2)    #=> null
  #     a.slice("lo")                   #=> "lo"
  #     a.slice("bye")                  #=> null
  #
  # @todo Implement support for ranges slice(R.Range.new(...))
  # @todo regexp
  #
  slice: (index, other) ->
    throw R.TypeError.new() if index is null

    index = R(index)
    unless other is undefined
      if index.is_regexp?
        throw R.NotImplementedError.new()
      else
        index = RCoerce.to_int_native(index)
        other = RCoerce.to_int_native(other)
        val   = _str.slice(@__native__, index, other)
        return if val? then new RString(val) else null


    if index.is_regexp?
      throw R.NotImplementedError.new()
    else if index.is_string?
      index = RCoerce.to_str_native(index)
    else if index.is_range?
      # nothing
    else
      index = RCoerce.to_int_native(index)

    val   = _str.slice(@__native__, index)
    if val? then new RString(val) else null





  # Divides str into substrings based on a delimiter, returning an array of
  # these substrings.
  #
  # If pattern is a String, then its contents are used as the delimiter when
  # splitting str. If pattern is a single space, str is split on whitespace,
  # with leading whitespace and runs of contiguous whitespace characters
  # ignored.
  #
  # If pattern is a Regexp, str is divided where the pattern matches. Whenever
  # the pattern matches a zero-length string, str is split into individual
  # characters. If pattern contains groups, the respective matches will be
  # returned in the array as well.
  #
  # If pattern is omitted, the value of $; is used. If $; is nil (which is the
  # default), str is split on whitespace as if ` ‘ were specified.
  #
  # If the limit parameter is omitted, trailing null fields are suppressed. If
  # limit is a positive number, at most that number of fields will be returned
  # (if limit is 1, the entire string is returned as the only entry in an
  # array). If negative, there is no limit to the number of fields returned,
  # and trailing null fields are not suppressed.
  #
  # @example
  #     R(" now's  the time").split()      #=> ["now's", "the", "time"]
  #     R(" now's  the time").split(' ')   #=> ["now's", "the", "time"]
  #     R(" now's  the time").split(/ /)   #=> ["", "now's", "", "the", "time"]
  #     R("1, 2.34,56, 7").split(%r{,\s*}) #=> ["1", "2.34", "56", "7"]
  #     R("hello").split(//)               #=> ["h", "e", "l", "l", "o"]
  #     # R("hello").split(//, 3)            #=> ["h", "e", "llo"]
  #     R("hi mom").split(%r{\s*})         #=> ["h", "i", "m", "o", "m"]
  #
  #     R("mellow yellow").split("ello")   #=> ["m", "w y", "w"]
  #     R("1,2,,3,4,,").split(',')         #=> ["1", "2", "", "3", "4"]
  #     # R("1,2,,3,4,,").split(',', 4)      #=> ["1", "2", "", "3,4,,"]
  #     # R("1,2,,3,4,,").split(',', -4)     #=> ["1", "2", "", "3", "4", "", ""]
  #
  # split(pattern=$;, [limit]) → anArray
  #
  # @todo limit is not yet supported
  #
  split: (pattern = " ", limit) ->
    unless R.Regexp.isRegexp(pattern)
      pattern = RCoerce.to_str(pattern).to_native()

    ret = @to_native().split(pattern)
    ret = R(new @constructor(str) for str in ret)

    # remove trailing empty fields
    while str = ret.last()
      break unless str.empty()
      ret.pop()

    if pattern is ' '
      ret.delete_if (str) -> str.empty()
    # TODO: if regexp does not include non-matching captures in the result array

    ret


  # @todo Not yet implemented
  squeeze_bang: ->
    throw new R.NotImplementedError()

  # Builds a set of characters from the other_str parameter(s) using the
  # procedure described for String#count. Returns a new string where runs of
  # the same character that occur in this set are replaced by a single
  # character. If no arguments are given, all runs of identical characters are
  # replaced by a single character.
  #
  # @example
  #     R("yellow moon").squeeze()                #=> "yelow mon"
  #     R("  now   is  the").squeeze(" ")         #=> " now is the"
  #     R("putters shoot balls").squeeze("m-z")   #=> "puters shot balls"
  #
  # @todo Fix A-a bug
  #
  squeeze: (pattern...) ->
    tbl   = new CharTable(pattern)
    chars = @to_native().split("")
    len   = @to_native().length
    i     = 1
    j     = 0
    last  = chars[0]
    all   = pattern.length == 0
    while i < len
      c = chars[i]
      unless c == last and (all || tbl.include(c))
        chars[j+=1] = last = c
      i += 1

    if (j + 1) < len
      chars = chars[0..j]

    new @constructor(chars.join(''))


  # Returns true if str starts with one of the prefixes given.
  #
  # @example
  #     R("hello").start_with("hell")               #=> true
  #     # returns true if one of the prefixes matches.
  #     R("hello").start_with("heaven", "hell")     #=> true
  #     R("hello").start_with("heaven", "paradise") #=> false
  #
  start_with: (needles...) ->
    needles = _arr.select(needles, (s) -> R(s)?.to_str? )
    neeldes = _arr.map(needles, _fn(RCoerce.to_str_native) )

    _str.start_with(@__native__, needles...)


  # Returns a copy of str with leading and trailing whitespace removed.
  #
  # @example
  #     R("    hello    ").strip()   #=> "hello"
  #     R("\tgoodbye\r\n").strip()   #=> "goodbye"
  #
  strip: () ->
    @dup().tap (s) -> s.strip_bang()


  # Removes leading and trailing whitespace from str. Returns nil if str was
  # not altered.
  #
  # @return str or null
  #
  strip_bang: () ->
    l = @lstrip_bang()
    r = @rstrip_bang()
    if l is null and r is null then null else this

  # Returns a copy of str with the first occurrence of pattern substituted for
  # the second argument. The pattern is typically a Regexp; if given as a
  # String, any regular expression metacharacters it contains will be
  # interpreted literally, e.g. '\\d' will match a backlash followed by ‘d’,
  # instead of a digit.
  #
  # If replacement is a String it will be substituted for the matched text. It
  # may contain back-references to the pattern’s capture groups of the form
  # \\d, where d is a group number, or \\k<n>, where n is a group name. If it
  # is a double-quoted string, both back-references must be preceded by an
  # additional backslash. However, within replacement the special match
  # variables, such as &$, will not refer to the current match.
  #
  # If the second argument is a Hash, and the matched text is one of its keys,
  # the corresponding value is the replacement string.
  #
  # In the block form, the current match string is passed in as a parameter,
  # and variables such as $1, $2, $`, $&, and $' will be set appropriately.
  # The value returned by the block will be substituted for the match on each
  # call.
  #
  # The result inherits any tainting in the original string or any supplied
  # replacement string.
  #
  # @example
  #     R("hello").sub(/[aeiou]/, '*')                  #=> "h*llo"
  #     R("hello").sub(/([aeiou])/, '<\1>')             #=> "h<e>llo"
  #     R("hello").sub(/./, (s) -> s.ord.to_s() + ' ' ) #=> "104 ello"
  #     # R("hello").sub(/(?<foo>[aeiou])/, '*\k<foo>*')  #=> "h*e*llo"
  #
  # @todo #sub does not yet add matches to R['$~'] as it should
  # @todo String#sub with pattern and block
  sub: (pattern, replacement) ->
    @dup().tap (dup) -> dup.sub_bang(pattern, replacement)

  # Performs the substitutions of String#sub in place, returning str, or nil
  # if no substitutions were performed.
  #
  sub_bang: (pattern, replacement) ->
    throw R.TypeError.new() if pattern is null

    pattern_lit = String.string_native(pattern)
    if pattern_lit isnt null
      pattern = new RegExp(R.Regexp.escape(pattern_lit))

    unless R.Regexp.isRegexp(pattern)
      throw R.TypeError.new()

    if pattern.global
      throw "String#sub: #{pattern} has set the global flag 'g'. #{pattern}g"

    replacement = RCoerce.to_str_native(replacement)
    subbed      = @to_native().replace(pattern, replacement)

    @replace(subbed)

  # Returns the successor to str. The successor is calculated by incrementing
  # characters starting from the rightmost alphanumeric (or the rightmost
  # character if there are no alphanumerics) in the string. Incrementing a
  # digit always results in another digit, and incrementing a letter results
  # in another letter of the same case. Incrementing nonalphanumerics uses the
  # underlying character set’s collating sequence.
  #
  # If the increment generates a “carry,” the character to the left of it is
  # incremented. This process repeats until there is no carry, adding an
  # additional character if necessary.
  #
  # @example
  #     R("abcd").succ()        #=> "abce"
  #     R("THX1138").succ()     #=> "THX1139"
  #     R("<<koala>>").succ()   #=> "<<koalb>>"
  #     R("1999zzz").succ()     #=> "2000aaa"
  #     R("ZZZ9999").succ()     #=> "AAAA0000"
  #     R("***").succ()         #=> "**+"
  #
  # @alias #next
  #
  succ: ->
    @dup().succ_bang()

  # Equivalent to String#succ, but modifies the receiver in place.
  #
  # @alias #next_bang
  #
  succ_bang: ->
    if this.length == 0
      @replace ""
    else
      codes      = (c.charCodeAt(0) for c in @to_native().split(""))
      carry      = null               # for "z".succ => "aa", carry is 'a'
      last_alnum = 0                  # last alpha numeric
      start      = codes.length - 1
      while start >= 0
        s = codes[start]
        if String.fromCharCode(s).match(/[a-zA-Z0-9]/) != null
          carry = 0

          if (48 <= s && s < 57) || (97 <= s && s < 122) || (65 <= s && s < 90)
            codes[start] = codes[start]+1
          else if s == 57              # 9
            codes[start] = 48          # 0
            carry = 49                 # 1
          else if s == 122             # z
            codes[start] = carry = 97  # a
          else if s == 90              # Z
            codes[start] = carry = 65  # A

          break if carry == 0
          last_alnum = start
        start -= 1

      if carry == null
        start = codes.length - 1
        carry = 1

        while start >= 0
          s = codes[start]
          if s >= 255
            codes[start] = 0
          else

            codes[start] = codes[start]+1
            break
          start -= 1

      chars = (String.fromCharCode(c) for c in codes)
      if start < 0
        chars[last_alnum] = nativeString.fromCharCode(carry, codes[last_alnum])

      @replace(chars.join(""))


  # @alias #succ
  next:      @prototype.succ

  # @alias #succ_bang
  next_bang: @prototype.succ_bang


  #sum

  # Returns a copy of str with uppercase alphabetic characters converted to
  # lowercase and lowercase characters converted to uppercase. Note: case
  # conversion is effective only in ASCII region.
  #
  # @example
  #     R("Hello").swapcase()          #=> "hELLO"
  #     R("cYbEr_PuNk11").swapcase()   #=> "CyBeR_pUnK11"
  #
  swapcase: () ->
    @dup().tap (s) -> s.swapcase_bang()


  # Equivalent to String#swapcase, but modifies the receiver in place,
  # returning str, or nil if no changes were made. Note: case conversion is
  # effective only in ASCII region.
  #
  swapcase_bang: () ->
    return null unless @to_native().match(/[a-zA-Z]/)
    @replace R(@__char_natives__()).map((c) ->
      if c.match(/[a-z]/)
        c.toUpperCase()
      else if c.match(/[A-Z]/)
        c.toLowerCase()
      else
        c
    ).join('').to_native()


  to_a: ->
    if @empty() then @$Array([]) else @$Array([this])


  #to_c


  # @private
  valid_float: () ->
    number_match = @to_native().match(/^([\+\-]?\d[_\d]*)(\.\d*)?([eE][\+\-]?[\d_]+)?$/)
    number_match?[0]?

  # Returns the result of interpreting leading characters in str as a floating point number. Extraneous characters past the end of a valid number are ignored. If there is not a valid number at the start of str, 0.0 is returned. This method never raises an exception.
  #
  # @example
  #     R("123.45e1").to_f()        #=> 1234.5
  #     R("45.67 degrees").to_f()   #=> 45.67
  #     R("thx1138").to_f()         #=> 0.0
  #
  # @todo Some exotic formats not yet fully supported.
  #
  to_f: ->
    number_match  = @to_native().match(/^([\+\-]?[_\d\.]+)([Ee\+\-\d]+)?/)
    number_string = number_match?[0] ? "0.0"
    @$Float Number(number_string.replace(/_/g, ''))


  # @BASE_IDENTIFIER:
  #   '0b': 2
  #   '0d': 10
  #   '0o': 8
    # '0x': 16

  # @BASE_REGEXP:
  #   2:  /01/
  #   4:  /[0-3]/
  #   8:  /[0-7]/
  #   10: /\d/
  #   16: /[\dA-Fa-f]/
  #   36: /[\dA-Za-z]/


  # Returns the result of interpreting leading characters in str as an integer
  # base base (between 2 and 36). Extraneous characters past the end of a valid
  # number are ignored. If there is not a valid number at the start of str, 0 is
  # returned. This method never raises an exception when base is valid.
  #
  # @example
  #     R("12345").to_i()           #=> 12345
  #     R("1_23_45").to_i()           #=> 12345
  #     R("99 red balloons").to_i() #=> 99
  #     R("0a").to_i()              #=> 0
  #     R("0a").to_i(16)            #=> 10
  #     R("hello").to_i()           #=> 0
  #     R("1100101").to_i(2)        #=> 101
  #     R("1100101").to_i(8)        #=> 294977
  #     R("1100101").to_i(10)       #=> 1100101
  #     R("1100101").to_i(16)       #=> 17826049
  #     # but:
  #     R("_12345").to_i()          #=> 0
  #     # TODO:
  #     R("0b10101").to_i(0)        #=> 21
  #     R("0b1010134").to_i(2)      #=> 21
  #
  # @todo #to_i(base) does not remove invalid characters:
  #       - e.g: R("1012").to_i(2) should return 5, but due to 2 being invalid it retunrs 0 now.
  # @todo #to_i(0) does not auto-detect base
  to_i: (base) ->
    base = 10 if base is undefined
    base = RCoerce.to_int_native(base)

    if base < 0 or base > 36 or base is 1
      throw R.ArgumentError.new()

    # ignore whitespace
    lit = @strip().to_native()

    # ([\+\-]?) matches +\- prefixes if any
    # ([^\+^\-_]+) matches everything after, except '_'.
    unless lit.match(/^([\+\-]?)([^\+^\-_]+)/)
      return R(0)

    # replace after check, so that _123 is invalid
    lit = lit.replace(/_/g, '')

    # if base > 0
    #   return R(0) unless BASE_IDENTIFIER[lit[0..1]] is base
    # else if base is 0
    #   base_str = if lit[0].match(/[\+\-]/) then lit[1..2] else lit[0..1]
    #   base = R.String.BASE_IDENTIFIER[base_str]

    @$Integer parseInt(lit, base)


  #to_r


  # Returns the receiver.
  to_s: -> this

  # Returns the receiver.
  to_str: @prototype.to_s


  #to_sym


  # Returns a copy of str with the characters in from_str replaced by the
  # corresponding characters in #to_str. If #to_str is shorter than from_str,
  # it is padded with its last character in order to maintain the
  # correspondence.
  #
  #     R("hello").tr('el', 'ip')      #=> "hippo"
  #     R("hello").tr('aeiou', '*')    #=> "h*ll*"
  #
  # Both strings may use the c1-c2 notation to denote ranges of characters,
  # and from_str may start with a ^, which denotes all characters except those
  # listed.
  #
  #     R("hello").tr('a-y', 'b-z')    #=> "ifmmp"
  #     R("hello").tr('^aeiou', '*')   #=> "*e**o"
  #
  tr: (from_str, to_str) ->
    @dup().tap (dup) -> dup.tr_bang(from_str, to_str)


  # Translates str in place, using the same rules as `String#tr`. Returns `str`,
  # or `nil` if no changes were made.
  #
  tr_bang: (from_str, to_str) ->
    chars = @__char_natives__()

    from       = new CharTable([from_str])
    from_chars = from.include_chars().to_native()

    to         = new CharTable([to_str])
    to_chars   = to.include_chars().to_native()
    to_length  = to_chars.length

    # TODO: optimize, replace in place, avoid for in.
    out = []

    i   = 0
    len = chars.length
    while i < len
      char = chars[i]
      i = i + 1
      if from.include(char)
        idx  = from_chars.indexOf(char)
        idx  = to_length - 1 if idx is -1 or idx >= to_length
        char = to_chars[idx]
      out.push(char)

    str = out.join('')
    if @equals(str) then null else @replace(str)


  # Processes a copy of str as described under String#tr, then removes
  # duplicate characters in regions that were affected by the translation.
  #
  # @example
  #     R("hello").tr_s('l', 'r')     #=> "hero"
  #     R("hello").tr_s('el', '*')    #=> "h*o"
  #     R("hello").tr_s('el', 'hx')   #=> "hhxo"
  #
  # @todo Implement
  #
  tr_s: ->
    throw R.NotImplementedError.new()


  #unpack


  @upcase: (str) ->
    str = RCoerce.to_str_native(str)
    return null unless str.match(/[a-z]/)
    R(str.split('')).map((c) ->
      if c.match(/[a-z]/) then c.toUpperCase() else c
    ).join('').to_native()


  # Returns a copy of str with all lowercase letters replaced with their
  # uppercase counterparts. The operation is locale insensitive—only
  # characters “a” to “z” are affected. Note: case replacement is effective
  # only in ASCII region.
  #
  # @example
  #     R("hEllO").upcase()   #=> "HELLO"
  #
  upcase: () ->
    new RString(_str.upcase(@__native__))

  # Upcases the contents of str, returning nil if no changes were made. Note:
  # case replacement is effective only in ASCII region.
  #
  upcase_bang: () ->
    return null unless @__native__.match(/[a-z]/)
    @replace(_str.upcase(@__native__))


  # Iterates through successive values, starting at str and ending at
  # other_str inclusive, passing each value in turn to the block. The
  # String#succ method is used to generate each value. If optional second
  # argument exclusive is omitted or is false, the last value will be
  # included; otherwise it will be excluded.
  #
  # If no block is given, an enumerator is returned instead.
  #
  # @example
  #     R("a8").upto("b6", (s) -> R.puts(s, ''))
  #     # out: a8 a9 b0 b1 b2 b3 b4 b5 b6
  #
  # If str and other_str contains only ascii numeric characters, both are recognized as decimal numbers. In addition, the width of string (e.g. leading zeros) is handled appropriately.
  #
  # @example
  #     R("9").upto("11").to_a()   #=> ["9", "10", "11"]
  #     R("25").upto("5").to_a()   #=> []
  #     R("07").upto("11").to_a()  #=> ["07", "08", "09", "10", "11"]
  #
  # @todo R('a').upto('c').to_a() should return ['a', 'b', 'c'] (include 'c')
  #
  upto: (stop, exclusive, block) ->
    stop = RCoerce.to_str(stop)
    exclusive ||= false
    if block is undefined and exclusive?.call?
      block = exclusive
      exclusive = false

    throw R.TypeError.new() unless stop?.is_string?
    return R.Enumerator.new(this, 'upto', stop, exclusive) unless block && block.call?

    # stop       = stop.to_str()
    # return this if @lt(stop)
    counter    = @dup()
    compare_fn = if exclusive is false then 'lteq' else 'lt'
    stop_size  = stop.size()
    while counter[compare_fn](stop) && !counter.size().gt(stop_size)
      block( counter )
      counter = counter.succ()

    this

  # used for the remaining missing test
  # _rubyjs_ascii_succ: ->
  #   @$Integer(@to_native().charCodeAt(0)).succ().chr()


  #valid_encoding?


  # ---- Class methods --------------------------------------------------------


  # ---- Private methods ------------------------------------------------------

  # @private
  __char_natives__: ->
    @__native__.split('')


  # ---- Unsupported methods --------------------------------------------------


  # ---- Aliases --------------------------------------------------------------

  @__add_default_aliases__(@prototype)

  # @alias #<<
  concat:   @prototype['<<']

  asciiOnly:    @prototype.ascii_only
  caseCompare:  @prototype.case_compare
  eachChar:     @prototype.each_char
  eachLine:     @prototype.each_line
  endWith:      @prototype.end_with
  startWith:    @prototype.start_with
  trS:          @prototype.tr_s




RString = RubyJS.String
