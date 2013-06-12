describe "String#slice with index", ->
  it "returns the character code of the character at the given index", ->
    expect( R("hello").slice(0) ).toEqual  R('h')
    expect( R("hello").slice(-1) ).toEqual R('o')

  it "returns nil if index is outside of self", ->
    expect( R("hello").slice(20) ).toEqual null
    expect( R("hello").slice(-20) ).toEqual null

    expect( R("").slice(0) ).toEqual null
    expect( R("").slice(-1) ).toEqual null

  it "calls valueOf on the given index", ->
    expect( R("hello").slice(0.5) ).toEqual R('h')

    obj = {valueOf: -> 1}
    expect( R("hello").slice(obj) ).toEqual R("e")

  it "raises a TypeError if the given index is nil", ->
    expect( -> R("hello").slice(null)        ).toThrow('TypeError')

  it "raises a TypeError if the given index can't be converted to an Integer", ->
    # expect( -> R("hello").slice(mock('x')) ).toThrow('TypeError')
    expect( -> R("hello").slice({})        ).toThrow('TypeError')
    expect( -> R("hello").slice([])        ).toThrow('TypeError')


describe "String#slice with index and length", ->
  it "returns the substring starting at the given index with the given length", ->
    expect( R("hello there").slice(0,0) ).toEqual R("")
    expect( R("hello there").slice(0,1) ).toEqual R("h")
    expect( R("hello there").slice(0,3) ).toEqual R("hel")
    expect( R("hello there").slice(0,6) ).toEqual R("hello ")
    expect( R("hello there").slice(0,9) ).toEqual R("hello the")
    expect( R("hello there").slice(0,12)).toEqual R("hello there")

    expect( R("hello there").slice(1,0) ).toEqual R("")
    expect( R("hello there").slice(1,1) ).toEqual R("e")
    expect( R("hello there").slice(1,3) ).toEqual R("ell")
    expect( R("hello there").slice(1,6) ).toEqual R("ello t")
    expect( R("hello there").slice(1,9) ).toEqual R("ello ther")
    expect( R("hello there").slice(1,12)).toEqual R("ello there")

    expect( R("hello there").slice(3,0) ).toEqual R("")
    expect( R("hello there").slice(3,1) ).toEqual R("l")
    expect( R("hello there").slice(3,3) ).toEqual R("lo ")
    expect( R("hello there").slice(3,6) ).toEqual R("lo the")
    expect( R("hello there").slice(3,9) ).toEqual R("lo there")

    expect( R("hello there").slice(4,0) ).toEqual R("")
    expect( R("hello there").slice(4,3) ).toEqual R("o t")
    expect( R("hello there").slice(4,6) ).toEqual R("o ther")
    expect( R("hello there").slice(4,9) ).toEqual R("o there")

    expect( R("foo").slice(2,1) ).toEqual R("o")
    expect( R("foo").slice(3,0) ).toEqual R("")
    expect( R("foo").slice(3,1) ).toEqual R("")

    expect( R("").slice(0,0) ).toEqual R("")
    expect( R("").slice(0,1) ).toEqual R("")

    expect( R("x").slice(0,0) ).toEqual R("")
    expect( R("x").slice(0,1) ).toEqual R("x")
    expect( R("x").slice(1,0) ).toEqual R("")
    expect( R("x").slice(1,1) ).toEqual R("")

    expect( R("x").slice(-1,0) ).toEqual R("")
    expect( R("x").slice(-1,1) ).toEqual R("x")

    expect( R("hello there").slice(-3,2) ).toEqual R("er")

  xit "always taints resulting strings when self is tainted", ->
    # str = "hello world"
    # str.taint

    # expect( R(str.slice(0,0).tainted? ).toEqual true
    # expect( R(str.slice(0,1).tainted? ).toEqual true
    # expect( R(str.slice(2,1).tainted? ).toEqual true

  it "returns nil if the offset falls outside of self", ->
    expect( R("hello there").slice(20,3) ).toEqual null
    expect( R("hello there").slice(-20,3) ).toEqual null

    expect( R("").slice(1,0) ).toEqual null
    expect( R("").slice(1,1) ).toEqual null

    expect( R("").slice(-1,0) ).toEqual null
    expect( R("").slice(-1,1) ).toEqual null

    expect( R("x").slice(2,0) ).toEqual null
    expect( R("x").slice(2,1) ).toEqual null

    expect( R("x").slice(-2,0) ).toEqual null
    expect( R("x").slice(-2,1) ).toEqual null

  it "returns nil if the length is negative", ->
    expect( R("hello there").slice(4,-3) ).toEqual null
    expect( R("hello there").slice(-4,-3) ).toEqual null

  it "calls valueOf on the given index and the given length", ->
    expect( R("hello").slice(0.5, 1) ).toEqual R("h")
    expect( R("hello").slice(0.5, 2.5) ).toEqual R("he")
    expect( R("hello").slice(1, 2.5) ).toEqual R("el")

    obj =
      valueOf: -> 2

    expect( R("hello").slice(obj, 1) ).toEqual R("l")
    expect( R("hello").slice(obj, obj) ).toEqual R("ll")
    expect( R("hello").slice(0, obj) ).toEqual R("he")

  it "raises a TypeError when idx or length can't be converted to an integer", ->
    obj = {}
    expect( -> R("hello").slice(obj, 0) ).toThrow('TypeError')
    expect( -> R("hello").slice(0, obj) ).toThrow('TypeError')

    # I'm deliberately including this here.
    # It means that str.slice(other, idx) isn't supported.
    expect( -> R("hello").slice("", 0) ).toThrow('TypeError')

  it "raises a TypeError when the given index or the given length is nil", ->
    expect( -> R("hello").slice(1, null)   ).toThrow('TypeError')
    expect( -> R("hello").slice(null, 1)   ).toThrow('TypeError')
    expect( -> R("hello").slice(null, null) ).toThrow('TypeError')

  xit "returns subclass instances", ->
    # s = StringSpecs::MyString.new("hello")
    # s.slice(0,0).should be_kind_of(StringSpecs::MyString)
    # s.slice(0,4).should be_kind_of(StringSpecs::MyString)
    # s.slice(1,4).should be_kind_of(StringSpecs::MyString)



