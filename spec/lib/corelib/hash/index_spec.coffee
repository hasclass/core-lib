require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/index', __FILE__)

describe "Hash#index", ->
  it "returns the corresponding key for value", ->
    expect( R.hashify(2: 'a', 1: 'b').index('b') ).toEqual '1'

  it "returns nil if the value is not found", ->
    expect( R.hashify(a: -1, b: 3.14, c: 2.718).index('1') ).toEqual null

  it "doesn't return default value if the value is not found", ->
    expect( R.hashify({}, 5).index(5) ).toEqual null

  it "compares values using ==", ->
    expect( R.hashify(1: 0).index(0.0) ).toEqual '1'
    expect( R.hashify(1: 0.0).index(0) ).toEqual '1'

    # TODO:
    # inhash = {'==': -> true}
    # expect( R.hashify(1: inhash).key("foo") ).toEqual '1'
