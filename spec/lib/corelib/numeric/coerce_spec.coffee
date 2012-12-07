# TODO: NumericSpecs need an overhaul
describe "Numeric#coerce", ->
  beforeEach ->
    @obj = NumericSpecs.Subclass.new()
    @obj.to_f = -> R(10.5)
    @spy = spyOn(@obj, 'to_f').andReturn(R(10.5))

  it "returns [other, self] if self and other are instances of the same class", ->
    a = NumericSpecs.Subclass.new()
    b = NumericSpecs.Subclass.new()

    expect( a.coerce(b) ).toEqual R([b, a])

  # I (emp) think that this behavior is actually a bug in MRI. It's here as documentation
  # of the behavior until we find out if it's a bug.
  # quarantine! do
  #   it "considers the presense of a metaclass when checking the class of the objects", ->
  #     a = NumericSpecs.Subclass.new()
  #     b = NumericSpecs.Subclass.new()

  #     # inject a metaclass on a
  #     class << a; true; end

  #     # watch it explode
  #     lambda { a.coerce(b) }.should raise_error(TypeError)

  xit "calls #to_f to convert other if self responds to #to_f", ->
    # # Do not use NumericSpecs::Subclass here, because coerce checks the classes of the receiver
    # # and arguments before calling #to_f.
    # other = mock("numeric")
    # lambda { @obj.coerce(other) }.should raise_error(TypeError)

  it "returns [other.to_f, self.to_f] if self and other are instances of different classes", ->
    result = @obj.coerce(2.5)
    expect( result ).toEqual R.$Array_r([2.5, 10.5])

    result = @obj.coerce("4.4")
    expect(result).toEqual R.$Array_r([4.4, 10.5])
    # result.first.should be_kind_of(Float)
    # result.last.should be_kind_of(Float)

    # result = @obj.coerce(bignum_value)
    # result.should == [bignum_value.to_f, 10.5]
    # result.first.should be_kind_of(Float)
    # result.last.should be_kind_of(Float)

  xit "TODO: fix this", ->
    # result = @obj.coerce(3)
    # expect( result ).toEqual R.$Array_r([R.$Float(3.0), 10.5])

  it "raises a TypeError when passed nil", ->
    obj = @obj
    expect( -> obj.coerce(null)     ).toThrow('TypeError')

  it "raises a TypeError when passed a boolean", ->
    obj = @obj
    expect( -> obj.coerce(false)   ).toThrow('TypeError')

  xit "raises a TypeError when passed a Symbol", ->
    # obj = @obj
    # expect( -> obj.coerce(:symbol) ).toThrow('TypeError')

  it "raises an ArgumentError when passed a String", ->
    obj = @obj
    expect( -> obj.coerce("test")  ).toThrow('ArgumentError')
