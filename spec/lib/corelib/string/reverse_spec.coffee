describe "String#reverse", ->
  it "returns a new string with the characters of self in reverse order", ->
    expect( R("stressed").reverse() ).toEqual R("desserts")
    expect( R("m").reverse() ).toEqual R("m")
    expect( R("").reverse() ).toEqual R("")

  xit "taints the result if self is tainted", ->
    # "".taint.reverse.tainted?.should == true
    # "m".taint.reverse.tainted?.should == true

describe "String#reverse_bang", ->
  it "reverses self in place and always returns self", ->
    a = R "stressed"
    expect( a.reverse_bang() is a).toEqual true
    expect( a ).toEqual R("desserts")

    expect( R("").reverse_bang() ).toEqual R("")

  # xruby_version_is ""..."1.9", ->
    # it "raises a TypeError on a frozen instance that is modified", ->
    #   lambda { "anna".freeze.reverse_bang  }.should raise_error(TypeError)
    #   lambda { "hello".freeze.reverse_bang }.should raise_error(TypeError)

    # it "does not raise an exception on a frozen instance that would not be modified", ->
    #   "".freeze.reverse_bang.should == ""

  xdescribe 'ruby_version_is "1.9"', ->
    xit "raises a RuntimeError on a frozen instance that is modified", ->
      # lambda { "anna".freeze.reverse_bang  }.should raise_error(RuntimeError)
      # lambda { "hello".freeze.reverse_bang }.should raise_error(RuntimeError)

    # see [ruby-core:23666]
    xit "raises a RuntimeError on a frozen instance that would not be modified", ->
      # lambda { "".freeze.reverse_bang }.should raise_error(RuntimeError)
