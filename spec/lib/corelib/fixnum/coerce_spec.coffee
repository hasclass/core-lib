describe "Fixnum#coerce when given a Fixnum", ->
  it "returns an array containing two Fixnums", ->
    expect( R(1).coerce(2).inspect() ).toEqual R("[2, 1]")
    #expect( R(1).coerce(2).map { |i| i.class } ).toEqual [Fixnum, Fixnum]

describe "Fixnum#coerce when given a String", ->
  it "raises an ArgumentError when trying to coerce with a non-number String", ->
    expect( -> R(1).coerce(":") ).toThrow "ArgumentError"

  it "returns  an array containing two Floats", ->
    expect( R(1).coerce("2").inspect() ).toEqual R('[2.0, 1.0]')
    expect( R(1).coerce("-2").inspect() ).toEqual R('[-2.0, 1.0]')

describe "Fixnum#coerce", ->
  it "raises a TypeError when trying to coerce with nil", ->
    expect( -> R(1).coerce(null) ).toThrow "TypeError"

  xit "tries to convert the given Object into a Float by using #to_f", ->
    (obj = mock('1.0')).should_receive("to_f").and_return(1.0)
    expect( R(2).coerce(obj) ).toEqual [1.0, 2.0]

    (obj = mock('0')).should_receive("to_f").and_return('0')
    expect( expect( -> R(2).coerce(obj) ).toEqual [1.0, 2.0] ).toThrow "TypeError"

  it "raises a TypeError when given an Object that does not respond to #to_f", ->
    # expect( -> R(1).coerce(mock('x'))  ).toThrow "TypeError"
    expect( -> R(1).coerce(RubyJS.Range.new(1,4))       ).toThrow "TypeError"
    expect( -> R(1).coerce({})      ).toThrow "TypeError"
