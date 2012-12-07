# NOTE integer? becomes is_integer?
describe "Numeric#integer? => is_integer?", ->
  it "returns false", ->
    expect( NumericSpecs.Subclass.new().integer? ).toEqual false
