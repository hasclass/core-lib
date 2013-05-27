RubyJS.i_am_feeling_evil = ->
  for [proto, methods] in [[Array.prototype, _arr], [Number, _num]]
    for own name, func of methods
      do (name) ->
        if typeof func == 'function'
          if proto[name] is undefined
            proto[name] = ->
              methods[name].apply(methods, [this].concat(_slice_.call(arguments, 0)))
              this
          else
            console.log("Array.#{name} exists. Skip.")
