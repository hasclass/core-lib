describe "Array#clear", ->
  it "removes all elements", ->
    a = R [1, 2, 3, 4]
    expect( a.clear() == a).toEqual true
    expect( a.empty()     ).toEqual true


  it "returns self", ->
    a = R [1]
    expect( a.clear() == a).toEqual true

  it "leaves the Array empty", ->
    a = R [1]
    a.clear()

    expect( a.empty()     ).toEqual true
    expect( +a.size()     ).toEqual 0


  it "does not accept any arguments", ->
    expect( -> R([1]).clear(true) ).toThrow("ArgumentError")

  xdescribe 'unsupported', ->
  # it "keeps tainted status", ->
  #   a = R [1]
  #   a.taint
  #   a.tainted?.should be_true
  #   a.clear
  #   a.tainted?.should be_true

  # ruby_version_is '1.9' do
  #   it "keeps untrusted status", ->
  #     a = R [1]
  #     a.untrust
  #     a.untrusted?.should be_true
  #     a.clear
  #     a.untrusted?.should be_true

  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     a = R [1]
  #     a.freeze
  #     lambda { a.clear }.should raise_error(TypeError)

  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     a = R [1]
  #     a.freeze
  #     lambda { a.clear }.should raise_error(RuntimeError)
