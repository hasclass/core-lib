describe "Integer#to_int", ->
  #   it_behaves_like(:integer_to_i, :floor)
  it "is an alias to #to_i", ->
    Proto = RubyJS.Integer.prototype
    expect( Proto.to_int ).toEqual Proto.to_i