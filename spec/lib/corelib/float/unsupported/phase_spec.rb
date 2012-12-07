describe "Float#phase", ->
  it "is alias to #arg", ->
    proto = R.Float.prototype
    expect( proto.phase ).toEqual proto.arg
