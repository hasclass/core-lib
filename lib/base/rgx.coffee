class RegexpMethods

  # Escapes any characters that would have special meaning in a regular
  # expression. Returns a new escaped string, or self if no characters are
  # escaped. For any string, Regexp.new(Regexp.escape(str))=~str will be true.
  #
  # @example
  #      R.Regexp.escape('\*?{}.')   #=> \\\*\?\{\}\.
  #
  # @alias Regexp.quote
  #
  escape: (pattern) ->
    pattern = __str(pattern)
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

  quote: (pattern) ->
    _rgx.escape(pattern)



_rgx = R._rgx = (rgx) ->
  new R.Regexp(rgx)


R.extend(_rgx, new RegexpMethods())