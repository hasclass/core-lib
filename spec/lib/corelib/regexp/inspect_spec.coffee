describe "Regexp#inspect", ->
  it "returns a formatted string that would eval to the same regexp", ->
    expect( R(/ab+c/).inspect() ).toEqual R("/ab+c/")
    expect( R(/ab+c/i).inspect() ).toEqual R("/ab+c/i")
    # /a(.)+s/n.inspect.should =~ %r|/a(.)+s/n?|  # Default 'n' may not appear
    # 1.9 doesn't round-trip the encoding flags, such as 'u'. This is
    # seemingly by design.
    # expect( R(/a(.)+s/m).inspect() ).toEqual R("/a(.)+s/m"     # But a specified one does)

  xit "returns options in the order 'mixn'", ->
    # expect( R(//nixm).inspect() ).toEqual R("//mixn")

  xit "does not include the 'o' option", ->
    # expect( R(//o).inspect() ).toEqual R("//")

  # ruby_version_is ""..."1.9", ->
  #   it "includes the character set code after other options", ->
  #     //xu.inspect.should  == "//xu"
  #     expect( R(//six).inspect() ).toEqual R("//ixs")
  #     //ni.inspect.should  == "//in"

  describe 'ruby_version_is "1.9"', ->
    xit "does not include a character set code", ->
      # expect( R(//u).inspect() ).toEqual R("//")
      # expect( R(//s).inspect() ).toEqual R("//")
      # expect( R(//e).inspect() ).toEqual R("//")

  xit "correctly escapes forward slashes /", ->
    expect( R.Regexp.new("/foo/bar").inspect() ).toEqual R("/\\/foo\\/bar/")
    expect( R.Regexp.new("/foo/bar[/]").inspect() ).toEqual R("/\\/foo\\/bar[\\/]/")

  xit "doesn't over escape forward slashes", ->
    expect( R(/\/foo\/bar/).inspect() ).toEqual R('/\/foo\/bar/')

  xit "escapes 2 slashes in a row properly", ->
    expect( R.Regexp.new("//").inspect() ).toEqual R('/\/\//')

  xit "does not over escape", ->
    expect( R.Regexp.new('\\\/').inspect() ).toEqual R("/\\\\\\//")
