describe "Numeric#nonzero?", ->
  beforeEach ->
    @obj = new NumericSpecs.Subclass()

  it "returns self if self#zero? is false", ->
    @obj.zero = -> false
    expect( @obj.nonzero() == @obj ).toEqual true

  it "returns nil if self#zero? is true", ->
    @obj.zero = -> true
    expect( @obj.nonzero() == null).toEqual true
