describe "Numeric#truncate", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()
    @obj.to_f = ->

  it "converts self to a Float (using #to_f) and returns the #truncate'd result", ->
    spy = spyOn( @obj, 'to_f').andReturn(R 2.5555)
    expect( @obj.truncate() ).toEqual R.$Integer(2)
    expect( spy ).wasCalled()

  it "converts self to a negative Float (using #to_f) and returns the #truncate'd result", ->
    spy = spyOn( @obj, 'to_f').andReturn(R -2.3333)
    expect( @obj.truncate() ).toEqual R.$Integer(-2)
    expect( spy ).wasCalled()
