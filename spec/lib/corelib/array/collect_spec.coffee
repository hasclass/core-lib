describe "Array#collect", ->
  it "returns a copy of array with each element replaced by the value returned by block", ->
    a = R(['a', 'b', 'c', 'd'])
    b = a.collect (i) -> i + '!'
    expect( b ).toEqual R(["a!", "b!", "c!", "d!"])
    expect( b is a ).toEqual false

  xit "does not return subclass instance", ->
    # ArraySpecs.MyArray[1, 2, 3].collect (x) -> x + 1 }.should be_kind_of(Array)

  it "does not change self", ->
    a = R(['a', 'b', 'c', 'd'])
    b = a.collect (i) -> i + '!'
    expect( a ).toEqual R(['a', 'b', 'c', 'd'])

  xit "returns the evaluated value of block if it broke in the block", ->
    # a = ['a', 'b', 'c', 'd']
    # b = a.collect {|i|
    #   if i == 'c'
    #     break 0
    #   else
    #     i + '!'
    #     }
    # b.should == 0

  # ruby_version_is '' ... '1.9' do
  #   it "returns a copy of self if no block given", ->
  #     a = [1, 2, 3]

  #     copy = a.collect
  #     copy.should == a
  #     copy.should_not equal(a)
  #   ruby_version_is '1.9' do
  #   it "returns an Enumerator when no block given", ->
  #     a = [1, 2, 3]
  #     a.collect.should be_an_instance_of(enumerator_class)

  # it "does not copy tainted status", ->
  #   a = [1, 2, 3]
  #   a.taint
  #   a.collect{|x| x}.tainted?.should be_false

  # ruby_version_is '1.9' do
  #   it "does not copy untrusted status", ->
  #     a = [1, 2, 3]
  #     a.untrust
  #     a.collect{|x| x}.untrusted?.should be_false

describe "Array#collect_bang", ->
  it "replaces each element with the value returned by block", ->
    a = R([7, 9, 3, 5])
    expect(a.collect_bang( (i) -> i - 1 )).toEqual(a)
    expect( a ).toEqual R([6, 8, 2, 4])

  it "returns self", ->
    a = R([1, 2, 3, 4, 5])
    b = a.collect_bang (i) -> i + 1
    expect( b is a ).toEqual true

  xit "returns the evaluated value of block but its contents is partially modified, if it broke in the block", ->
    # a = ['a', 'b', 'c', 'd']
    # b = a.collect_bang {|i|
    #   if i == 'c'
    #     break 0
    #   else
    #     i + '!'
    #     }
    # b.should == 0
    # a.should == ['a!', 'b!', 'c', 'd']


  describe "ruby_version_is '1.8.7'", ->
    it "returns an Enumerator when no block given, and the enumerator can modify the original array", ->
      a = R([1, 2, 3])
      en = a.collect_bang()
      expect( en ).toBeInstanceOf R.Enumerator
      en.each (i) -> "#{i}!"
      expect( a ).toEqual R(["1!", "2!", "3!"])

  xdescribe "tainted trusted", ->
    # it "keeps tainted status", ->
    #   a = [1, 2, 3]
    #   a.taint
    #   a.tainted?.should be_true
    #   a.collect{|x| x}
    #   a.tainted?.should be_true

    # ruby_version_is '1.9' do
    #   it "keeps untrusted status", ->
    #     a = [1, 2, 3]
    #     a.untrust
    #     a.collect{|x| x}
    #     a.untrusted?.should be_true

  xdescribe "when frozen", ->
    # ruby_version_is '' ... '1.9' do
    #   it "raises a TypeError", ->
    #     expect( -> ArraySpecs.frozen_array.collect {} ).toThrow(TypeError)

    #   it "raises a TypeError when empty", ->
    #     expect( -> ArraySpecs.empty_frozen_array.collect {} ).toThrow(TypeError)

    #   ruby_version_is '1.8.7' do
    #     it "raises a TypeError when calling #each on the returned Enumerator", ->
    #       enumerator = ArraySpecs.frozen_array.collect
    #       expect( -> enumerator.each {|x| x } ).toThrow(TypeError)

    #     it "raises a TypeError when calling #each on the returned Enumerator when empty", ->
    #       enumerator = ArraySpecs.empty_frozen_array.collect
    #       expect( -> enumerator.each {|x| x } ).toThrow(TypeError)

    # ruby_version_is '1.9' do
    #   it "raises a RuntimeError", ->
    #     expect( -> ArraySpecs.frozen_array.collect {} ).toThrow(RuntimeError)

    #   it "raises a RuntimeError when empty", ->
    #     expect( -> ArraySpecs.empty_frozen_array.collect {} ).toThrow(RuntimeError)

    #   it "raises a RuntimeError when calling #each on the returned Enumerator", ->
    #     enumerator = ArraySpecs.frozen_array.collect
    #     expect( -> enumerator.each {|x| x } ).toThrow(RuntimeError)

    #   it "raises a RuntimeError when calling #each on the returned Enumerator when empty", ->
    #     enumerator = ArraySpecs.empty_frozen_array.collect
    #     expect( -> enumerator.each {|x| x } ).toThrow(RuntimeError)
    #

  # ruby_version_is '' ... '1.8.7' do
  #   it "raises LocalJumpError if no block given", ->
  #     a = [1, 2, 3]
  #     expect( -> a.collect ).toThrow(LocalJumpError)
