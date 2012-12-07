describe "Float#to_i", ->
  #it_behaves_like(:float_to_i, :to_i)
  it "returns self truncated to an Integer", ->
    expect( R(899.2).to_i() ).toEqual(R 899)
    expect( R(5213451.9201).to_i() ).toEqual(R 5213451)
    expect( R(1.233450999123389e+12).to_i() ).toEqual(R 1233450999123)
    expect( R(-9223372036854775808.1).to_i() ).toEqual(R -9223372036854775808)
    expect( R(9223372036854775808.1).to_i() ).toEqual(R 9223372036854775808)
    expect( R(-2.333).to_i() ).toEqual(R -2)

  # TODO solve:
  xit 'BUG', ->
    expect( R(-1.122256e-45).to_i() ).toEqual(R 0)
