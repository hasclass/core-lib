describe "Range#to_a", ->
  it "converts self to an array", ->
    expect( RubyJS.Range.new(-5,5).to_a().unbox(true)    ).toEqual  [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    expect( RubyJS.Range.new('A','D').to_a().unbox(true) ).toEqual  ['A','B','C','D']
    expect( RubyJS.Range.new('A','D', true).to_a().unbox(true) ).toEqual  ['A','B','C']
    expect( RubyJS.Range.new(0xfffd,0xffff, true).to_a().unbox(true) ).toEqual  [0xfffd,0xfffe]
    expect( -> RubyJS.Range.new(0.5, 2.4).to_a()      ).toThrow("TypeError")

  it "returns empty array for descending-ordered", ->
    expect( RubyJS.Range.new(5,-5).to_a().unbox() ).toEqual  []
    expect( RubyJS.Range.new('D','A').to_a().unbox() ).toEqual  []
    expect( RubyJS.Range.new('D','A', true).to_a().unbox() ).toEqual  []
    expect( RubyJS.Range.new(0xffff,0xfffd, true).to_a().unbox() ).toEqual  []

  xdescribe 'ruby_version_is "1.9"', ->
    # This crashed on 1.9 prior to r24573
    it "works with Ranges of Symbols", ->
      #(:A,:z).to_a.size.toEqual  58
