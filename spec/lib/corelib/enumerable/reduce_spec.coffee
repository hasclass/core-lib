describe "Enumerable#reduce", ->
    # it_behaves_like :enumerable_inject, :reduce
  it "aliases to inject", ->
    expect( R.Enumerable.reduce ).toEqual R.Enumerable.inject
