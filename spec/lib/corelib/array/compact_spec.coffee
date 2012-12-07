describe "Array#compact", ->
  it "returns a copy of array with all null elements removed", ->
    a = R [1, 2, 4]
    expect( a.compact().unbox() ).toEqual [1, 2, 4]
    a = R [1, null, 2, 4]
    expect( a.compact().unbox() ).toEqual [1, 2, 4]
    a = R [1, 2, 4, null]
    expect( a.compact().unbox() ).toEqual [1, 2, 4]
    a = R [null, 1, 2, 4]
    expect( a.compact().unbox() ).toEqual [1, 2, 4]

  it "does not return self", ->
    a = R [1, 2, 3]
    expect( a.compact() == a).toEqual false

  xdescribe 'taint and trust not supported', ->
    # ruby_version_is '' ... '1.9.3' do
    #   it "keeps tainted status even if all elements are removed", ->
    #     a = [null, null]
    #     a.taint
    #     a.compact.tainted?.should be_true

    # ruby_version_is '1.9' ... '1.9.3' do
    #   it "keeps untrusted status even if all elements are removed", ->
    #     a = [null, null]
    #     a.untrust
    #     a.compact.untrusted?.should be_true

    # ruby_version_is '' ... '1.9.3' do
    #   it "returns subclass instance for Array subclasses", ->
    #     ArraySpecs::MyArray[1, 2, 3, null].compact.should be_kind_of(ArraySpecs::MyArray)

    # ruby_version_is '1.9.3' do
    #   it "does not return subclass instance for Array subclasses", ->
    #     ArraySpecs::MyArray[1, 2, 3, null].compact.should be_kind_of(Array)

    #   it "does not keep tainted status even if all elements are removed", ->
    #     a = [null, null]
    #     a.taint
    #     a.compact.tainted?.should be_false

    #   it "does not keep untrusted status even if all elements are removed", ->
    #     a = [null, null]
    #     a.untrust
    #     a.compact.untrusted?.should be_false

describe "Array#compact!", ->
  it "removes all null elements", ->
    a = R ['a', null, 'b', false, 'c']
    expect( a.compact_bang() == a).toEqual true
    expect( a.unbox() ).toEqual ["a", "b", false, "c"]
    a = R [null, 'a', 'b', false, 'c']
    expect( a.compact_bang() == a).toEqual true
    expect( a.unbox() ).toEqual ["a", "b", false, "c"]
    a = R ['a', 'b', false, 'c', null]
    expect( a.compact_bang() == a).toEqual true
    expect( a.unbox() ).toEqual ["a", "b", false, "c"]

  it "returns self if some null elements are removed", ->
    a = R ['a', null, 'b', false, 'c']
    expect( a.compact_bang() == a).toEqual true

  it "returns null if there are no null elements to remove", ->
    expect( R([1, 2, false, 3]).compact_bang() ).toEqual null

  xdescribe 'taint and trust not supported', ->
    # it "keeps tainted status even if all elements are removed", ->
    #   a = R [null, null]
    #   a.taint
    #   a.compact!
    #   a.tainted?.should be_true

    # ruby_version_is '1.9' do
    #   it "keeps untrusted status even if all elements are removed", ->
    #     a = [null, null]
    #     a.untrust
    #     a.compact!
    #     a.untrusted?.should be_true

    # ruby_version_is '' ... '1.9' do
    #   it "raises a TypeError on a frozen array", ->
    #     lambda { ArraySpecs.frozen_array.compact! }.should raise_error(TypeError)

    # ruby_version_is '1.9' do
    #   it "raises a RuntimeError on a frozen array" do
    #     lambda { ArraySpecs.frozen_array.compact! }.should raise_error(RuntimeError)
