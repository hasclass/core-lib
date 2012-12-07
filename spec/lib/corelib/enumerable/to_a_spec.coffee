describe "Enumerable#to_a", ->
  # it_behaves_like(:enumerable_entries , :to_a)

  it "returns an array containing the elements", ->
    numerous = EnumerableSpecs.Numerous.new(1, null, 'a', 2, false, true)
    expect( numerous.to_a() ).toEqual R.$Array_r([1, null, "a", 2, false, true])

  it "passes through the values yielded by #each_with_index", ->
    expect( R(["a", 'b']).each_with_index().to_a() ).toEqual R([['a', 0], ['b', 1]])

#     it "passes arguments to each" do
#       count = EnumerableSpecs::EachCounter.new(1, 2, 3)
#       count.to_a(:hello, "world").should == [1, 2, 3]
#       count.arguments_passed.should == [:hello, "world"]
