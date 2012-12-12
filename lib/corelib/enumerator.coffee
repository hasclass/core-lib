class RubyJS.Enumerator extends RubyJS.Object
  @include RubyJS.Enumerable

  # ---- Constructors & Typecast ----------------------------------------------

  @new: (obj, iter, args...) -> new RubyJS.Enumerator(obj, iter, args)


  # Creates an Enumerator. Pass optional arguments as an array instead of
  # splatted argument.
  #
  # new R.Enumerator([], 'each')
  # new R.Enumerator([], 'each_with_object', ['foo'])
  #
  constructor: (@object, @iter = 'each', @args = []) ->
    @generator = null
    @length = @object.length
    @idx = 0


  @create: (args...) ->
    if block = R.__extract_block(args)
      object = new RubyJS.Enumerator.Generator(block)
      iter = 'each'
      return Enumerator.new(object, iter)


  # ---- RubyJSism ------------------------------------------------------------

  is_enumerator: -> true


  # ---- Javascript primitives --------------------------------------------------


  # ---- Instance methods -----------------------------------------------------

  each: (block) ->
    @object[@iter](@args..., block)


  # Same as Enumerable, but without returning this
  each_with_index: (block) ->
    return @to_enum('each_with_index') unless block && block.call?

    callback = Block.create(block, this)

    idx = 0
    @each ->
      args = BlockMulti.prototype.args(arguments)
      val  = callback.invokeSplat(args, idx)
      idx += 1
      val


  size: -> @object.length


  iterator: () ->
    @to_a().unbox()

  native_array: () ->
    @arr ||= @iterator()

  next: ->
    idx = @idx
    @idx += 1
    @native_array()[idx]

  to_enum: (iter = "each", args...) ->
    new RubyJS.Enumerator(this, iter, args)


  eachWithIndex: @prototype.each_with_index



  # ---- Aliases --------------------------------------------------------------


# @private
class RubyJS.Enumerator.Yielder extends RubyJS.Object
  constructor: (@proc) ->
    throw 'LocalJumpError' unless @proc.call?

   yield: () ->
     @proc.apply(this, arguments)

   '<<': (value) ->
      @yield(value)
      this

# @private
class RubyJS.Enumerator.Generator extends RubyJS.Object
  constructor: (@proc) ->
    throw 'LocalJumpError' unless @proc.call?

  each: (block) ->
    # Confused? This is how your grand-parents feel when you explain them the internet.
    # TODO: document, taken straight from Rubinius.
    enclosed_yield = () ->
      block.apply(this, arguments)
    @proc( new RubyJS.Enumerator.Yielder( enclosed_yield ) )
