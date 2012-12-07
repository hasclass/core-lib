describe "String#clear", ->
  beforeEach ->
    @s = R("Jolene")

  it "sets self equal to the empty String", ->
    @s.clear()
    expect( @s ).toEqual R("")

  it "returns self after emptying it", ->
    cleared = @s.clear()
    expect( cleared ).toEqual R("")
    expect( cleared is @s).toEqual true

  xit "preserves its encoding", ->
    # @s.encode!(Encoding::SHIFT_JIS)
    # @s.encoding.should == Encoding::SHIFT_JIS
    # @s.clear.encoding.should == Encoding::SHIFT_JIS
    # @s.encoding.should == Encoding::SHIFT_JIS

  # does not work in node
  xit "works with multibyte Strings", ->
    # s = R("\u{9765}\u{876}")
    # s.clear()
    # expect( s ).toEqual R("")

  xit "raises a RuntimeError if self is frozen", ->
    # @s.freeze
    # lambda { @s.clear        }.should raise_error(RuntimeError)
    # lambda { "".freeze.clear }.should raise_error(RuntimeError)
