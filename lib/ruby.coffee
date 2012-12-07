###
RubyJS Alpha 0.7.2
Copyright (c) 2012 Sebastian Burkhard
All rights reserved.
http://www.rubyjs.org/LICENSE.txt
###

root = global ? window

# TODO: link rubyjs/_r directly to RubyJS.RubyJS.prototype.box
#       this is a suboptimal solution as of now.
root.RubyJS = (obj, recursive, block) ->
  RubyJS.Base.prototype.box(obj, recursive, block)

RubyJS.VERSION = '0.7.2'

# noConflict mode for R
previousR = root.R if root.R?

RubyJS.noConflict = ->
  root.R = previousR
  RubyJS

# Alias to RubyJS
root.R  = RubyJS



# Native classes, to avoid naming conflicts inside RubyJS classes.
nativeArray  = Array
nativeNumber = Number
nativeObject = Object
nativeRegExp = RegExp
nativeString = String
_toString_   = Object.prototype.toString
_slice_      = Array.prototype.slice



RubyJS.extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin
  obj

if typeof(exports) != 'undefined'
  exports.R = R
  exports.RubyJS = RubyJS

