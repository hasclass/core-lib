describe :array_clone, :shared => true do
  it "returns an Array or a subclass instance", ->
    [].send(@method).should be_kind_of(Array)
    ArraySpecs.MyArray[1, 2].send(@method).should be_kind_of(ArraySpecs.MyArray)

  it "produces a shallow copy where the references are directly copied", ->
    a = [mock('1'), mock('2')]
    b = a.send @method
    b.first.object_id.should == a.first.object_id
    b.last.object_id.should == a.last.object_id

  it "creates a new array containing all elements or the original", ->
    a = [1, 2, 3, 4]
    b = a.send @method
    b.should == a
    b.__id__.should_not == a.__id__

  it "copies taint status from the original", ->
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    a.taint
    aa = a.send @method
    bb = b.send @method

    aa.tainted?.should == true
    bb.tainted?.should == false

  ruby_version_is '1.9' do
    it "copies untrusted status from the original", ->
      a = [1, 2, 3, 4]
      b = [1, 2, 3, 4]
      a.untrust
      aa = a.send @method
      bb = b.send @method

      aa.untrusted?.should == true
      bb.untrusted?.should == false
