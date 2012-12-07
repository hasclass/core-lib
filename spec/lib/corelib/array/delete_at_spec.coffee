describe "Array#delete_at", ->
  it "removes the element at the specified index", ->
    a = R([1, 2, 3, 4])
    a.delete_at(2)
    expect( a ).toEqual R([1, 2, 4])
    a.delete_at(-1)
    expect( a ).toEqual R([1, 2])

  it "returns the removed element at the specified index", ->
    a = R([1, 2, 3, 4])
    expect( a.delete_at(2) ).toEqual 3
    expect( a.delete_at(-1) ).toEqual 4

  it "returns null and makes no modification if the index is out of range", ->
    a = R([1, 2])
    expect( a.delete_at(3) ).toEqual R(null)
    expect( a ).toEqual R([1, 2])
    expect( a.delete_at(-3) ).toEqual R(null)
    expect( a ).toEqual R([1, 2])

  it "tries to convert the passed argument to an Integer using #to_int", ->
    obj =
      to_int: -> R(-1)
    expect( R([1, 2]).delete_at(obj) ).toEqual 2

  it "accepts negative indices", ->
    a = R([1, 2])
    expect( a.delete_at(-2) ).toEqual 1

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> [1,2,3].freeze.delete_at(0) ).toThrow(TypeError)

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> [1,2,3].freeze.delete_at(0) ).toThrow(RuntimeError)

  # it "keeps tainted status", ->
  #   ary = [1, 2]
  #   ary.taint
  #   ary.tainted?.should be_true
  #   ary.delete_at(0)
  #   ary.tainted?.should be_true
  #   ary.delete_at(0) # now empty
  #   ary.tainted?.should be_true

  # ruby_version_is '1.9' do
  #   it "keeps untrusted status", ->
  #     ary = [1, 2]
  #     ary.untrust
  #     ary.untrusted?.should be_true
  #     ary.delete_at(0)
  #     ary.untrusted?.should be_true
  #     ary.delete_at(0) # now empty
  #     ary.untrusted?.should be_true
