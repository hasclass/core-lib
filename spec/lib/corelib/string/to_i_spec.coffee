describe "String#to_i", ->
  # Ruby 1.9 doesn't allow underscores and spaces as part of a number
  # ruby_version_is ""..."1.9", ->
  #   it "ignores leading underscores", ->
  #     expect(R("_123").to_i() ).toEqual R(123)
  #     expect(R("__123").to_i() ).toEqual R(123)
  #     expect(R("___123").to_i() ).toEqual R(123)
  #   it "ignores a leading mix of whitespaces and underscores", ->
  #     [ "_ _123", "_\t_123", "_\r\n_123" ].each do |str|
  #       expect(  str.to_i() ).toEqual R(123)

  describe 'ruby_version_is "1.9"', ->
    it "returns 0 for strings with leading underscores", ->
      expect( R("_123").to_i() ).toEqual R(0)

  it "ignores underscores in between the digits", ->
    expect( R("1_2_3asdf").to_i() ).toEqual R(123)

  it "ignores leading whitespaces", ->
    R([ " 123", "     123", "\r\n\r\n123", "\t\t123",
      "\r\n\t\n123", " \t\n\r\t 123"]).each (str) ->
      expect( R(str).to_i() ).toEqual R(123)

  it "ignores subsequent invalid characters", ->
    expect( R("123asdf").to_i() ).toEqual R(123)
    expect( R("123#123").to_i() ).toEqual R(123)
    expect( R("123 456").to_i() ).toEqual R(123)

  it "returns 0 if self is no valid integer-representation", ->
    R([ "++2", "+-2", "--2" ]).each (str) ->
      expect( R(str).to_i() ).toEqual R(0)

  it "interprets leading characters as a number in the given base", ->
    expect( R("100110010010").to_i(2)  ).toEqual R(0b100110010010)
    expect( R("100110201001").to_i(3)  ).toEqual R(186409)
    expect( R("103110201001").to_i(4)  ).toEqual R(5064769)
    expect( R("103110241001").to_i(5)  ).toEqual R(55165126)
    expect( R("153110241001").to_i(6)  ).toEqual R(697341529)
    expect( R("153160241001").to_i(7)  ).toEqual R(3521513430)
    expect( R("153160241701").to_i(8)  ).toEqual R(14390739905)
    expect( R("853160241701").to_i(9)  ).toEqual R(269716550518)
    expect( R("853160241791").to_i(10) ).toEqual R(853160241791)

    expect( R("F00D_BE_1337").to_i(16) ).toEqual R(0xF00DBE1337)
    expect( R("-hello_world").to_i(32) ).toEqual R(-18306744)
    expect( R("abcXYZ").to_i(36)       ).toEqual R(623741435)

    expect( R("z").multiply(24).to_i(36)        ).toEqual R(22452257707354557240087211123792674815)

    expect( R("5e10").to_i() ).toEqual R(5)

  xdescribe 'TODO: auto-decting works but not the ', ->
    it "auto-detects base 8 via leading 0 when base = 0", ->
      expect( R("01778").to_i(0)  ).toEqual R(0o177)
      expect( R("-01778").to_i(0) ).toEqual R(-0o177)

    it "auto-detects base 2 via 0b when base = 0", ->
      expect( R("0b112").to_i(0) ).toEqual R(0b11)
      expect( R("-0b112").to_i(0) ).toEqual R(-0b11)

    it "auto-detects base 10 via 0d when base = 0", ->
      expect( R("0d19A").to_i(0) ).toEqual R(19)
      expect( R("-0d19A").to_i(0) ).toEqual R(-19)

    it "auto-detects base 8 via 0o when base = 0", ->
      expect( R("0o178").to_i(0) ).toEqual R(0o17)
      expect( R("-0o178").to_i(0) ).toEqual R(-0o17)

    it "auto-detects base 16 via 0x when base = 0", ->
      expect( R("0xFAZ").to_i(0) ).toEqual R(0xFA)
      expect( R("-0xFAZ").to_i(0) ).toEqual R(-0xFA)

    it "auto-detects base 10 with no base specifier when base = 0", ->
      expect( R("1234567890ABC").to_i(0) ).toEqual R(1234567890)
      expect( R("-1234567890ABC").to_i(0) ).toEqual R(-1234567890)

  xit "doesn't handle foreign base specifiers when base is > 0", ->
    R([2, 3, 4, 8, 10]).each (base) ->
      expect( R("0111").to_i(base) ).toEqual R("111").to_i(base)

      expect( R("0b11").to_i(base) ).toEqual R((if base ==  2 then 0b11 else 0))
      expect( R("0d11").to_i(base) ).toEqual R((if base == 10 then   11 else 0))
      expect( R("0o11").to_i(base) ).toEqual R((if base ==  8 then 0o11 else 0))
      expect( R("0xFA").to_i(base) ).toEqual R(0)

    expect( R("0xD00D").to_i(16) ).toEqual R(0xD00D)

    expect( R("0b11").to_i(16) ).toEqual R(0xb11)
    expect( R("0d11").to_i(16) ).toEqual R(0xd11)
    expect( R("0o11").to_i(25) ).toEqual R(15026)
    expect( R("0x11").to_i(34) ).toEqual R(38183)

  it "tries to convert the base to an integer using to_int", ->
    obj =
      to_int: -> R(8)

    expect( R("777").to_i(obj) ).toEqual R(0o777)

  xit "requires that the sign if any appears before the base specifier", ->
    expect( R("0b-1").to_i( 2) ).toEqual R(0)
    expect( R("0d-1").to_i(10) ).toEqual R(0)
    expect( R("0o-1").to_i( 8) ).toEqual R(0)
    expect( R("0x-1").to_i(16) ).toEqual R(0)

    expect( R("0b-1").to_i(2) ).toEqual R(0)
    expect( R("0o-1").to_i(8) ).toEqual R(0)
    expect( R("0d-1").to_i(10) ).toEqual R(0)
    expect( R("0x-1").to_i(16) ).toEqual R(0)

  it "raises an ArgumentError for illegal bases (1, < 0 or > 36)", ->
    expect( -> R("").to_i(1)  ).toThrow('ArgumentError')
    expect( -> R("").to_i(-1) ).toThrow('ArgumentError')
    expect( -> R("").to_i(37) ).toThrow('ArgumentError')

  it "returns a Fixnum for long strings with trailing spaces", ->
    expect( R("0                             ").to_i() ).toEqual R(0)
    expect( R("0                             ").to_i() ).toBeInstanceOf(R.Fixnum)

    expect( R("10                             ").to_i() ).toEqual R(10)
    expect( R("10                             ").to_i() ).toBeInstanceOf(R.Fixnum)

    expect( R("-10                            ").to_i() ).toEqual R(-10)
    expect( R("-10                            ").to_i() ).toBeInstanceOf(R.Fixnum)

  it "returns a R.Fixnum for long strings with leading spaces", ->
    expect( R("                             0").to_i() ).toEqual R(0)
    expect( R("                             0").to_i() ).toBeInstanceOf(R.Fixnum)

    expect( R("                             10").to_i() ).toEqual R(10)
    expect( R("                             10").to_i() ).toBeInstanceOf(R.Fixnum)

    expect( R("                            -10").to_i() ).toEqual R(-10)
    expect( R("                            -10").to_i() ).toBeInstanceOf(R.Fixnum)

