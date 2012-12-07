describe "Array#delete_if", ->
  beforeEach ->
    @a = R [ "a", "b", "c" ]

  it "removes each element for which block returns true", ->
    @a.delete_if (x) -> x >= "b"
    expect( @a ).toEqual R(["a"])

  it "returns self", ->
    expect( @a.delete_if -> true ).toEqual @a

  it "returns self when called on an Array emptied with #shift", ->
    array = R([1])
    array.shift()
    expect( array.delete_if (x) -> true ).toEqual array

  describe "ruby_version_is '1.8.7'", ->
    it "returns an Enumerator if no block given, and the enumerator can modify the original array", ->
      # enum = @a.delete_if
      # enum.should be_an_instance_of(enumerator_class)
      # @a.should_not be_empty
      # enum.each { true }
      # @a.should be_empty

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.delete_if {} ).toThrow(TypeError)
  #     it "raises a TypeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.delete_if {} ).toThrow(TypeError)

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.delete_if {} ).toThrow(RuntimeError)
  #     it "raises a RuntimeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.delete_if {} ).toThrow(RuntimeError)

  # it "keeps tainted status", ->
  #   @a.taint
  #   @a.tainted?.should be_true
  #   @a.delete_if{ true }
  #   @a.tainted?.should be_true

  # ruby_version_is '1.9' do
  #   it "keeps untrusted status", ->
  #     @a.untrust
  #     @a.untrusted?.should be_true
  #     @a.delete_if{ true }
  #     @a.untrusted?.should be_true
