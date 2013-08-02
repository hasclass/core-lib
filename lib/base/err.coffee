_err =
  throw_argument: (msg) ->
    throw RArgumentError.new(msg)

  throw_type: (msg) ->
    throw RTypeError.new(msg)

  throw_index: (msg) ->
    throw RIndexError.new(msg)

  throw_not_implemented: (msg) ->
    throw RNotImplementedError.new(msg)

  throw_key: (msg) ->
    throw RKeyError.new(msg)

