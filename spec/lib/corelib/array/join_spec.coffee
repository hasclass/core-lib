describe "Array#join", ->

  it "does not separate elements when the passed separator is nil", ->
    # expect( R([1, 2, 3]).join()     ).toEqual R('123')
    expect( R([1, 2, 3]).join(null) ).toEqual R('123')

  it "calls #to_str to convert the separator to a String", ->
    sep =
      to_str: -> R(', ')
    expect( R([1, 2]).join(sep) ).toEqual R("1, 2")


  xit "does not call #to_str on the separator if the array is empty", ->
    # UNSUPPORTED
    sep =
      to_str: -> throw 'should not be called'
    expect( R([]).join(sep) ).toEqual R("")

  it "raises a TypeError if the separator cannot be coerced to a String by calling #to_str", ->
    obj = {}
    expect( -> R([1, 2]).join(obj) ).toThrow('TypeError')

  it "raises a TypeError if passed false as the separator", ->
    expect( -> R([1, 2]).join(false) ).toThrow('TypeError')

  beforeEach ->
    @separator = R['$,']

  afterEach ->
    R['$,'] = @separator

  it "returns an empty string if the Array is empty", ->
    expect( R([]).join() ).toEqual R('')

#   ruby_version_is "1.9", ->
#     it "returns a US-ASCII string for an empty Array", ->
#       [].send(@method).encoding.should == Encoding::US_ASCII

  it "returns a string formed by concatenating each String element separated by $,", ->
    R['$,'] = " | "
    expect( R(["1", "2", "3"]).join() ).toEqual R("1 | 2 | 3")

#   ruby_version_is ""..."1.9", ->
#     it "coerces non-String elements via #to_s", ->
#       obj = mock('foo')
#       obj.should_receive(:to_s).and_return("foo")
#       [obj].send(@method).should == "foo"

#     it "raises a NoMethodError if an element does not respond to #to_s", ->
#       obj = mock('o')
#       class << obj; undef :to_s; end
#       expect( -> [obj].send(@method) ).toThrow(NoMethodError)

  describe 'ruby_version_is "1.9"', ->
    xit "attempts coercion via #to_str first", ->
      obj =
        to_str: -> R("foo")
      expect( R([obj]).join() ).toEqual R("foo")

    xit "attempts coercion via #to_ary second", ->
      obj =
        to_str: -> null
        to_ary: -> R(["foo"])

      expect( R([obj]).join() ).toEqual R("foo")

    xit "attempts coercion via #to_s third", ->
      obj =
        to_str: -> null
        to_ary: -> null
        to_s: -> R("foo")
      expect( R([obj]).join() ).toEqual R("foo")

    xit "raises a NoMethodError if an element does not respond to #to_str, #to_ary, or #to_s", ->
#       obj = mock('o')
#       class << obj; undef :to_s; end
#       expect( -> [1, obj].send(@method) ).toThrow(NoMethodError)

#   ruby_version_is "".."1.9", ->
#     ruby_bug "[ruby-dev:37019]", "1.8.6.319", ->
#       it "represents a recursive element with '[...]'", ->
#         ArraySpecs.recursive_array.send(@method).should == "1two3.0[...][...][...][...][...]"
#         ArraySpecs.head_recursive_array.send(@method).should == "[...][...][...][...][...]1two3.0"
#         ArraySpecs.empty_recursive_array.send(@method).should == "[...]"

#   ruby_version_is "1.9", ->
#     it "raises an ArgumentError when the Array is recursive", ->
#       expect( -> ArraySpecs.recursive_array.send(@method) ).toThrow(ArgumentError)
#       expect( -> ArraySpecs.head_recursive_array.send(@method) ).toThrow(ArgumentError)
#       expect( -> ArraySpecs.empty_recursive_array.send(@method) ).toThrow(ArgumentError)


#   it "taints the result if the Array is tainted and non-empty", ->
#     [1, 2].taint.send(@method).tainted?.should be_true

#   it "does not taint the result if the Array is tainted but empty", ->
#     [].taint.send(@method).tainted?.should be_false

