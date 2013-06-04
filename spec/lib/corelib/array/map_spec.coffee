describe "Array#map", ->

  it "checks array hasn't changed", ->
    x = R([1, 2, 3])
    a = x.map((item) -> x.clear(); item )
    expect( a.to_native() ).toEqual([1])

  it "checks array hasn't changed from outside", ->
    b = [1, 2, 3]
    x = R(b)
    a = x.map((item) -> b.length = 0; item)
    expect( a.to_native() ).toEqual([1])

  it "returns a copy of array with each element replaced by the value returned by block", ->
    a = R ['a', 'b', 'c', 'd']
    b = a.map (i) ->
      i + '!'
    expect( b.valueOf() ).toEqual ["a!", "b!", "c!", "d!"]
    expect( b == a).toEqual false

  xit "does not return subclass instance", ->
    # ArraySpecs::MyArray[1, 2, 3].map (i) ->
    #   x + 1 }.should be_kind_of(Array)

  it "does not change self", ->
    a = R ['a', 'b', 'c', 'd']
    b = a.map (i) ->
      i + '!'
    expect( a.valueOf() ).toEqual ['a', 'b', 'c', 'd']

  it "returns the evaluated value of block if it broke in the block", ->
    a = R ['a', 'b', 'c', 'd']
    b = R.catch_break (breaker) ->
      a.map (i) ->
        if i == 'c'
          breaker.break(0)
        else
          i + '!'
    expect( b ).toEqual 0

#   ruby_version_is '' ... '1.9' do
#     it "returns a copy of self if no block given", ->
#       a = R [1, 2, 3]

#       copy = a.send(@method)
#       copy.should == a
#       copy.should_not equal(a)
#     ruby_version_is '1.9' do
#     it "returns an Enumerator when no block given", ->
#       a = R [1, 2, 3]
#       a.send(@method).should be_an_instance_of(enumerator_class)

#   it "does not copy tainted status", ->
#     a = R [1, 2, 3]
#     a.taint
#     a.send(@method){|x| x}.tainted?.should be_false

#   ruby_version_is '1.9' do
#     it "does not copy untrusted status", ->
#       a = R [1, 2, 3]
#       a.untrust
#       a.send(@method){|x| x}.untrusted?.should be_false
#   end

# describe :array_collect_b, :shared => true do
#   it "replaces each element with the value returned by block", ->
#     a = R [7, 9, 3, 5]
#     a.send(@method) { |i| i - 1 }.should equal(a)
#     a.should == [6, 8, 2, 4]

#   it "returns self", ->
#     a = R [1, 2, 3, 4, 5]
#     b = a.send(@method) {|i| i+1 }
#     a.object_id.should == b.object_id

#   it "returns the evaluated value of block but its contents is partially modified, if it broke in the block", ->
#     a = R ['a', 'b', 'c', 'd']
#     b = a.send(@method) {|i|
#       if i == 'c'
#         break 0
#       else
#         i + '!'
#         }
#     b.should == 0
#     a.should == ['a!', 'b!', 'c', 'd']

#   ruby_version_is '' ... '1.8.7' do
#     it "raises LocalJumpError if no block given", ->
#       a = R [1, 2, 3]
#       lambda { a.send(@method) }.should raise_error(LocalJumpError)

#   ruby_version_is '1.8.7' do
#     it "returns an Enumerator when no block given, and the enumerator can modify the original array", ->
#       a = R [1, 2, 3]
#       enum = a.send(@method)
#       enum.should be_an_instance_of(enumerator_class)
#       enum.each{|i| "#{i}!" }
#       a.should == ["1!", "2!", "3!"]

#   it "keeps tainted status", ->
#     a = R [1, 2, 3]
#     a.taint
#     a.tainted?.should be_true
#     a.send(@method){|x| x}
#     a.tainted?.should be_true

#   ruby_version_is '1.9' do
#     it "keeps untrusted status", ->
#       a = R [1, 2, 3]
#       a.untrust
#       a.send(@method){|x| x}
#       a.untrusted?.should be_true

#   describe "when frozen", ->
#     ruby_version_is '' ... '1.9' do
#       it "raises a TypeError", ->
#         lambda { ArraySpecs.frozen_array.send(@method) {} }.should raise_error(TypeError)

#       it "raises a TypeError when empty", ->
#         lambda { ArraySpecs.empty_frozen_array.send(@method) {} }.should raise_error(TypeError)

#       ruby_version_is '1.8.7' do
#         it "raises a TypeError when calling #each on the returned Enumerator", ->
#           enumerator = ArraySpecs.frozen_array.send(@method)
#           lambda { enumerator.each {|x| x } }.should raise_error(TypeError)

#         it "raises a TypeError when calling #each on the returned Enumerator when empty", ->
#           enumerator = ArraySpecs.empty_frozen_array.send(@method)
#           lambda { enumerator.each {|x| x } }.should raise_error(TypeError)

#     ruby_version_is '1.9' do
#       it "raises a RuntimeError", ->
#         lambda { ArraySpecs.frozen_array.send(@method) {} }.should raise_error(RuntimeError)

#       it "raises a RuntimeError when empty", ->
#         lambda { ArraySpecs.empty_frozen_array.send(@method) {} }.should raise_error(RuntimeError)

#       it "raises a RuntimeError when calling #each on the returned Enumerator", ->
#         enumerator = ArraySpecs.frozen_array.send(@method)
#         lambda { enumerator.each {|x| x } }.should raise_error(RuntimeError)

#       it "raises a RuntimeError when calling #each on the returned Enumerator when empty", ->
#         enumerator = ArraySpecs.empty_frozen_array.send(@method)
#         lambda { enumerator.each {|x| x } }.should raise_error(RuntimeError)
