require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe :hash_index, :shared => true do
  it "returns the corresponding key for value", ->
    new_hash(2 => 'a', 1 => 'b').send(@method, 'b').should == 1

  it "returns nil if the value is not found", ->
    new_hash(:a => -1, :b => 3.14, :c => 2.718).send(@method, 1).should be_nil

  it "doesn't return default value if the value is not found", ->
    new_hash(5).send(@method, 5).should be_nil

  it "compares values using ==", ->
    new_hash(1 => 0).send(@method, 0.0).should == 1
    new_hash(1 => 0.0).send(@method, 0).should == 1

    needle = mock('needle')
    inhash = mock('inhash')
    inhash.should_receive(:==).with(needle).and_return(true)

    new_hash(1 => inhash).send(@method, needle).should == 1
end
