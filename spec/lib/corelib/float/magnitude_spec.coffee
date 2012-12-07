describe "Float#magnitude", ->
  it "is alias to #abs", ->
    proto = R.Float.prototype
    expect( proto.magnitude ).toEqual proto.abs
