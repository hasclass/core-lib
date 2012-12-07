describe :array_collect, :shared => true do
  it "returns a copy of array with each element replaced by the value returned by block", ->
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    b.should == ["a!", "b!", "c!", "d!"]
    b.object_id.should_not == a.object_id

  it "does not return subclass instance", ->
    ArraySpecs.MyArray[1, 2, 3].send(@method) { |x| x + 1 }.should be_kind_of(Array)

  it "does not change self", ->
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    a.should == ['a', 'b', 'c', 'd']

  it "returns the evaluated value of block if it broke in the block", ->
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
        }
    b.should == 0

  ruby_version_is '' ... '1.9' do
    it "returns a copy of self if no block given", ->
      a = [1, 2, 3]

      copy = a.send(@method)
      copy.should == a
      copy.should_not equal(a)
    ruby_version_is '1.9' do
    it "returns an Enumerator when no block given", ->
      a = [1, 2, 3]
      a.send(@method).should be_an_instance_of(enumerator_class)
  
  it "does not copy tainted status", ->
    a = [1, 2, 3]
    a.taint
    a.send(@method){|x| x}.tainted?.should be_false

  ruby_version_is '1.9' do
    it "does not copy untrusted status", ->
      a = [1, 2, 3]
      a.untrust
      a.send(@method){|x| x}.untrusted?.should be_false

describe :array_collect_b, :shared => true do
  it "replaces each element with the value returned by block", ->
    a = [7, 9, 3, 5]
    a.send(@method) { |i| i - 1 }.should equal(a)
    a.should == [6, 8, 2, 4]

  it "returns self", ->
    a = [1, 2, 3, 4, 5]
    b = a.send(@method) {|i| i+1 }
    a.object_id.should == b.object_id

  it "returns the evaluated value of block but its contents is partially modified, if it broke in the block", ->
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
        }
    b.should == 0
    a.should == ['a!', 'b!', 'c', 'd']

  ruby_version_is '' ... '1.8.7' do
    it "raises LocalJumpError if no block given", ->
      a = [1, 2, 3]
      expect( -> a.send(@method) ).toThrow(LocalJumpError)
  
  ruby_version_is '1.8.7' do
    it "returns an Enumerator when no block given, and the enumerator can modify the original array", ->
      a = [1, 2, 3]
      enum = a.send(@method)
      enum.should be_an_instance_of(enumerator_class)
      enum.each{|i| "#{i}!" }
      a.should == ["1!", "2!", "3!"]
  
  it "keeps tainted status", ->
    a = [1, 2, 3]
    a.taint
    a.tainted?.should be_true
    a.send(@method){|x| x}
    a.tainted?.should be_true

  ruby_version_is '1.9' do
    it "keeps untrusted status", ->
      a = [1, 2, 3]
      a.untrust
      a.send(@method){|x| x}
      a.untrusted?.should be_true
  
  describe "when frozen", ->
    ruby_version_is '' ... '1.9' do
      it "raises a TypeError", ->
        expect( -> ArraySpecs.frozen_array.send(@method) {} ).toThrow(TypeError)
    
      it "raises a TypeError when empty", ->
        expect( -> ArraySpecs.empty_frozen_array.send(@method) {} ).toThrow(TypeError)
    
      ruby_version_is '1.8.7' do
        it "raises a TypeError when calling #each on the returned Enumerator", ->
          enumerator = ArraySpecs.frozen_array.send(@method)
          expect( -> enumerator.each {|x| x } ).toThrow(TypeError)
      
        it "raises a TypeError when calling #each on the returned Enumerator when empty", ->
          enumerator = ArraySpecs.empty_frozen_array.send(@method)
          expect( -> enumerator.each {|x| x } ).toThrow(TypeError)
            
    ruby_version_is '1.9' do
      it "raises a RuntimeError", ->
        expect( -> ArraySpecs.frozen_array.send(@method) {} ).toThrow(RuntimeError)
    
      it "raises a RuntimeError when empty", ->
        expect( -> ArraySpecs.empty_frozen_array.send(@method) {} ).toThrow(RuntimeError)
    
      it "raises a RuntimeError when calling #each on the returned Enumerator", ->
        enumerator = ArraySpecs.frozen_array.send(@method)
        expect( -> enumerator.each {|x| x } ).toThrow(RuntimeError)
    
      it "raises a RuntimeError when calling #each on the returned Enumerator when empty", ->
        enumerator = ArraySpecs.empty_frozen_array.send(@method)
        expect( -> enumerator.each {|x| x } ).toThrow(RuntimeError)
    