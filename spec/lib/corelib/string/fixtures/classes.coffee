root = global ? window
root.StringSpecs = {}

class StringSpecs.MyString extends RubyJS.String

class StringSpecs.SubString extends RubyJS.String
  constructor: (str) ->
    super
    @special = str || null

class StringSpecs.InitializeString extends RubyJS.String
  @object_ids: 0

  constructor: (other) ->
    super
    @object_id = InitializeString.object_ids++
    @ivar = 1

  initialize_copy: (other) ->
    @recorded = other.object_id
