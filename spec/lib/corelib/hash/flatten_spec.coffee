describe "Hash#flatten", ->

  beforeEach ->
    @h = R.h({
      plato: 'greek',
      witgenstein: ['austrian', 'british'],
      russell: 'welsh'
    })

  it "returns an Array", ->
    expect( R.h({}).flatten() ).toBeInstanceOf(R.Array)

  it "returns an empty Array for an empty Hash", ->
    expect( R.h({}).flatten() ).toEqual R([])

  it "sets each even index of the Array to a key of the Hash", ->
    a = @h.flatten().to_native()
    expect( a[0] ).toEqual 'plato'
    expect( a[2] ).toEqual 'witgenstein'
    expect( a[4] ).toEqual 'russell'

  it "sets each odd index of the Array to the value corresponding to the previous element", ->
    a = @h.flatten().to_native()
    expect( a[1] ).toEqual 'greek'
    expect( a[3] ).toEqual ['austrian', 'british']
    expect( a[5] ).toEqual 'welsh'

  it "does not recursively flatten Array values when called without arguments", ->
    a = @h.flatten().to_native()
    expect( a[3] ).toEqual ['austrian', 'british']

  it "does not recursively flatten Hash values when called without arguments", ->
    @h.set('russell', {born: 'wales', influenced_by: 'mill' })
    a = @h.flatten().to_native()
    expect( a[5] ).toNotEqual ['born', 'wales', 'influenced_by', 'mill' ]
    expect( a[5] ).toEqual {born: 'wales', influenced_by: 'mill' }

  it "recursively flattens Array values when called with an argument >= 2", ->
    a = @h.flatten(2).to_native()
    expect( a[3] ).toEqual 'austrian'
    expect( a[4] ).toEqual 'british'

  it "recursively flattens Array values to the given depth", ->
    @h.set('russell', [['born', 'wales'], ['influenced_by', 'mill']])
    a = @h.flatten(2).to_native()
    expect( a[6] ).toEqual ['born', 'wales']
    expect( a[7] ).toEqual ['influenced_by', 'mill']

  # it "raises an TypeError if given a non-Integer argument", ->
  #   lambda do
  #     @h.flatten(Object.new)
  #   end.should raise_error(TypeError)
