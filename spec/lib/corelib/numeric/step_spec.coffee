class ScratchPadKlass
  append: (obj) -> @arr.push(obj)
  record: (@arr = []) ->
    @arr = R(@arr)
  recorded: () -> @arr.unbox(true)

ScratchPad = new ScratchPadKlass

describe "Numeric#step", ->
  beforeEach ->
    ScratchPad.record []
    @prc = (x) -> ScratchPad.append(x)


  it "raises an ArgumentError when step is 0", ->
    expect( -> R(1).step(5, 0, ->) ).toThrow("ArgumentError")
    # without block
    #expect( -> R(1).step(5, 0) ).toNotThrow("ArgumentError")

  it "raises an ArgumentError when step is 0.0", ->
    expect( -> R(1).step(2, 0.0, ->) ).toThrow("ArgumentError")

  it "defaults to step = 1", ->
    R(1).step(5, @prc)
    expect( ScratchPad.recorded() ).toEqual [1, 2, 3, 4, 5]

  describe 'ruby_version_is "1.8.7"', ->
    it "returns an Enumerator when step is 0", ->
      expect( R(1).step(2, 0) ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator when not passed a block and self > stop", ->
      expect( R(1).step(0, 2) ).toBeInstanceOf(R.Enumerator)

    it "returns an Enumerator when not passed a block and self < stop", ->
      expect( R(1).step(2, 3) ).toBeInstanceOf(R.Enumerator)

    xit "returns an Enumerator that uses the given step", ->
      expect( R(0).step(5, 2).to_a().unbox(true) ).toEqual [0, 2, 4]

# Not testing mocked behaviour for now...
#
#   describe "with [stop, step]", ->
#     before :each do
#       @stop = mock("Numeric#step stop value")
#       @step = mock("Numeric#step step value")
#       @obj = NumericSpecs::Subclass.new
#
#     ruby_version_is ""..."1.8.7" do
#       it "does not raise a LocalJumpError when not passed a block and self > stop" do
#         @step.should_receive(:>).with(0).and_return(true)
#         @obj.should_receive(:>).with(@stop).and_return(true)
#         @obj.step(@stop, @step)
#       end

#       it "raises a LocalJumpError when not passed a block and self < stop" do
#         @step.should_receive(:>).with(0).and_return(true)
#         @obj.should_receive(:>).with(@stop).and_return(false)

#         lambda { @obj.step(@stop, @step) }.should raise_error(LocalJumpError)
#       end
#     end

#     it "increments self using #+ until self > stop when step > 0" do
#       @step.should_receive(:>).with(0).and_return(true)
#       @obj.should_receive(:>).with(@stop).and_return(false, false, false, true)
#       @obj.should_receive(:+).with(@step).and_return(@obj, @obj, @obj)

#       @obj.step(@stop, @step, &@prc)

#       ScratchPad.recorded.should == [@obj, @obj, @obj]
#     end

#     it "decrements self using #+ until self < stop when step < 0" do
#       @step.should_receive(:>).with(0).and_return(false)
#       @obj.should_receive(:<).with(@stop).and_return(false, false, false, true)
#       @obj.should_receive(:+).with(@step).and_return(@obj, @obj, @obj)

#       @obj.step(@stop, @step, &@prc)

#       ScratchPad.recorded.should == [@obj, @obj, @obj]
#     end
#   end

  describe "Numeric#step with [stop, step] when self, stop and step are Fixnums", ->
    it "yields only Fixnums", ->
      # TODO R(1).step(5, 1) { |x| x.should be_kind_of(Fixnum) }

  describe "Numeric#step with [stop, +step] when self, stop and step are Fixnums", ->
    it "yields while increasing self by step until stop is reached", ->
      R(1).step(5, 1, @prc)
      expect( ScratchPad.recorded() ).toEqual [1, 2, 3, 4, 5]

    it "yields once when self equals stop", ->
      R(1).step(1, 1, @prc)
      expect( ScratchPad.recorded() ).toEqual [1]

    it "does not yield when self is greater than stop", ->
      R(2).step(1, 1, @prc)
      expect( ScratchPad.recorded() ).toEqual []

  describe "Numeric#step with [stop, -step] when self, stop and step are Fixnums", ->
    it "yields while decreasing self by step until stop is reached", ->
      R(5).step(1, -1, @prc)

      expect( ScratchPad.recorded() ).toEqual [5,4,3,2,1]

    it "yields once when self equals stop", ->
      R(5).step(5, -1, @prc)
      expect( ScratchPad.recorded() ).toEqual [5]

    it "does not yield when self is less than stop", ->
      R(1).step(5, -1, @prc)
      expect( ScratchPad.recorded() ).toEqual []


  describe "Numeric#step with [stop, step]", ->
    it "yields only Floats when self is a Float", ->
      R(1.5).step(5, 1, (x) -> expect( x ).toBeInstanceOf(R.Float) )

    it "yields only Floats when stop is a Float", ->
      R(1).step(R(5.0).to_f(), 1, (x) -> expect( x ).toBeInstanceOf(R.Float) )

    it "yields only Floats when step is a Float", ->
      R(1).step(5, R(1.0).to_f(), (x) -> expect( x ).toBeInstanceOf(R.Float) )

  describe "Numeric#step with [stop, +step] when self, stop or step is a Float", ->
    it "yields while increasing self by step while < stop", ->
      R(1.5).step(5, 1, @prc)
      expect( ScratchPad.recorded() ).toEqual [1.5, 2.5, 3.5, 4.5]

    it "yields once when self equals stop", ->
      R(1.5).step(1.5, 1, @prc)
      expect( ScratchPad.recorded() ).toEqual [1.5]

    it "does not yield when self is greater than stop", ->
      R(2.5).step(1.5, 1, @prc)
      expect( ScratchPad.recorded() ).toEqual []

    describe 'ruby_bug "redmine #4576", "1.9.3"', ->
      it "is careful about not yielding a value greater than limit", ->
        # As 9*1.3+1.0 == 12.700000000000001 > 12.7, we test:
        R(1.0).step(12.7, 1.3, @prc)
        expect( ScratchPad.recorded() ).toEqual [1.0, 2.3, 3.6, 4.9, 6.2, 7.5, 8.8, 10.1, 11.4, 12.7]

  describe "Numeric#step with [stop, -step] when self, stop or step is a Float", ->
    it "yields while decreasing self by step while self > stop", ->
      R(5).step(1.5, -1, @prc)
      expect( ScratchPad.recorded() ).toEqual [5.0, 4.0, 3.0, 2.0]

    it "yields once when self equals stop", ->
      R(1.5).step(1.5, -1, @prc)
      ScratchPad.recorded.should == [1.5]
      expect( ScratchPad.recorded() ).toEqual [1.5]


    it "does not yield when self is less than stop", ->
      R(1).step(5, -1.5, @prc)
      expect( ScratchPad.recorded() ).toEqual []

    describe 'ruby_bug "redmine #4576", "1.9.3"', ->
      it "is careful about not yielding a value smaller than limit", ->
        # As -9*1.3-1.0 == -12.700000000000001 < -12.7, we test:
        R(-1.0).step(-12.7, -1.3, @prc)
        expect( ScratchPad.recorded() ).toEqual [-1.0, -2.3, -3.6, -4.9, -6.2, -7.5, -8.8, -10.1, -11.4, -12.7]

#   describe "Numeric#step with [stop, +Infinity]" do
#     ruby_bug "#781", "1.8.7" do
#       it "yields once if self < stop" do
#         42.step(100, infinity_value, &@prc)
#         ScratchPad.recorded.should == [42]
#       end

#       it "yields once when stop is Infinity" do
#         42.step(infinity_value, infinity_value, &@prc)
#         ScratchPad.recorded.should == [42]
#       end

#       it "yields once when self equals stop" do
#         42.step(42, infinity_value, &@prc)
#         ScratchPad.recorded.should == [42]
#       end

#       it "yields once when self and stop are Infinity" do
#         (infinity_value).step(infinity_value, infinity_value, &@prc)
#         ScratchPad.recorded.should == [infinity_value]
#       end
#     end

#     ruby_bug "#3945", "1.9.2.135" do
#       it "does not yield when self > stop" do
#         100.step(42, infinity_value, &@prc)
#         ScratchPad.recorded.should == []
#       end

#       it "does not yield when stop is -Infinity" do
#         42.step(-infinity_value, infinity_value, &@prc)
#         ScratchPad.recorded.should == []
#       end
#     end
#   end

#   describe "Numeric#step with [stop, -infinity]" do
#     ruby_bug "#3945", "1.9.2.135" do
#       it "yields once if self > stop" do
#         42.step(6, -infinity_value, &@prc)
#         ScratchPad.recorded.should == [42]
#       end

#       it "yields once if stop is -Infinity" do
#         42.step(-infinity_value, -infinity_value, &@prc)
#         ScratchPad.recorded.should == [42]
#       end

#       it "yields once when self equals stop" do
#         42.step(42, -infinity_value, &@prc)
#         ScratchPad.recorded.should == [42]
#       end

#       it "yields once when self and stop are Infinity" do
#         (infinity_value).step(infinity_value, -infinity_value, &@prc)
#         ScratchPad.recorded.should == [infinity_value]
#       end
#     end

#     ruby_bug "#781", "1.8.7" do
#       it "does not yield when self > stop" do
#         42.step(100, -infinity_value, &@prc)
#         ScratchPad.recorded.should == []
#       end

#       it "does not yield when stop is Infinity" do
#         42.step(infinity_value, -infinity_value, &@prc)
#         ScratchPad.recorded.should == []
#       end
#     end
#   end

#   it "does not rescue ArgumentError exceptions" do
#     lambda { 1.step(2) { raise ArgumentError, "" }}.should raise_error(ArgumentError)
#   end

#   it "does not rescue TypeError exceptions" do
#     lambda { 1.step(2) { raise TypeError, "" } }.should raise_error(TypeError)
#   end
# end
