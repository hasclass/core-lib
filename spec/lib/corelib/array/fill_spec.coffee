describe "Array#fill", ->
  it "returns self", ->
    ary = R [1, 2, 3]
    expect( ary.fill('a') is ary ).toEqual true

  it "is destructive", ->
    ary = R [1, 2, 3]
    ary.fill('a')
    expect( ary ).toEqual R(['a', 'a', 'a'])

  it "does not replicate the filler", ->
    ary = R([1, 2, 3, 4])
    str = R("x")
    expect( ary.fill(str) ).toEqual R([str, str, str, str])
    str.append "y"
    expect( ary ).toEqual R([str, str, str, str])
    expect( ary.at(0)        ).toEqual R("xy")
    expect( ary.at(0) is str ).toEqual true
    expect( ary.at(1) is str ).toEqual true
    expect( ary.at(2) is str ).toEqual true
    expect( ary.at(3) is str ).toEqual true

  it "replaces all elements in the array with the filler if not given a index nor a length", ->
    ary = R ['a', 'b', 'c', 'duh']
    expect( ary.fill(8) ).toEqual R([8, 8, 8, 8])

    str = "x"
    expect( ary.fill(str) ).toEqual R([str, str, str, str])

  it "replaces all elements with the value of block (index given to block)", ->
    expect( R([null, null, null, null]).fill( (i) -> i * 2 ) ).toEqual R([0, 2, 4, 6])

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.fill('x') ).toThrow(TypeError)
  #     it "raises a TypeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.fill('x') ).toThrow(TypeError)

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     expect( -> ArraySpecs.frozen_array.fill('x') ).toThrow('RuntimeError')
  #     it "raises a RuntimeError on an empty frozen array", ->
  #     expect( -> ArraySpecs.empty_frozen_array.fill('x') ).toThrow('RuntimeError')

  it "raises an ArgumentError if 4 or more arguments are passed when no block given", ->
    expect( -> R([]).fill('a') )
    # ruby_bug "#", "1.8.6.277", ->
    expect( -> R([]).fill('a', 1) )
    expect( -> R([]).fill('a', 1, 2) )
    expect( -> R([]).fill('a', 1, 2, true) ).toThrow('ArgumentError')

  it "raises an ArgumentError if no argument passed and no block given", ->
    expect( -> R([]).fill() ).toThrow('ArgumentError')

  it "raises an ArgumentError if 3 or more arguments are passed when a block given", ->
    expect( -> R([]).fill(->) )
    # ruby_bug "#", "1.8.6.277", ->
    expect( -> R([]).fill(1, ->) )
    expect( -> R([]).fill(1, 2, ->) )
    expect( -> R([]).fill(1, 2, true, ->) ).toThrow('ArgumentError')

