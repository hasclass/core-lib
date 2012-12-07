describe "String#lstrip", ->
  it "returns a copy of self with leading whitespace removed", ->
   expect( R("  hello  ").lstrip() ).toEqual R("hello  ")
   expect( R("  hello world  ").lstrip() ).toEqual R("hello world  ")
   expect( R("\n\r\t\n\v\r hello world  ").lstrip() ).toEqual R("hello world  ")
   expect( R("hello").lstrip() ).toEqual R("hello")
   # expect( R("\000 \000hello\000 \000").lstrip() ).toEqual R("\000 \000hello\000 \000")

  # spec/core/string/lstrip_spec.rb
  # not_compliant_on :rubinius do
  #   it "does not strip leading \0", ->
  #    "\x00hello".lstrip.should == "\x00hello"

  xit "taints the result when self is tainted", ->
    # "".taint.lstrip.tainted?.should == true
    # "ok".taint.lstrip.tainted?.should == true
    # "   ok".taint.lstrip.tainted?.should == true

describe "String#lstrip!", ->
  it "modifies self in place and returns self", ->
    a = R "  hello  "
    expect( a.lstrip_bang() is a).toEqual true
    expect( a ).toEqual R("hello  ")

    # a = R "\000 \000hello\000 \000"
    # a.lstrip_bang()
    # expect( a ).toEqual R("\000 \000hello\000 \000")

  it "returns nil if no modifications were made", ->
    a = R "hello"
    expect( a.lstrip_bang() ).toEqual null
    expect( a ).toEqual R("hello")

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError on a frozen instance that is modified", ->
  #     lambda { "  hello  ".freeze.lstrip! }.should raise_error(TypeError)

  #   it "does not raise an exception on a frozen instance that would not be modified", ->
  #     "hello".freeze.lstrip!.should be_nil
  #     "".freeze.lstrip!.should be_nil

# ruby_version_is "1.9", ->
  xit "raises a RuntimeError on a frozen instance that is modified", ->
    # lambda { "  hello  ".freeze.lstrip! }.should raise_error(RuntimeError)

  # see [ruby-core:23657]
  xit "raises a RuntimeError on a frozen instance that would not be modified", ->
    # lambda { "hello".freeze.lstrip! }.should raise_error(RuntimeError)
    # lambda { "".freeze.lstrip!      }.should raise_error(RuntimeError)
