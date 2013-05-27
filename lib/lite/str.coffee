class StringMethods
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


  downcase: (str) ->
    return null unless str.match(/[A-Z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    R(str.split('')).map((c) ->
      if c.match(/[A-Z]/) then c.toLowerCase() else c
    ).join('').to_native()


  empty: (str) ->
    str.length == 0


  end_with: (str, needles...) ->
    for w in needles
      if str.lastIndexOf(w) + w.length is str.length
        return true
    false


  include: (str, other) ->
    str.indexOf(other) >= 0


  upcase: (str) ->
    return null unless str.match(/[a-z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    _arr.map(str.split(''), (c) ->
      if c.match(/[a-z]/) then c.toUpperCase() else c
    ).join('')


  reverse: (str) ->
    str.split("").reverse().join("")


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


_str = R._str = new StringMethods()