describe "Array#clone", ->
  xit "copies frozen status from the original", ->
    # a = [1, 2, 3, 4]
    # b = [1, 2, 3, 4]
    # a.freeze
    # aa = a.clone
    # bb = b.clone

    # aa.frozen?.should == true
    # bb.frozen?.should == false

  it "copies singleton methods", ->
    # a = [1, 2, 3, 4]
    # b = [1, 2, 3, 4]
    # def a.a_singleton_method; end
    # aa = a.clone
    # bb = b.clone

    # a.respond_to?(:a_singleton_method).should be_true
    # b.respond_to?(:a_singleton_method).should be_false
    # aa.respond_to?(:a_singleton_method).should be_true
    # bb.respond_to?(:a_singleton_method).should be_false

  xit "returns an Array or a subclass instance", ->
    # [].send(@method).should be_kind_of(Array)
    # ArraySpecs.MyArray[1, 2].send(@method).should be_kind_of(ArraySpecs.MyArray)

  it "produces a shallow copy where the references are directly copied", ->
    a = R([new Object(), new Object()])
    b = a.clone()
    expect( b.first() is a.first()  ).toEqual true
    expect( b.last() is a.last() ).toEqual true

  it "creates a new array containing all elements or the original", ->
    a = R([1, 2, 3, 4])
    b = a.clone()
    expect( b ).toEqual a
    # b.__id__.should_not == a.__id__

  xit "copies taint status from the original", ->
    # a = [1, 2, 3, 4]
    # b = [1, 2, 3, 4]
    # a.taint
    # aa = a.send @method
    # bb = b.send @method

    # aa.tainted?.should == true
    # bb.tainted?.should == false

  # ruby_version_is '1.9' do
    xit "copies untrusted status from the original", ->
      # a = [1, 2, 3, 4]
      # b = [1, 2, 3, 4]
      # a.untrust
      # aa = a.send @method
      # bb = b.send @method

      # aa.untrusted?.should == true
      # bb.untrusted?.should == false
