describe "Enumerable#member?", ->
#  it_behaves_like(:enumerable_include, :member?)

  it "returns true if any element == argument for numbers", ->
    obj =
      '==': (other) -> other.valueOf() == 5

    expect( EnumerableSpecs.Numerous.new(0,1,2,3,4,5).member(5)).toEqual true
    expect( EnumerableSpecs.Numerous.new(0,1,2,3,4,5).member(10)).toEqual false
    expect( EnumerableSpecs.Numerous.new(0,1,2,3,4,5).member(obj)).toEqual true

  it "returns true if any element == argument for other objects", ->
    obj =
      '==': (other) -> other == '11'

    # elements = ('0'..'5').to_a + [EnumerableSpecIncludeP11.new]
    expect( EnumerableSpecs.Numerous.new('0', '1', '2', '3', '4', '5', obj).member('5')  ).toEqual true
    expect( EnumerableSpecs.Numerous.new('0', '1', '2', '3', '4', '5', obj).member('10') ).toEqual false
    expect( EnumerableSpecs.Numerous.new('0', '1', '2', '3', '4', '5', obj).member(obj)  ).toEqual true
    expect( EnumerableSpecs.Numerous.new('0', '1', '2', '3', '4', '5', obj).member('11') ).toEqual true


  xit "returns true if any member of enum equals obj when == compare different classes (legacy rubycon)", ->
    # TODO: implement this special behaviour
    # equality is tested with ==
    expect( EnumerableSpecs.Numerous.new(2,4,6,8,10).member(2.0) ).toEqual true
    expect( EnumerableSpecs.Numerous.new(2,4,[6,8],10).member([6, 8]) ).toEqual true
    expect( EnumerableSpecs.Numerous.new(2,4,[6,8],10).member([6.0, 8.0]) ).toEqual true

  xit "gathers whole arrays as elements when each yields multiple", ->
    # multi = EnumerableSpecs.YieldsMulti.new
    # multi.member?([1,2]).should be_true

