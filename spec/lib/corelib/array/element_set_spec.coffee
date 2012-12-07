describe "Array#[]=", ->
  it "sets the value of the element at index", ->
    # a = R([1, 2, 3, 4])
    # a[2] = 5
    # a[-1] = 6
    # a[5] = 3
    # expect(a).toEqual R([1, 2, 5, 6, null, 3])

    # a = []
    # a[4] = "e"
    # a.should == [nil, nil, nil, nil, "e"]
    # a[3] = "d"
    # a.should == [nil, nil, nil, "d", "e"]
    # a[0] = "a"
    # a.should == ["a", nil, nil, "d", "e"]
    # a[-3] = "C"
    # a.should == ["a", nil, "C", "d", "e"]
    # a[-1] = "E"
    # a.should == ["a", nil, "C", "d", "E"]
    # a[-5] = "A"
    # a.should == ["A", nil, "C", "d", "E"]
    # a[5] = "f"
    # a.should == ["A", nil, "C", "d", "E", "f"]
    # a[1] = []
    # a.should == ["A", [], "C", "d", "E", "f"]
    # a[-1] = nil
    # a.should == ["A", [], "C", "d", "E", nil]

#   it "sets the section defined by [start,length] to other", ->
#     a = [1, 2, 3, 4, 5, 6]
#     a[0, 1] = 2
#     a[3, 2] = ['a', 'b', 'c', 'd']
#     a.should == [2, 2, 3, "a", "b", "c", "d", 6]
#   it "replaces the section defined by [start,length] with the given values", ->
#     a = [1, 2, 3, 4, 5, 6]
#     a[3, 2] = 'a', 'b', 'c', 'd'
#     a.should == [1, 2, 3, "a", "b", "c", "d", 6]

#   ruby_version_is '' ... '1.9' do
#     it "removes the section defined by [start,length] when set to nil", ->
#       a = ['a', 'b', 'c', 'd', 'e']
#       a[1, 3] = nil
#       a.should == ["a", "e"]

#     it "is not confused by shift when removing elements with nil", ->
#       a = [1,2,3]

#       a.shift
#       a[1,1] = nil

#       a.should == [2]
#     ruby_version_is '1.9' do
#     it "just sets the section defined by [start,length] to other even if other is nil", ->
#       a = ['a', 'b', 'c', 'd', 'e']
#       a[1, 3] = nil
#       a.should == ["a", nil, "e"]
#     it "returns nil if the rhs is nil", ->
#     a = [1, 2, 3]
#     (a[1, 3] = nil).should == nil
#     (a[1..3] = nil).should == nil

#   it "sets the section defined by range to other", ->
#     a = [6, 5, 4, 3, 2, 1]
#     a[1...2] = 9
#     a[3..6] = [6, 6, 6]
#     a.should == [6, 9, 4, 6, 6, 6]

#   it "replaces the section defined by range with the given values", ->
#     a = [6, 5, 4, 3, 2, 1]
#     a[3..6] = :a, :b, :c
#     a.should == [6, 5, 4, :a, :b, :c]

#   ruby_version_is '' ... '1.9' do
#     it "removes the section defined by range when set to nil", ->
#       a = [1, 2, 3, 4, 5]
#       a[0..1] = nil
#       a.should == [3, 4, 5]
#       it "just sets the section defined by range to nil when the rhs is [nil].", ->
#       a = [1, 2, 3, 4, 5]
#       a[0..1] = [nil]
#       a.should == [nil, 3, 4, 5]
#     ruby_version_is '1.9' do
#     it "just sets the section defined by range to other even if other is nil", ->
#       a = [1, 2, 3, 4, 5]
#       a[0..1] = nil
#       a.should == [nil, 3, 4, 5]

#   it "calls to_int on its start and length arguments", ->
#     obj = mock('to_int')
#     obj.stub!(:to_int).and_return(2)

#     a = [1, 2, 3, 4]
#     a[obj, 0] = [9]
#     a.should == [1, 2, 9, 3, 4]
#     a[obj, obj] = []
#     a.should == [1, 2, 4]
#     a[obj] = -1
#     a.should == [1, 2, -1]

#   ruby_version_is '1.9' do
#     it "checks frozen before attempting to coerce arguments", ->
#       a = [1,2,3,4].freeze
#       expect( ->a[:foo] = 1).toThrow(RuntimeError)
#       expect( ->a[:foo, :bar] = 1).toThrow(RuntimeError)

