describe "String#end_with?", ->
  it "returns true only if ends match", ->
    s = R "hello"
    expect( s.end_with('o')   ).toEqual(true)
    expect( s.end_with('llo') ).toEqual(true)
    expect( s.end_with('ll')  ).toEqual(false)

  it "returns true only if any ending match", ->
    expect( R("hello").end_with('x', 'y', 'llo', 'z') ).toEqual(true)

  xit "converts its argument using :to_str", ->
    s = R "hello"
    find =
      to_str: ->
    spy = spyOn(find, 'to_str').andReturn(R "o")
    expect( R(s).end_with(find) ).toEqual true
    expect( spy ).wasCalled()

  describe "ruby_version_is '1.8.7'...'2.0'", ->
    it "ignores arguments not convertible to string", ->
      expect( R("hello").end_with() ).toEqual false
      expect( R("hello").end_with(1) ).toEqual false
      expect( R("hello").end_with(["o"]) ).toEqual false
      expect( R("hello").end_with(1, null, "o") ).toEqual true

  # ruby_version_is '2.0', ->
  #   it "ignores arguments not convertible to string", ->
  #     "hello".end_with?().should be_false
  #     lambda { "hello".end_with?(1) }.should raise_error(TypeError)
  #     lambda { "hello".end_with?(["o"]) }.should raise_error(TypeError)
  #     lambda { "hello".end_with?(1, nil, "o") }.should raise_error(TypeError)

  xit "uses only the needed arguments", ->
    # find = mock('h')
    # find.should_not_receive(:to_str)
    # "hello".end_with?("o",find).should be_true

  # it "works for multibyte strings", ->
  #   old_kcode = $KCODE
  #   begin
  #     $KCODE = "UTF-8"
  #     "céréale".end_with?("réale").should be_true
  #   ensure
  #     $KCODE = old_kcode
