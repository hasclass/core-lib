
# @private
class RubyJS.NilClass extends RubyJS.Object
  @instance: -> new NilClass()

  nil: -> true

  inspect: -> @to_s()
  to_a: -> new R.Array([])
  to_i: -> new R.Fixnum(0)
  to_f: -> new R.Float(0.0)
  to_s: -> new R.String('')