# TODO Implement
describe "String#slice with range", ->
  it "returns the substring given by the offsets of the range", ->
    expect( R("hello there").slice(R.Range.new 1, 1)        ).toEqual R("e")
    expect( R("hello there").slice(R.Range.new 1, 3)        ).toEqual R("ell")
    expect( R("hello there").slice(R.Range.new 1, 3, true)  ).toEqual R("el")
    expect( R("hello there").slice(R.Range.new -4, -2)      ).toEqual R("her")
    expect( R("hello there").slice(R.Range.new -4, -2, true)).toEqual R("he")
    expect( R("hello there").slice(R.Range.new 5,-1)        ).toEqual R(" there")
    expect( R("hello there").slice(R.Range.new 5, -1, true) ).toEqual R(" ther")

    expect( R("").slice(R.Range.new 0,0) ).toEqual R("")

    expect( R("x").slice(R.Range.new 0,0)        ).toEqual R("x")
    expect( R("x").slice(R.Range.new 0,1)        ).toEqual R("x")
    expect( R("x").slice(R.Range.new 0, 1, true) ).toEqual R("x")
    expect( R("x").slice(R.Range.new 0,-1)       ).toEqual R("x")

    expect( R("x").slice(R.Range.new 1,1)        ).toEqual R("")
    expect( R("x").slice(R.Range.new 1,-1)       ).toEqual R("")

  it "returns nil if the beginning of the range falls outside of self", ->
    expect( R("hello there").slice(R.Range.new 12,-1)  ).toEqual null
    expect( R("hello there").slice(R.Range.new 20,25)  ).toEqual null
    expect( R("hello there").slice(R.Range.new 20,1)   ).toEqual null
    expect( R("hello there").slice(R.Range.new -20,1)  ).toEqual null
    expect( R("hello there").slice(R.Range.new -20,-1) ).toEqual null

    expect( R("").slice(R.Range.new -1,-1)        ).toEqual null
    expect( R("").slice(R.Range.new -1, -1, true) ).toEqual null
    expect( R("").slice(R.Range.new -1,0)         ).toEqual null
    expect( R("").slice(R.Range.new -1, 0, true)  ).toEqual null

  it "returns an empty string if range.begin is inside self and > real end", ->
    expect( R("hello there").slice(R.Range.new 1, 1, true)  ).toEqual R("")
    expect( R("hello there").slice(R.Range.new 4,2)   ).toEqual R("")
    expect( R("hello"      ).slice(R.Range.new 4,-4)  ).toEqual R("")
    expect( R("hello there").slice(R.Range.new -5,-6) ).toEqual R("")
    expect( R("hello there").slice(R.Range.new -2,-4) ).toEqual R("")
    expect( R("hello there").slice(R.Range.new -5,-6) ).toEqual R("")
    expect( R("hello there").slice(R.Range.new -5,2)  ).toEqual R("")

    expect( R("").slice(R.Range.new 0, 0, true)   ).toEqual R("")
    expect( R("").slice(R.Range.new 0,-1)   ).toEqual R("")
    expect( R("").slice(R.Range.new 0, -1, true)  ).toEqual R("")

    expect( R("x").slice(R.Range.new 0, 0, true)  ).toEqual R("")
    expect( R("x").slice(R.Range.new 0, -1, true) ).toEqual R("")
    expect( R("x").slice(R.Range.new 1, 1, true)  ).toEqual R("")
    expect( R("x").slice(R.Range.new 1, -1, true) ).toEqual R("")

  xit "always taints resulting strings when self is tainted", ->
    # str = "hello world"
    # str.taint

    # str.slice(0,0).tainted? ).toEqual true
    # str.slice(0, 0, true).tainted? ).toEqual true
    # str.slice(0..1).tainted? ).toEqual true
    # str.slice(0, 1, true).tainted? ).toEqual true
    # str.slice(2..3).tainted? ).toEqual true
    # str.slice(2..0).tainted? ).toEqual true

  xit "returns subclass instances", ->
    # s = StringSpecs::MyString.new("hello")
    # s.slice(0...0).should be_kind_of(StringSpecs::MyString)
    # s.slice(0..4).should be_kind_of(StringSpecs::MyString)
    # s.slice(1..4).should be_kind_of(StringSpecs::MyString)

  it "calls valueOf on range arguments", ->
    from = {
      cmp: -> 0,
      valueOf: -> 1
    }
    to =   {
      cmp: -> 1,
      valueOf: -> -2
    }

    # # So we can construct a range out of them...
    # from.should_receive(:<=>).twice.and_return(0)
    # from.should_receive(:valueOf).twice.and_return(1)
    # to.should_receive(:valueOf).twice.and_return(-2)

    expect( R("hello there").slice(R.Range.new from, to) ).toEqual R("ello ther")
    expect( R("hello there").slice(R.Range.new from, to, true) ).toEqual R("ello the")

  xit "works with Range subclasses", ->
    # a = "GOOD"
    # range_incl = StringSpecs::MyRange.new(1, 2)
    # range_excl = StringSpecs::MyRange.new(-3, -1, true)

    # a.slice(range_incl) ).toEqual "OO"
    # a.slice(range_excl) ).toEqual "OO"

