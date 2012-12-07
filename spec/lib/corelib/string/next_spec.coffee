describe "String#next", ->
  it "is alias to #succ", ->
    proto = R.String.prototype
    expect( proto.next ).toEqual proto.succ

describe "String#next!", ->
  it "is alias to #succ", ->
    proto = R.String.prototype
    expect( proto.next_bang ).toEqual proto.succ_bang
