describe "Float#truncate", ->
  it "is alias to #to_i", ->
    proto = R.Float.prototype
    expect( proto.truncate ).toEqual proto.to_i
