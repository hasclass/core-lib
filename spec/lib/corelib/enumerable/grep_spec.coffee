describe "Enumerable#grep", ->

  it "grep without a block should return an array of all elements === pattern", ->
    m =
      '===': (obj) -> obj?.equals?('2')

    expect( EnumerableSpecs.Numerous.new('2', 'a', 'nil', '3', false).grep(m) ).toEqual R.$Array_r(['2'])

  it "grep with a block should return an array of elements === pattern passed through block", ->
    m =
      '===': (obj) -> obj.match /^ca/

    en = EnumerableSpecs.Numerous.new("cat", "coat", "car", "cadr", "cost")
    expect( en.grep m, (i) -> i.upcase() ).toEqual R.$Array_r(["CAT", "CAR", "CADR"])

  xit "grep the enumerable (rubycon legacy)", ->
  #   @a = EnumerableSpecs.EachDefiner.new( 2, 4, 6, 8, 10)
  #   EnumerableSpecs.EachDefiner.new().grep(1).should == []
  #   @a.grep(3..7).should == [4,6]
  #   @a.grep(3..7) {|a| a+1}.should == [5,7]

  xit "can use $~ in the block when used with a Regexp", ->
    # ary = ["aba", "aba"]
    # ary.grep(/a(b)a/) { $1 }.should == ["b", "b"]
