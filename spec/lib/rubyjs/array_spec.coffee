describe "Array#minmax", ->
  it "should find min,max", ->
    expect( R([1,8,3]).minmax() ).toEqual R([1,8])

describe "Array#min, #max", ->
  it "should not return wrapped values", ->
    expect( R([1,18,3]).min() ).toEqual 1
    expect( R([1,18,3]).max() ).toEqual 18

  it "throws error when mixing natives", ->
    expect( -> R([1,'18',3]).min()).toThrow('ArgumentError')
    expect( -> R([1,'18',3]).max()).toThrow('ArgumentError')

  it "throws error when mixing natives on to_enum", ->
    expect( -> R([1,'18',3]).to_enum().min()).toThrow('ArgumentError')
    expect( -> R([1,'18',3]).to_enum().max()).toThrow('ArgumentError')

describe "Array#min_by, #max_by", ->
  it "compares natives", ->
    expect( R([1,18,3]).min_by((w) -> w ) ).toEqual 1
    expect( R([1,18,3]).max_by((w) -> w ) ).toEqual 18

  it "compares rubyjs", ->
    expect( R([1,18,3]).min_by((w) -> R(w) ) ).toEqual 1
    expect( R([1,18,3]).max_by((w) -> R(w) ) ).toEqual 18

  it "throws error when mixing natives", ->
    expect( -> R([1,'18']).min_by((w) -> w ) ).toThrow("ArgumentError")
    expect( -> R([1,'18']).max_by((w) -> w ) ).toThrow("ArgumentError")

  it "throws error when mixing natives on to_enum", ->
    expect( -> R([1,'18']).to_enum().min_by((w) -> w ) ).toThrow("ArgumentError")
    expect( -> R([1,'18']).to_enum().max_by((w) -> w ) ).toThrow("ArgumentError")
