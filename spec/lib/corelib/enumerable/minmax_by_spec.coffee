
describe 'ruby_version_is "1.8.7"', ->
  describe "Enumerable#minmax_by", ->
    it "returns an enumerator if no block", ->
      expect( EnumerableSpecs.Numerous.new(42).minmax_by() ).toBeInstanceOf R.Enumerator

    it "returns nil if #each yields no objects", ->
      expect( EnumerableSpecs.Empty.new().minmax_by (o) -> o.nonesuch ).toEqual R([null,null])

    it "returns the object for whom the value returned by block is the largest", ->
      expect( EnumerableSpecs.Numerous.new('1', '2', '3').minmax_by (obj) -> obj.to_i() ).toEqual R.$Array_r(['1','3'])
      expect( EnumerableSpecs.Numerous.new('three', 'five').minmax_by (obj) -> obj.size() ).toEqual R.$Array_r(['five', 'three'])

    it "returns the object that appears first in #each in case of a tie", ->
      expect( EnumerableSpecs.Numerous.new('1', '1', '2', '2').minmax_by (obj) -> obj.to_i() ).toEqual R.$Array_r(['1','2'])

    it "uses max.<=>(current) to determine order", ->
      # a, b, c = (1..3).map(n) -> EnumerableSpecs.ReverseComparable.new(n)

      # # Just using self here to avoid additional complexity
      # expect( EnumerableSpecs.Numerous.new(a, b, c).minmax_by (obj) -> obj ).toEqual a

    it "is able to return the minimum for enums that contain nils", ->
      en = EnumerableSpecs.Numerous.new(null, null, true)
      expect( en.minmax_by (o) -> if o is null then R(0) else R(1) ).toEqual R.$Array_r([null, true])

    xit "gathers whole arrays as elements when each yields multiple", ->
      # multi = EnumerableSpecs.YieldsMulti.new
      # multi.minmax_by {|e| e.size}.should == [6, 7, 8, 9]


# ruby_version_is "1.8.7", ->
#   describe "Enumerable#minmax_by", ->
#     it "returns an enumerator if no block", ->
#       EnumerableSpecs.Numerous.new(42).minmax_by.should be_an_instance_of(enumerator_class)

#     it "returns nil if #each yields no objects", ->
#       EnumerableSpecs.Empty.new.minmax_by {|o| o.nonesuch }.should == [nil, nil]

#     it "returns the object for whom the value returned by block is the largest", ->
#       EnumerableSpecs.Numerous.new(*%w[1 2 3]).minmax_by {|obj| obj.to_i }.should == ['1', '3']
#       EnumerableSpecs.Numerous.new(*%w[three five]).minmax_by {|obj| obj.length }.should == ['five', 'three']

#     it "returns the object that appears first in #each in case of a tie", ->
#       a, b, c, d = '1', '1', '2', '2'
#       mm = EnumerableSpecs.Numerous.new(a, b, c, d).minmax_by {|obj| obj.to_i }
#       mm[0].should equal(a)
#       mm[1].should equal(c)

#     it "uses min/max.<=>(current) to determine order", ->
#       a, b, c = (1..3).map{|n| EnumerableSpecs.ReverseComparable.new(n)}

#       # Just using self here to avoid additional complexity
#       EnumerableSpecs.Numerous.new(a, b, c).minmax_by {|obj| obj }.should == [c, a]

#     it "is able to return the maximum for enums that contain nils", ->
#       enum = EnumerableSpecs.Numerous.new(nil, nil, true)
#       enum.minmax_by {|o| o.nil? ? 0 : 1 }.should == [nil, true]

#     it "gathers whole arrays as elements when each yields multiple", ->
#       multi = EnumerableSpecs.YieldsMulti.new
#       multi.minmax_by {|e| e.size}.should == [[1, 2], [6, 7, 8, 9]]
#   end

