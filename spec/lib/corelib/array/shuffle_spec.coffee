# TODO: finalize tests
describe "Array#shuffle", ->
  describe 'ruby_version_is "1.8.7"', ->
    it "returns the same values, in a usually different order", ->
      a = R [1, 2, 3, 4]
      different = false
      R(10).times ->
        s = a.shuffle()
        # TODO: uncomment once sort is implemented
        # expect( s.sort() ).toEqual a
        different ||= (a != s)
      expect( different ).toEqual true # Will fail once in a blue moon (4!^10)

#     it "is not destructive", ->
#       a = [1, 2, 3]
#       10.times do
#         a.shuffle
#         a.should == [1, 2, 3]

#   ruby_version_is "1.8.7" ... "1.9.3", ->
#     it "returns subclass instances with Array subclass", ->
#       ArraySpecs.MyArray[1, 2, 3].shuffle.should be_an_instance_of(ArraySpecs.MyArray)

#   ruby_version_is "1.9.3", ->
#     it "does not return subclass instances with Array subclass", ->
#       ArraySpecs.MyArray[1, 2, 3].shuffle.should be_an_instance_of(Array)

# describe "Array#shuffle!", ->
#   ruby_version_is "1.8.7", ->
#     it "returns the same values, in a usually different order", ->
#       a = [1, 2, 3, 4]
#       original = a
#       different = false
#       10.times do
#         a = a.shuffle!
#         a.sort.should == [1, 2, 3, 4]
#         different ||= (a != [1, 2, 3, 4])
#           different.should be_true # Will fail once in a blue moon (4!^10)
#       a.should equal(original)

#     ruby_version_is ""..."1.9", ->
#       it "raises a TypeError on a frozen array", ->
#         expect( -> ArraySpecs.frozen_array.shuffle! ).toThrow(TypeError)
#         expect( -> ArraySpecs.empty_frozen_array.shuffle! ).toThrow(TypeError)

#     ruby_version_is "1.9", ->
#       it "raises a RuntimeError on a frozen array", ->
#         expect( -> ArraySpecs.frozen_array.shuffle! ).toThrow(RuntimeError)
#         expect( -> ArraySpecs.empty_frozen_array.shuffle! ).toThrow(RuntimeError)
#