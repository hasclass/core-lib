describe "Numeric#remainder", ->
  beforeEach ->
    @obj    = NumericSpecs.Subclass.new()
    @result = {} #mock("Numeric#% result")
    @other  = {} #mock("Passed Object")
    @obj['%'] = ->
    @result.equals = ->
    @obj['lt'] = ->
    @obj.gt = ->
    @other.gt = ->
    @other['lt'] = ->
    @result.minus = ->
  it "returns the result of calling self#% with other if self is 0", ->
    spy1 = spyOn( @obj, '%').andReturn(@result)
    spy2 = spyOn( @result, 'equals').andReturn(true)

    # @obj.should_receive(:%).with(@other).and_return(@result)
    # @result.should_receive(:==).with(0).and_return(true)

    expect( @obj.remainder(@other)).toEqual @result
    expect( spy1 ).wasCalled()
    expect( spy1.mostRecentCall.args[0]).toEqual(@other)
    expect( spy2 ).wasCalled()
    expect( spy2.mostRecentCall.args[0]).toEqual(0)

  it "returns the result of calling self#% with other if self and other are greater than 0", ->
    spy1 = spyOn( @obj, '%').andReturn(@result)
    spy2 = spyOn( @result, 'equals').andReturn(false)
    spy3 = spyOn( @obj, 'lt').andReturn(false)
    spy4 = spyOn( @obj, 'gt').andReturn(true)
    spy5 = spyOn( @other, 'lt').andReturn(false)

    expect( @obj.remainder(@other)).toEqual @result

    expect( spy1 ).wasCalled()
    expect( spy2 ).wasCalled()
    expect( spy3 ).wasCalled()
    expect( spy4 ).wasCalled()
    expect( spy5 ).wasCalled()

  it "returns the result of calling self#% with other if self and other are less than 0", ->
    spy1 = spyOn( @obj,    '%').andReturn(@result)
    spy2 = spyOn( @result, 'equals').andReturn(false)
    spy3 = spyOn( @obj,    'lt').andReturn(true)
    spy4 = spyOn( @other,  'gt').andReturn(false)
    # spy5 = spyOn( @obj,    'gt').andReturn(false)

    expect( @obj.remainder(@other)).toEqual @result

    expect( spy1 ).wasCalled()
    expect( spy2 ).wasCalled()
    expect( spy3 ).wasCalled()
    expect( spy4 ).wasCalled()
    # expect( spy5 ).wasCalled()


  it "returns the result of calling self#% with other - other if self is greater than 0 and other is less than 0", ->
    spy1 = spyOn( @obj,    '%').andReturn(@result)
    spy2 = spyOn( @result, 'equals').andReturn(false)
    spy3 = spyOn( @obj,    'lt').andReturn(false)
    spy5 = spyOn( @obj,    'gt').andReturn(true)
    spy6 = spyOn( @other,  'lt').andReturn(true)
    spy7 = spyOn( @result, 'minus').andReturn(123)

    expect( @obj.remainder(@other)).toEqual 123

    expect( spy1 ).wasCalled()
    expect( spy2 ).wasCalled()
    expect( spy3 ).wasCalled()
    expect( spy5 ).wasCalled()
    expect( spy6 ).wasCalled()
    expect( spy7 ).wasCalled()

  it "returns the result of calling self#% with other - other if self is less than 0 and other is greater than 0", ->
    spy1 = spyOn( @obj,    '%').andReturn(@result)
    spy2 = spyOn( @result, 'equals').andReturn(false)
    spy3 = spyOn( @obj,    'lt').andReturn(true)
    spy5 = spyOn( @other,  'gt').andReturn(true)
    spy7 = spyOn( @result, 'minus').andReturn(123)

    expect( @obj.remainder(@other) ).toEqual 123
