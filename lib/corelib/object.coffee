

class RubyJS.Object
  @include: RubyJS.include

  # Adds default aliases to symbol method names.
  #
  # @example Aliases used throughout RubyJS
  #
  #     <<  append
  #     ==  equals
  #     === equal_case
  #     <=> cmp
  #     %   modulo
  #     +   plus
  #     -   minus
  #     *   multiply
  #     **  exp
  #     /   divide
  #
  # @example Useage, at the end of your class:
  #
  #     class Foo extends RubyJS.Object
  #        # ...
  #        @__add_default_aliases__(@prototype)
  #
  @__add_default_aliases__: (proto) ->
    proto.append     = proto['<<']  if proto['<<']?
    proto.equals     = proto['==']  if proto['==']?
    proto.equal_case = proto['==='] if proto['===']?
    proto.cmp        = proto['cmp'] if proto['cmp']?
    proto.modulo     = proto['%']   if proto['%']?
    proto.plus       = proto['+']   if proto['+']?
    proto.minus      = proto['-']   if proto['-']?
    proto.multiply   = proto['*']   if proto['*']?
    proto.exp        = proto['**']  if proto['**']?
    proto.divide     = proto['/']   if proto['/']?


  @include RubyJS.Kernel


  send: (method_name, args...) ->
    @[method_name](args)


  respond_to: (method_name) ->
    this[method_name]?
    #this[function_name] != undefined


  to_enum: (iter = "each", args...) ->
    new RubyJS.Enumerator(this, iter, args)


  tap: (block) ->
    block(this)
    this


  value: ->
    @to_native.apply(this, arguments)
