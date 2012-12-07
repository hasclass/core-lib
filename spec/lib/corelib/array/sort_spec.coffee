# TODO: finalize implementation
describe "Array#sort", ->
  it "returns a new array sorted based on comparing elements with <=>", ->
    a = R([1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0])
    expect( a.sort().unbox() ).toEqual [-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000]

  it "does not affect the original Array", ->
    a = R([0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13])
    b = a.sort()
    expect( a ).toEqual R([0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13])
    expect( b ).toEqual R(i for i in [0..15])

  it "sorts already-sorted Arrays", ->
    # (0..15).to_a.sort.should == (0..15).to_a

  it "sorts reverse-sorted Arrays", ->
    # (0..15).to_a.reverse.sort.should == (0..15).to_a

#   it "sorts Arrays that consist entirely of equal elements", ->
#     a = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
#     a.sort.should == a
#     b = Array.new(15).map { ArraySpecs.SortSame.new }
#     b.sort.should == b

#   it "sorts Arrays that consist mostly of equal elements", ->
#     a = [1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]
#     a.sort.should == [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

#   it "does not return self even if the array would be already sorted", ->
#     a = [1, 2, 3]
#     sorted = a.sort
#     sorted.should == a
#     sorted.should_not equal(a)

#   it "properly handles recursive arrays", ->
#     empty = ArraySpecs.empty_recursive_array
#     empty.sort.should == empty

#     array = [[]]; array << array
#     array.sort.should == [[], array]

#   it "uses #<=> of elements in order to sort", ->
#     a = ArraySpecs.MockForCompared.new
#     b = ArraySpecs.MockForCompared.new
#     c = ArraySpecs.MockForCompared.new

#     ArraySpecs.MockForCompared.compared?.should == false
#     [a, b, c].sort.should == [c, b, a]
#     ArraySpecs.MockForCompared.compared?.should == true

#   it "does not deal with exceptions raised by unimplemented or incorrect #<=>", ->
#     o = Object.new

#     expect( -> [o, 1].sort ).toThrow

#   it "may take a block which is used to determine the order of objects a and b described as -1, 0 or +1", ->
#     a = [5, 1, 4, 3, 2]
#     a.sort.should == [1, 2, 3, 4, 5]
#     a.sort {|x, y| y <=> x}.should == [5, 4, 3, 2, 1]

#   it "raises an error when a given block returns nil", ->
#     expect( -> [1, 2].sort {} ).toThrow(ArgumentError)

#   it "does not call #<=> on contained objects when invoked with a block", ->
#     a = Array.new(25)
#     (0...25).each {|i| a[i] = ArraySpecs.UFOSceptic.new }

#     a.sort { -1 }.should be_kind_of(Array)

#   it "does not call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)", ->
#     a = Array.new(1500)
#     (0...1500).each {|i| a[i] = ArraySpecs.UFOSceptic.new }

#     a.sort { -1 }.should be_kind_of(Array)

#   it "completes when supplied a block that always returns the same result", ->
#     a = [2, 3, 5, 1, 4]
#     a.sort {  1 }.should be_kind_of(Array)
#     a.sort {  0 }.should be_kind_of(Array)
#     a.sort { -1 }.should be_kind_of(Array)

#   it "does not freezes self during being sorted", ->
#     a = [1, 2, 3]
#     a.sort { |x,y| a.frozen?.should == false; x <=> y }

#   it "returns the specified value when it would break in the given block", ->
#     [1, 2, 3].sort{ break :a }.should == :a

#   it "uses the sign of Bignum block results as the sort result", ->
#     a = [1, 2, 5, 10, 7, -4, 12]
#     begin
#       class Bignum;
#         alias old_spaceship <=>
#         def <=>(other)
#           raise
#                 a.sort {|n, m| (n - m) * (2 ** 200)}.should == [-4, 1, 2, 5, 7, 10, 12]
#     ensure
#       class Bignum
#         alias <=> old_spaceship

#   it "compares values returned by block with 0", ->
#     a = [1, 2, 5, 10, 7, -4, 12]
#     a.sort { |n, m| n - m }.should == [-4, 1, 2, 5, 7, 10, 12]
#     a.sort { |n, m|
#       ArraySpecs.ComparableWithFixnum.new(n-m)
#     }.should == [-4, 1, 2, 5, 7, 10, 12]
#     expect( ->
#       a.sort { |n, m| (n - m).to_s }
#     ).toThrow(ArgumentError)

