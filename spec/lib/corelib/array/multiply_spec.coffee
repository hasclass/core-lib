describe "Array#*", ->
  it "tries to convert the passed argument to a String using #valueOf", ->
    obj =
      valueOf: -> '::'
    expect(R([1, 2, 3, 4]).multiply obj).toEqual R('1::2::3::4')

  it "tires to convert the passed argument to an Integer using #to_int", ->
    obj =
      valueOf: -> 2
    expect(R([1, 2, 3, 4]).multiply obj).toEqual R([1, 2, 3, 4, 1, 2, 3, 4])

  it "raises a TypeError if the argument can neither be converted to a string nor an integer", ->
    obj = {}
    expect( -> R([1,2]).multiply obj ).toThrow('TypeError')

  xit "converts the passed argument to a String rather than an Integer", ->
    obj =
      valueOf: -> 2
      # valueOf: -> "2"
    expect(R(['a', 'b', 'c']).multiply obj).toEqual R("a2b2c")

  it "raises a TypeError is the passed argument is nil", ->
    expect( -> R([1,2]).multiply null ).toThrow('TypeError')

  it "raises an ArgumentError when passed 2 or more arguments", ->
    expect( -> R([1,2]).multiply(1, 2) ).toThrow('ArgumentError')

  it "raises an ArgumentError when passed no arguments", ->
    expect( -> R([1,2]).multiply() ).toThrow('ArgumentError')

describe "Array#* with an integer", ->
  it "concatenates n copies of the array when passed an integer", ->
    expect( R([ 1, 2, 3 ]).multiply 0).toEqual R([])
    expect( R([ 1, 2, 3 ]).multiply 1).toEqual R([1, 2, 3])
    expect( R([ 1, 2, 3 ]).multiply 3).toEqual R([1, 2, 3, 1, 2, 3, 1, 2, 3])
    expect( R([]).multiply 10).toEqual R([])

  it "does not return self even if the passed integer is 1", ->
    ary = R [1, 2, 3]
    expect(ary.multiply(1) is ary).toEqual false

  xit "properly handles recursive arrays", ->
    # empty = ArraySpecs.empty_recursive_array
    # (empty.multiply 0).toEqual R([])
    # (empty.multiply 1).toEqual R(empty)
    # (empty.multiply 3).toEqual R([empty, empty, empty])

    # array = ArraySpecs.recursive_array
    # (array.multiply 0).toEqual R([])
    # (array.multiply 1).toEqual R(array)

  it "raises an ArgumentError when passed a negative integer", ->
    expect( -> R([ 1, 2, 3 ]).multiply -1 ).toThrow('ArgumentError')
    expect( -> R([]).multiply -1 ).toThrow('ArgumentError')

  xdescribe "with a subclass of Array", ->
    # before :each do
    #   ScratchPad.clear

    #   @array = ArraySpecs.MyArray[1, 2, 3, 4, 5]

    # it "returns a subclass instance", ->
    #   (@array * 0).should be_an_instance_of(ArraySpecs.MyArray)
    #   (@array * 1).should be_an_instance_of(ArraySpecs.MyArray)
    #   (@array * 2).should be_an_instance_of(ArraySpecs.MyArray)

    # it "does not call #initialize on the subclass instance", ->
    #   (@array * 2).should == [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
    #   ScratchPad.recorded.should be_nil

  # ruby_version_is '' ... '1.9' do
  #   it "does not copy the taint status of the original array if the passed count is 0", ->
  #     ary = [1, 2, 3]
  #     ary.taint
  #     (ary * 0).tainted?.should == false
  #   ruby_version_is '1.9' do
  #   it "copies the taint status of the original array even if the passed count is 0", ->
  #     ary = [1, 2, 3]
  #     ary.taint
  #     (ary * 0).tainted?.should == true

  # it "copies the taint status of the original array even if the array is empty", ->
  #   ary = []
  #   ary.taint
  #   (ary * 3).tainted?.should == true

  # it "copies the taint status of the original array if the passed count is not 0", ->
  #   ary = [1, 2, 3]
  #   ary.taint
  #   (ary * 1).tainted?.should == true
  #   (ary * 2).tainted?.should == true

  # ruby_version_is '1.9' do
  #   it "copies the untrusted status of the original array even if the passed count is 0", ->
  #     ary = [1, 2, 3]
  #     ary.untrust
  #     (ary * 0).untrusted?.should == true

  #   it "copies the untrusted status of the original array even if the array is empty", ->
  #     ary = []
  #     ary.untrust
  #     (ary * 3).untrusted?.should == true

  #   it "copies the untrusted status of the original array if the passed count is not 0", ->
  #     ary = [1, 2, 3]
  #     ary.untrust
  #     (ary * 1).untrusted?.should == true
  #     (ary * 2).untrusted?.should == true

describe "Array#* with a string", ->
#   it_behaves_like :array_join_with_string_separator, :*
# end
