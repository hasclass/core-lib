describe "Regexp#==", ->
  # TODO: test alias

  # it_behaves_like :regexp_eql, :==

  it "is true if self and other have the same pattern", ->
    expect( R(/abc/)['=='](/abc/) ).toEqual true
    expect( R(/abc/)['=='](/abd/) ).toEqual false

  xit "is true if self and other have the same character set code", ->
    # expect( R(/abc/ )['=='](/abc/x) ).toEqual false
    # expect( R(/abc/x)['=='](/abc/x) ).toEqual true
    # expect( R(/abc/u)['=='](/abc/n) ).toEqual false
    # expect( R(/abc/u)['=='](/abc/u) ).toEqual true
    # expect( R(/abc/n)['=='](/abc/n) ).toEqual true

  it "is true if other has the same #casefold? values", ->
    expect( R(/abc/)['=='](/abc/i) ).toEqual false
    expect( R(/abc/i)['=='](/abc/i) ).toEqual true

  it "is aliased by equals", ->
    expect( R(/abc/).equals(/abc/) ).toEqual true
    expect( R(/abc/).equals(/abd/) ).toEqual false

  xit "is true if self does not specify /n option and other does", ->
    # expect( R(//)['=='](//n) ).toEqual true

  xit "is true if self specifies /n option and other does not", ->
    # expect( R(//n)['=='](//) ).toEqual true
