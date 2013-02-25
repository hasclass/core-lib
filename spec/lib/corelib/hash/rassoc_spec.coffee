describe "Hash#rassoc", ->
  beforeEach ->
    @h = R.hashify(apple: 'green', orange: 'orange', grape: 'green', banana: 'yellow')

  it "returns an Array if the argument is a value of the Hash", ->
    expect( @h.rassoc('green') ).toBeInstanceOf(R.Array)

  it "returns a 2-element Array if the argument is a value of the Hash", ->
    expect( @h.rassoc('orange').size() ).toEqual R(2)

  it "sets the first element of the Array to the key of the located value", ->
    expect( @h.rassoc('yellow').first() ).toEqual 'banana'

  it "sets the last element of the Array to the located value", ->
    expect( @h.rassoc('yellow').last() ).toEqual 'yellow'

  it "only returns the first matching key-value pair", ->
    expect( @h.rassoc('green') ).toEqual R(['apple', 'green'])

  # it "uses #== to compare the argument to the values", ->
  #   @h[:key] = 1.0
  #   1.should == 1.0
  #   @h.rassoc(1).should eql [:key, 1.0]

  it "returns nil if the argument is not a value of the Hash", ->
    expect( @h.rassoc('banana') ).toEqual null

  it "returns nil if the argument is not a value of the Hash even when there is a default", ->
    expect( R.hashify({}, 42).merge( foo: 'bar' ).rassoc(42) ).toEqual null
    # Hash.new{|h, k| h[k] = 42}.merge!( :foo => :bar ).rassoc(42).should be_nil
