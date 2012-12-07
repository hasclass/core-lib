describe "Range#each", ->
  it "passes each element to the given block by using #succ", ->
    a = R []
    RubyJS.Range.new(-5, 5).each (i) -> a.push(i)
    expect( a.unbox(true) ).toEqual  [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]

    a = R []
    RubyJS.Range.new('A', 'D').each (i) -> a.push(i)
    expect( a.unbox(true) ).toEqual  ['A','B','C','D']

    a = R []
    RubyJS.Range.new('A', 'D', true).each (i) -> a.push(i)
    expect( a.unbox(true) ).toEqual  ['A','B','C']

    a = R []
    RubyJS.Range.new(0xfffd, 0xffff, true).each (i) -> a.push(i)
    expect( a.unbox(true) ).toEqual  [0xfffd, 0xfffe]

#   xit "", ->
#     y = mock('y')
#     x = mock('x')
#     # x.should_receive(:<=>).with(y).any_number_of_times.and_return(-1)
#     # x.should_receive(:<=>).with(x).any_number_of_times.and_return(0)
#     # x.should_receive(:succ).any_number_of_times.and_return(y)
#     # y.should_receive(:<=>).with(x).any_number_of_times.and_return(1)
#     # y.should_receive(:<=>).with(y).any_number_of_times.and_return(0)

#     a = R []
#     RubyJS.Range.new(x, y).each (i) -> a.push(i)
#     expect( a.unbox(true) ).toEqual  [x, y]

  it "raises a TypeError if the first element does not respond to #succ", ->
    expect( -> RubyJS.Range.new(0.5, 2.4).each (i) -> i ).toThrow("TypeError")

    b = R('x')
    b.succ = undefined
    a = R('1')
    a['<=>'] = -> 1
    a.succ = undefined

    expect( -> RubyJS.Range.new(a, b).each (i) -> i  ).toThrow("TypeError")

  it "returns self", ->
    range = R.Range.new 1, 10
    expect( range.each(->) ).toEqual(range)

  describe "ruby_version_is '1.8.7'", ->
    it "returns an enumerator when no block given", ->
      en = RubyJS.Range.new(1, 3).each()
      expect( en ).toBeInstanceOf(RubyJS.Enumerator)
      expect( en.to_a().unbox(true) ).toEqual [1, 2, 3]

  # TODO: test when Time is implemented
  # describe "ruby_version_is '1.9'", ->
  #   it "raises a TypeError if the first element is a Time object", ->
  #     t = RubyJS.Time.now
  #     expect( -> RubyJS.Range.new(t, t).each (i) -> i  ).toThrow("TypeError")
