describe "Array#concat", ->
  it "returns the array itself", ->
    ary = R [1,2,3]
    expect( ary.concat([4,5,6]) is ary).toEqual true

  it "appends the elements in the other array", ->
    ary = R([1, 2, 3])
    expect( ary.concat([9, 10, 11]) is ary).toEqual true
    expect( ary ).toEqual R([1, 2, 3, 9, 10, 11])
    ary.concat([])
    expect( ary ).toEqual R([1, 2, 3, 9, 10, 11])

  it "does not loop endlessly when argument is self", ->
    ary = R(["x", "y"])
    expect( ary.concat(ary) ).toEqual R(["x", "y", "x", "y"])

  it "tries to convert the passed argument to an Array using #to_ary", ->
    obj =
      to_ary: -> R(["x", "y"])
    expect( R([4, 5, 6]).concat(obj) ).toEqual R([4, 5, 6, "x", "y"])

  xit "does not call #to_ary on Array subclasses", ->
    # obj = ArraySpecs.ToAryArray[5, 6, 7]
    # obj.should_not_receive(:to_ary)
    # [].concat(obj).should == [5, 6, 7]

  # ruby_version_is ""..."1.9", ->
  #   it "raises a TypeError when Array is frozen and modification occurs", ->
  #     expect( -> ArraySpecs.frozen_array.concat [1] ).toThrow(TypeError)

  #   it "does not raise a TypeError when Array is frozen but no modification occurs", ->
  #     ArraySpecs.frozen_array.concat([]).should == [1, 2, 3]

  # ruby_version_is "1.9", ->
  #   it "raises a RuntimeError when Array is frozen and modification occurs", ->
  #     expect( -> ArraySpecs.frozen_array.concat [1] ).toThrow(RuntimeError)

  #   # see [ruby-core:23666]
  #   it "raises a RuntimeError when Array is frozen and no modification occurs", ->
  #     expect( -> ArraySpecs.frozen_array.concat([]) ).toThrow(RuntimeError)

  # it "keeps tainted status", ->
  #   ary = [1, 2]
  #   ary.taint
  #   ary.concat([3])
  #   ary.tainted?.should be_true
  #   ary.concat([])
  #   ary.tainted?.should be_true

  # it "is not infected by the other", ->
  #   ary = [1,2]
  #   other = [3]; other.taint
  #   ary.tainted?.should be_false
  #   ary.concat(other)
  #   ary.tainted?.should be_false

  # it "keeps the tainted status of elements", ->
  #   ary = [ Object.new, Object.new, Object.new ]
  #   ary.each {|x| x.taint }

  #   ary.concat([ Object.new ])
  #   ary[0].tainted?.should be_true
  #   ary[1].tainted?.should be_true
  #   ary[2].tainted?.should be_true
  #   ary[3].tainted?.should be_false

  # ruby_version_is '1.9' do
  #   it "keeps untrusted status", ->
  #     ary = [1, 2]
  #     ary.untrust
  #     ary.concat([3])
  #     ary.untrusted?.should be_true
  #     ary.concat([])
  #     ary.untrusted?.should be_true

  #   it "is not infected untrustedness by the other", ->
  #     ary = [1,2]
  #     other = [3]; other.untrust
  #     ary.untrusted?.should be_false
  #     ary.concat(other)
  #     ary.untrusted?.should be_false

  #   it "keeps the untrusted status of elements", ->
  #     ary = [ Object.new, Object.new, Object.new ]
  #     ary.each {|x| x.untrust }

  #     ary.concat([ Object.new ])
  #     ary[0].untrusted?.should be_true
  #     ary[1].untrusted?.should be_true
  #     ary[2].untrusted?.should be_true
  #     ary[3].untrusted?.should be_false
