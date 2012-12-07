
describe "Regexp#=~", ->
  it "returns nil if there is no match", ->
    expect( R(/xyz/)['=~']("abxyc") ).toEqual null

  it "returns nil if the object is nil", ->
    expect( R(/\w+/)['=~'](null) ).toEqual null

  it "returns the index of the first character of the matching region", ->
    expect( R(/(.)(.)(.)/)['=~']("abc")).toEqual R(0)

describe "Regexp#match", ->
  it "returns nil if there is no match", ->
    expect( R(/xyz/).match("abxyc") ).toEqual null

  it "returns nil if the object is nil", ->
    expect( R(/\w+/).match( null) ).toEqual null

  it "returns a MatchData object", ->
    expect( R(/(.)(.)(.)/).match("abc") ).toBeInstanceOf(R.MatchData)

  describe 'ruby_version_is "1.9"', ->
    it "matches the input at a given position", ->
      expect( R(/./).match("abc", 1).begin(0) ).toEqual R(1)

    describe "when passed a block", ->
      it "yields the MatchData", ->
        record = []
        R(/./).match("abc", (m) -> record.push m)
        expect( record[0] ).toBeInstanceOf(R.MatchData)

      it "returns the block result", ->
        expect( R(/./).match("abc", -> 'result') ).toEqual 'result'

      it "does not yield if there is no match", ->
        record =  []
        R(/a/).match("b", (m) -> record.push(m))
        expect( record ).toEqual []

  it "resets $~ if passed nil", ->
    # set $~
    R(/./).match("a")
    expect( R['$~'] ).toBeInstanceOf(R.MatchData)

    R(/1/).match(null)
    expect( R['$~'] ).toEqual null

  it "raises TypeError when the given argument cannot be coarce to String", ->
    f = 1
    expect( -> R(/foo/).match(f)[0] ).toThrow('TypeError')

  # ruby_version_is ""..."1.9", ->
  #   it "coerces Exceptions into strings", ->
  #     f = Exception.new("foo")
  #     expect( R(/foo/).match(f)[0] ).toEqual "foo"

  describe 'ruby_version_is "1.9"', ->
    xit "raises TypeError when the given argument is an Exception", ->
      f = Exception.new("foo")
      expect( -> R(/foo/).match(f)[0] ).toThrow('TypeError')

describe "Regexp#~", ->
  # it "matches against the contents of $_", ->
  #   $_ = "input data"
  #   expect( (~ /at/) ).toEqual 7
