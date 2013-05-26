describe "String#chomp with separator", ->

  it "returns a new string with the given record separator removed", ->
    expect(R("hello").chomp("llo")).toEqual R("he")
    expect(R("hellollo").chomp("llo")).toEqual R("hello")

  it "removes carriage return (except \\r) chars multiple times when separator is an empty string", ->
    expect(R("").chomp("")).toEqual R("")
    expect(R("hello").chomp("")).toEqual R("hello")
    expect(R("hello\n").chomp("")).toEqual R("hello")
    expect(R("hello\nx").chomp("")).toEqual R("hello\nx")
    expect(R("hello\r\n").chomp("")).toEqual R("hello")
    expect(R("hello\r\n\r\n\n\n\r\n").chomp("")).toEqual R("hello")

    expect(R("hello\r").chomp("")).toEqual R("hello\r")
    expect(R("hello\n\r").chomp("")).toEqual R("hello\n\r")
    expect(R("hello\r\r\r\n").chomp("")).toEqual R("hello\r\r")

  it "removes carriage return chars (\\n, \\r, \\r\\n) when separator is \\n", ->
    expect(R("hello").chomp("\n")).toEqual R("hello")
    expect(R("hello\n").chomp("\n")).toEqual R("hello")
    expect(R("hello\r\n").chomp("\n")).toEqual R("hello")
    expect(R("hello\n\r").chomp("\n")).toEqual R("hello\n")
    expect(R("hello\r").chomp("\n")).toEqual R("hello")
    expect(R("hello \n there").chomp("\n")).toEqual R("hello \n there")
    expect(R("hello\r\n\r\n\n\n\r\n").chomp("\n")).toEqual R("hello\r\n\r\n\n\n")
    expect(R("hello\n\r").chomp("\r")).toEqual R("hello\n")
    expect(R("hello\n\r\n").chomp("\r\n")).toEqual R("hello\n")

  it "returns self if the separator is nil", ->
    str = R("hello\n\n")
    expect(str.chomp(null) is str).toEqual true

  it "returns an empty string when called on an empty string", ->
    expect(R("").chomp("\n")).toEqual R("")
    expect(R("").chomp("\r")).toEqual R("")
    expect(R("").chomp("")).toEqual R("")
    expect(R("").chomp(null)).toEqual R("")

  # TAINT
  # xit "taints result when self is tainted", ->
    # expect("hello".taint().chomp("llo").is_tainted()).toEqual true
    # expect("hello".taint().chomp("").is_tainted()).toEqual true
    # expect("hello".taint().chomp(null).is_tainted()).toEqual true
    # expect("hello".taint().chomp().is_tainted()).toEqual true
    # expect("hello\n".taint().chomp().is_tainted()).toEqual true
    # expect("hello".chomp("llo".taint()).is_tainted()).toEqual false

  it "raises a TypeError if separator can't be converted to a string", ->
    expect(-> R("hello").chomp(30.3)      ).toThrow ("TypeError")
    expect(-> R("hello").chomp([])        ).toThrow ("TypeError")

  # it "calls #to_str to convert separator to a String", ->
  #   separator = mock('llo')
  #   separator.should_receive(:to_str).and_return("llo")
  #   "hello".chomp(separator).should == "he"

  # it "returns subclass instances when called on a subclass", ->
  #   StringSpecs::MyString.new("hello\n").chomp.should be_kind_of(StringSpecs::MyString)
  #   StringSpecs::MyString.new("hello").chomp.should be_kind_of(StringSpecs::MyString)
  #   StringSpecs::MyString.new("").chomp.should be_kind_of(StringSpecs::MyString)

  # it "uses $/ as the separator when none is given", ->
  #   ["", "x", "x\n", "x\r", "x\r\n", "x\n\r\r\n", "hello"].each do |str|
  #     ["", "llo", "\n", "\r", nil].each do |sep|
  #       begin
  #         expected = str.chomp(sep)

  #         old_rec_sep, $/ = $/, sep

  #         str.chomp.should == expected
  #       ensure
  #         $/ = old_rec_sep


# describe "String#chomp! with separator", ->
#   it "modifies self in place and returns self", ->
#     s = "one\n"
#     s.chomp!.should equal(s)
#     s.should == "one"

#     t = "two\r\n"
#     t.chomp!.should equal(t)
#     t.should == "two"

#     u = "three\r"
#     u.chomp!
#     u.should == "three"

#     v = "four\n\r"
#     v.chomp!
#     v.should == "four\n"

#     w = "five\n\n"
#     w.chomp!(nil)
#     w.should == "five\n\n"

#     x = "six"
#     x.chomp!("ix")
#     x.should == "s"

#     y = "seven\n\n\n\n"
#     y.chomp!("")
#     y.should == "seven"

#   it "returns nil if no modifications were made", ->
#      v = "four"
#      v.chomp!.should == nil
#      v.should == "four"

#     "".chomp!.should == nil
#     "line".chomp!.should == nil

#     "hello\n".chomp!("x").should == nil
#     "hello".chomp!("").should == nil
#     "hello".chomp!(nil).should == nil

#   ruby_version_is ""..."1.9", ->
#     it "raises a TypeError when self is frozen", ->
#       a = "string\n"
#       a.freeze

#       lambda { a.chomp! }.should raise_error(TypeError)
#       lambda { a.chomp!("\n") }.should raise_error(TypeError)
#       lambda { a.chomp!("") }.should raise_error(TypeError)

#       c = "fooa"
#       c.freeze
#       lambda { c.chomp!("a") }.should raise_error(TypeError)

#     it "does raise an exception when no change would be done and no argument is passed in", ->
#       b = "string"
#       b.freeze

#       lambda { b.chomp! }.should raise_error(TypeError)

#     it "does not raise an exception when no change would be done and no argument is passed in on an empty string", ->
#       b = ""
#       b.freeze

#        b.chomp!.should be_nil

#     it "does not raise an exception when the string would not be modified", ->
#       a = "string\n\r"
#       a.freeze

#       a.chomp!(nil).should be_nil
#       a.chomp!("x").should be_nil

#   ruby_version_is "1.9", ->
#     it "raises a RuntimeError on a frozen instance when it is modified", ->
#       a = "string\n\r"
#       a.freeze

#       lambda { a.chomp! }.should raise_error(RuntimeError)

#     # see [ruby-core:23666]
#     it "raises a RuntimeError on a frozen instance when it would not be modified", ->
#       a = "string\n\r"
#       a.freeze
#       lambda { a.chomp!(nil) }.should raise_error(RuntimeError)
#       lambda { a.chomp!("x") }.should raise_error(RuntimeError)
