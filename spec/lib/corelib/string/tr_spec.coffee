describe "String#tr", ->
  xit "returns a new string with the characters from from_string replaced by the ones in to_string", ->
    expect( R("hello").tr('aeiou', '*')  ).toEqual R("h*ll*")
    expect( R("hello").tr('el', 'ip')    ).toEqual R("hippo")
    expect( R("Lisp").tr("Lisp", "Ruby") ).toEqual R("Ruby")

  xit "accepts c1-c2 notation to denote ranges of characters", ->
    expect( R("hello").tr('a-y', 'b-z')        ).toEqual R("ifmmp")
    expect( R("123456789").tr("2-5","abcdefg") ).toEqual R("1abcd6789")
    expect( R("hello ^-^").tr("e-", "__")      ).toEqual R("h_llo ^_^")
    expect( R("hello ^-^").tr("---", "_")      ).toEqual R("hello ^_^")

  xit "pads to_str with its last char if it is shorter than from_string", ->
    expect( R("this").tr("this", "x")    ).toEqual R("xxxx")
    expect( R("hello").tr("a-z", "A-H.") ).toEqual R("HE...")

  describe "ruby_version_is '1.9.2'", ->
    xit "raises a ArgumentError a descending range in the replacement as containing just the start character", ->
      expect( -> R("hello").tr("a-y", "z-b") ).toThrow('ArgumentError')

    xit "raises a ArgumentError a descending range in the source as empty", ->
      expect( -> R("hello").tr("l-a", "z") ).toThrow('ArgumentError')

  xit "translates chars not in from_string when it starts with a ^", ->
    expect( R("hello").tr('^aeiou', '*')        ).toEqual R("*e**o")
    expect( R("123456789").tr("^345", "abc")    ).toEqual R("cc345cccc")
    expect( R("abcdefghijk").tr("^d-g", "9131") ).toEqual R("111defg1111")

    expect( R("hello ^_^").tr("a-e^e", ".")   ).toEqual R("h.llo ._.")
    expect( R("hello ^_^").tr("^^", ".")      ).toEqual R("......^.^")
    expect( R("hello ^_^").tr("^", "x")       ).toEqual R("hello x_x")
    expect( R("hello ^-^").tr("^-^", "x")     ).toEqual R("xxxxxx^-^")
    expect( R("hello ^-^").tr("^^-^", "x")    ).toEqual R("xxxxxx^x^")
    expect( R("hello ^-^").tr("^---", "x")    ).toEqual R("xxxxxxx-x")
    expect( R("hello ^-^").tr("^---l-o", "x") ).toEqual R("xxlloxx-x")

  xit "supports non-injective replacements", ->
    expect( R("hello").tr("helo", "1212") ).toEqual R("12112")

  xit "tries to convert from_str and to_str to strings using to_str", ->
    from_str =
      to_str: -> R("ab")

    to_str =
      to_str: -> R("AB")

    expect( R("bla").tr(from_str, to_str) ).toEqual R("BlA")

  xit "returns subclass instances when called on a subclass", ->
    expect( new StringSpecs.MyString("hello").tr("e", "a") ).toBeInstanceOf(StringSpecs.MyString)

  # it "taints the result when self is tainted", ->
  #   ["h", "hello"].each do |str|
  #     tainted_str = str.dup.taint

  #     expect( tainted_str.tr("e", "a").tainted? ).toEqual true

  #     expect( str.tr("e".taint, "a").tainted? ).toEqual false
  #     expect( str.tr("e", "a".taint).tainted? ).toEqual false

  # with_feature :encoding do
  #   # http://redmine.ruby-lang.org/issues/show/1839
  #   xit "can replace a 7-bit ASCII character with a multibyte one", ->
  #     a = "uber"
  #     expect( a.encoding ).toEqual Encoding::UTF_8
  #     b = a.tr("u","ü")
  #     expect( b ).toEqual "über"
  #     expect( b.encoding ).toEqual Encoding::UTF_8
  # end

describe "String#tr!", ->
  xit "modifies self in place", ->
    s = R("abcdefghijklmnopqR")
    expect( s.tr_bang("cdefg", "12") ).toEqual R("ab12222hijklmnopqR")
    expect( s ).toEqual R("ab12222hijklmnopqR")

  xit "returns nil if no modification was made", ->
    s = R("hello")
    expect( s.tr_bang("za", "yb") ).toEqual null
    expect( s.tr_bang("", "") ).toEqual null
    expect( s ).toEqual R("hello")

  xit "does not modify self if from_str is empty", ->
    s = R("hello")
    expect( s.tr_bang("", "") ).toEqual null
    expect( s ).toEqual R("hello")
    expect( s.tr_bang("", "yb") ).toEqual null
    expect( s ).toEqual R("hello")

  describe 'ruby_version_is "1.9"', ->
    xit "raises a RuntimeError if self is frozen", ->
    #   s = R("abcdefghijklmnopqR".freeze)
    #   expect( -> s.tr_bang("cdefg", "12") ).toThrow('RuntimeError')
    #   expect( -> s.tr_bang("R", "S")      ).toThrow('RuntimeError')
    #   expect( -> s.tr_bang("", "")        ).toThrow('RuntimeError')


  # ruby_version_is ""..."1.9", ->
  #   xit "raises a TypeError if self is frozen", ->
  #     s = "abcdefghijklmnopqR".freeze
  #     lambda { s.tr_bang("cdefg", "12") }.should raise_error(TypeError)
  #     lambda { s.tr_bang("R", "S")      }.should raise_error(TypeError)
  #     lambda { s.tr_bang("", "")        }.should raise_error(TypeError)
  # ruby_version_is '' ... '1.9.2' do
  #   xit "treats a descending range in the replacement as containing just the start character", ->
  #     expect( R("hello").tr("a-y", "z-b") ).toEqual "zzzzz"
  #   xit "treats a descending range in the source as empty", ->
  #     expect( R("hello").tr("l-a", "z") ).toEqual "hello"