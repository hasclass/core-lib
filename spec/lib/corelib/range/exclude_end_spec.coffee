describe "Range#exclude_end()", ->
  it "returns true if the range exludes the end value", ->
    expect( RubyJS.Range.new(-2, 2).exclude_end() ).toEqual  false
    expect( RubyJS.Range.new('A', 'B').exclude_end() ).toEqual  false
    expect( RubyJS.Range.new(0.5, 2.4).exclude_end() ).toEqual  false
    expect( RubyJS.Range.new(0xfffd, 0xffff).exclude_end() ).toEqual  false

    expect( RubyJS.Range.new(0,5, true).exclude_end() ).toEqual  true
    expect( RubyJS.Range.new('A','B', true).exclude_end() ).toEqual  true
    expect( RubyJS.Range.new(0.5,2.4, true).exclude_end() ).toEqual  true
    expect( RubyJS.Range.new(0xfffd,0xffff, true).exclude_end() ).toEqual  true
