###
RubyJS Alpha 0.8.0-beta1
Copyright (c) 2012 Sebastian Burkhard
All rights reserved.
http://www.rubyjs.org/LICENSE.txt
###

root = global ? window

# TODO: link rubyjs/_r directly to RubyJS.RubyJS.prototype.box
#       this is a suboptimal solution as of now.
root.RubyJS = (obj, recursive, block) ->
  RubyJS.Base.prototype.box(obj, recursive, block)

RubyJS.VERSION = '0.8.0-beta1'

# noConflict mode for R
previousR = root.R if root.R?

RubyJS.noConflict = ->
  root.R = previousR
  RubyJS

# Alias to RubyJS
root.R  = RubyJS



RubyJS.extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin
  obj

RubyJS.include = (mixin, replace = false) ->
  for name, method of mixin.prototype
    if replace
      @prototype[name] = method
    else
      @prototype[name] = method unless @prototype[name]
  mixin

if typeof(exports) != 'undefined'
  exports.R = R
  exports.RubyJS = RubyJS

