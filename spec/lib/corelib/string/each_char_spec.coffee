# ruby_version_is '1.8.7' do
describe "String#each_char", ->
  # it_behaves_like(:string_each_char, :each_char)

  it "passes each char in self to the given block", ->
    a = []
    R("hello").each_char( (char) -> a.push(char) )
    expect(a).toEqual ['h', 'e', 'l', 'l', 'o']

  describe "ruby_bug 'redmine #1487', '1.9.1'", ->
    it "returns self", ->
      s = new StringSpecs.MyString "hello"
      expect( s.each_char -> ).toEqual(s)

  it "returns an enumerator when no block given", ->
    enumerator = R("hello").each_char()
    expect( enumerator ).toBeInstanceOf(R.Enumerator)
    expect( enumerator.to_a() ).toEqual R(['h', 'e', 'l', 'l', 'o'])

  xit "is unicode aware", ->
    before = $KCODE
    $KCODE = "UTF-8"
    #"\303\207\342\210\202\303\251\306\222g".send(@method).to_a.should == ["\303\207", "\342\210\202", "\303\251", "\306\222", "g"]
    $KCODE = before

  xdescribe "With encoding", ->
    xit "returns characters in the same encoding as self", ->
      #"&%".force_encoding('Shift_JIS').each_char.to_a.all? {|c| c.encoding.name.should == 'Shift_JIS'}
      #"&%".encode('ASCII-8BIT').each_char.to_a.all? {|c| c.encoding.name.should == 'ASCII-8BIT'}

    xit "works with multibyte characters", ->
      # not on firefox
      #s = "\u{8987}".force_encoding("UTF-8")
      s.bytesize.should == 3
      s.send(@method).to_a.should == [s]

    it "works if the String's contents is invalid for its encoding", ->
      s = "\xA4"
      s.force_encoding('UTF-8')
      s.valid_encoding?.should be_false
      s.send(@method).to_a.should == ["\xA4".force_encoding("UTF-8")]

    xit "returns a different character if the String is transcoded", ->
      # not on firefox
      #s = "\u{20AC}".force_encoding('UTF-8')
      # s.encode('UTF-8').send(@method).to_a.should == ["\u{20AC}".force_encoding('UTF-8')]
      # s.encode('iso-8859-15').send(@method).to_a.should == [
      #   "\xA4".force_encoding('iso-8859-15')]
      # s.encode('iso-8859-15').encode('UTF-8').send(@method).to_a.should == [
      #   "\u{20AC}".force_encoding('UTF-8')]

    xit "uses the String's encoding to determine what characters it contains", ->
      # not on firefox
      #s = "\u{287}"
      s.force_encoding('UTF-8').send(@method).to_a.should == [s.force_encoding('UTF-8')]
      s.force_encoding('BINARY').send(@method).to_a.should == [
        "\xCA".force_encoding('BINARY'), "\x87".force_encoding('BINARY')]
      s.force_encoding('SJIS').send(@method).to_a.should == [
        "\xCA".force_encoding('SJIS'), "\x87".force_encoding('SJIS')]
