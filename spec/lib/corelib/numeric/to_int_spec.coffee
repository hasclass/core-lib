describe "Numeric#to_int", ->
  it "returns self#to_i", ->
    obj = NumericSpecs.Subclass.new()
    obj.to_i = ->
    spy = spyOn(obj, 'to_i').andReturn(5)
    expect( obj.to_int() ).toEqual 5
    expect( spy ).wasCalled()
