describe "String#strip", ->
  it "returns a copy of self with leading whitespace removed", ->
   expect( R("  hello  ").strip() ).toEqual R("hello")
   expect( R("  hello world  ").strip() ).toEqual R("hello world")
   expect( R("\n\r\t\n\v\r hello world  ").strip() ).toEqual R("hello world")
   expect( R("hello").strip() ).toEqual R("hello")
   # expect( R("\000 \000hello\000 \000").strip() ).toEqual R("\000 \000hello\000 \000")

  # spec/core/string/strip_spec.rb
  # not_compliant_on :rubinius do
  #   it "does not strip leading \0", ->
  #    "\x00hello".strip.should == "\x00hello"

  xit "taints the result when self is tainted", ->
    # "".taint.strip.tainted?.should == true
    # "ok".taint.strip.tainted?.should == true
    # "   ok".taint.strip.tainted?.should == true

describe "String#strip!", ->
  it "modifies self in place and returns self", ->
    a = R "  hello  "
    expect( a.strip_bang() is a).toEqual true
    expect( a ).toEqual R("hello")

    # a = R "\000 \000hello\000 \000"
    # a.strip_bang()
    # expect( a ).toEqual R("\000 \000hello\000 \000")

  it "returns nil if no modifications were made", ->
    a = R "hello"
    expect( a.strip_bang() ).toEqual null
    expect( a ).toEqual R("hello")

  it "returns nil if no modifications were made", ->
    a = R "  hello"
    expect( a.strip_bang() ).toNotEqual null

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError on a frozen instance that is modified", ->
  #     lambda { "  hello  ".freeze.strip! }.should raise_error(TypeError)

  #   it "does not raise an exception on a frozen instance that would not be modified", ->
  #     "hello".freeze.strip!.should be_nil
  #     "".freeze.strip!.should be_nil

# ruby_version_is "1.9", ->
  xit "raises a RuntimeError on a frozen instance that is modified", ->
    # lambda { "  hello  ".freeze.strip! }.should raise_error(RuntimeError)

  # see [ruby-core:23657]
  xit "raises a RuntimeError on a frozen instance that would not be modified", ->
    # lambda { "hello".freeze.strip! }.should raise_error(RuntimeError)
    # lambda { "".freeze.strip!      }.should raise_error(RuntimeError)
