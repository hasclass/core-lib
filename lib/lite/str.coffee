class StringMethods
  capitalize: (str) ->
    return "" if str.length == 0
    b = @downcase(str)
    a = @upcase(str[0])
    a + b.slice(1)


  center: (str, length, padString = ' ') ->
    throw R.ArgumentError.new() if padString.length == 0

    size = str.length
    return str if size >= length

    lft       = Math.floor((length - size) / 2)
    rgt       = length - size - lft
    max       = if lft > rgt then lft else rgt
    padString = @multiply(padString, max)

    padString[0...lft] + str + padString[0...rgt]


  chars: (str, block) ->
    idx = -1
    len = str.length
    while ++idx < len
      block(str[idx])
    str


  chomp: (str, sep = null) ->
    if sep == null
      if @empty(str) then "" else null
    else
      sep = RCoerce.to_str_native(sep)
      if sep.length == 0
        regexp = /((\r\n)|\n)+$/
      else if sep is "\n" or sep is "\r" or sep is "\r\n"
        ending = str.match(/((\r\n)|\n|\r)$/)?[0] || "\n"
        regexp = new RegExp("(#{R.Regexp.escape(ending)})$")
      else
        regexp = new RegExp("(#{R.Regexp.escape(sep)})$")
      str.replace(regexp, '')


  chop: (str) ->
    return str if str.length == 0

    if str.lastIndexOf("\r\n") == str.length - 2
      str.replace(/\r\n$/, '')
    else
      @slice str, 0, str.length - 1


  count: (str, args...) ->
    throw R.ArgumentError.new() if args.length == 0

    for el in args
      r = @__to_regexp__(el)
      matches = str.match(r) || []
      str = matches.join('')

    str.length

  # creates a regexp from the "a-z", "^ab" arguments used in #count
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
      throw R.ArgumentError.new()


  downcase: (str) ->
    return str unless str.match(/[A-Z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    _arr.map(str.split(''), (c) ->
      if c.match(/[A-Z]/) then c.toLowerCase() else c
    ).join('')


  empty: (str) ->
    str.length == 0


  end_with: (str, needles...) ->
    for w in needles
      if str.lastIndexOf(w) + w.length is str.length
        return true
    false


  include: (str, other) ->
    str.indexOf(other) >= 0


  index: (str, needle, offset) ->
    if offset?
      offset = str.length + offset if offset < 0

    # unless needle.is_string? or needle.is_regexp? or needle.is_fixnum?
    #   throw R.TypeError.new()

    if offset? && (offset > str.length or offset < 0)
      return null

    idx = str.indexOf(needle, offset)
    if idx < 0
      null
    else
      idx


  ljust: (str, width, padString = " ") ->
    len = str.length
    if len >= width
      str
    else
      throw R.ArgumentError.new() if padString.length == 0
      pad_length = width - len
      idx = -1
      out = ""
      # TODO refactor
      out += padString while ++idx <= pad_length
      str + out[0...pad_length]


  lstrip: (str) ->
    str.replace(/^[\s\n\t]+/g, '')


  match: (str, pattern, offset = null, block) ->
    unless block?
      if offset?.call?
        block = offset
        offset = null

    # unless RString.isString(pattern) or R.Regexp.isRegexp(pattern)
    #   throw R.TypeError.new()

    opts = {}

    if offset?
      opts = {string: str, offset: offset}
      str = str.slice(offset)
      matches = str.match(pattern, offset)
    else
      # Firefox breaks if you'd pass str.match(..., undefined)
      matches = str.match(pattern)

    result = if matches
      new R.MatchData(matches, opts)
    else
      null

    R['$~'] = result

    if block
      if result then block(result) else []
    else
      result


  multiply: (str, num) ->
    throw R.ArgumentError.new() if num < 0
    out = ""
    out += str for n in [0...num]
    out


  partition: (str, pattern) ->
    # TODO: regexps
    idx = @index(str, pattern)
    unless idx is null
      start = idx + pattern.length
      a = @slice(str, 0, idx) || ''
      b = pattern
      c = str.slice(start)
      [a,b,c]
    else
      [str, '', '']


  reverse: (str) ->
    str.split("").reverse().join("")


  rjust: (str, width, pad_str = " ") ->
    len = str.length
    if len >= width
      str
    else
      throw R.ArgumentError.new() if pad_str.length == 0
      pad_len = width - len
      _str.multiply(pad_str, pad_len)[0...pad_len] + str


  slice: (str, index, other) ->
    throw R.TypeError.new() if index is null
    # TODO: This methods needs some serious refactoring

    size = str.length
    unless other is undefined
      if index.is_regexp?
        throw R.NotImplementedError.new()
        # match, str = subpattern(index, other)
        # Regexp.last_match = match
        # return str
      else
        length = other
        start  = index
        start += size if start < 0

        return null if length < 0 or start < 0 or start > size

        return str.slice(start, start + length)

    if index.is_regexp?
      throw R.NotImplementedError.new()
      # match_data = index.search_region(self, 0, @num_bytes, true)
      # Regexp.last_match = match_data
      # if match_data
      #   result = match_data.to_s
      #   result.taint if index.tainted?
      #   return result

    else if typeof index == 'string'
      return if @include(str, index) then index else null

    else if index.is_range?
      start   = RCoerce.to_int_native index.begin()
      length  = RCoerce.to_int_native index.end()

      start += size if start < 0

      length += size if length < 0
      length += 1 unless index.exclude_end()

      return "" if start is size
      return null if start < 0 || start > size

      length = size if length > size
      length = length - start
      length = 0 if length < 0

      return str.slice(start, start + length)
    else
      index += size if index < 0
      return null if index < 0 or index >= size
      return str[index]


  start_with: (str, needles...) ->
    for needle in needles
      return true if str.indexOf(needle) is 0
    false



  upcase: (str) ->
    return str unless str.match(/[a-z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    _arr.map(str.split(''), (c) ->
      if c.match(/[a-z]/) then c.toUpperCase() else c
    ).join('')


# @private
#
# @example
#     tbl = new CharTable(['abc', 'd-f'])
#     tbl.include('c') # => true
#     tbl.include('e') # => true
#
# @example negating
#     tbl = new CharTable(['^abc', 'd-f'])
#     tbl.include('c') # => false
#     tbl.include('e') # => true
#     tbl.include('z') # => true
#
class CharTable
  # @param patterns Array[String]
  constructor: (patterns) ->
    @patterns = patterns

    @incl = null
    @excl = null

    for w in @patterns
      v = RCoerce.to_str_native(w)
      if v.length == 0

      else if v[0] == '^' and v.length > 1
        arr = @__char_table__(v[1..-1])
        @excl = if @excl then @excl['&'] arr else R(arr)
      else
        arr = @__char_table__(v)
        @incl = if @incl then @incl['&'] arr else R(arr)

  include_chars: ->
    @incl || new R.Array([])

  exclude_chars: ->
    @excl || new R.Array([])

  exclude: (chr) ->
    !@include(chr)

  include: (chr) ->
    if @incl && @excl
      @incl.include(chr) && !@excl.include(chr)
    else if @incl
      @incl.include(chr)
    else if @excl
      !@excl.include(chr)
    else
      false

  # @private
  # @example
  #    __char_table__('a-c')  # => ['a','b','c']
  #    __char_table__('a-cf')  # => ['a','b','c','f']
  __char_table__: (str) ->
    arr = []
    if m = str.match(/[^\\]\-./g)
      for s in m
        arr = arr.concat @__char_range__(s[0], s[2])
    arr = arr.concat str.replace(/[^\\]\-./g, '').split("")
    arr

  # @private
  # @example
  #     __char_range__('a', 'c')   # => ['a','b','c']
  #     __char_range__('1', '3')   # => ['1','2','3']
  #
  __char_range__: (a, b) ->
    arr = []
    a = R(a)
    throw R.ArgumentError.new() unless a['<='](b)
    counter = 0
    while a['<='](b)
      counter++
      arr.push a.to_native()
      a = a.succ()
      throw R.ArgumentError.new("ERROR: #{a} #{b}") if counter == 10000
    arr


_str = R._str = new StringMethods()
