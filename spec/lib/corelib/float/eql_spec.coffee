describe "Float#eql?", ->
  it "returns true if other is a Float equal to self", ->
    expect( R.$Float(0.0).eql(R.$Float(0.0))  ).toEqual true

  it "returns false if other is a Float not equal to self", ->
    expect( R.$Float(1.0).eql(1.1)  ).toEqual false

  it "returns false if other is not a Float", ->
    expect( R.$Float(1.0).eql(1)   ).toEqual false
    expect( R.$Float(1.0).eql([])  ).toEqual false
