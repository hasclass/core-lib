# DEPRECATED!
describe "String#to_a", ->
  xit "returns an empty array for empty strings", ->
    expect(R("").to_a().valueOf()).toEqual []

  xit "returns an array containing the string for non-empty strings", ->
    expect(R("hello").to_a().valueOf()).toNotEqual ["hello"]
    expect(R("hello").to_a().unbox(true)).toEqual ["hello"]
