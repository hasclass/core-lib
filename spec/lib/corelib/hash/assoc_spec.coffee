describe "Hash#assoc", ->
  beforeEach ->
    @h = R.hashify({apple: 'green', orange: 'orange', grape: 'green', banana: 'yellow'})

  it "returns an Array if the argument is == to a key of the Hash", ->
    expect( @h.assoc('apple') ).toBeInstanceOf(R.Array)

  it "returns a 2-element Array if the argument is == to a key of the Hash", ->
    expect( @h.assoc('grape').size()   ).toEqual == R(2)

  it "sets the first element of the Array to the located key", ->
    expect( @h.assoc('banana').first() ).toEqual == 'banana'

  it "sets the last element of the Array to the value of the located key", ->
    expect( @h.assoc('banana').last()  ).toEqual == 'yellow'

  # it "only returns the first matching key-value pair for identity hashes", ->
  #   @h.compare_by_identity
  #   @h['pear'] = :red
  #   @h['pear'] = :green
  #   @h.keys.grep(/pear/).size.should == 2
  #   @h.assoc('pear').should == ['pear', :red]

  # it "uses #== to compare the argument to the keys", ->
  #   @h[1.0] = :value
  #   1.should == 1.0
  #   @h.assoc(1).should == [1.0, :value]

  it "returns nil if the argument is not a key of the Hash", ->
    expect( @h.assoc('green') ).toEqual null

  # it "returns nil if the argument is not a key of the Hash even when there is a default", ->
  #   Hash.new(42).merge!( foo: 'bar' ).assoc(42).should be_nil
  #   Hash.new{|h, k| h[k] = 42}.merge!( foo: 'bar' ).assoc(42).should be_nil
