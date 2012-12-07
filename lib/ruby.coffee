###
RubyJS Alpha 0.7.2
Copyright (c) 2012 FundExplorer GmbH
All rights reserved.

http://www.rubyjs.org/license

Open Source License
------------------------------------------------------------------------------------------
This version of RubyJS is licensed under the terms of the Open Source AGPL 3.0 license.

http://www.gnu.org/licenses/agpl-3.0.html


Alternate Licensing
------------------------------------------------------------------------------------------
Commercial and OEM Licenses are available for an alternate download of RubyJS.
This is the appropriate option if you are creating proprietary applications and you are
not prepared to distribute and share the source code of your application under the
AGPL v3 license. Please visit http://www.rubyjs.org/license for more details.

###


# Establish the root object, `window` in the browser, or `global` on the server.
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

