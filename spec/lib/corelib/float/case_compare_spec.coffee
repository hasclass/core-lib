describe "Float#===", ->
  it "is alias to #==", ->
    proto = R.Float.prototype
    expect( proto['==='] ).toEqual proto['==']
    expect( proto.equal_case ).toEqual proto.equals
