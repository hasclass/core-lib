# TODO: finish!
describe "Enumerator.new", ->
  # it_behaves_like(:enum_new, :new)

  describe 'ruby_version_is "1.9.1"', ->
    # Maybe spec should be broken up?
    it "accepts a block", ->
      en = R.Enumerator.create (yielder) ->
        r = yielder.yield 3
        yielder['<<'](r)['<<'](2)['<<'](1)

      expect( en).toBeInstanceOf R.Enumerator
      r = []
      en.each (x) -> r.push(x); x * 2
      expect( r ).toEqual [3, 6, 2, 1]

    it "ignores block if arg given", ->
      # enum = enumerator_class.new([1,2,3]){|y| y.yield 4}
      # enum.to_a.should == [1,2,3]


# describe :enum_new, :shared => true do
#   it "creates a new custom enumerator with the given object, iterator and arguments", ->
#     enum = enumerator_class.new(1, :upto, 3)
#     enum.should be_an_instance_of(enumerator_class)

#   it "creates a new custom enumerator that responds to #each", ->
#     enum = enumerator_class.new(1, :upto, 3)
#     enum.respond_to?(:each).should == true

#   it "creates a new custom enumerator that runs correctly", ->
#     enumerator_class.new(1, :upto, 3).map{|x|x}.should == [1,2,3]

#   it "aliases the second argument to :each", ->
#     enumerator_class.new(1..2).to_a.should == enumerator_class.new(1..2, :each).to_a

#   it "doesn't check for the presence of the iterator method", ->
#     enumerator_class.new(nil).should be_an_instance_of(enumerator_class)

#   it "uses the latest define iterator method", ->
#     class StrangeEach
#       def each
#         yield :foo
#           enum = enumerator_class.new(StrangeEach.new)
#     enum.to_a.should == [:foo]
#     class StrangeEach
#       def each
#         yield :bar
#           enum.to_a.should == [:bar]

