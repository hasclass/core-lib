# TODO:
# describe "Enumerable#zip", ->
#   it "combines each element of the receiver with the element of the same index in arrays given as arguments", ->
#     expect( R([1,2,3] ).zip([4,5,6],[7,8,9]) ).toEqual R([[1, 4, 7], [2, 5, 8], [3, 6, 9]])
#     expect( R([1,2,3] ).zip() ).toEqual R([[1], [2], [3]])

#   it "passes each element of the result array to a block and return nil if a block is given", ->
#     expected = [[1, 4, 7],[2, 5, 8],[3, 6, 9]]
#     ret = EnumerableSpecs.Numerous.new(1,2,3).zip [4,5,6],[7,8,9], (result) ->
#       expect( result ).toEqual R(expected.shift())
#     expect( ret is null ).toEqual true
#     expect( expected.length ).toEqual 0

#   it "fills resulting array with nils if an argument array is too short", ->
#     expect( EnumerableSpecs.Numerous.new(1,2,3).zip([4,5,6], [7,8]).inspect(true) ).toEqual R([[1, 4, 7], [2, 5, 8], [3, 6, null]])

#   # ruby_version_is ''...'1.9' do
#   #   it "converts arguments to arrays using #to_a", ->
#   #     convertable = EnumerableSpecs.ArrayConvertable.new(4,5,6)
#   #     EnumerableSpecs.Numerous.new(1,2,3).zip(convertable).should == [[1,4],[2,5],[3,6]]
#   #     convertable.called.should == :to_a

#   describe "ruby_version_is '1.9'", ->
#     it "converts arguments to arrays using #to_ary", ->
#       convertable = new EnumerableSpecs.ArrayConvertable(4,5,6)
#       expect( EnumerableSpecs.Numerous.new(1,2,3).zip(convertable).inspect()).toEqual R('[[1, 4], [2, 5], [3, 6]]')
#       expect( convertable.called ).toEqual 'to_ary'

#     it "converts arguments to enums using #to_enum", ->
#       convertable = new EnumerableSpecs.EnumConvertable(R.Range.new(4, 6))
#       expect( EnumerableSpecs.Numerous.new(1,2,3).zip(convertable).inspect() ).toEqual R('[[1, 4], [2, 5], [3, 6]]')
#       expect( convertable.called ).toEqual 'to_enum'
#       expect( convertable.sym ).toEqual 'each'

#   it "gathers whole arrays as elements when each yields multiple", ->
#     multi = new EnumerableSpecs.YieldsMulti()
#     expect( multi.zip(multi)).toEqual R([[1, [1,2]], [3, [3,4,5]], [6, [6,7,8,9]]])