#   it "sets elements in the range arguments when passed ranges", ->
#     ary = [1, 2, 3]
#     rhs = [nil, [], ["x"], ["x", "y"]]
#     (0 .. ary.size + 2).each do |a|
#       (a .. ary.size + 3).each do |b|
#         rhs.each do |c|
#           ary1 = ary.dup
#           ary1[a .. b] = c
#           ary2 = ary.dup
#           ary2[a, 1 + b-a] = c
#           ary1.should == ary2

#           ary1 = ary.dup
#           ary1[a ... b] = c
#           ary2 = ary.dup
#           ary2[a, b-a] = c
#           ary1.should == ary2

#   it "inserts the given elements with [range] which the range is zero-width", ->
#     ary = [1, 2, 3]
#     ary[1...1] = 0
#     ary.should == [1, 0, 2, 3]
#     ary[1...1] = [5]
#     ary.should == [1, 5, 0, 2, 3]
#     ary[1...1] = :a, :b, :c
#     ary.should == [1, :a, :b, :c, 5, 0, 2, 3]

#   it "inserts the given elements with [start, length] which length is zero", ->
#     ary = [1, 2, 3]
#     ary[1, 0] = 0
#     ary.should == [1, 0, 2, 3]
#     ary[1, 0] = [5]
#     ary.should == [1, 5, 0, 2, 3]
#     ary[1, 0] = :a, :b, :c
#     ary.should == [1, :a, :b, :c, 5, 0, 2, 3]

#   # Now we only have to test cases where the start, length interface would
#   # have raise an exception because of negative size
#   it "inserts the given elements with [range] which the range has negative width", ->
#     ary = [1, 2, 3]
#     ary[1..0] = 0
#     ary.should == [1, 0, 2, 3]
#     ary[1..0] = [4, 3]
#     ary.should == [1, 4, 3, 0, 2, 3]
#     ary[1..0] = :a, :b, :c
#     ary.should == [1, :a, :b, :c, 4, 3, 0, 2, 3]

#   ruby_version_is '' ... '1.9' do
#     it "does nothing if the section defined by range is zero-width and the rhs is nil", ->
#       ary = [1, 2, 3]
#       ary[1...1] = nil
#       ary.should == [1, 2, 3]
#       it "does nothing if the section defined by range has negative width and the rhs is nil", ->
#       ary = [1, 2, 3]
#       ary[1..0] = nil
#       ary.should == [1, 2, 3]
#     ruby_version_is '1.9' do
#     it "just inserts nil if the section defined by range is zero-width and the rhs is nil", ->
#       ary = [1, 2, 3]
#       ary[1...1] = nil
#       ary.should == [1, nil, 2, 3]
#       it "just inserts nil if the section defined by range has negative width and the rhs is nil", ->
#       ary = [1, 2, 3]
#       ary[1..0] = nil
#       ary.should == [1, nil, 2, 3]

#   it "does nothing if the section defined by range is zero-width and the rhs is an empty array", ->
#     ary = [1, 2, 3]
#     ary[1...1] = []
#     ary.should == [1, 2, 3]
#   it "does nothing if the section defined by range has negative width and the rhs is an empty array", ->
#     ary = [1, 2, 3, 4, 5]
#     ary[1...0] = []
#     ary.should == [1, 2, 3, 4, 5]
#     ary[-2..2] = []
#     ary.should == [1, 2, 3, 4, 5]

#   it "tries to convert Range elements to Integers using #to_int with [m..n] and [m...n]", ->
#     from = mock('from')
#     to = mock('to')

#     # So we can construct a range out of them...
#     def from.<=>(o) 0 end
#     def to.<=>(o) 0 end

#     def from.to_int() 1 end
#     def to.to_int() -2 end

#     a = [1, 2, 3, 4]

#     a[from .. to] = ["a", "b", "c"]
#     a.should == [1, "a", "b", "c", 4]

#     a[to .. from] = ["x"]
#     a.should == [1, "a", "b", "x", "c", 4]
#     expect( -> a["a" .. "b"] = []  ).toThrow(TypeError)
#     expect( -> a[from .. "b"] = [] ).toThrow(TypeError)

#   it "raises an IndexError when passed indexes out of bounds", ->
#     a = [1, 2, 3, 4]
#     expect( -> a[-5] = ""      ).toThrow(IndexError)
#     expect( -> a[-5, -1] = ""  ).toThrow(IndexError)
#     expect( -> a[-5, 0] = ""   ).toThrow(IndexError)
#     expect( -> a[-5, 1] = ""   ).toThrow(IndexError)
#     expect( -> a[-5, 2] = ""   ).toThrow(IndexError)
#     expect( -> a[-5, 10] = ""  ).toThrow(IndexError)