describe "Array#fill with (filler, index, length)", ->
  beforeEach ->
    @never_passed = () -> throw 'ExpectationNotMetError'


  it "replaces length elements beginning with the index with the filler if given an index and a length", ->
    ary = R [1, 2, 3, 4, 5, 6]
    ary.fill('x', 2, 3).should == [1, 2, 'x', 'x', 'x', 6]

  it "replaces length elements beginning with the index with the value of block", ->
    arr = R([true, false, true, false, true, false, true])
    expect( arr.fill(1, 4, (i) ->
      i + 3 ).unbox(true) ).toEqual([true, 4, 5, 6, 7, false, true])

  it "replaces all elements after the index if given an index and no length ", ->
    ary = R [1, 2, 3]
    expect( ary.fill('x', 1)         ).toEqual R([1, 'x', 'x'])
    expect( ary.fill(1, (i) -> i*2 ) ).toEqual R([1, 2, 4])

  it "replaces all elements after the index if given an index and nil as a length", ->
    a = R [1, 2, 3]
    expect( a.fill('x', 1, null)         ).toEqual R([1, 'x', 'x'])
    expect( a.fill(1, null, (i) -> i*2 ) ).toEqual R([1, 2, 4])
    expect( a.fill('y', null)            ).toEqual R(['y', 'y', 'y'])

  it "replaces the last (-n) elements if given an index n which is negative and no length", ->
    a = R [1, 2, 3, 4, 5]
    expect( a.fill('x', -2) ).toEqual R([1, 2, 3, 'x', 'x'])
    expect( a.fill(-2, (i) -> "#{i}" ) ).toEqual R([1, 2, 3, '3', '4'])

  it "replaces the last (-n) elements if given an index n which is negative and null as a length", ->
    a = R [1, 2, 3, 4, 5]
    expect( a.fill('x', -2, null) ).toEqual R([1, 2, 3, 'x', 'x'])
    expect( a.fill(-2, null, (i) -> "#{i}" ) ).toEqual R([1, 2, 3, '3', '4'])

  it "makes no modifications if given an index greater than end and no length", ->
    expect( R([1, 2, 3, 4, 5]).fill('a', 5)           ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill(5, @never_passed) ).toEqual R([1, 2, 3, 4, 5])

  it "makes no modifications if given an index greater than end and null as a length", ->
    expect( R([1, 2, 3, 4, 5]).fill('a', 5, null)           ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill(5, null, @never_passed) ).toEqual R([1, 2, 3, 4, 5])

  it "replaces length elements beginning with start index if given an index >= 0 and a length >= 0", ->
    expect( R([1, 2, 3, 4, 5]).fill('a', 2, 0) ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill('a', 2, 2) ).toEqual R([1, 2, "a", "a", 5])

    expect( R([1, 2, 3, 4, 5]).fill(2, 0, @never_passed) ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill(2, 2, (i) -> i*2 )   ).toEqual R([1, 2, 4, 6, 5])

  it "increases the Array size when necessary", ->
    a = R [1, 2, 3]
    expect(a.size()).toEqual R(3)
    a.fill('a', 0, 10)
    expect(a.size()).toEqual R(10)

  it "pads between the last element and the index with null if given an index which is greater than size of the array", ->
    expect( R([1, 2, 3, 4, 5]).fill('a', 8, 5) ).toEqual R([1, 2, 3, 4, 5, null, null, null, 'a', 'a', 'a', 'a', 'a'])
    expect( R([1, 2, 3, 4, 5]).fill(8, 5, (i) -> 'a' )).toEqual R([1, 2, 3, 4, 5, null, null, null, 'a', 'a', 'a', 'a', 'a'])

  it "replaces length elements beginning with the (-n)th if given an index n < 0 and a length > 0", ->
    expect( R([1, 2, 3, 4, 5]).fill('a', -2, 2) ).toEqual R([1, 2, 3, "a", "a"])
    expect( R([1, 2, 3, 4, 5]).fill('a', -2, 4) ).toEqual R([1, 2, 3, "a", "a", "a", "a"])

    expect( R([1, 2, 3, 4, 5]).fill(-2, 2, (i) -> 'a' )).toEqual R([1, 2, 3, "a", "a"])
    expect( R([1, 2, 3, 4, 5]).fill(-2, 4, (i) -> 'a' )).toEqual R([1, 2, 3, "a", "a", "a", "a"])

  it "starts at 0 if the negative index is before the start of the array", ->
    expect( R([1, 2, 3, 4, 5]).fill('a', -25, 3) ).toEqual R(['a', 'a', 'a', 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill('a', -10, 10) ).toEqual R(['a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a'])

    expect( R([1, 2, 3, 4, 5]).fill(-25, 3, (i) -> 'a' )).toEqual R(['a', 'a', 'a', 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill(-10, 10, (i) -> 'a' )).toEqual R(['a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a'])

  it "makes no modifications if the given length <= 0", ->
    expect( R([1, 2, 3, 4, 5]).fill('a',  2, 0) ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill('a', -2, 0) ).toEqual R([1, 2, 3, 4, 5])

  it 'ruby_bug "#", "1.8.6.277"', ->
    expect( R([1, 2, 3, 4, 5]).fill('a', 2, -2) ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill('a', -2, -2) ).toEqual R([1, 2, 3, 4, 5])

    expect( R([1, 2, 3, 4, 5]).fill(2, 0, @never_passed) ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill(-2, 0, @never_passed) ).toEqual R([1, 2, 3, 4, 5])

    expect( R([1, 2, 3, 4, 5]).fill(2, -2, @never_passed) ).toEqual R([1, 2, 3, 4, 5])
    expect( R([1, 2, 3, 4, 5]).fill(-2, -2, @never_passed) ).toEqual R([1, 2, 3, 4, 5])

#   ruby_bug "#", "1.8.6.277", ->
#     # See: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/17481
  it "does not raise an exception if the given length is negative and its absolute value does not exceed the index", ->
    expect( -> R([1, 2, 3, 4]).fill('a', 3, -1) ) #}.should_not raise_error(ArgumentError)
    expect( -> R([1, 2, 3, 4]).fill('a', 3, -2) ) #}.should_not raise_error(ArgumentError)
    expect( -> R([1, 2, 3, 4]).fill('a', 3, -3) ) #}.should_not raise_error(ArgumentError)

    expect( -> R([1, 2, 3, 4]).fill(3, -1, @never_passed) ) #}.should_not raise_error(ArgumentError)
    expect( -> R([1, 2, 3, 4]).fill(3, -2, @never_passed) ) #}.should_not raise_error(ArgumentError)
    expect( -> R([1, 2, 3, 4]).fill(3, -3, @never_passed) ) #}.should_not raise_error(ArgumentError)

  it "does not raise an exception even if the given length is negative and its absolute value exceeds the index", ->
    expect( -> [1, 2, 3, 4].fill('a', 3, -4) ) #}.should_not raise_error(ArgumentError)
    expect( -> [1, 2, 3, 4].fill('a', 3, -5) ) #}.should_not raise_error(ArgumentError)
    expect( -> [1, 2, 3, 4].fill('a', 3, -10000) ) #}.should_not raise_error(ArgumentError)

    expect( -> [1, 2, 3, 4].fill(3, -4, @never_passed) ) #}.should_not raise_error(ArgumentError)
    expect( -> [1, 2, 3, 4].fill(3, -5, @never_passed) ) #}.should_not raise_error(ArgumentError)
    expect( -> [1, 2, 3, 4].fill(3, -10000, @never_passed) ) #}.should_not raise_error(ArgumentError)

  it "tries to convert the second and third arguments to Integers using #to_int", ->
    obj =
      to_int: -> R(2)
    filler =
      to_int: -> throw 'ExpectationNotMetError'
    expect( R([1, 2, 3, 4, 5]).fill(filler, obj, obj)).toEqual R([1, 2, filler, filler, 5])

  it "raises a TypeError if the index is not numeric", ->
    expect( -> R([]).fill 'a', true ).toThrow('TypeError')

    obj = 'nonnumeric'
    expect( -> R([]).fill('a', obj) ).toThrow('TypeError')

#   not_compliant_on :rubinius do
#     platform_is :wordsize => 32 do
#       it "raises an ArgumentError or RangeError for too-large sizes", ->
#         arr = [1, 2, 3]
#         expect( -> arr.fill(10, 1, 2**31 - 1) ).toThrow(ArgumentError)
#         expect( -> arr.fill(10, 1, 2**31) ).toThrow(RangeError)

#     platform_is :wordsize => 64 do
#       it "raises an ArgumentError or RangeError for too-large sizes", ->
#         arr = [1, 2, 3]
#         expect( -> arr.fill(10, 1, 2**63 - 1) ).toThrow(ArgumentError)
#         expect( -> arr.fill(10, 1, 2**63) ).toThrow(RangeError)

#   deviates_on :rubinius do
#     it "raises an ArgumentError if the length is not a Fixnum", ->
#       expect( -> [1, 2].fill(10, 1, bignum_value()) ).toThrow(ArgumentError)

# describe "Array#fill with (filler, range)", ->
#   it "replaces elements in range with object", ->
#     [1, 2, 3, 4, 5, 6].fill(8, 0..3).should == [8, 8, 8, 8, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(8, 0...3).should == [8, 8, 8, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', 4..6).should == [1, 2, 3, 4, 'x', 'x', 'x']
#     [1, 2, 3, 4, 5, 6].fill('x', 4...6).should == [1, 2, 3, 4, 'x', 'x']
#     [1, 2, 3, 4, 5, 6].fill('x', -2..-1).should == [1, 2, 3, 4, 'x', 'x']
#     [1, 2, 3, 4, 5, 6].fill('x', -2...-1).should == [1, 2, 3, 4, 'x', 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -2...-2).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -2..-2).should == [1, 2, 3, 4, 'x', 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -2..0).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', 0...0).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', 1..1).should == [1, 'x', 3, 4, 5, 6]

#   it "replaces all elements in range with the value of block", ->
#     [1, 1, 1, 1, 1, 1].fill(1..6) { |i| i + 1 }.should == [1, 2, 3, 4, 5, 6, 7]

#   it "increases the Array size when necessary", ->
#     [1, 2, 3].fill('x', 1..6).should == [1, 'x', 'x', 'x', 'x', 'x', 'x']
#     [1, 2, 3].fill(1..6){|i| i+1}.should == [1, 2, 3, 4, 5, 6, 7]

#   it "raises a TypeError with range and length argument", ->
#     expect( -> [].fill('x', 0 .. 2, 5) ).toThrow(TypeError)

#   it "replaces elements between the (-m)th to the last and the (n+1)th from the first if given an range m..n where m < 0 and n >= 0", ->
#     [1, 2, 3, 4, 5, 6].fill('x', -4..4).should == [1, 2, 'x', 'x', 'x', 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -4...4).should == [1, 2, 'x', 'x', 5, 6]

#     [1, 2, 3, 4, 5, 6].fill(-4..4){|i| (i+1).to_s}.should == [1, 2, '3', '4', '5', 6]
#     [1, 2, 3, 4, 5, 6].fill(-4...4){|i| (i+1).to_s}.should == [1, 2, '3', '4', 5, 6]

#   it "replaces elements between the (-m)th and (-n)th to the last if given an range m..n where m < 0 and n < 0", ->
#     [1, 2, 3, 4, 5, 6].fill('x', -4..-2).should == [1, 2, 'x', 'x', 'x', 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -4...-2).should == [1, 2, 'x', 'x', 5, 6]

#     [1, 2, 3, 4, 5, 6].fill(-4..-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', '5', 6]
#     [1, 2, 3, 4, 5, 6].fill(-4...-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', 5, 6]

#   it "replaces elements between the (m+1)th from the first and (-n)th to the last if given an range m..n where m >= 0 and n < 0", ->
#     [1, 2, 3, 4, 5, 6].fill('x', 2..-2).should == [1, 2, 'x', 'x', 'x', 6]
#     [1, 2, 3, 4, 5, 6].fill('x', 2...-2).should == [1, 2, 'x', 'x', 5, 6]

#     [1, 2, 3, 4, 5, 6].fill(2..-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', '5', 6]
#     [1, 2, 3, 4, 5, 6].fill(2...-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', 5, 6]

#   it "makes no modifications if given an range which implies a section of zero width", ->
#     [1, 2, 3, 4, 5, 6].fill('x', 2...2).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -4...2).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -4...-4).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', 2...-4).should == [1, 2, 3, 4, 5, 6]

#     [1, 2, 3, 4, 5, 6].fill(2...2, &@never_passed).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(-4...2, &@never_passed).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(-4...-4, &@never_passed).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(2...-4, &@never_passed).should == [1, 2, 3, 4, 5, 6]

#   it "makes no modifications if given an range which implies a section of negative width", ->
#     [1, 2, 3, 4, 5, 6].fill('x', 2..1).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -4..1).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', -2..-4).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill('x', 2..-5).should == [1, 2, 3, 4, 5, 6]

#     [1, 2, 3, 4, 5, 6].fill(2..1, &@never_passed).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(-4..1, &@never_passed).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(-2..-4, &@never_passed).should == [1, 2, 3, 4, 5, 6]
#     [1, 2, 3, 4, 5, 6].fill(2..-5, &@never_passed).should == [1, 2, 3, 4, 5, 6]

#   it "raise an exception if some of the given range lies before the first of the array", ->
#     expect( -> [1, 2, 3].fill('x', -5..-3) ).toThrow(RangeError)
#     expect( -> [1, 2, 3].fill('x', -5...-3) ).toThrow(RangeError)
#     expect( -> [1, 2, 3].fill('x', -5..-4) ).toThrow(RangeError)

#     expect( -> [1, 2, 3].fill(-5..-3, &@never_passed) ).toThrow(RangeError)
#     expect( -> [1, 2, 3].fill(-5...-3, &@never_passed) ).toThrow(RangeError)
#     expect( -> [1, 2, 3].fill(-5..-4, &@never_passed) ).toThrow(RangeError)

#   it "tries to convert the start and end of the passed range to Integers using #to_int", ->
#     obj = mock('to_int')
#     def obj.<=>(rhs); rhs == self ? 0 : nil end
#     obj.should_receive(:to_int).twice.and_return(2)
#     filler = mock('filler')
#     filler.should_not_receive(:to_int)
#     [1, 2, 3, 4, 5].fill(filler, obj..obj).should == [1, 2, filler, 4, 5]

#   it "raises a TypeError if the start or end of the passed range is not numeric", ->
#     obj = mock('nonnumeric')
#     def obj.<=>(rhs); rhs == self ? 0 : nil end
#     expect( -> [].fill('a', obj..obj) ).toThrow(TypeError)
# end
