describe "ruby_version_is '1.8.7'", ->
  describe "String#start_with?", ->
    it "returns true only if beginning match", ->
      s = R "hello"
      expect( R(s).start_with('h')   ).toEqual true
      expect( R(s).start_with('hel') ).toEqual true
      expect( R(s).start_with('el')  ).toEqual false

    it "returns true only if any beginning match", ->
      expect( R("hello").start_with('x', 'y', 'he', 'z') ).toEqual true

    xit "converts its argument using :valueOf", ->
      s = R "hello"
      find =
        valueOf: ->
      spy = spyOn(find, 'valueOf').andReturn("h")
      expect( R(s).start_with(find) ).toEqual true
      expect( spy ).wasCalled()

    describe "ruby_version_is '1.8.7'...'2.0'", ->
      it "ignores arguments not convertible to string", ->
        expect( R("hello").start_with()      ).toEqual false
        expect( R("hello").start_with(1)     ).toEqual false
        expect( R("hello").start_with(["h"]) ).toEqual false
        expect( R("hello").start_with(1, null, "h") ).toEqual true

    # ruby_version_is '2.0', ->
    #   it "ignores arguments not convertible to string", ->
    #     expect( R("hello").start_with() ).toEqual false
    #     lambda { "hello".start_with?(1) }.should  raise_error(TypeError)
    #     lambda { "hello".start_with?(["h"]) }.should  raise_error(TypeError)
    #     lambda { "hello".start_with?(1, nil, "h").should }.should raise_error(TypeError)

    xit "uses only the needed arguments", ->
      # find = mock('h')
      # find.should_not_receive(:to_str)
      # "hello".start_with?("h",find).should be_true

    xit "works for multibyte strings", ->
      # old_kcode = $KCODE
      # begin
      #   $KCODE = "UTF-8"
      #   "céréale".start_with?("cér").should be_true
      # ensure
      #   $KCODE = old_kcode
      # end