# describe :string_slice_regexp_index, :shared => true do
#   it "returns the capture for the given index", ->
#     "hello there".slice(/[aeiou](.)\1/, 0).should == "ell"
#     "hello there".slice(/[aeiou](.)\1/, 1).should == "l"
#     "hello there".slice(/[aeiou](.)\1/, -1).should == "l"

#     "har".slice(/(.)(.)(.)/, 0).should == "har"
#     "har".slice(/(.)(.)(.)/, 1).should == "h"
#     "har".slice(/(.)(.)(.)/, 2).should == "a"
#     "har".slice(/(.)(.)(.)/, 3).should == "r"
#     "har".slice(/(.)(.)(.)/, -1).should == "r"
#     "har".slice(/(.)(.)(.)/, -2).should == "a"
#     "har".slice(/(.)(.)(.)/, -3).should == "h"

#   it "always taints resulting strings when self or regexp is tainted", ->
#     strs = ["hello world"]
#     strs += strs.map { |s| s.dup.taint }

#     strs.each do |str|
#       str.slice(//, 0).tainted?.should == str.tainted?
#       str.slice(/hello/, 0).tainted?.should == str.tainted?

#       str.slice(/(.)(.)(.)/, 0).tainted?.should == str.tainted?
#       str.slice(/(.)(.)(.)/, 1).tainted?.should == str.tainted?
#       str.slice(/(.)(.)(.)/, -1).tainted?.should == str.tainted?
#       str.slice(/(.)(.)(.)/, -2).tainted?.should == str.tainted?

