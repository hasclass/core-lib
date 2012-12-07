describe "Examples", ->
  it "_r methods return R Objects to chain things together", ->
    arr     = R(['foo', 'bar', 'baz'])
    new_arr = arr.each_with_index().map((w,i) -> "#{i}: #{w}" )
    expect( new_arr.unbox() ).toEqual ['0: foo', '1: bar', '2: baz']

    line1 = R("hello world")
    line2 = R("-").multiply(line1.size())
    str   = [line1, line2].join("\n")

    expect( str ).toEqual "hello world\n-----------"

  it "should scan words", ->
    scanned = R("foo bar").scan(/\w+/)

    # recursively unbox RubyJS.Array and RubyJS.Strings to native types
    # Makes tests more concise.
    expect( scanned.unbox(true)                   ).toEqual ["foo", "bar"]

    # map to capitalize
    expect( scanned.map((w) -> w.capitalize() ).unbox(true) ).toEqual ["Foo", "Bar"]

    # use string to proc
    # expect( scanned.map("capitalize").inspect()           ).toEqual R('["Foo", "Bar"]')

    # Works with CoffeeScript iterators using .iterator().
    # scanned.iterator() returns a for .. in .. compatible object. Currently
    # a native array.
    native_arr_of__r_strings = (w.capitalize() for w in scanned.iterator())
    # for .. in .. however returns a native array again, and we have to box it
    # if we need RubyJS.Array methods.
    expect( native_arr_of__r_strings.each ).toBeUndefined
    expect( R(native_arr_of__r_strings).unbox(true) ).toEqual ["Foo", "Bar"]

    # _bang methods alter the RubyJS.Strings directly
    scanned.each (w) -> w.capitalize_bang()
    expect( scanned.unbox(true)         ).toEqual ["Foo", "Bar"]

