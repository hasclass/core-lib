# TODO: create BlockNone class that coerces multiple yield arguments into array.

# @abstract
class Block
  # Block.create returns a different implementation of Block (BlockMulti,
  # BlockSingle) depending on the arity of block.
  #
  # If no block is given returns a BlockArgs callback, that returns
  # a single block argument.
  #
  @create: (block, thisArg) ->
    if block?.call? #block_given
      if block.length != 1
        new BlockMulti(block, thisArg)
      else
        new BlockSingle(block, thisArg)
    else
      new BlockArgs(block, thisArg)

  # handles block argument splatting
  # reverse_each([[1,2]], (a,b) -> )
  # if block has multiple arguments, returns a wrapper
  # function that applies arguments to block instead of passing.
  # Otherwise it returns the block itself.
  @splat_arguments: (block) ->
    if block.length > 1
      (item) ->
        if typeof item is 'object' && __isArr(item)
          block.apply(null, item)
        else
          block(item)
    else
      block

# @private
class BlockArgs
  constructor: (@block, @thisArg) ->

  invoke: (args) ->
    RCoerce.single_block_args(args, @block)


# @private
class BlockMulti
  constructor: (@block, @thisArg) ->

  args: (args) ->
    if args.length > 1 then nativeSlice.call(args) else args[0]

  # @param args array or arguments
  invoke: (args) ->
    if args.length > 1
      @block.apply(@thisArg, args)
    else
      arg = args[0]
      if typeof arg is 'object' && __isArr(arg)
        @block.apply(@thisArg, arg)
      else
        @block.call(@thisArg, arg)


  invokeSplat: ->
    @block.apply(@thisArg, arguments)


# for blocks with arity 1
# @private
class BlockSingle
  constructor: (@block, @thisArg) ->

  args: (args) ->
    args[0]

  invoke: (args) ->
    @block.call(@thisArg, args[0])

  invokeSplat: ->
    @block.apply(@thisArg, arguments)


R.Block = Block
R.blockify = __blockify = Block.create