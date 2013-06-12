describe "Numeric#abs", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()
    @obj['lt'] = ->
    @obj.uminus = ->

  it "returns self when self is greater than 0", ->
    spy = spyOn(@obj, 'lt').andReturn(false)
    expect( @obj.abs() is @obj).toEqual true
    expect( spy ).wasCalled()
    expect( spy.mostRecentCall.args[0] ).toEqual 0

  it "returns self\#@- when self is less than 0", ->
    spy  = spyOn(@obj, 'lt').andReturn(true)
    spy2 = spyOn(@obj, 'uminus').andReturn(R(123))
    expect( @obj.abs() ).toEqual R(123)

    expect( spy ).wasCalled()
    expect( spy.mostRecentCall.args[0] ).toEqual 0
    expect( spy2 ).wasCalled()
