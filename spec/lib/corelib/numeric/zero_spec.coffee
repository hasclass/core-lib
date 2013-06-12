describe "Numeric#zero?", ->
  beforeEach ->
    # FIXME: move to proper subclass
    @obj = NumericSpecs.Subclass.new()
    @obj.equals = ->

  it "returns true if self is 0", ->
    spy = spyOn(@obj, 'equals').andReturn(true)
    expect( @obj.zero() ).toEqual true
    expect( spy ).wasCalled()

  it "returns false if self is not 0", ->
    spy = spyOn(@obj, 'equals').andReturn(false)
    expect( @obj.zero() ).toEqual false
    expect( spy ).wasCalled()
