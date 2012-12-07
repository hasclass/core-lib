describe "Regexp.escape", ->
  # it_behaves_like :regexp_quote, :escape
  # -*- encoding: ascii-8bit -*-

  it "escapes any characters with special meaning in a regular expression", ->
    expect( R.Regexp.escape("\*?{}.+^[]()- ") ).toEqual '\\*\\?\\{\\}\\.\\+\\^\\[\\]\\(\\)\\-\\ '
    expect( R.Regexp.escape("\n\r\f\t") ).toEqual '\\n\\r\\f\\t'
    # DOCUMENT: single and double quotes act the same in JS
    # expect( R.Regexp.quote('\*?{}.+^[]()- ') ).toEqual '\\\\\*\?\{\}\.\+\^\[\]\(\)\-\\ '
    # expect( R.Regexp.quote('\n\r\f\t') ).toEqual '\\\\n\\\\r\\\\f\\\\t'
