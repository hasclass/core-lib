describe "String#casecmp independent of case", ->
  it "returns -1 when less than other", ->
    expect( R("a").casecmp("b") ).toEqual -1
    expect( R("A").casecmp("b") ).toEqual -1

  it "returns 0 when equal to other", ->
    expect( R("a").casecmp("a") ).toEqual 0
    expect( R("A").casecmp("a") ).toEqual 0

  it "returns 1 when greater than other", ->
    expect( R("b").casecmp("a") ).toEqual 1
    expect( R("B").casecmp("a") ).toEqual 1

  it "tries to convert other to string using to_str", ->
    obj = R('ABC')
    spy = spyOn(obj, 'to_str').andReturn(R('abc'))
    expect( R('abc').casecmp(obj) ).toEqual 0
    expect( spy ).wasCalled()

  it "raises a TypeError if other can't be converted to a string", ->
    expect( -> R("abc").casecmp([]) ).toThrow('TypeError')

  # describe "in UTF-8 mode", ->
  #   before :each do
  #     @kcode = $KCODE
  #     $KCODE = "utf-8"

  #   after :each do
  #     $KCODE = @kcode

  #   describe "for non-ASCII characters", ->
  #     before :each do
  #       @upper_a_tilde  = "\xc3\x83"
  #       @lower_a_tilde  = "\xc3\xa3"
  #       @upper_a_umlaut = "\xc3\x84"
  #       @lower_a_umlaut = "\xc3\xa4"

  #     it "returns -1 when numerically less than other", ->
  #       expect( R(@upper_a_tilde).casecmp(@lower_a_tilde) ).toEqual -1
  #       expect( R(@upper_a_tilde).casecmp(@upper_a_umlaut) ).toEqual -1

  #     it "returns 0 when numerically equal to other", ->
  #       expect( R(@upper_a_tilde).casecmp(@upper_a_tilde) ).toEqual 0

  #     it "returns 1 when numerically greater than other", ->
  #       expect( R(@lower_a_umlaut).casecmp(@upper_a_umlaut) ).toEqual 1
  #       expect( R(@lower_a_umlaut).casecmp(@lower_a_tilde) ).toEqual 1

  #   describe "for ASCII characters", ->
  #     it "returns -1 when less than other", ->
  #       expect( R("a").casecmp("b") ).toEqual -1
  #       expect( R("A").casecmp("b") ).toEqual -1

  #     it "returns 0 when equal to other", ->
  #       expect( R("a").casecmp("a") ).toEqual 0
  #       expect( R("A").casecmp("a") ).toEqual 0

  #     it "returns 1 when greater than other", ->
  #       expect( R("b").casecmp("a") ).toEqual 1
  #       expect( R("B").casecmp("a") ).toEqual 1

  # describe "for non-ASCII characters", ->
  #   before :each do
  #     @upper_a_tilde = "\xc3"
  #     @lower_a_tilde = "\xe3"

  #   # These could be encoded in Latin-1, but there's no way
  #   # to express that in 1.8.
  #   it "returns -1 when numerically less than other", ->
  #     expect( R(@upper_a_tilde).casecmp(@lower_a_tilde) ).toEqual -1

  #   it "returns 0 when equal to other", ->
  #     expect( R(@upper_a_tilde).casecmp("\xc3") ).toEqual 0

  #   it "returns 1 when numerically greater than other", ->
  #     expect( R(@lower_a_tilde).casecmp(@upper_a_tilde) ).toEqual 1

  # TODO: subclassing

  # describe "when comparing a subclass instance", ->
  #   it "returns -1 when less than other", ->
  #     b = StringSpecs::MyString.new "b"
  #     expect( R("a").casecmp(b) ).toEqual -1
  #     expect( R("A").casecmp(b) ).toEqual -1

  #   it "returns 0 when equal to other", ->
  #     a = StringSpecs::MyString.new "a"
  #     expect( R("a").casecmp(a) ).toEqual 0
  #     expect( R("A").casecmp(a) ).toEqual 0

  #   it "returns 1 when greater than other", ->
  #     a = StringSpecs::MyString.new "a"
  #     expect( R("b").casecmp(a) ).toEqual 1
  #     expect( R("B").casecmp(a) ).toEqual 1
