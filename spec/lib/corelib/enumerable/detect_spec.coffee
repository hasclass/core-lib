describe "Enumerable#detect", ->
  it "aliases to #find", ->
    numerous = EnumerableSpecs.Numerous.new()
    expect( numerous.detect ).toBeDefined()
    expect( numerous.detect ).toEqual(numerous.find)
