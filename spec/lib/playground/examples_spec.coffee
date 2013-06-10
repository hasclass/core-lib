describe "Examples", ->
  it "_r methods return R Objects to chain things together", ->
    arr     = R(['foo', 'bar', 'baz'])
    new_arr = arr.each_with_index().map((w,i) -> "#{i}: #{w}" )
    expect( new_arr.valueOf() ).toEqual ['0: foo', '1: bar', '2: baz']

    line1 = R("hello world")
    line2 = R("-").multiply(line1.size())
    str   = [line1, line2].join("\n")

    expect( str ).toEqual "hello world\n-----------"

