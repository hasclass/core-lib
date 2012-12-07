describe "String#empty?", ->
  it "returns true if the string has a length of zero", ->
    expect( R("hello").empty() ).toEqual false
    expect( R(" ").empty()     ).toEqual false
    expect( R("\x00").empty()  ).toEqual false
    expect( R("").empty()      ).toEqual true
    # StringSpecs::MyString.new("").empty?.should == true