#     expect( -> a[-5..-5] = ""  ).toThrow(RangeError)
#     expect( -> a[-5...-5] = "" ).toThrow(RangeError)
#     expect( -> a[-5..-4] = ""  ).toThrow(RangeError)
#     expect( -> a[-5...-4] = "" ).toThrow(RangeError)
#     expect( -> a[-5..10] = ""  ).toThrow(RangeError)
#     expect( -> a[-5...10] = "" ).toThrow(RangeError)

#     # ok
#     a[0..-9] = [1]
#     a.should == [1, 1, 2, 3, 4]

#   it "calls to_ary on its rhs argument for multi-element sets", ->
#     obj = mock('to_ary')
#     def obj.to_ary() [1, 2, 3] end
#     ary = [1, 2]
#     ary[0, 0] = obj
#     ary.should == [1, 2, 3, 1, 2]
#     ary[1, 10] = obj
#     ary.should == [1, 1, 2, 3]

#   it "does not call to_ary on rhs array subclasses for multi-element sets", ->
#     ary = []
#     ary[0, 0] = ArraySpecs.ToAryArray[5, 6, 7]
#     ary.should == [5, 6, 7]

#   ruby_version_is '' ... '1.9' do
#     it "raises a TypeError on a frozen array", ->
#       expect( -> ArraySpecs.frozen_array[0, 0] = [] ).toThrow(TypeError)

#   ruby_version_is '1.9' do
#     it "raises a RuntimeError on a frozen array", ->
#       expect( -> ArraySpecs.frozen_array[0, 0] = [] ).toThrow(RuntimeError)

# describe "Array#[]= with [index]", ->
#   it "returns value assigned if idx is inside array", ->
#     a = [1, 2, 3, 4, 5]
#     (a[3] = 6).should == 6

#   it "returns value assigned if idx is right beyond right array boundary", ->
#     a = [1, 2, 3, 4, 5]
#     (a[5] = 6).should == 6

#   it "returns value assigned if idx far beyond right array boundary", ->
#     a = [1, 2, 3, 4, 5]
#     (a[10] = 6).should == 6

#   it "sets the value of the element at index", ->
#       a = [1, 2, 3, 4]
#       a[2] = 5
#       a[-1] = 6
#       a[5] = 3
#       a.should == [1, 2, 5, 6, nil, 3]

#   it "sets the value of the element if it is right beyond the array boundary", ->
#     a = [1, 2, 3, 4]
#     a[4] = 8
#     a.should == [1, 2, 3, 4, 8]

# end

# describe "Array#[]= with [index, count]", ->
#   it "returns non-array value if non-array value assigned", ->
#     a = [1, 2, 3, 4, 5]
#     (a[2, 3] = 10).should == 10

#   it "returns array if array assigned", ->
#     a = [1, 2, 3, 4, 5]
#     (a[2, 3] = [4, 5]).should == [4, 5]

#   ruby_version_is '' ... '1.9' do
#     it "removes the section defined by [start,length] when set to nil", ->
#       a = ['a', 'b', 'c', 'd', 'e']
#       a[1, 3] = nil
#       a.should == ["a", "e"]
#     ruby_version_is '1.9' do
#     it "just sets the section defined by [start,length] to nil even if the rhs is nil", ->
#       a = ['a', 'b', 'c', 'd', 'e']
#       a[1, 3] = nil
#       a.should == ["a", nil, "e"]

#   ruby_version_is '' ... '1.9' do
#     it "removes the section when set to nil if negative index within bounds and cnt > 0", ->
#       a = ['a', 'b', 'c', 'd', 'e']
#       a[-3, 2] = nil
#       a.should == ["a", "b", "e"]

#   ruby_version_is '1.9' do
#     it "just sets the section defined by [start,length] to nil if negative index within bounds, cnt > 0 and the rhs is nil", ->
#       a = ['a', 'b', 'c', 'd', 'e']
#       a[-3, 2] = nil
#       a.should == ["a", "b", nil, "e"]

#   it "replaces the section defined by [start,length] to other", ->
#     a = [1, 2, 3, 4, 5, 6]
#     a[0, 1] = 2
#     a[3, 2] = ['a', 'b', 'c', 'd']
#     a.should == [2, 2, 3, "a", "b", "c", "d", 6]

