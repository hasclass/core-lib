errors = [
  'ArgumentError'
  'RegexpError'
  'TypeError'
  'IndexError'
  'FloatDomainError'
  'RangeError'
  'StandardError'
  'ZeroDivisionError'
  'NotSupportedError'
  'NotImplementedError'
]

for error in errors
  do (error) ->
    errorClass     = class extends Error
    errorClass.new = -> new RubyJS[error](error)
    RubyJS[error]  = errorClass
