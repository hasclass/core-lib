class StringMethods
  equals: (str, other) ->
    str   = str.valueOf()   if typeof str is 'object'
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
  camel_case: (str) ->
    str.replace /([\:\-\_]+(.))/g, (_1, _2, letter, offset) ->
      if offset then letter.toUpperCase() else letter



  capitalize: (str) ->
    return "" if str.length == 0
    b = _str.downcase(str)
    a = _str.upcase(str[0])
    a + nativeStrSlice.call(b, 1)


  center: (str, length, padString = ' ') ->
    _err.throw_argument() if padString.length == 0

    size = str.length
    return str if size >= length

    lft       = Math.floor((length - size) / 2)
    rgt       = length - size - lft
    max       = if lft > rgt then lft else rgt
    padString = _str.multiply(padString, max)

    padString[0...lft] + str + padString[0...rgt]


  chars: (str, block) ->
    idx = -1
    len = str.length
    while ++idx < len
      block(str[idx])
    str


  chomp: (str, sep = null) ->
    if sep == null
      if _str.empty(str) then "" else null
    else
      sep = __str(sep)
      if sep.length == 0
        regexp = /((\r\n)|\n)+$/
      else if sep is "\n" or sep is "\r" or sep is "\r\n"
        ending = nativeStrMatch.call(str, /((\r\n)|\n|\r)$/)?[0] || "\n"
        regexp = new RegExp("(#{_rgx.escape(ending)})$")
      else
        regexp = new RegExp("(#{_rgx.escape(sep)})$")
      str.replace(regexp, '')


  chop: (str) ->
    return str if str.length == 0

    if str.lastIndexOf("\r\n") == str.length - 2
      str.replace(/\r\n$/, '')
    else
      _str.slice str, 0, str.length - 1


  count: (str) ->
    _err.throw_argument("String.count needs arguments") if arguments.length == 1
    args = _coerce.split_args(arguments, 1)

    _str.__matched__(str, args).length


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


  downcase: (str) ->
    return str unless nativeStrMatch.call(str, /[A-Z]/)

    str.replace /[A-Z]/g, (ch) ->
      String.fromCharCode(ch.charCodeAt(0) | 32)


  dump: (str) ->
    escaped =  str.replace(/[\f]/g, '\\f')
      .replace(/["]/g, "\\\"")
      .replace(/[\n]/g, '\\n')
      .replace(/[\r]/g, '\\r')
      .replace(/[\t]/g, '\\t')
      # .replace(/[\s]/g, '\\ ') # do not
    "\"#{escaped}\""


  empty: (str) ->
    str.length == 0


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


  include: (str, other) ->
    str.indexOf(other) >= 0


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



  rstrip: (str) ->
    str.replace(/[\s\n\t]+$/g, '')


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


  strip: (str) ->
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



  succ: (str) ->
    return '' if str.length == 0

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
  swapcase: (str) ->
    return str unless str.match(/[a-zA-Z]/)

    str.replace /[a-zA-Z]/g, (ch) ->
      code = ch.charCodeAt(0)
      swap = if code < 97 then (code | 32) else (code & ~32)
      String.fromCharCode(swap)



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

    parseInt(lit, base)


  to_f: (str) ->
    number_match  = str.match(/^([\+\-]?[_\d\.]+)([Ee\+\-\d]+)?/)
    number_string = number_match?[0] ? "0.0"
    Number(number_string.replace(/_/g, ''))



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
