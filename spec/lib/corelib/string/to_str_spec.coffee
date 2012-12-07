describe "String#<<", ->
  it "is alias to concat", ->
    a = R('str')
    expect( a.to_str ).toEqual a.to_s