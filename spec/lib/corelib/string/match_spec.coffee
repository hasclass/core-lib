describe "String#=~", ->
  xit "behaves the same way as index() when given a regexp", ->
    expect( R("rudder")['=~'](/udder/   ) ).toEqual R("rudder").index(/udder/)
    expect( R("boat"  )['=~'](/[^fl]oat/) ).toEqual R("boat").index(/[^fl]oat/)
    expect( R("bean"  )['=~'](/bag/     ) ).toEqual R("bean").index(/bag/)
    expect( R("true"  )['=~'](/false/   ) ).toEqual R("true").index(/false/)

  it "raises a TypeError if a obj is a string", ->
    expect( -> R("some string")['=~']("another string"   ) ).toThrow('TypeError')
    expect( -> R("some string")['=~'](R("another string")) ).toThrow('TypeError')
    expect( -> R("a")['=~'](new StringSpecs.MyString("b")) ).toThrow('TypeError')

  it "invokes obj.=~ with self if obj is neither a string nor regexp", ->
    # str = "w00t"
    # obj = {}

    # obj.should_receive(:=~).with(str).any_number_of_times.and_return(true)
    # str.should.match obj

    # obj = mock('y')
    # obj.should_receive(:=~).with(str).any_number_of_times.and_return(false)
    # str.should_not.match obj

  it "sets $~ to MatchData when there is a match and nil when there's none", ->
    R('hello')['=~'](/./)
    expect( R['$~'][0] ).toEqual 'h'

    R('hello')['=~'](/not/)
    expect( R['$~'] ).toEqual null

describe "String#match", ->
  it "matches the pattern against self", ->
    expect( R('hello').match(/(.)\1/)[0] ).toEqual 'll'

  describe 'ruby_version_is "1.9"', ->
    it "matches the pattern against self starting at an optional index", ->
      expect( R("hello").match(/(.+)/,2)[0] ).toEqual 'llo'

    describe "when passed a block", ->
      it "yields the MatchData", ->
        scratch = []
        R("abc").match /./, (m) -> scratch.push m
        expect( scratch[0] ).toBeInstanceOf(R.MatchData)

      it "returns the block result", ->
        expect( R("abc").match(/./, -> "result") ).toEqual 'result'

      it "does not yield if there is no match", ->
        scratch = []
        R("b").match /a/, (m) -> scratch.push m
        expect( scratch ).toEqual []

  it "tries to convert pattern to a string via to_str", ->
    obj =
      to_str: () -> R(".")
    expect( R("hello").match(obj)[0] ).toEqual "h"

    # TODO
    # obj = mock('.')
    # def obj.respond_to?(type, *) true     def obj.method_missing(*args) "."
    # "hello".match(obj)[0].should == "h"

  it "raises a TypeError if pattern is not a regexp or a string", ->
    expect( -> R("hello").match 10    ).toThrow('TypeError')
    expect( -> R("hello").match R(10) ).toThrow('TypeError')
    expect( -> R("hello").match {}    ).toThrow('TypeError')

  xit "converts string patterns to regexps without escaping", ->
    # octal escape sequences "(.)\1" are not allowed on line 69
    # expect( R('hello').match("(.)\1")[0] ).toEqual 'll'

  it "returns nil if there's no match", ->
    expect( R('hello').match('xx') ).toEqual null

  xit "matches \\G at the start of the string", ->
    expect( R('hello').match(/\Gh/)[0] ).toEqual 'h'
    expect( R('hello').match(/\Go/) ).toEqual null

  it "sets $~ to MatchData of match or nil when there is none", ->
    R('hello').match(/./)
    expect( R['$~'][0] ).toEqual 'h'
    expect( R.Regexp.last_match()[0] ).toEqual 'h'

    R('hello').match(/X/)
    expect( R['$~'] ).toEqual null
    expect( R.Regexp.last_match() ).toEqual null

  it "sets $~ to MatchData of match or when block is given", ->
    R('hello').match(/./, -> 'foo')
    expect( R['$~'][0] ).toEqual 'h'
