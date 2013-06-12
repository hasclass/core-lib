# Modifying a collection while the contents are being iterated
# gives undefined behavior. See
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/23633

describe "Array#rindex", ->

  it "returns the first index backwards from the end where element == to object", ->
    key = 3
    uno  =
      equals: -> throw 'do not go here'
    dos  =
      equals: -> true
    tres =
      equals: -> false
    ary = R [uno, dos, tres]

    expect( ary.rindex(key) ).toEqual R(1)

  it "returns size-1 if last element == to object", ->
    expect( R([2, 1, 3, 2, 5]).rindex(5) ).toEqual R(4)

  it "returns 0 if only first element == to object", ->
    expect( R([2, 1, 3, 1, 5]).rindex(2) ).toEqual R(0)

  it "returns nil if no element == to object", ->
    expect( R([1, 1, 3, 2, 1, 3]).rindex(4) ).toEqual null

  # it "properly handles empty recursive arrays", ->
  #   empty = ArraySpecs.empty_recursive_array
  #   empty.rindex(empty).should == 0
  #   empty.rindex(1).should be_nil

  # it "properly handles recursive arrays", ->
  #   array = ArraySpecs.recursive_array
  #   array.rindex(1).should == 0
  #   array.rindex(array).should == 7

  describe 'ruby_version_is "1.8.7"', ->
    it "accepts a block instead of an argument", ->
      expect( R([4, 2, 1, 5, 1, 3]).rindex (x) -> x < 2 ).toEqual R(4)

    it "ignore the block if there is an argument", ->
      expect( R([4, 2, 1, 5, 1, 3]).rindex(5, (x) -> x < 2 ) ).toEqual R(3)

    xit "rechecks the array size during iteration", ->
      ary = R([4, 2, 1, 5, 1, 3])
      seen = []
      ary.rindex (x) ->
        seen.push(x)
        ary.clear()
        false

      expect( seen ).toEqual [3]

    describe "given no argument and no block", ->
      it "produces an Enumerator", ->
        en = R([4, 2, 1, 5, 1, 3]).rindex()
        expect( en ).toBeInstanceOf R.Enumerator
        expect( en.each (x) -> x < 2 ).toEqual R(4)