#   it "taints the result if the result of coercing an element is tainted", ->
#     s = mock("taint")
#     s.should_receive(:to_s).and_return("str".taint)
#     [s].send(@method).tainted?.should be_true

#   ruby_version_is "1.9", ->
#     it "untrusts the result if the Array is untrusted and non-empty", ->
#       [1, 2].untrust.send(@method).untrusted?.should be_true

#     it "does not untrust the result if the Array is untrusted but empty", ->
#       [].untrust.send(@method).untrusted?.should be_false

#     it "untrusts the result if the result of coercing an element is untrusted", ->
#       s = mock("untrust")
#       s.should_receive(:to_s).and_return("str".untrust)
#       [s].send(@method).untrusted?.should be_true

#   ruby_version_is "1.9", ->
#     it "uses the first encoding when other strings are compatible", ->
#       ary1 = ArraySpecs.array_with_7bit_utf8_and_usascii_strings
#       ary2 = ArraySpecs.array_with_usascii_and_7bit_utf8_strings
#       ary3 = ArraySpecs.array_with_utf8_and_7bit_ascii8bit_strings
#       ary4 = ArraySpecs.array_with_usascii_and_7bit_ascii8bit_strings

#       ary1.send(@method).encoding.should == Encoding::UTF_8
#       ary2.send(@method).encoding.should == Encoding::US_ASCII
#       ary3.send(@method).encoding.should == Encoding::UTF_8
#       ary4.send(@method).encoding.should == Encoding::US_ASCII

#     it "uses the widest common encoding when other strings are incompatible", ->
#       ary1 = ArraySpecs.array_with_utf8_and_usascii_strings
#       ary2 = ArraySpecs.array_with_usascii_and_utf8_strings

#       ary1.send(@method).encoding.should == Encoding::UTF_8
#       ary2.send(@method).encoding.should == Encoding::UTF_8

#     it "fails for arrays with incompatibly-encoded strings", ->
#       ary_utf8_bad_ascii8bit = ArraySpecs.array_with_utf8_and_ascii8bit_strings

#       expect( -> ary_utf8_bad_ascii8bit.send(@method) ).toThrow(EncodingError)

# describe :array_join_with_string_separator, :shared => true do
#   ruby_version_is ""..."1.9", ->
#     it "returns a string formed by concatenating each element.to_s separated by separator", ->
#       obj = mock('foo')
#       obj.should_receive(:to_s).and_return("foo")
#       [1, 2, 3, 4, obj].send(@method, ' | ').should == '1 | 2 | 3 | 4 | foo'

#   ruby_version_is "1.9", ->
    xit "returns a string formed by concatenating each element.to_str separated by separator", ->
      obj =
        to_str: -> R("foo")
      expect( R([1, 2, 3, 4, obj]).join(' | ')).toEqual R('1 | 2 | 3 | 4 | foo')

  xit "uses the same separator with nested arrays", ->
    # [1, [2, [3, 4], 5], 6].send(@method, ":").should == "1:2:3:4:5:6"
    # [1, [2, ArraySpecs.MyArray[3, 4], 5], 6].send(@method, ":").should == "1:2:3:4:5:6"

#   describe "with a tainted separator", ->
#     before :each do
#       @sep = ":".taint

#     it "does not taint the result if the array is empty", ->
#       [].send(@method, @sep).tainted?.should be_false

#     ruby_bug "5902", "2.0", ->
#       it "does not taint the result if the array has only one element", ->
#         [1].send(@method, @sep).tainted?.should be_false

#     it "taints the result if the array has two or more elements", ->
#       [1, 2].send(@method, @sep).tainted?.should be_true

#   ruby_version_is "1.9", ->
#     describe "with an untrusted separator", ->
#       before :each do
#         @sep = ":".untrust

#       it "does not untrust the result if the array is empty", ->
#         [].send(@method, @sep).untrusted?.should be_false

#       ruby_bug "5902", "2.0", ->
#         it "does not untrust the result if the array has only one element", ->
#           [1].send(@method, @sep).untrusted?.should be_false

#       it "untrusts the result if the array has two or more elements", ->
#         [1, 2].send(@method, @sep).untrusted?.should be_true
#