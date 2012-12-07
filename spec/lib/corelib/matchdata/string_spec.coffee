describe "MatchData#string", ->
  it "returns a copy of the match string", ->
    str = R(/(.)(.)(\d+)(\d)/).match("THX1138.").string()
    expect( str ).toEqual R("THX1138.")

  xit "returns a frozen copy of the match string", ->
    # str = /(.)(.)(\d+)(\d)/.match("THX1138.").string
    # str.should == "THX1138."
    # str.frozen?.should == true
