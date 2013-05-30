# Native classes, to avoid naming conflicts inside RubyJS classes.
nativeArray  = Array
nativeNumber = Number
nativeObject = Object
nativeRegExp = RegExp
nativeString = String

ObjProto = Object.prototype
StrProto = String.prototype
ArrProto = Array.prototype

_toString_ = ObjProto.toString
_slice_    = ArrProto.slice

str_slice   = StrProto.slice
str_match   = StrProto.match
arr_join    = ArrProto.join
arr_sort    = ArrProto.sort
arr_slice   = ArrProto.slice
arr_unshift = ArrProto.unshift