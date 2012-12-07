describe "String#to_a", ->
  it "returns an empty array for empty strings", ->
    expect(R("").to_a().unbox()).toEqual []

  it "returns an array containing the string for non-empty strings", ->
    expect(R("hello").to_a().unbox()).toNotEqual ["hello"]
    expect(R("hello").to_a().unbox(true)).toEqual ["hello"]
