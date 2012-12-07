describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#first", ->
    it "returns the first element", ->
      expect( EnumerableSpecs.Numerous.new().first() ).toEqual R(2)
      expect( EnumerableSpecs.Empty.new().first()    ).toEqual null

    it "returns nil if self is empty", ->
      expect( EnumerableSpecs.Empty.new().first()    ).toEqual null

    # describe "when passed an argument", ->
    #   it_behaves_like :enumerable_take, :first
