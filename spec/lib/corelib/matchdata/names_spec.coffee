describe "MatchData#names", ->
  it "returns an Array", ->
    expect( -> R(/foo/).match("foo").names() ).toThrow('NotSupportedError')


# require File.expand_path('../../../spec_helper', __FILE__)

# language_version __FILE__, "names"