#       tainted_re = /(.)(.)(.)/
#       tainted_re.taint

#       str.slice(tainted_re, 0).tainted?.should == true
#       str.slice(tainted_re, 1).tainted?.should == true
#       str.slice(tainted_re, -1).tainted?.should == true

#   it "returns nil if there is no match", ->
#     "hello there".slice(/(what?)/, 1).should == nil

#   it "returns nil if there is no capture for the given index", ->
#     "hello there".slice(/[aeiou](.)\1/, 2).should == nil
#     # You can't refer to 0 using negative indices
#     "hello there".slice(/[aeiou](.)\1/, -2).should == nil

#   it "calls valueOf on the given index", ->
#     obj = mock('2')
#     obj.should_receive(:valueOf).and_return(2)

#     "har".slice(/(.)(.)(.)/, 1.5).should == "h"
#     "har".slice(/(.)(.)(.)/, obj).should == "a"

#   it "raises a TypeError when the given index can't be converted to Integer", ->
#     lambda { "hello".slice(/(.)(.)(.)/, mock('x')) }.should raise_error(TypeError)
#     lambda { "hello".slice(/(.)(.)(.)/, {})        }.should raise_error(TypeError)
#     lambda { "hello".slice(/(.)(.)(.)/, [])        }.should raise_error(TypeError)

#   it "raises a TypeError when the given index is nil", ->
#     lambda { "hello".slice(/(.)(.)(.)/, nil) }.should raise_error(TypeError)

#   it "returns subclass instances", ->
#     s = StringSpecs::MyString.new("hello")
#     s.slice(/(.)(.)/, 0).should be_kind_of(StringSpecs::MyString)
#     s.slice(/(.)(.)/, 1).should be_kind_of(StringSpecs::MyString)

#   it "sets $~ to MatchData when there is a match and nil when there's none", ->
#     'hello'.slice(/.(.)/, 0)
#     $~[0].should == 'he'

#     'hello'.slice(/.(.)/, 1)
#     $~[1].should == 'e'

#     'hello'.slice(/not/, 0)
#     $~.should == nil
# end

