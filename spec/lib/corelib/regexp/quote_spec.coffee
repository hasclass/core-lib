describe "Regexp.quote", ->
  # it_behaves_like :regexp_quote, :quote
  # -*- encoding: ascii-8bit -*-

  it "escapes any characters with special meaning in a regular expression", ->
    expect( R.Regexp.quote("\*?{}.+^[]()- ") ).toEqual '\\*\\?\\{\\}\\.\\+\\^\\[\\]\\(\\)\\-\\ '
    expect( R.Regexp.quote("\n\r\f\t") ).toEqual '\\n\\r\\f\\t'
    # DOCUMENT: single and double quotes act the same in JS
    # expect( R.Regexp.quote('\*?{}.+^[]()- ') ).toEqual '\\\\\*\?\{\}\.\+\^\[\]\(\)\-\\ '
    # expect( R.Regexp.quote('\n\r\f\t') ).toEqual '\\\\n\\\\r\\\\f\\\\t'

  # DOCUMENT: no encoding
  # ruby_version_is "1.9", ->
  #   it "sets the encoding of the result to US-ASCII if there are only US-ASCII characters present in the input String", ->
  #     str = encode("abc", "euc-jp")
  #     expect( R.Regexp.quote(str).encoding ).toEqual Encoding::US_ASCII

  #   it "sets the encoding of the result to the encoding of the String if any non-US-ASCII characters are present in an input String with valid encoding", ->
  #     str = encode("ありがとう", "utf-8")
  #     str.valid_encoding?.should be_true
  #     expect( R.Regexp.quote(str).encoding ).toEqual Encoding::UTF_8

  #   it "sets the encoding of the result to ASCII-8BIT if any non-US-ASCII characters are present in an input String with invalid encoding", ->
  #     str = "\xff".force_encoding "us-ascii"
  #     str.valid_encoding?.should be_false
  #     expect( R.Regexp.quote("\xff").encoding ).toEqual Encoding::ASCII_8BIT
