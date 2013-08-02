# Experimental.
#
# Chain objects are a more lightweight oo approach for chaining multiple
# methods. similar to underscores _.chain(obj).
#
class Chain
  constructor: (@value, @type) ->
    @chain = false


  valueOf: ->
    @value


lookupFunction = (val, name) ->
  if val is null
    return -> throw new TypeError("wrapper has null value")

  return @type if @type

  val = val.valueOf() if typeof val is 'object'

  ns = null
  if typeof val is 'string'
    ns = _str
  else if typeof val is 'number'
    ns = _num
  else if __isArr(val)
    ns = _arr
  else
    ns = _hsh

  ns[name]


dispatchFunction = (name) ->
  ->
    self = this
    if t = self.type
      func = t[name]
      self.type  = null
    else
      func = lookupFunction(self.value, name)
    self.value = __call(func, self.value, arguments)

    # if self.chain then this else self.value
    this

klasses = [
  ArrayMethods,
  HashMethods,
  StringMethods,
  NumericMethods,
  TimeMethods
]

for klass in klasses
  for own name, fn of klass.prototype
    do (name,fn) ->
      Chain.prototype[name] = dispatchFunction(name)