describe "string_slice_string", ->
  it "returns other_str if it occurs in self", ->
    s = "lo"
    expect( R("hello there").slice(s) ).toEqual R(s)
    expect( R("hello there").slice(R(s)) ).toEqual R(s)

  # it "taints resulting strings when other is tainted", ->
  #   strs = ["", "hello world", "hello"]
  #   strs += strs.map { |s| s.dup.taint }

  #   strs.each do |str|
  #     strs.each do |other|
  #       r = str.slice(other)

  #       expect( r.tainted? ).toEqual !r.nil? & other.tainted?

  it "doesn't set $~", ->
    R['$~'] = null

    R('hello').slice('ll')
    expect( R['$~'] ).toEqual null

  it "returns nil if there is no match", ->
    expect( R("hello there").slice("bye") ).toEqual null

  it "doesn't call to_str on its argument", ->
    o = {to_str: -> throw 'should_not_receive'}

    expect( -> R("hello").slice(o) ).toThrow('TypeError')

  # TODO: subclass
  xit "returns a subclass instance when given a subclass instance", ->
    s = StringSpecs.MyString.new("el")
    r = R("hello").slice(s)
    expect( r.to_native() ).toEqual "el"
    expect( r ).toBeInstanceOf(StringSpecs.MyString)

# language_version __FILE__, "slice"




# describe "String#slice! with index" do
#   it "deletes and return the char at the given position" do
#     a = "hello"
#     a.slice!(1) ).toEqual ?e
#     a ).toEqual R("hllo")
#     a.slice!(-1) ).toEqual ?o
#     a.should == "hll"
#   end

#   it "returns nil if idx is outside of self" do
#     a = "hello"
#     a.slice!(20).should == nil
#     a.should == "hello"
#     a.slice!(-20).should == nil
#     a.should == "hello"
#   end

#   ruby_version_is ""..."1.9" do
#     it "raises a TypeError if self is frozen" do
#       lambda { "hello".freeze.slice!(1) }.should raise_error(TypeError)
#     end
#   end

#   ruby_version_is "1.9" do
#     it "raises a RuntimeError if self is frozen" do
#       lambda { "hello".freeze.slice!(1)  }.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(10) }.should raise_error(RuntimeError)
#       lambda { "".freeze.slice!(0)       }.should raise_error(RuntimeError)
#     end
#   end

#   ruby_version_is ""..."1.9" do
#     it "doesn't raise a TypeError if self is frozen and idx is outside of self" do
#       "hello".freeze.slice!(10).should be_nil
#       "".freeze.slice!(0).should be_nil
#     end
#   end

#   it "calls valueOf on index" do
#     "hello").slice!(0.5).should == ?h

#     obj = mock('1')
#     # MRI calls this twice so we can't use should_receive here.
#     def obj.valueOf() 1 end
#     "hello".slice!(obj).should == ?e

#     obj = mock('1')
#     def obj.respond_to?(name, *) name == :valueOf ? true : super; end
#     def obj.method_missing(name, *) name == :valueOf ? 1 : super; end
#     "hello".slice!(obj).should == ?e
#   end
# end

# describe "String#slice! with index, length" do
#   it "deletes and returns the substring at idx and the given length" do
#     a = "hello"
#     a.slice!(1, 2).should == "el"
#     a.should == "hlo"

#     a.slice!(1, 0).should == ""
#     a.should == "hlo"

#     a.slice!(-2, 4).should == "lo"
#     a.should == "h"
#   end

#   it "always taints resulting strings when self is tainted" do
#     str = "hello world"
#     str.taint

#     str.slice!(0, 0).tainted?.should == true
#     str.slice!(2, 1).tainted?.should == true
#   end

#   it "returns nil if the given position is out of self" do
#     a = "hello"
#     a.slice(10, 3).should == nil
#     a.should == "hello"

#     a.slice(-10, 20).should == nil
#     a.should == "hello"
#   end

#   it "returns nil if the length is negative" do
#     a = "hello"
#     a.slice(4, -3).should == nil
#     a.should == "hello"
#   end

#   ruby_version_is "1.9" do
#     it "raises a RuntimeError if self is frozen" do
#       lambda { "hello".freeze.slice!(1, 2)  }.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(10, 3) }.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(-10, 3)}.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(4, -3) }.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(10, 3) }.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(-10, 3)}.should raise_error(RuntimeError)
#       lambda { "hello".freeze.slice!(4, -3) }.should raise_error(RuntimeError)
#     end
#   end

