# Do not use #should_receive(:eql?) mocks in these specs
# because MSpec uses Hash for mocks and Hash calls #eql?.

describe "Array#eql?", ->
  xit "returns false if any corresponding elements are not #eql?", ->
    # TODO: IMPORTANT: integers and float do not compare properly
    expect( R([1, 2, 3, 4]).eql( [1, 2, 3, R.$Float(4.0)]) ).toEqual false

  it "returns true if other is the same array", ->
    a = R [1]
    expect( R(a).eql( a) ).toEqual true

  it "returns true if corresponding elements are #eql?", ->
    expect( R([]).eql( []) ).toEqual true
    expect( R([1, 2, 3, 4]).eql( [1, 2, 3, 4]) ).toEqual true

  it "returns false if other is shorter than self", ->
    expect( R([1, 2, 3, 4]).eql( [1, 2, 3]) ).toEqual false

  it "returns false if other is longer than self", ->
    expect( R([1, 2, 3, 4]).eql( [1, 2, 3, 4, 5]) ).toEqual false

  it "returns false immediately when sizes of the arrays differ", ->
    obj =
      to_ary: -> throw "should not call"

    expect( R([]        ).eql(    [obj]  )).toEqual false
    expect( R([obj]     ).eql(    []     )).toEqual false

  # ruby_bug "ruby-core #1448", "1.9.1", ->
  #   it "handles well recursive arrays", ->
  #     a = ArraySpecs.empty_recursive_array
  #     a       .eql(    [a]    ).should be_true
  #     a       .eql(    [[a]]  ).should be_true
  #     [a]     .eql(    a      ).should be_true
  #     [[a]]   .eql(    a      ).should be_true
  #     # These may be surprising, but no difference can be
  #     # found between these arrays, so they are ==.
  #     # There is no "path" that will lead to a difference
  #     # (contrary to other examples below)

  #     a2 = ArraySpecs.empty_recursive_array
  #     a       .eql(    a2     ).should be_true
  #     a       .eql(    [a2]   ).should be_true
  #     a       .eql(    [[a2]] ).should be_true
  #     [a]     .eql(    a2     ).should be_true
  #     [[a]]   .eql(    a2     ).should be_true

  #     back = []
  #     forth = [back]; back << forth;
  #     back   .eql(  a  ).should be_true

  #     x = []; x << x << x
  #     x       .eql(    a                ).should be_false  # since x.size != a.size
  #     x       .eql(    [a, a]           ).should be_false  # since x[0].size != [a, a][0].size
  #     x       .eql(    [x, a]           ).should be_false  # since x[1].size != [x, a][1].size
  #     [x, a]  .eql(    [a, x]           ).should be_false  # etc...
  #     x       .eql(    [x, x]           ).should be_true
  #     x       .eql(    [[x, x], [x, x]] ).should be_true

  #     tree = [];
  #     branch = []; branch << tree << tree; tree << branch
  #     tree2 = [];
  #     branch2 = []; branch2 << tree2 << tree2; tree2 << branch2
  #     forest = [tree, branch, :bird, a]; forest << forest
  #     forest2 = [tree2, branch2, :bird, a2]; forest2 << forest2

  #     forest .eql(     forest2         ).should be_true
  #     forest .eql(     [tree2, branch, :bird, a, forest2]).should be_true

  #     diffforest = [branch2, tree2, :bird, a2]; diffforest << forest2
  #     forest .eql(     diffforest      ).should be_false # since forest[0].size == 1 != 3 == diffforest[0]
  #     forest .eql(     [nil]           ).should be_false
  #     forest .eql(     [forest]        ).should be_false

  xit "does not call #to_ary on its argument", ->
    obj =
      to_ary: -> throw "should not call"

    expect( R( [1, 2, 3]).eql( obj) ).toEqual false

  it "does not call #to_ary on Array subclasses", ->
    ary = R([5, 6, 7])
    ary.to_ary = -> throw "should not call"
    expect( R( [5, 6, 7]).eql( ary) ).toEqual true

  xit "ignores array class differences", ->
    # ArraySpecs.MyArray[1, 2, 3].eql( [1, 2, 3]).should be_true
    # ArraySpecs.MyArray[1, 2, 3].eql( ArraySpecs.MyArray[1, 2, 3]).should be_true
    # [1, 2, 3].eql( ArraySpecs.MyArray[1, 2, 3]).should be_true
