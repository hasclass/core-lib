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

    # DO:
    # if @end_with("\r\n")
    #   new R.String(@to_native().replace(/\r\n$/, ''))
    # else
    #   @slice 0, @size().minus(1)


  downcase: (str) ->
    return null unless str.match(/[A-Z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    R(str.split('')).map((c) ->
      if c.match(/[A-Z]/) then c.toLowerCase() else c
    ).join('').to_native()


  empty: (str) ->
    str.length == 0


  end_with: (str, needles) ->
    needles = R.$Array_r(needles).select((el) -> el?.to_str?).map (w) -> w.to_str().to_native()

    str_len = str.length
    for w in needles.iterator()
      return true if str.lastIndexOf(w) + w.length is str_len
    false


  upcase: (str) ->
    return null unless str.match(/[a-z]/)
    # FIXME ugly and slow but ruby upcase differs from normal toUpperCase
    _arr.map(str.split(''), (c) ->
      if c.match(/[a-z]/) then c.toUpperCase() else c
    ).join('')


  reverse: (str) ->
    str.split("").reverse().join("")

_str = R._str = new StringMethods()