#   it "calls valueOf on idx and length" do
#     "hello".slice!(0.5, 2.5).should == "he"

#     obj = mock('2')
#     def obj.valueOf() 2 end
#     "hello".slice!(obj, obj).should == "ll"

#     obj = mock('2')
#     def obj.respond_to?(name, *) name == :valueOf; end
#     def obj.method_missing(name, *) name == :valueOf ? 2 : super; end
#     "hello".slice!(obj, obj).should == "ll"
#   end

#   it "returns subclass instances" do
#     s = StringSpecs::MyString.new("hello")
#     s.slice!(0, 0).should be_kind_of(StringSpecs::MyString)
#     s.slice!(0, 4).should be_kind_of(StringSpecs::MyString)
#   end
# end

# describe "String#slice! Range" do
#   it "deletes and return the substring given by the offsets of the range" do
#     a = "hello"
#     a.slice!(1..3).should == "ell"
#     a.should == "ho"
#     a.slice!(0..0).should == "h"
#     a.should == "o"
#     a.slice!(0...0).should == ""
#     a.should == "o"

#     # Edge Case?
#     "hello".slice!(-3..-9).should == ""
#   end

#   it "returns nil if the given range is out of self" do
#     a = "hello"
#     a.slice!(-6..-9).should == nil
#     a.should == "hello"

#     b = "hello"
#     b.slice!(10..20).should == nil
#     b.should == "hello"
#   end

#   it "always taints resulting strings when self is tainted" do
#     str = "hello world"
#     str.taint

#     str.slice!(0..0).tainted?.should == true
#     str.slice!(2..3).tainted?.should == true
#   end

#   it "returns subclass instances" do
#     s = StringSpecs::MyString.new("hello")
#     s.slice!(0...0).should be_kind_of(StringSpecs::MyString)
#     s.slice!(0..4).should be_kind_of(StringSpecs::MyString)
#   end

#   it "calls to_int on range arguments" do
#     from = mock('from')
#     to = mock('to')

#     # So we can construct a range out of them...
#     def from.<=>(o) 0 end
#     def to.<=>(o) 0 end

#     def from.to_int() 1 end
#     def to.to_int() -2 end

#     "hello there".slice!(from..to).should == "ello ther"

#     from = mock('from')
#     to = mock('to')

#     def from.<=>(o) 0 end
#     def to.<=>(o) 0 end

#     def from.respond_to?(name, *) name == :to_int; end
#     def from.method_missing(name) name == :to_int ? 1 : super; end
#     def to.respond_to?(name, *) name == :to_int; end
#     def to.method_missing(name) name == :to_int ? -2 : super; end

#     "hello there".slice!(from..to).should == "ello ther"
#   end

#   it "works with Range subclasses" do
#     a = "GOOD"
#     range_incl = StringSpecs::MyRange.new(1, 2)

#     a.slice!(range_incl).should == "OO"
#   end

#   ruby_version_is ""..."1.9" do
#     it "raises a TypeError on a frozen instance that would be modifed" do
#       lambda { "hello".freeze.slice!(1..3) }.should raise_error(TypeError)
#     end

#     it "does not raise an exception on a frozen instance that would not be modified" do
#       "hello".freeze.slice!(10..20).should be_nil
#     end
#   end

#   ruby_version_is "1.9" do
#     it "raises a RuntimeError on a frozen instance that is modified" do
#       lambda { "hello".freeze.slice!(1..3)  }.should raise_error(RuntimeError)
#     end

#     # see redmine #1551
#     it "raises a RuntimeError on a frozen instance that would not be modified" do
#       lambda { "hello".freeze.slice!(10..20)}.should raise_error(RuntimeError)
#     end
#   end
# end

# describe "String#slice! with Regexp" do
#   it "deletes and returns the first match from self" do
#     s = "this is a string"
#     s.slice!(/s.*t/).should == 's is a st'
#     s.should == 'thiring'

