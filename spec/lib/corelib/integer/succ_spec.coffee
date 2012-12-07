describe "Integer#succ", ->
  #   it_behaves_like(:integer_to_i, :floor)
  it "is an alias to #next", ->
    Proto = RubyJS.Integer.prototype
    expect( Proto.succ ).toEqual Proto.next