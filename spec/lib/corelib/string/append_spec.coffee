describe "String#<<", ->
  it "is alias to concat", ->
    a = R('str')
    expect( a['<<'] ).toEqual a.concat