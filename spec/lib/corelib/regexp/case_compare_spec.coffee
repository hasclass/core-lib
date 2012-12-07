describe "Regexp#===", ->
  it "is true if there is a match", ->
    expect(R(/abc/)['==='] "aabcc").toEqual true

  it "is false if there is no match", ->
    expect(R(/abc/)['==='] "xyz").toEqual false

  xdescribe 'ruby_version_is "1.9"', ->
    it "returns true if it matches a Symbol", ->
      # expect(R(/a/)['==='] :a).toEqual true

    it "returns false if it does not match a Symbol", ->
      # expect(R(/a/)['==='] :b).toEqual false