#     c = "hello hello"
#     c.slice!(/llo/).should == "llo"
#     c.should == "he hello"
#   end

#   it "returns nil if there was no match" do
#     s = "this is a string"
#     s.slice!(/zzz/).should == nil
#     s.should == "this is a string"
#   end

#   it "always taints resulting strings when self or regexp is tainted" do
#     strs = ["hello world"]
#     strs += strs.map { |s| s.dup.taint }

#     strs.each do |str|
#       str = str.dup
#       str.slice!(//).tainted?.should == str.tainted?
#       str.slice!(/hello/).tainted?.should == str.tainted?

#       tainted_re = /./
#       tainted_re.taint

#       str.slice!(tainted_re).tainted?.should == true
#     end
#   end

#   it "doesn't taint self when regexp is tainted" do
#     s = "hello"
#     s.slice!(/./.taint)
#     s.tainted?.should == false
#   end

#   it "returns subclass instances" do
#     s = StringSpecs::MyString.new("hello")
#     s.slice!(//).should be_kind_of(StringSpecs::MyString)
#     s.slice!(/../).should be_kind_of(StringSpecs::MyString)
#   end

#   it "sets $~ to MatchData when there is a match and nil when there's none" do
#     'hello'.slice!(/./)
#     $~[0].should == 'h'

#     'hello'.slice!(/not/)
#     $~.should == nil
#   end

#   ruby_version_is ""..."1.9" do
#     it "raises a TypeError on a frozen instance that is modified" do
#       lambda { "this is a string".freeze.slice!(/s.*t/) }.should raise_error(TypeError)
#     end

#     it "does not raise an exception on a frozen instance that would not be modified" do
#       "this is a string".freeze.slice!(/zzz/).should be_nil
#     end
#   end

#   ruby_version_is "1.9" do
#     it "raises a RuntimeError on a frozen instance that is modified" do
#       lambda { "this is a string".freeze.slice!(/s.*t/) }.should raise_error(RuntimeError)
#     end

#     it "raises a RuntimeError on a frozen instance that would not be modified" do
#       lambda { "this is a string".freeze.slice!(/zzz/)  }.should raise_error(RuntimeError)
#     end
#   end
# end

# describe "String#slice! with Regexp, index" do
#   it "deletes and returns the capture for idx from self" do
#     str = "hello there"
#     str.slice!(/[aeiou](.)\1/, 0).should == "ell"
#     str.should == "ho there"
#     str.slice!(/(t)h/, 1).should == "t"
#     str.should == "ho here"
#   end

#   it "always taints resulting strings when self or regexp is tainted" do
#     strs = ["hello world"]
#     strs += strs.map { |s| s.dup.taint }

#     strs.each do |str|
#       str = str.dup
#       str.slice!(//, 0).tainted?.should == str.tainted?
#       str.slice!(/hello/, 0).tainted?.should == str.tainted?

#       tainted_re = /(.)(.)(.)/
#       tainted_re.taint

#       str.slice!(tainted_re, 1).tainted?.should == true
#     end
#   end

#   it "doesn't taint self when regexp is tainted" do
#     s = "hello"
#     s.slice!(/(.)(.)/.taint, 1)
#     s.tainted?.should == false
#   end

#   it "returns nil if there was no match" do
#     s = "this is a string"
#     s.slice!(/x(zzz)/, 1).should == nil
#     s.should == "this is a string"
#   end

#   it "returns nil if there is no capture for idx" do
#     "hello there".slice!(/[aeiou](.)\1/, 2).should == nil
#     # You can't refer to 0 using negative indices
#     "hello there".slice!(/[aeiou](.)\1/, -2).should == nil
#   end

#   it "calls to_int on idx" do
#     obj = mock('2')
#     def obj.to_int() 2 end

