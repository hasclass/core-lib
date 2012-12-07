describe "Float#==", ->
  # it_behaves_like :float_equal, :==

  it "returns true if self has the same value as other", ->
    expect( R(1.0).to_f().equals 1).toEqual true
    expect( R(2.71828).equals 1.428).toEqual false
    expect( R(-4.2).equals 4.2).toEqual false

  xit "calls 'other == self' if coercion fails", ->
    # class X; def ==(other); 2.0 == other; end; end

    # 1.0.send(@method, X.new).should == false
    # 2.0.send(@method, X.new).should == true
