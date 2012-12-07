#    it_behaves_like(:numeric_abs, :magnitude)
describe "Numeric#magnitude", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()
    @obj['<'] = ->
    @obj.uminus = ->

  it "returns self when self is greater than 0", ->
    spy = spyOn(@obj, '<').andReturn(false)
    expect( @obj.magnitude() is @obj).toEqual true
    expect( spy ).wasCalled()
    expect( spy.mostRecentCall.args[0] ).toEqual 0

  it "returns self\#@- when self is less than 0", ->
    spy  = spyOn(@obj, '<').andReturn(true)
    spy2 = spyOn(@obj, 'uminus').andReturn(R(123))
    expect( @obj.magnitude() ).toEqual R(123)

    expect( spy ).wasCalled()
    expect( spy.mostRecentCall.args[0] ).toEqual 0
    expect( spy2 ).wasCalled()