#     "har".slice!(/(.)(.)(.)/, 1.5).should == "h"
#     "har".slice!(/(.)(.)(.)/, obj).should == "a"

#     obj = mock('2')
#     def obj.respond_to?(name, *) name == :to_int; end
#     def obj.method_missing(name) name == :to_int ? 2: super; end
#     "har".slice!(/(.)(.)(.)/, obj).should == "a"
#   end

#   it "returns subclass instances" do
#     s = StringSpecs::MyString.new("hello")
#     s.slice!(/(.)(.)/, 0).should be_kind_of(StringSpecs::MyString)
#     s.slice!(/(.)(.)/, 1).should be_kind_of(StringSpecs::MyString)
#   end

#   it "sets $~ to MatchData when there is a match and nil when there's none" do
#     'hello'[/.(.)/, 0]
#     $~[0].should == 'he'

#     'hello'[/.(.)/, 1]
#     $~[1].should == 'e'

#     'hello'[/not/, 0]
#     $~.should == nil
#   end

#   ruby_version_is ""..."1.9" do
#     it "raises a TypeError if self is frozen" do
#       lambda { "this is a string".freeze.slice!(/s.*t/) }.should raise_error(TypeError)
#     end

#     it "doesn't raise a TypeError if self is frozen but there is no match" do
#       "this is a string".freeze.slice!(/zzz/, 0).should == nil
#     end

#     it "doesn't raise a TypeError if self is frozen but there is no capture for idx" do
#       "this is a string".freeze.slice!(/(.)/, 2).should == nil
#     end
#   end

#   ruby_version_is "1.9" do
#     it "raises a RuntimeError if self is frozen" do
#       lambda { "this is a string".freeze.slice!(/s.*t/)  }.should raise_error(RuntimeError)
#       lambda { "this is a string".freeze.slice!(/zzz/, 0)}.should raise_error(RuntimeError)
#       lambda { "this is a string".freeze.slice!(/(.)/, 2)}.should raise_error(RuntimeError)
#     end
#   end
# end

# describe "String#slice! with String" do
#   it "removes and returns the first occurrence of other_str from self" do
#     c = "hello hello"
#     c.slice!('llo').should == "llo"
#     c.should == "he hello"
#   end

#   it "taints resulting strings when other is tainted" do
#     strs = ["", "hello world", "hello"]
#     strs += strs.map { |s| s.dup.taint }

#     strs.each do |str|
#       str = str.dup
#       strs.each do |other|
#         other = other.dup
#         r = str.slice!(other)

#         r.tainted?.should == !r.nil? & other.tainted?
#       end
#     end
#   end

#   it "doesn't set $~" do
#     $~ = nil

#     'hello'.slice!('ll')
#     $~.should == nil
#   end

#   it "returns nil if self does not contain other" do
#     a = "hello"
#     a.slice!('zzz').should == nil
#     a.should == "hello"
#   end

#   it "doesn't call to_str on its argument" do
#     o = mock('x')
#     o.should_not_receive(:to_str)

#     lambda { "hello".slice!(o) }.should raise_error(TypeError)
#   end

#   it "returns a subclass instance when given a subclass instance" do
#     s = StringSpecs::MyString.new("el")
#     r = "hello".slice!(s)
#     r.should == "el"
#     r.should be_kind_of(StringSpecs::MyString)
#   end

#   ruby_version_is ""..."1.9" do
#     it "raises a TypeError if self is frozen" do
#       lambda { "hello hello".freeze.slice!('llo') }.should raise_error(TypeError)
#     end
#   end

#   ruby_version_is "1.9" do
#     it "raises a RuntimeError if self is frozen" do
#       lambda { "hello hello".freeze.slice!('llo')     }.should raise_error(RuntimeError)
#       lambda { "this is a string".freeze.slice!('zzz')}.should raise_error(RuntimeError)
#       lambda { "this is a string".freeze.slice!('zzz')}.should raise_error(RuntimeError)
#     end
#   end
# end
