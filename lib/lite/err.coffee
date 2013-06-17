_err =
  throw_argument: (msg) ->
    throw R.ArgumentError.new(msg)

  throw_type: (msg) ->
    throw R.TypeError.new(msg)

  throw_index: (msg) ->
    throw R.IndexError.new(msg)

  throw_not_implemented: (msg) ->
    throw R.NotImplementedError.new(msg)

  throw_key: (msg) ->
    throw R.KeyError.new(msg)

R.Support.err = _err
