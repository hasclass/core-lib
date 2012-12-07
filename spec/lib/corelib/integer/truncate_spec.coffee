describe "Integer#truncate", ->
  #   it_behaves_like(:integer_to_i, :floor)
  it "is an alias to #to_i", ->
    Proto = RubyJS.Integer.prototype
    expect( Proto.truncate ).toEqual Proto.to_i