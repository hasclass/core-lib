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
    if block && block.call? #block_given
      if block.length != 1
        new BlockMulti(block, thisArg)
      else
        new BlockSingle(block, thisArg)
    else
      new BlockArgs(block, thisArg)

  # if block has multiple arguments, returns a wrapper
  # function that applies arguments to block instead of passing.
  # Otherwise it returns the block itself.
  #
  @supportMultipleArgs: (block) ->
    if block.length is 1
      block
    else
      (item) ->
        if typeof item is 'object' && R.Array.isNativeArray(item)
          block.apply(this, item)
        else
          block(item)


  invoke: () ->
    throw "Calling #invoke on an abstract Block instance"

  # Use invokeSplat applies the arguments to the block.
  #
  # E.g.
  #
  #     each_with_object: (obj) ->
  #        @each (el) ->
  #          callback.invokeSplat(el, obj)
  #
  invokeSplat: ->
    throw "Calling #invokeSplat on an abstract Block instance"

  # @abstract
  args: () ->
    throw "Calling #args on an abstract Block instance"

# @private
class BlockArgs
  constructor: (@block, @thisArg) ->

  invoke: (args) ->
    CoerceProto.single_block_args(args, @block)

# @private
class BlockMulti
  constructor: (@block, @thisArg) ->

  args: (args) ->
    if args.length > 1 then _slice_.call(args) else args[0]

  # @param args array or arguments
  invoke: (args) ->
    if args.length > 1
      @block.apply(@thisArg, args)
    else
      arg = args[0]
      if typeof arg is 'object' && R.Array.isNativeArray(arg)
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