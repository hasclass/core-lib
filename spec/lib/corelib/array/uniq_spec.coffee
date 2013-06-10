describe "Array#uniq", ->
  it "returns an array with no duplicates", ->
    expect( R(["a", "a", "b", "b", "c"]).uniq() ).toEqual R(["a", "b", "c"])

  # ruby_bug "#", "1.8.6.277", ->
  #   it "properly handles recursive arrays", ->
  #     empty = ArraySpecs.empty_recursive_array
  #     empty.uniq.should == [empty]

  #     array = ArraySpecs.recursive_array
  #     array.uniq.should == [1, 'two', 3.0, array]

  xit "uses eql? semantics", ->
    expect( R([R.$Float(1.0), 1]).uniq().valueOf() ).toEqual [1.0, 1]

  xit "compares elements first with hash", ->
    # Can't use should_receive because it uses hash internally
  #   x = mock('0')
  #   def x.hash() 0 end
  #   y = mock('0')
  #   def y.hash() 0 end

  #   [x, y].uniq.should == [x, y]

  # it "does not compare elements with different hash codes via eql?", ->
  #   # Can't use should_receive because it uses hash and eql? internally
  #   x = mock('0')
  #   def x.eql?(o) raise("Shouldn't receive eql?") end
  #   y = mock('1')
  #   def y.eql?(o) raise("Shouldn't receive eql?") end

  #   def x.hash() 0 end
  #   def y.hash() 1 end

  #   [x, y].uniq.should == [x, y]

  xit "compares elements with matching hash codes with #eql?", ->
    # # Can't use should_receive because it uses hash and eql? internally
    # a = Array.new(2) do
    #   obj = mock('0')

    #   def obj.hash()
    #     # It's undefined whether the impl does a[0].eql?(a[1]) or
    #     # a[1].eql?(a[0]) so we taint both.
    #     def self.eql?(o) taint; o.taint; false; end
    #     return 0

    #   obj

    # a.uniq.should == a
    # a[0].tainted?.should == true
    # a[1].tainted?.should == true

    # a = Array.new(2) do
    #   obj = mock('0')

    #   def obj.hash()
    #     # It's undefined whether the impl does a[0].eql?(a[1]) or
    #     # a[1].eql?(a[0]) so we taint both.
    #     def self.eql?(o) taint; o.taint; true; end
    #     return 0

    #   obj

    # a.uniq.size.should == 1
    # a[0].tainted?.should == true
    # a[1].tainted?.should == true

  it "compares elements based on the value returned from the block", ->
    a = R [1, 2, 3, 4]
    expect( a.uniq (x) -> x >= 2 ? 1 : 0 ).should == [1, 2]

  # ruby_version_is "" ... "1.9.3", ->
  #   it "returns subclass instance on Array subclasses", ->
  #     ArraySpecs.MyArray[1, 2, 3].uniq.should be_kind_of(ArraySpecs.MyArray)

  # ruby_version_is "1.9.3", ->
  #   it "does not return subclass instance on Array subclasses", ->
  #     ArraySpecs.MyArray[1, 2, 3].uniq.should be_kind_of(Array)

describe "Array#uniq!", ->
  it "modifies the array in place", ->
    a = R [ "a", "a", "b", "b", "c" ]
    a.uniq_bang()
    expect( a ).toEqual R(["a", "b", "c"])

  it "returns self", ->
    a = R [ "a", "a", "b", "b", "c" ]
    expect( a is a.uniq_bang()).toEqual true

  # ruby_bug "#", "1.8.6.277", ->
  #   it "properly handles recursive arrays", ->
  #     empty = ArraySpecs.empty_recursive_array
  #     empty_dup = empty.dup
  #     empty.uniq_bang()
  #     empty.should == empty_dup

  #     array = ArraySpecs.recursive_array
  #     expected = array[0..3]
  #     array.uniq_bang()
  #     array.should == expected

  it "returns null if no changes are made to the array", ->
    expect( R([ "a", "b", "c" ] ).uniq_bang() ).toEqual null

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError on a frozen array when the array is modified", ->
  #     dup_ary = [1, 1, 2]
  #     dup_ary.freeze
  #     expect( -> dup_ary.uniq! ).toThrow(TypeError)

  #   it "does not raise an exception on a frozen array when the array would not be modified", ->
  #     ArraySpecs.frozen_array.uniq!.should be_null

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError on a frozen array when the array is modified", ->
  #     dup_ary = [1, 1, 2]
  #     dup_ary.freeze
  #     expect( -> dup_ary.uniq! ).toThrow(RuntimeError)

  #   # see [ruby-core:23666]
  #   it "raises a RuntimeError on a frozen array when the array would not be modified", ->
  #     expect( -> ArraySpecs.frozen_array.uniq!).toThrow(RuntimeError)
  #     expect( -> ArraySpecs.empty_frozen_array.uniq!).toThrow(RuntimeError)

  #   it "doesn't yield to the block on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.uniq!{ raise RangeError, "shouldn't yield"}).toThrow(RuntimeError)

  xit "compares elements based on the value returned from the block", ->
    # a = R [1, 2, 3, 4]
    # a.uniq! { |x| x >= 2 ? 1 : 0 }.should == [1, 2]
