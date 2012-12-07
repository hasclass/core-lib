describe "Numeric#floor", ->
  beforeEach ->
    @obj = new NumericSpecs.Subclass()
    @obj.to_f = () -> null

  it "converts self to a Float (using #to_f) and returns the #floor'ed result", ->
    spy = spyOn(@obj, 'to_f').andReturn(R(2 - 0.000001))
    expect( @obj.floor() ).toEqual R(1)
    expect( spy ).wasCalled()

  it "converts self to a Float (using #to_f) and returns the #floor'ed result", ->
    spy = spyOn(@obj, 'to_f').andReturn(R(0.000001 - 2))
    expect( @obj.floor() ).toEqual R(-2)
    expect( spy ).wasCalled()