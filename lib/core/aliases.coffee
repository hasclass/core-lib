# Native classes, to avoid naming conflicts inside RubyJS classes.
nativeArray  = Array
nativeNumber = Number
nativeObject = Object
nativeRegExp = RegExp
nativeString = String

ObjProto = Object.prototype
StrProto = String.prototype
ArrProto = Array.prototype

nativeToString = ObjProto.toString
nativeStrSlice = StrProto.slice
nativeStrMatch = StrProto.match
nativeJoin     = ArrProto.join
nativeSort     = ArrProto.sort
nativeSlice    = ArrProto.slice
nativeUnshift  = ArrProto.unshift
nativePush     = ArrProto.push