describe "Array#flatten", ->
  it "flattens [null, undefined]", ->
    expect( R([null, undefined]).flatten().to_native() ).toEqual
  it "returns a one-dimensional flattening recursively", ->
    expect(
      RubyJS.$Array_r([[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []] ).flatten().inspect()
    ).toEqual R('[1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4]')

  describe 'ruby_version_is "1.8.7"', ->
    it "takes an optional argument that determines the level of recursion", ->
      expect(
        R([ 1, 2, [3, [4, 5] ] ]).flatten(1).inspect() ).toEqual R("[1, 2, 3, [4, 5]]")

#     ruby_version_is ""..."1.9", ->
#       it "returns self when the level of recursion is 0", ->
#         a = [ 1, 2, [3, [4, 5] ] ]
#         a.flatten(0).should equal(a)

    describe 'ruby_version_is "1.9"', ->
      it "returns dup when the level of recursion is 0", ->
        a = R [ 1, 2, [3, [4, 5] ] ]
        expect( a.flatten(0).inspect() ).toEqual R('[1, 2, [3, [4,5]]]')
        expect( a.flatten(0) == a).toEqual false

    it "ignores negative levels", ->
      arr = R([ 1, 2, [ 3, 4, [5, 6] ] ])
      expect( arr.flatten(-1).inspect() ).toEqual R('[1, 2, 3, 4, 5, 6]')
      expect( arr.flatten(-10).inspect() ).toEqual R('[1, 2, 3, 4, 5, 6]')

#     it "tries to convert passed Objects to Integers using #to_int", ->
#       obj = mock("Converted to Integer")
#       obj.should_receive(:to_int).and_return(1)

#       expect(
#         [ 1, 2, [3, [4, 5] ] ].flatten(obj) ).toEqual [1, 2, 3, [4, 5]]

#     it "raises a TypeError when the passed Object can't be converted to an Integer", ->
#       obj = mock("Not converted")
#       lambda { [ 1, 2, [3, [4, 5] ] ].flatten(obj) }.should raise_error(TypeError)

  it "does not call flatten on elements", ->
    obj =
      flatten: -> throw "should_not_receive"
    expect( R([obj, obj]).flatten().to_native() ).toEqual [obj, obj]

    obj = [5, 4]
    obj.flatten = -> throw "should_not_receive"
    expect(
      R([obj, obj]).flatten().to_native(true) ).toEqual [5, 4, 5, 4]

#   it "raises an ArgumentError on recursive arrays", ->
#     x = []
#     x << x
#     lambda { x.flatten }.should raise_error(ArgumentError)

#     x = []
#     y = []
#     x << y
#     y << x
#     lambda { x.flatten }.should raise_error(ArgumentError)

#   it "flattens any element which responds to #to_ary, using the return value of said method", ->
#     x = mock("[3,4]")
#     x.should_receive(:to_ary).at_least(:once).and_return([3, 4])
#     expect(
#       [1, 2, x, 5].flatten ).toEqual [1, 2, 3, 4, 5]

#     y = mock("MyArray[]")
#     y.should_receive(:to_ary).at_least(:once).and_return(ArraySpecs::MyArray[])
#     expect(
#       [y].flatten ).toEqual []

#     z = mock("[2,x,y,5]")
#     z.should_receive(:to_ary).and_return([2, x, y, 5])
#     expect(
#       [1, z, 6].flatten ).toEqual [1, 2, 3, 4, 5, 6]

#   it "returns subclass instance for Array subclasses", ->
#     ArraySpecs::MyArray[].flatten.should be_kind_of(ArraySpecs::MyArray)
#     ArraySpecs::MyArray[1, 2, 3].flatten.should be_kind_of(ArraySpecs::MyArray)
#     ArraySpecs::MyArray[1, [2], 3].flatten.should be_kind_of(ArraySpecs::MyArray)
#     [ArraySpecs::MyArray[1, 2, 3]].flatten.should be_kind_of(Array)

  it "is not destructive", ->
    ary = R [1, [2, 3]]
    ary.flatten()
    expect( ary.inspect() ).toEqual R('[1, [2,3]]')

#   describe "with a non-Array object in the Array", ->
#     before :each do
#       @obj = mock("Array#flatten")

#     it "does not call #to_ary if the method does not exist", ->
#       expect(
#         [@obj].flatten ).toEqual [@obj]

#     it "ignores the return value of #to_ary if it is nil", ->
#       @obj.should_receive(:to_ary).and_return(nil)
#       expect(
#         [@obj].flatten ).toEqual [@obj]

#     it "raises a TypeError if the return value of #to_ary is not an Array", ->
#       @obj.should_receive(:to_ary).and_return(1)
#       lambda { [@obj].flatten }.should raise_error(TypeError)
#   end

# describe "Array#flatten!, ->
#   it "modifies array to produce a one-dimensional flattening recursively", ->
#     a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
#     a.flatten!
#     expect(
#       a ).toEqual [1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4]

#   it "returns self if made some modifications", ->
#     a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
#     a.flatten!.should equal(a)

#   it "returns nil if no modifications took place", ->
#     a = [1, 2, 3]
#     expect(
#       a.flatten! ).toEqual nil
#     a = [1, [2, 3]]
#     a.flatten!.should_not == nil

#   ruby_version_is "1.8.7", ->
#     it "takes an optional argument that determines the level of recursion", ->
#       expect(
#         [ 1, 2, [3, [4, 5] ] ].flatten!(1) ).toEqual [1, 2, 3, [4, 5]]

#     ruby_bug "redmine #1440", "1.9.1", ->
#       it "returns nil when the level of recursion is 0", ->
#         a = [ 1, 2, [3, [4, 5] ] ]
#         expect(
#           a.flatten!(0) ).toEqual nil

#     it "treats negative levels as no arguments", ->
#       expect(
#         [ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-1) ).toEqual [1, 2, 3, 4, 5, 6]
#       expect(
#         [ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-10) ).toEqual [1, 2, 3, 4, 5, 6]

#     it "tries to convert passed Objects to Integers using #to_int", ->
#       obj = mock("Converted to Integer")
#       obj.should_receive(:to_int).and_return(1)

#       expect(
#         [ 1, 2, [3, [4, 5] ] ].flatten!(obj) ).toEqual [1, 2, 3, [4, 5]]

#     it "raises a TypeError when the passed Object can't be converted to an Integer", ->
#       obj = mock("Not converted")
#       lambda { [ 1, 2, [3, [4, 5] ] ].flatten!(obj) }.should raise_error(TypeError)

#   it "does not call flatten! on elements", ->
#     obj = mock('[1,2]')
#     obj.should_not_receive(:flatten!)
#     expect(
#       [obj, obj].flatten! ).toEqual nil

#     obj = [5, 4]
#     obj.should_not_receive(:flatten!)
#     expect(
#       [obj, obj].flatten! ).toEqual [5, 4, 5, 4]

#   it "raises an ArgumentError on recursive arrays", ->
#     x = []
#     x << x
#     lambda { x.flatten! }.should raise_error(ArgumentError)

#     x = []
#     y = []
#     x << y
#     y << x
#     lambda { x.flatten! }.should raise_error(ArgumentError)

#   it "flattens any elements which responds to #to_ary, using the return value of said method", ->
#     x = mock("[3,4]")
#     x.should_receive(:to_ary).at_least(:once).and_return([3, 4])
#     expect(
#       [1, 2, x, 5].flatten! ).toEqual [1, 2, 3, 4, 5]

#     y = mock("MyArray[]")
#     y.should_receive(:to_ary).at_least(:once).and_return(ArraySpecs::MyArray[])
#     expect(
#       [y].flatten! ).toEqual []

#     z = mock("[2,x,y,5]")
#     z.should_receive(:to_ary).and_return([2, x, y, 5])
#     expect(
#       [1, z, 6].flatten! ).toEqual [1, 2, 3, 4, 5, 6]

#     ary = [ArraySpecs::MyArray[1, 2, 3]]
#     ary.flatten!
#     ary.should be_kind_of(Array)
#     expect(
#       ary ).toEqual [1, 2, 3]

#   ruby_version_is ""..."1.9", ->
#     it "raises a TypeError on frozen arrays when the array is modified", ->
#       nested_ary = [1, 2, []]
#       nested_ary.freeze
#       lambda { nested_ary.flatten! }.should raise_error(TypeError)

#     it "does not raise on frozen arrays when the array would not be modified", ->
#       ArraySpecs.frozen_array.flatten!.should be_nil

#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError on frozen arrays when the array is modified", ->
#       nested_ary = [1, 2, []]
#       nested_ary.freeze
#       lambda { nested_ary.flatten! }.should raise_error(RuntimeError)

#     # see [ruby-core:23663]
#     it "raises a RuntimeError on frozen arrays when the array would not be modified", ->
#       lambda { ArraySpecs.frozen_array.flatten! }.should raise_error(RuntimeError)
#       lambda { ArraySpecs.empty_frozen_array.flatten! }.should raise_error(RuntimeError)
