describe "Array#delete", ->
  it "removes elements that are #== to object", ->
    x =
      '==': (other) -> R(3).equals other
      equals: (other) -> R(3).equals other

    a = R([1, 2, 3, x, 4, 3, 5, x])
    a.delete "not contained"
    expect( a ).toEqual R([1, 2, 3, x, 4, 3, 5, x])

    a.delete 3
    expect( a ).toEqual R([1, 2, 4, 5])

  it "calculates equality correctly for reference values", ->
    a = R(["foo", "bar", "foo", "quux", "foo"])
    a.delete "foo"
    expect( a ).toEqual R(["bar","quux"])

  it "returns object or null if no elements match object", ->
    expect(R( [1, 2, 4, 5] ).delete(1)).toEqual 1
    expect(R( [1, 2, 4, 5] ).delete(3)).toEqual null

  it "may be given a block that is executed if no element matches object", ->
    expect(R( [1]          ).delete(1, -> 'not_found')).toEqual 1
    expect(R( []           ).delete('a', -> 'not_found')).toEqual 'not_found'

  it "returns null if the array is empty due to a shift", ->
    a = R([1])
    a.shift()
    expect( a.delete(null) ).toEqual null

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array if a modification would take place", ->
  #     expect( -> [1, 2, 3].freeze.delete(1) ).toThrow(TypeError)

  #   it "returns false on a frozen array if a modification does not take place", ->
  #     [1, 2, 3].freeze.delete(0).should == null

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> [1, 2, 3].freeze.delete(1) ).toThrow(RuntimeError)

  # it "keeps tainted status", ->
  #   a = [1, 2]
  #   a.taint
  #   a.tainted?.should be_true
  #   a.delete(2)
  #   a.tainted?.should be_true
  #   a.delete(1) # now empty
  #   a.tainted?.should be_true

  # ruby_version_is '1.9' do
  #   it "keeps untrusted status", ->
  #     a = [1, 2]
  #     a.untrust
  #     a.untrusted?.should be_true
  #     a.delete(2)
  #     a.untrusted?.should be_true
  #     a.delete(1) # now empty
  #     a.untrusted?.should be_true
