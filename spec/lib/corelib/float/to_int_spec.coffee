describe "Float#to_int", ->
  it "is alias to #to_i", ->
    proto = R.Float.prototype
    expect( proto.to_int ).toEqual proto.to_i
