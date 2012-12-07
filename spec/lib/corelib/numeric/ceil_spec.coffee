describe "Numeric#ceil", ->
  beforeEach ->
    @obj = new NumericSpecs.Subclass()
    @obj.to_f = () -> null

  it "converts self to a Float (using #to_f) and returns the #ceil'ed result", ->
    spy = spyOn(@obj, 'to_f').andReturn(R(1 + 0.000001))
    expect( @obj.ceil() ).toEqual R(2)
    expect( spy ).wasCalled()

  it "converts self to a Float (using #to_f) and returns the #ceil'ed result", ->
    spy = spyOn(@obj, 'to_f').andReturn(R(-1 - 0.000001))
    expect( @obj.ceil() ).toEqual R(-1)
    expect( spy ).wasCalled()
