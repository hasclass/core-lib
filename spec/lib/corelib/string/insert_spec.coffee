describe "String#insert with index, other", ->
  it "inserts other before the character at the given index", ->
    expect( R("abcd").insert(0, 'X' )).toEqual R("Xabcd")
    expect( R("abcd").insert(3, 'X' )).toEqual R("abcXd")
    expect( R("abcd").insert(4, 'X' )).toEqual R("abcdX")

  it "modifies self in place", ->
    a = R("abcd")
    expect( a.insert(4, 'X' )).toEqual R("abcdX")
    expect( a ).toEqual R("abcdX")

  it "inserts after the given character on an negative count", ->
    expect( R("abcd").insert(-5, 'X' )).toEqual R("Xabcd")
    expect( R("abcd").insert(-3, 'X' )).toEqual R("abXcd")
    expect( R("abcd").insert(-1, 'X' )).toEqual R("abcdX")

  it "raises an IndexError if the index is beyond string", ->
    expect( -> R("abcd").insert(5, 'X')  ).toThrow('IndexError')
    expect( -> R("abcd").insert(-6, 'X') ).toThrow('IndexError')

  it "converts index to an integer using to_int", ->
    other =
      to_int: -> R(-3)

    expect( R("abcd").insert(other, "XYZ" )).toEqual R("abXYZcd")

  it "converts other to a string using to_str", ->
    other =
      to_str: -> R("XYZ")

    expect( R("abcd").insert(-3, other) ).toEqual R("abXYZcd")

  # it "taints self if string to insert is tainted", ->
  #   str = "abcd"
  #   str.insert(0, "T".taint).tainted?.should == true

  #   str = "abcd"
  #   other =
  #     to_str: () "T".taint end
  #   str.insert(0, other).tainted?.should == true

  it "raises a TypeError if other can't be converted to string", ->
    expect( -> R("abcd").insert(-6, new Object()) ).toThrow('TypeError')
    expect( -> R("abcd").insert(-6, [])           ).toThrow('TypeError')

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError if self is frozen", ->
  #     str = "abcd".freeze
  #     lambda { str.insert(4, '')  }.should raise_error(TypeError)
  #     lambda { str.insert(4, 'X') }.should raise_error(TypeError)

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError if self is frozen", ->
  #     str = "abcd".freeze
  #     lambda { str.insert(4, '')  }.should raise_error(RuntimeError)
  #     lambda { str.insert(4, 'X') }.should raise_error(RuntimeError)
