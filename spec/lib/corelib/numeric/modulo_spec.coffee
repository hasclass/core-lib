describe 'ruby_version_is "".."1.9"', ->
  describe "Numeric#modulo", ->
    it "returns the result of calling self#% with other", ->
      obj = NumericSpecs.Subclass.new()
      obj['modulo'] = ->
      spy = spyOn(obj, 'modulo').andReturn 'result'
      expect( obj.modulo(20) ).toEqual 'result'
      expect( spy ).wasCalled()
      expect( spy.mostRecentCall.args[0]).toEqual(20)

describe 'ruby_version_is "1.9"', ->
  describe "Numeric#modulo", ->
    it "returns self - other * self.div(other)", ->
      obj      = NumericSpecs.Subclass.new()
      obj.div  = ->
      obj['-'] = ->
      other    = NumericSpecs.Subclass.new()
      other['*'] = ->
      n3 = NumericSpecs.Subclass.new()
      n4 = NumericSpecs.Subclass.new()
      n5 = NumericSpecs.Subclass.new()

      spy1 = spyOn( obj, 'div').andReturn(n3) # with other
      spy2 = spyOn( other, '*').andReturn(n4) #(n3)
      spy1 = spyOn( obj, '-').andReturn(n5) # with n4
      
      expect( obj.modulo(other) ).toEqual n5
  
  describe "Numeric#modulo", ->
  #  it_behaves_like :numeric_modulo_19, :modulo

  describe "Numeric#%", ->
  #  it_behaves_like :numeric_modulo_19, :%
