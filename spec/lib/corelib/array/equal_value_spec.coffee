describe "Array#==", ->
  # it_behaves_like :array_eql, :==

  xit "compares with an equivalent Array-like object using #to_ary", ->
    # FIXME: Proper implementation, commented out due
    # to mspec bugs (#194 and #195):
    # obj = mock('array-like')
    # obj.should_receive(:respond_to?).with(:to_ary).and_return(true)
    # obj.should_receive(:==).with([1]).and_return(true)

    # obj = Object.new
    # def obj.to_ary; [1]; end
    # def obj.==(arg); to_ary == arg; end

    # ([1] == obj).should be_true
    # ([[1]] == [obj]).should be_true
    # ([[[1], 3], 2] == [[obj, 3], 2]).should be_true

    # ruby_version_is "1.9.1", ->
    #   # recursive arrays
    #   arr1 = [[1]]
    #   arr1 << arr1
    #   arr2 = [obj]
    #   arr2 << arr2
    #   (arr1 == arr2).should be_true
    #   (arr2 == arr1).should be_true

  it "returns false if any corresponding elements are not #==", ->
    a = R(["a", "b", "c"])
    b = R(["a", "b", "not equal value"])
    # expect( a['=='](b) ).toEqual false

    c =
      '==': -> false
    expect( R(["a", "b", c])['=='] a).toEqual false

  it "returns true if corresponding elements are #==", ->
    expect( R([])['==']    [] ).toEqual true
    expect( R([])['=='] R([])).toEqual true
    expect( R(["a", "c", 7])['=='] ["a", "c", 7]).toEqual true

    expect( R([1, 2, 3])['=='] [1.0, 2.0, 3.0]).toEqual true

    obj =
      "==": -> true
    expect( R([obj])['=='] [5] ).toEqual true

  # As per bug #1720
  xit "returns false for [NaN] == [NaN]", ->
    # [nan_value].should_not == [nan_value]


describe "Array#== (behaving like eql?)", ->
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
