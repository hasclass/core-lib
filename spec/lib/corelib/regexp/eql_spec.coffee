describe "Regexp#eql>", ->
  # it_behaves_like :regexp_eql, :eql?

  # TODO: test alias

  # it_behaves_like :regexp_eql, :==

  it "is true if self and other have the same pattern", ->
    expect( R(/abc/).eql(/abc/) ).toEqual true
    expect( R(/abc/).eql(/abd/) ).toEqual false

  xit "is true if self and other have the same character set code", ->
    # expect( R(/abc/ ).eql(/abc/x) ).toEqual false
    # expect( R(/abc/x).eql(/abc/x) ).toEqual true
    # expect( R(/abc/u).eql(/abc/n) ).toEqual false
    # expect( R(/abc/u).eql(/abc/u) ).toEqual true
    # expect( R(/abc/n).eql(/abc/n) ).toEqual true

  it "is true if other has the same #casefold? values", ->
    expect( R(/abc/).eql(/abc/i) ).toEqual false
    expect( R(/abc/i).eql(/abc/i) ).toEqual true

  xit "is true if self does not specify /n option and other does", ->
    # expect( R(//).eql(//n) ).toEqual true

  xit "is true if self specifies /n option and other does not", ->
    # expect( R(//n).eql(//) ).toEqual true
