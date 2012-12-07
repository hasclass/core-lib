# @private
class RubyJS.ArgumentError extends Error
  @new: () ->
    new RubyJS.ArgumentError('ArgumentError')

# @private
class RubyJS.RegexpError extends Error
  @new: () ->
    new RubyJS.RegexpError('RegexpError')

# @private
class RubyJS.TypeError extends Error
  @new: () ->
    new RubyJS.TypeError('TypeError')

# @private
class RubyJS.IndexError extends Error
  @new: () ->
    new RubyJS.IndexError('IndexError')

# @private
class RubyJS.FloatDomainError extends Error
  @new: () ->
    new RubyJS.FloatDomainError('FloatDomainError')

# @private
class RubyJS.RangeError extends Error
  @new: () ->
    new RubyJS.RangeError('RangeError')

# @private
class RubyJS.StandardError extends Error
  @new: () ->
    new RubyJS.StandardError('StandardError')

# @private
class RubyJS.ZeroDivisionError extends Error
  @new: () ->
    new RubyJS.ZeroDivisionError('ZeroDivisionError')

# @private
class RubyJS.NotSupportedError extends Error
  @new: () ->
    new RubyJS.NotSupportedError('NotSupportedError')

# @private
class RubyJS.NotImplementedError extends Error
  @new: () ->
    new RubyJS.NotImplementedError('NotImplementedError')