#   it "raises an error if objects can't be compared", ->
#     a=[ArraySpecs.Uncomparable.new, ArraySpecs.Uncomparable.new]
#     expect( ->a.sort).toThrow(ArgumentError)

#   # From a strange Rubinius bug
#   it "handles a large array that has been pruned", ->
#     pruned = ArraySpecs.LargeArray.dup.delete_if { |n| n !~ /^test./ }
#     pruned.sort.should == ArraySpecs.LargeTestArraySorted

#   ruby_version_is "" ... "1.9.3", ->
#     it "returns subclass instance on Array subclasses", ->
#       ary = ArraySpecs.MyArray[1, 2, 3]
#       ary.sort.should be_kind_of(ArraySpecs.MyArray)

#   ruby_version_is "1.9.3", ->
#     it "does not return subclass instance on Array subclasses", ->
#       ary = ArraySpecs.MyArray[1, 2, 3]
#       ary.sort.should be_kind_of(Array)

describe "Array#sort!", ->
  it "sorts array in place using <=>", ->
    a = R [1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    a.sort_bang()
    expect( a).toEqual R([-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000])

#   it "sorts array in place using block value if a block given", ->
#     a = [0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
#     a.sort! { |x, y| y <=> x }.should == (0..15).to_a.reverse

#   it "returns self if the order of elements changed", ->
#     a = [6, 7, 2, 3, 7]
#     a.sort!.should equal(a)
#     a.should == [2, 3, 6, 7, 7]

#   it "returns self even if makes no modification", ->
#     a = [1, 2, 3, 4, 5]
#     a.sort!.should equal(a)
#     a.should == [1, 2, 3, 4, 5]

#   it "properly handles recursive arrays", ->
#     empty = ArraySpecs.empty_recursive_array
#     empty.sort!.should == empty

#     array = [[]]; array << array
#     array.sort!.should == array

#   it "uses #<=> of elements in order to sort", ->
#     a = ArraySpecs.MockForCompared.new
#     b = ArraySpecs.MockForCompared.new
#     c = ArraySpecs.MockForCompared.new

#     ArraySpecs.MockForCompared.compared?.should == false
#     [a, b, c].sort!.should == [c, b, a]
#     ArraySpecs.MockForCompared.compared?.should == true

#   it "does not call #<=> on contained objects when invoked with a block", ->
#     a = Array.new(25)
#     (0...25).each {|i| a[i] = ArraySpecs.UFOSceptic.new }

#     a.sort! { -1 }.should be_kind_of(Array)

#   it "does not call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)", ->
#     a = Array.new(1500)
#     (0...1500).each {|i| a[i] = ArraySpecs.UFOSceptic.new }

#     a.sort! { -1 }.should be_kind_of(Array)

#   it "completes when supplied a block that always returns the same result", ->
#     a = [2, 3, 5, 1, 4]
#     a.sort!{  1 }.should be_kind_of(Array)
#     a.sort!{  0 }.should be_kind_of(Array)
#     a.sort!{ -1 }.should be_kind_of(Array)

#   ruby_version_is '' ... '1.9' do
#     it "raises a TypeError on a frozen array", ->
#       expect( -> ArraySpecs.frozen_array.sort! ).toThrow(TypeError)

#     not_compliant_on :rubinius do
#       it "temporarily freezes self and recovers after sorted", ->
#         a = [1, 2, 3]
#         a.sort! { |x,y| a.frozen?.should == true; x <=> y }
#         a.frozen?.should == false

#   ruby_version_is '1.9' do
#     it "raises a RuntimeError on a frozen array", ->
#       expect( -> ArraySpecs.frozen_array.sort! ).toThrow(RuntimeError)

#   it "returns the specified value when it would break in the given block", ->
#     [1, 2, 3].sort{ break :a }.should == :a

#   it "makes some modification even if finished sorting when it would break in the given block", ->
#     partially_sorted = (1..5).map{|i|
#       ary = [5, 4, 3, 2, 1]
#       ary.sort!{|x,y| break if x==i; x<=>y}
#       ary
#     }
#     partially_sorted.any?{|ary| ary != [1, 2, 3, 4, 5]}.should be_true
# end
