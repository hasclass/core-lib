describe "Numeric#eql?", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()

  # TODO: follow the protocol:
  xit "returns false if self's and other's types don't match", ->
    expect( @obj.eql(1) ).toEqual false
    expect( @obj.eql(-1.5) ).toEqual false
    # expect( @obj.eql(bignum_value) ).toEqual false
    expect( @obj.eql('sym') ).toEqual false

  it "returns the result of calling self#== with other when self's and other's types match", ->
    other = NumericSpecs.Subclass.new()
    @obj['=='] = -> 'result'
    # @obj.should_receive(:==).with(other).and_return("result", nil)
    expect( @obj.eql(other) ).toEqual true

    @obj['=='] = -> null
    expect( @obj.eql(other) ).toEqual false
