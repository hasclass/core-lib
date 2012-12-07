describe "Float#fdiv", ->
  it "is alias to #quo", ->
    proto = R.Float.prototype
    expect( proto.fdiv ).toEqual proto.quo
