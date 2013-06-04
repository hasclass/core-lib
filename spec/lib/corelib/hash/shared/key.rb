describe :hash_key_p, :shared => true do
  it "returns true if argument is a key", ->
    h = new_hash(:a => 1, :b => 2, :c => 3, 4 => 0)
    h.send(@method, :a).should == true
    h.send(@method, :b).should == true
    h.send(@method, 'b').should == false
    h.send(@method, 2).should == false
    h.send(@method, 4).should == true
    h.send(@method, 4.0).should == false

  it "returns true if the key's matching value was nil", ->
    new_hash(:xyz => nil).send(@method, :xyz).should == true

  it "returns true if the key's matching value was false", ->
    new_hash(:xyz => false).send(@method, :xyz).should == true

  it "returns true if the key is nil", ->
    new_hash(nil => 'b').send(@method, nil).should == true
    new_hash(nil => nil).send(@method, nil).should == true

  it "compares keys with the same #hash value via #eql?", ->
    x = mock('x')
    x.stub!(:hash).and_return(42)

    y = mock('y')
    y.stub!(:hash).and_return(42)
    y.should_receive(:eql?).and_return(false)

    new_hash(x => nil).send(@method, y).should == false
end
