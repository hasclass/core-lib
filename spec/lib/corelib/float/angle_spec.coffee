describe "Float#angle", ->
  it "is alias to #arg", ->
    proto = R.Float.prototype
    expect( proto.angle ).toEqual proto.arg