#   it "replaces the section to other if idx < 0 and cnt > 0", ->
#     a = [1, 2, 3, 4, 5, 6]
#     a[-3, 2] = ["x", "y", "z"]
#     a.should == [1, 2, 3, "x", "y", "z", 6]

#   it "replaces the section to other even if cnt spanning beyond the array boundary", ->
#     a = [1, 2, 3, 4, 5]
#     a[-1, 3] = [7, 8]
#     a.should == [1, 2, 3, 4, 7, 8]

#   it "pads the Array with nils if the span is past the end", ->
#     a = [1, 2, 3, 4, 5]
#     a[10, 1] = [1]
#     a.should == [1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1]

#     b = [1, 2, 3, 4, 5]
#     b[10, 0] = [1]
#     a.should == [1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1]

#   it "inserts other section in place defined by idx", ->
#     a = [1, 2, 3, 4, 5]
#     a[3, 0] = [7, 8]
#     a.should == [1, 2, 3, 7, 8, 4, 5]

#     b = [1, 2, 3, 4, 5]
#     b[1, 0] = b
#     b.should == [1, 1, 2, 3, 4, 5, 2, 3, 4, 5]

#   it "raises an IndexError when passed start and negative length", ->
#     a = [1, 2, 3, 4]
#     expect( -> a[-2, -1] = "" ).toThrow(IndexError)
#     expect( -> a[0, -1] = ""  ).toThrow(IndexError)
#     expect( -> a[2, -1] = ""  ).toThrow(IndexError)
#     expect( -> a[4, -1] = ""  ).toThrow(IndexError)
#     expect( -> a[10, -1] = "" ).toThrow(IndexError)
#     expect( -> [1, 2, 3, 4,  5][2, -1] = [7, 8] ).toThrow(IndexError)
# end

# describe "Array#[]= with [m..n]", ->
#   it "returns non-array value if non-array value assigned", ->
#     a = [1, 2, 3, 4, 5]
#     (a[2..4] = 10).should == 10

#   it "returns array if array assigned", ->
#     a = [1, 2, 3, 4, 5]
#     (a[2..4] = [7, 8]).should == [7, 8]

#   ruby_version_is '' ... '1.9' do
#     it "removes the section defined by range when set to nil", ->
#       a = [1, 2, 3, 4, 5]
#       a[0..1] = nil
#       a.should == [3, 4, 5]
#       it "removes the section when set to nil if m and n < 0", ->
#       a = [1, 2, 3, 4, 5]
#       a[-3..-2] = nil
#       a.should == [1, 2, 5]

#   ruby_version_is '1.9' do
#     it "just sets the section defined by range to nil even if the rhs is nil", ->
#       a = [1, 2, 3, 4, 5]
#       a[0..1] = nil
#       a.should == [nil, 3, 4, 5]
#       it "just sets the section defined by range to nil if m and n < 0 and the rhs is nil", ->
#       a = [1, 2, 3, 4, 5]
#       a[-3..-2] = nil
#       a.should == [1, 2, nil, 5]

#   it "replaces the section defined by range", ->
#       a = [6, 5, 4, 3, 2, 1]
#       a[1...2] = 9
#       a[3..6] = [6, 6, 6]
#       a.should == [6, 9, 4, 6, 6, 6]

#   it "replaces the section if m and n < 0", ->
#     a = [1, 2, 3, 4, 5]
#     a[-3..-2] = [7, 8, 9]
#     a.should == [1, 2, 7, 8, 9, 5]

#   it "replaces the section if m < 0 and n > 0", ->
#     a = [1, 2, 3, 4, 5]
#     a[-4..3] = [8]
#     a.should == [1, 8, 5]

#   it "inserts the other section at m if m > n", ->
#     a = [1, 2, 3, 4, 5]
#     a[3..1] = [8]
#     a.should == [1, 2, 3, 8, 4, 5]

#   it "accepts Range subclasses", ->
#     a = [1, 2, 3, 4]
#     range_incl = ArraySpecs.MyRange.new(1, 2)
#     range_excl = ArraySpecs.MyRange.new(-3, -1, true)

#     a[range_incl] = ["a", "b"]
#     a.should == [1, "a", "b", 4]
#     a[range_excl] = ["A", "B"]
#     a.should == [1, "A", "B", 4]
# end

# describe "Array#[] after a shift", ->
#   it "works for insertion", ->
#     a = [1,2]
#     a.shift
#     a.shift
#     a[0,0] = [3,4]
#     a.should == [3,4]
# end

