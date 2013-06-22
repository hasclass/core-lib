class StringMethods
  # @return [Boolean]
  equals: (str, other) ->
    str   = str.valueOf()   if typeof str   is 'object'
    other = other.valueOf() if typeof other is 'object'
    str is other


  # Converts str to camelCase.
  #
  # @example
  #   _s.camelCase('foo-bar')      // => ('fooBar')
  #   _s.camelCase('foo-bar-baz')  // => ('fooBarBaz')
  #   _s.camelCase('foo:bar_baz')  // => ('fooBarBaz')
  #   _s.camelCase('')             // => ('')
  #   _s.camelCase('foo')          // => ('foo')
  #   _s.camelCase('fooBar')       // => ('fooBar')
  #
  # @return [String]
  #
  camel_case: (str) ->
    str.replace /([\:\-\_]+(.))/g, (_1, _2, letter, offset) ->
      if offset then letter.toUpperCase() else letter


  # Returns a copy of str with the first character converted to uppercase and
  # the remainder to lowercase. Note: case conversion is effective only in
  # ASCII region.
  #
  # @example
  #   _s.capitalize("hello")    // => "Hello"
  #   _s.capitalize("HELLO")    // => "Hello"
  #   _s.capitalize("äöü")      // => "äöü"
  #   _s.capitalize("123ABC")   // => "123abc"
  #
  # @note Doesn't handle special characters like ä, ö.
  #
  # @return [String]
  #
  capitalize: (str) ->
    return "" if str.length == 0
    b = _str.downcase(str)
    a = _str.upcase(str[0])
    a + nativeStrSlice.call(b, 1)


  # TODO: casecmp


  # If integer is greater than the length of str, returns a new String of
  # length integer with str centered and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #   _s.center("hello", 4)         // => "hello"
  #   _s.center("hello", 20)        // => "       hello        "
  #   _s.center("hello", 20, '123') // => "1231231hello12312312"
  #
  # @return [String]
  #
  center: (str, length, padString = ' ') ->
    _err.throw_argument() if padString.length == 0

    size = str.length
    return str if size >= length

    lft       = Math.floor((length - size) / 2)
    rgt       = length - size - lft
    max       = if lft > rgt then lft else rgt
    padString = _str.multiply(padString, max)

    padString[0...lft] + str + padString[0...rgt]


  # Passes each character in str to the given block, or returns an enumerator if
  # no block is given.
  #
  # @example
  #     acc = []
  #     _s.chars("foo", function (c) { acc.push(c + ' ') })
  #     acc // => ["f ", "o ", "o "]
  #
  # @note Does *not* typecast chars to R.Strings.
  #
  chars: (str, block) ->
    idx = -1
    len = str.length
    while ++idx < len
      block(str[idx])
    str


  # @alias #chars
  each_char: @prototype.chars


  # Returns a new String with the given record separator removed from the end
  # of str (if present). If $/ has not been changed from the default Ruby
  # record separator, then chomp also removes carriage return characters (that
  # is it will remove \n, \r, and \r\n).
  #
  # @example
  #   _s.chomp("hello")            // => "hello"
  #   _s.chomp("hello\n")          // => "hello"
  #   _s.chomp("hello\r\n")        // => "hello"
  #   _s.chomp("hello\n\r")        // => "hello\n"
  #   _s.chomp("hello\r")          // => "hello"
  #   _s.chomp("hello \n there")   // => "hello \n there"
  #   _s.chomp("hello", "llo")     // => "he"
  #
  # @return [String]
  #
  chomp: (str, sep) ->
    sep = "\n" unless sep?
    sep = __str(sep)
    if sep.length == 0
      regexp = /((\r\n)|\n)+$/
    else if sep is "\n" or sep is "\r" or sep is "\r\n"
      ending = str.match(/((\r\n)|\n|\r)$/)?[0] || "\n"
      regexp = new RegExp("(#{_rgx.escape(ending)})$")
    else
      regexp = new RegExp("(#{_rgx.escape(sep)})$")
    str.replace(regexp, '')


  # Returns a new String with the last character removed. If the string ends
  # with \r\n, both characters are removed. Applying chop to an empty string
  # returns an empty string. String#chomp is often a safer alternative, as it
  # leaves the string unchanged if it doesn’t end in a record separator.
  #
  # @example
  #   _s.chop("string\r\n")   // => "string"
  #   _s.chop("string\n\r")   // => "string\n"
  #   _s.chop("string\n")     // => "string"
  #   _s.chop("string")       // => "strin"
  #   _s.chop(_s.chop("x"))   // => ""
  #
  # @return [String]
  #
  chop: (str) ->
    return str if str.length == 0

    if str.lastIndexOf("\r\n") == str.length - 2
      str.slice(0, -2)
    else
      str.slice(0, -1)


  # Each other_str parameter defines a set of characters to count. The
  # intersection of these sets defines the characters to count in str. Any
  # other_str that starts with a caret (^) is negated. The sequence c1–c2 means
  # all characters between c1 and c2.
  #
  # @example
  #   str = "hello world"
  #   _s.count(str, "lo")           // => 5
  #   _s.count(str, "lo", "o")      // => 2
  #   _s.count(str, "hello", "^l")  // => 4
  #   _s.count(str, "ej-m")         // => 4
  #
  # @param str [String]
  # @param needles [String]
  # @todo expect( s.count("A-a")).toEqual s.count("A-Z[\\]^_`a")
  #
  # @return [Number]
  #
  count: (str, needle) ->
    _err.throw_argument("String.count needs arguments") if arguments.length == 1
    args = _coerce.split_args(arguments, 1)

    _str.__matched__(str, args).length


  # Returns a copy of str with all characters in the intersection of its
  # arguments deleted. Uses the same rules for building the set of characters as
  # String#count.
  #
  # @example
  #   _s.delete("hello", "l","lo")       // => "heo"
  #   _s.delete("hello", "lo")           // => "he"
  #   _s.delete("hello", "aeiou", "^e")  // => "hell"
  #   _s.delete("hello", "ej-m")         // => "ho"
  #
  # @todo expect( R("ABCabc[]").delete("A-a") ).toEqual R("bc")
  #
  # @return [String]
  #
  'delete': (str) ->
    _err.throw_argument() if arguments.length == 1
    args  = _coerce.split_args(arguments, 1)
    trash = _str.__matched__(str, args)
    str.replace(new RegExp("[#{trash}]", 'g'), '')


  each_line: (str, separator, block) ->
    unless block?
      if separator?
        if separator.call?
          block = separator
          separator = null
      else
        block(str)
        return


    # unless separator?
    separator ||= R['$/']

    if separator.length is 0
      separator = "\n\n"

    lft = 0
    rgt = null
    dup = str # allows the string to be changed with bang methods
    while (rgt = _str.index(dup, separator, lft)) != null
      rgt = rgt + 1
      str = _str.slice(dup, lft, rgt - lft)
      lft = rgt
      block(str)

    remainder = nativeStrSlice.call(dup, lft)
    if remainder?
      block(remainder) unless remainder.length == 0

    this


  # Returns a copy of str with all uppercase letters replaced with their
  # lowercase counterparts. The operation is locale insensitive—only characters
  # “A” to “Z” are affected. Note: case replacement is effective only in ASCII
  # region.
  #
  # @example
  #   _s.downcase("hEllO")   // => "hello"
  #
  # @note unlike toLowerCase, downcase doesnt change special characters ä,ö
  #
  # @return [String]
  #
  downcase: (str) ->
    return str unless nativeStrMatch.call(str, /[A-Z]/)

    str.replace /[A-Z]/g, (ch) ->
      String.fromCharCode(ch.charCodeAt(0) | 32)


  # @return [String]
  #
  dump: (str) ->
    escaped =  str.replace(/[\f]/g, '\\f')
      .replace(/["]/g, "\\\"")
      .replace(/[\n]/g, '\\n')
      .replace(/[\r]/g, '\\r')
      .replace(/[\t]/g, '\\t')
      # .replace(/[\s]/g, '\\ ') # do not
    "\"#{escaped}\""


  # @return [Boolean]
  #
  empty: (str) ->
    str.length == 0


  # Returns true if str ends with one of the suffixes given.
  #
  # @return [Boolean]
  #
  end_with: (str) ->
    needles = _coerce.split_args(arguments, 1)
    for w in needles
      try
        w = __str(w)
        if str.lastIndexOf(w) + w.length is str.length
          return true
      catch e

    false


  gsub: (str, pattern, replacement) ->
    _err.throw_type() if pattern is null

    pattern_lit = __try_str(pattern)
    if pattern_lit isnt null
      pattern = new RegExp(_rgx.escape(pattern_lit), 'g')

    unless __isRgx(pattern)
      _err.throw_type()

    unless pattern.global
      throw "String#gsub: #{pattern} has not set the global flag 'g'. #{pattern}g"

    str.replace(pattern, replacement)


  # Returns true if str contains the given string or character.
  #
  # @example
  #   _s.include("hello", "lo")   // => true
  #   _s.include("hello", "ol")   // => false
  #   _s.include("hello", "hh" )  // => true
  #
  # @return [Boolean]
  #
  include: (str, other) ->
    str.indexOf(other) >= 0


  # Returns the index of the first occurrence of the given substring or pattern
  # (regexp) in str. Returns nil if not found. If the second parameter is
  # present, it specifies the position in the string to begin the search.
  #
  # @example
  #   _s.index("hello", 'e')           // => 1
  #   _s.index("hello", 'lo')          // => 3
  #   _s.index("hello", 'a')           // => null
  #   _s.index("hello", 'el')          // => 1
  #   _s.index("hello", /[aeiou]/, -3) // => 4
  #
  # @todo #index(regexp)
  #
  # @return [Number]
  #
  index: (str, needle, offset) ->
    needle = __str(needle)

    if offset?
      offset = __int(offset)
      offset = str.length + offset if offset < 0

    # unless needle.is_string? or needle.is_regexp? or needle.is_fixnum?
    #   _err.throw_type()

    if offset? && (offset > str.length or offset < 0)
      return null

    idx = str.indexOf(needle, offset)
    if idx < 0
      null
    else
      idx


  # Inserts other_str before the character at the given index, modifying str.
  # Negative indices count from the end of the string, and insert after the
  # given character. The intent is insert aString so that it starts at the
  # given index.
  #
  # @example
  #   _s.insert("abcd", 0, 'X')    // => "Xabcd"
  #   _s.insert("abcd", 3, 'X')    // => "abcXd"
  #   _s.insert("abcd", 4, 'X')    // => "abcdX"
  #
  # @example inserts after with negative counts
  #   _s.insert("abcd", -3, 'X')   // => "abXcd"
  #   _s.insert("abcd", -1, 'X')   // => "abcdX"
  #
  # @return [String]
  #
  insert: (str, idx, other) ->
    if idx < 0
      # On negative count
      idx = str.length - Math.abs(idx) + 1

    if idx < 0 or idx > str.length
      _err.throw_index()

    before = str.slice(0, idx)
    after  = str.slice(idx)
    before + other + after


  # If integer is greater than the length of str, returns a new String of
  # length integer with str left justified and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #   _s.ljust("hello", 4)           // => "hello"
  #   _s.ljust("hello", 20)          // => "hello               "
  #   _s.ljust("hello", 20, '1234')  // => "hello123412341234123"
  #
  # @return [String]
  #
  ljust: (str, width, padString = " ") ->
    len = str.length
    if len >= width
      str
    else
      _err.throw_argument() if padString.length == 0
      pad_length = width - len
      idx = -1
      out = ""
      # TODO refactor
      out += padString while ++idx <= pad_length
      str + out.slice(0, pad_length)


  # Returns a copy of str with leading whitespace removed. See also
  # String#rstrip and String#strip.
  #
  # @example
  #   _s.lstrip("  hello  ")  // => "hello  "
  #   _s.lstrip("hello")      // => "hello"
  #
  # @return [String]
  #
  lstrip: (str) ->
    str.replace(/^[\s\n\t]+/g, '')


  match: (str, pattern, offset = null, block) ->
    unless block?
      if offset?.call?
        block = offset
        offset = null

    # unless RString.isString(pattern) or __isRgx(pattern)
    #   _err.throw_type()

    opts = {}

    if offset?
      opts = {string: str, offset: offset}
      str = nativeStrSlice.call(str, offset)
      matches = nativeStrMatch.call(str, pattern, offset)
    else
      # Firefox breaks if you'd pass str.match(..., undefined)
      matches = nativeStrMatch.call(str, pattern)

    result = if matches
      new R.MatchData(matches, opts)
    else
      null

    R['$~'] = result

    if block
      if result then block(result) else []
    else
      result


  # Copy—Returns a new String containing integer copies of the receiver.
  #
  # @example
  #   _s.multiply("Ho! ", 3)   // => "Ho! Ho! Ho! "
  #
  # @return [String]
  #
  multiply: (str, num) ->
    _err.throw_argument() if num < 0
    out = ""
    n = 0
    while ++n <= num
      out += str
    out


  partition: (str, pattern) ->
    # TODO: regexps
    idx = _str.index(str, pattern)
    unless idx is null
      start = idx + pattern.length
      a = _str.slice(str, 0, idx) || ''
      b = pattern
      c = nativeStrSlice.call(str, start)
      [a,b,c]
    else
      [str, '', '']


  # Returns a new string with the characters from str in reverse order.
  #
  # @example
  #   _s.reverse("stressed")   // => "desserts"
  #
  # @return [String]
  #
  reverse: (str) ->
    str.split("").reverse().join("")



  # Returns the index of the last occurrence of the given substring or pattern
  # (regexp) in str. Returns nil if not found. If the second parameter is
  # present, it specifies the position in the string to end the
  # search—characters beyond this point will not be considered.
  #
  # @example
  #   _s.rindex("hello", 'e')             // => 1
  #   _s.rindex("hello", 'l')             // => 3
  #   _s.rindex("hello", 'a')             // => null
  #   _s.rindex("hello", /[aeiou]/, -2)   // => 1
  #
  # @todo #rindex(/.../) does not add matches to R['$~'] as it should
  #
  # @return [Number, null]
  #
  rindex: (str, needle, offset) ->
    if offset != undefined
      offset = offset + str.length if offset < 0
      return null if offset < 0

      if typeof needle is 'string'
        offset = offset + needle.length
        ret = str[0...offset].lastIndexOf(needle)
      else
        ret = _str.__rindex_with_regexp__(str, needle, offset)
    else
      if typeof needle is 'string'
        ret = str.lastIndexOf(needle)
      else
        ret = _str.__rindex_with_regexp__(str, needle)

    if ret is -1 then null else ret


  # @private
  # @param needle R.Regexp
  # @param offset [number]
  __rindex_with_regexp__: (str, needle, offset) ->
    unless needle.global
      needle = new RegExp(needle.source, "g" + (if needle.ignoreCase then "i" else "") + (if needle.multiLine then "m" else ""));

    offset = str.length unless offset?
    idx = -1
    stop = 0

    while (result = needle.exec(str)) != null
      break if result.index > offset
      idx = result.index
      needle.lastIndex = ++stop

    idx


  # If integer is greater than the length of str, returns a new String of
  # length integer with str right justified and padded with padstr; otherwise,
  # returns str.
  #
  # @example
  #   _s.rjust("hello", 4)            // => "hello"
  #   _s.rjust("hello", 20)           // => "               hello"
  #   _s.rjust("hello", 20, '1234')   // => "123412341234123hello"
  #
  # @return [String]
  #
  rjust: (str, width, pad_str = " ") ->
    width = __int(width)
    len = str.length
    if len >= width
      str
    else
      pad_str = __str(pad_str)
      _err.throw_argument() if pad_str.length == 0
      pad_len = width - len
      _str.multiply(pad_str, pad_len)[0...pad_len] + str



  # Searches sep or pattern (regexp) in the string from the end of the string,
  # and returns the part before it, the match, and the part after it. If it is
  # not found, returns two empty strings and str.
  #
  # @example
  #   _s.rpartition("hello", "l")     // => ["hel", "l", "o"]
  #   _s.rpartition("hello", "x")     // => ["", "", "hello"]
  #
  # @example edge cases
  #   _s.rpartition("hello", "x")     // => ["", "", "hello"]
  #   _s.rpartition("hello", "hello") // => ["", "hello", ""]
  #
  # @example todo:
  #   _s.rpartition("hello", /.l/)    // => ["he", "ll", "o"]
  #
  # @todo does not yet accept regexp as pattern
  # @todo does not yet affect R['$~']
  #
  # @return [Array]
  #
  rpartition: (str, pattern) ->
    pattern = __str(pattern)

    idx = _str.rindex(str, pattern)
    unless idx is null
      start = idx + pattern.length
      len = str.length -  start
      a = str.slice(0,idx)
      b = pattern
      c = str.slice(start)
      [a,b,c]
    else
      ['', '',str]



  # Returns a copy of str with trailing whitespace removed. See also
  # String#lstrip and String#strip.
  #
  # @example
  #   _s.rstrip("  hello  ")  // => "  hello"
  #   _s.rstrip("hello")      // => "hello"
  #
  # @return [String]
  #
  rstrip: (str) ->
    str.replace(/[\s\n\t]+$/g, '')


  # Both forms iterate through str, matching the pattern (which may be a
  # Regexp or a String). For each match, a result is generated and either
  # added to the result array or passed to the block. If the pattern contains
  # no groups, each individual result consists of the matched string, $&. If
  # the pattern contains groups, each individual result is itself an array
  # containing one entry per group.
  #
  # @example
  #     str = "cruel world"
  #     _s.scan(str, /\w+/)        #=> ["cruel", "world"]
  #     _s.scan(str, /.../)        #=> ["cru", "el ", "wor"]
  #     _s.scan(str, /(...)/)      #=> [["cru"], ["el "], ["wor"]]
  #     _s.scan(str, /(..)(..)/)   #=> [["cr", "ue"], ["l ", "wo"]]
  #     // And the block form:
  #     _s.scan(str, /\w+/, function (w) { _puts("<<#{w}>> ") } )
  #     // > <<cruel>> <<world>>
  #     // TODO:
  #     // _s.scan(str, /(.)(.)/, function (x,y) { _puts(y, x)} )
  #     // > rceu lowlr
  #
  #
  # @todo some untested specs
  #
  scan: (str, pattern, block = null) ->
    unless __isRgx(pattern)
      pattern = __str(pattern)
      pattern = _rgx.quote(pattern)

    index = 0

    R['$~'] = null
    match_arr = if block != null then str else []

    # FIXME: different from rubinius implementation
    while match = str[index..-1].match(pattern)
      fin  = index + match.index + match[0].length
      fin += 1 if match[0].length == 0

      R['$~'] = new R.MatchData(match, {offset: index, string: str})

      if match.length > 1
        val = match[1...match.length]
      else
        val = [match[0]]

      if block != null
        block(val)
      else
        val = val[0] if match.length == 1
        match_arr.push val

      index = fin
      break if index > str.length

    # return this if block was passed
    if block != null then str else match_arr


  # Length of string
  #
  # @example
  #   _s.size('')  // => 0
  #   _s.size('foo')  // => 3
  #
  # @return [Number]
  #
  size: (str) ->
    str.length


  # Builds a set of characters from the other_str parameter(s) using the
  # procedure described for String#count. Returns a new string where runs of
  # the same character that occur in this set are replaced by a single
  # character. If no arguments are given, all runs of identical characters are
  # replaced by a single character.
  #
  # @example
  #   _s.squeeze("yellow moon")                 // => "yelow mon"
  #   _s.squeeze("  now   is  the", " ")        // => " now is the"
  #   _s.squeeze("putters shoot balls", "m-z")  // => "puters shot balls"
  #
  # @todo Fix A-a bug
  #
  # @return [String]
  #
  squeeze: (str) ->
    pattern = _coerce.split_args(arguments, 1)

    trash = _str.__matched__(str, pattern)
    chars = str.split("")
    len   = str.length
    i     = 1
    j     = 0
    last  = chars[0]
    all   = pattern.length == 0
    while i < len
      c = chars[i]
      unless c == last and (all || trash.indexOf(c) >= 0)
        chars[j+=1] = last = c
      i += 1

    if (j + 1) < len
      chars = chars[0..j]

    chars.join('')


  # Returns a copy of str with leading and trailing whitespace removed.
  #
  # @example
  #   _s.strip("    hello    ")   // => "hello"
  #   _s.strip("\tgoodbye\r\n")   // => "goodbye"
  #
  # @return [String]
  #
  strip: (str) ->
    # TODO Optimize
    _str.rstrip(_str.lstrip(str))


  sub: (str, pattern, replacement) ->
    _err.throw_type() if pattern is null

    pattern_lit = __try_str(pattern)
    if pattern_lit isnt null
      pattern = new RegExp(_rgx.escape(pattern_lit))

    unless __isRgx(pattern)
      _err.throw_type()

    if pattern.global
      throw "String#sub: #{pattern} has set the global flag 'g'. #{pattern}g"

    str.replace(pattern, replacement)



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
  #   _s.succ("abcd")        // => "abce"
  #   _s.succ("THX1138")     // => "THX1139"
  #   _s.succ("<<koala>>")   // => "<<koalb>>"
  #   _s.succ("1999zzz")     // => "2000aaa"
  #   _s.succ("ZZZ9999")     // => "AAAA0000"
  #   _s.succ("***")         // => "**+"
  #
  # @alias #next
  #
  # @return [String]
  #
  succ: (str) ->
    return '' if str.length == 0

    # OPTIMIZE: use a while loop or so
    codes      = (c.charCodeAt(0) for c in str.split(""))
    carry      = null               # for "z".succ => "aa", carry is 'a'
    last_alnum = 0                  # last alpha numeric
    start      = codes.length - 1
    while start >= 0
      s = codes[start]
      if nativeString.fromCharCode(s).match(/[a-zA-Z0-9]/) != null
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

    chars.join("")


  slice: (str, index, other) ->
    _err.throw_type() if index is null
    # TODO: This methods needs some serious refactoring

    size = str.length
    unless other is undefined
      if index.is_regexp?
        _err.throw_not_implemented()
        # match, str = subpattern(index, other)
        # Regexp.last_match = match
        # return str
      else
        length = other
        start  = index
        start += size if start < 0

        return null if length < 0 or start < 0 or start > size

        return nativeStrSlice.call(str, start, start + length)

    if index.is_regexp?
      _err.throw_not_implemented()
      # match_data = index.search_region(self, 0, _str.num_bytes, true)
      # Regexp.last_match = match_data
      # if match_data
      #   result = match_data.to_s
      #   result.taint if index.tainted?
      #   return result

    else if typeof index == 'string'
      return if _str.include(str, index) then index else null

    else if index.is_range?
      start   = __int(index.begin())
      length  = __int(index.end())

      start += size if start < 0

      length += size if length < 0
      length += 1 unless index.exclude_end()

      return "" if start is size
      return null if start < 0 || start > size

      length = size if length > size
      length = length - start
      length = 0 if length < 0

      return nativeStrSlice.call(str, start, start + length)
    else
      index += size if index < 0
      return null if index < 0 or index >= size
      return str[index]


  split: (str, pattern = " ", limit) ->
    # pattern string or regexp
    pattern = pattern.valueOf() if typeof pattern isnt 'string'
    # TODO: implement limit

    ary = str.split(pattern)

    # remove trailing empty fields
    while __truthy(str = ary[ary.length - 1])
      break unless str.length == 0
      ary.pop()

    if pattern is ' '
      tmp = []
      for el in ary
        tmp.push(el) if el != ''
      ary = tmp

    # TODO: if regexp does not include non-matching captures in the result array

    ary


  # Returns true if str starts with one of the prefixes given.
  #
  # @example
  #   _s.start_with("hello", "hell")               // => true
  #   // returns true if one of the prefixes matches.
  #   _s.start_with("hello", "heaven", "hell")     // => true
  #   _s.start_with("hello", "heaven", "paradise") // => false
  #
  # @return [Boolean]
  #
  start_with: (str) ->
    needles = _coerce.split_args(arguments, 1)

    for needle in needles
      try
        needle = __str(needle)
        return true if str.indexOf(needle) is 0
      catch e
        # TODO get rid of try

    false


  # Returns a copy of str with uppercase alphabetic characters converted to
  # lowercase and lowercase characters converted to uppercase. Note: case
  # conversion is effective only in ASCII region.
  #
  # @example
  #   _s.swapcase("Hello")          // => "hELLO"
  #   _s.swapcase("cYbEr_PuNk11")   // => "CyBeR_pUnK11"
  #
  # @return [String]
  #
  swapcase: (str) ->
    return str unless str.match(/[a-zA-Z]/)

    str.replace /[a-zA-Z]/g, (ch) ->
      code = ch.charCodeAt(0)
      swap = if code < 97 then (code | 32) else (code & ~32)
      String.fromCharCode(swap)



  # Returns the result of interpreting leading characters in str as an integer
  # base base (between 2 and 36). Extraneous characters past the end of a valid
  # number are ignored. If there is not a valid number at the start of str, 0 is
  # returned. This method never raises an exception when base is valid.
  #
  # @example
  #   _s.to_i("12345")           // => 12345
  #   _s.to_i("1_23_45")         // => 12345
  #   _s.to_i("99 red balloons") // => 99
  #   _s.to_i("0a")              // => 0
  #   _s.to_i("0a", 16)          // => 10
  #   _s.to_i("hello")           // => 0
  #   _s.to_i("1100101", 2)      // => 101
  #   _s.to_i("1100101", 8)      // => 294977
  #   _s.to_i("1100101", 10)     // => 1100101
  #   _s.to_i("1100101", 16)     // => 17826049
  #   // but:
  #   _s.to_i("_12345")          // => 0
  #   // TODO:
  #   _s.to_i("0b10101").to_i(0)        #=> 21
  #   _s.to_i("0b1010134").to_i(2)      #=> 21
  #
  # @todo #to_i(base) does not remove invalid characters:
  #       - e.g: R("1012").to_i(2) should return 5, but due to 2 being invalid it retunrs 0 now.
  # @todo #to_i(0) does not auto-detect base
  #
  # @return [Number]
  #
  to_i: (str, base) ->
    base = 10 if base is undefined
    base = __int(base)

    if base < 0 or base > 36 or base is 1
      _err.throw_argument()

    # ignore whitespace
    lit = _str.strip(str)

    # ([\+\-]?) matches +\- prefixes if any
    # ([^\+^\-_]+) matches everything after, except '_'.
    unless lit.match(/^([\+\-]?)([^\+^\-_]+)/)
      return 0

    # replace after check, so that _123 is invalid
    lit = lit.replace(/_/g, '')

    # if base > 0
    #   return R(0) unless BASE_IDENTIFIER[lit[0..1]] is base
    # else if base is 0
    #   base_str = if lit[0].match(/[\+\-]/) then lit[1..2] else lit[0..1]
    #   base = R.String.BASE_IDENTIFIER[base_str]

    int = parseInt(lit, base)
    if isNaN(int) then 0 else int


  # @return [Number]
  #
  to_f: (str) ->
    number_match  = str.match(/^([\+\-]?[_\d\.]+)([Ee\+\-\d]+)?/)
    number_string = number_match?[0] ? "0.0"
    Number(number_string.replace(/_/g, ''))


  # Returns a copy of str with all lowercase letters replaced with their
  # uppercase counterparts. The operation is locale insensitive—only
  # characters “a” to “z” are affected. Note: case replacement is effective
  # only in ASCII region.
  #
  # @example
  #   _s.upcase("hEllO")   // => "HELLO"
  #
  # @note unlike toUpperCase(), upcase doesnt change special characters ä,ö
  #
  # @return [String]
  #
  upcase: (str) ->
    return str unless str.match(/[a-z]/)

    str.replace /[a-z]/g, (ch) ->
      String.fromCharCode(ch.charCodeAt(0) & ~32)


  upto: (str, stop, exclusive, block) ->
    stop = __str(stop)
    exclusive ||= false
    if block is undefined and exclusive?.call?
      block = exclusive
      exclusive = false

    orig = str
    stop_size = stop.length
    exclusive = exclusive is true

    while (str < stop || (!exclusive && str == stop)) && !(str.length > stop_size)
      block( str )
      str = _str.succ(str)

    orig



  # @private
  __matched__: (str, args) ->
    for el in args
      rgx = _str.__to_regexp__(el)
      str = (nativeStrMatch.call(str, rgx) || []).join('')
    str


  # creates a regexp from the "a-z", "^ab" arguments used in #count
  # @private
  __to_regexp__: (str) ->
    r = ""

    if str.length == 0
      r = "(?!)"
    else if str == '^'
      r = "\\^"
    else
      if str.lastIndexOf("^") >= 1
        str = str[0] + str[1..-1].replace("^", "\\^")
      r = "[#{str}]"

    try
      return new RegExp(r, 'g')
    catch e
      _err.throw_argument()



_str = R._str = (str) ->
  new RWrapper(str, _str)

R.extend(_str, new StringMethods())
