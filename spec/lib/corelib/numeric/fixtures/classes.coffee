root = global ? window
root.NumericSpecs = {}

class NumericSpecs.Comparison extends RubyJS.Numeric
  # This method is used because we cannot define
  # singleton methods on subclasses of Numeric,
  # which is needed for a.should_receive to work.
  '<=>': (other) ->
    #ScratchPad.record :numeric_comparison
    1

class NumericSpecs.Subclass extends RubyJS.Numeric
  @new: -> new NumericSpecs.Subclass()


  singleton_method_added: (val) ->
