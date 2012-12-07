describe "Array#&", ->
  it "creates an array with elements common to both arrays (intersection)", ->
    expect(R([])['&'] []).toEqual R([])
    expect(R([1, 2])['&'] []).toEqual R([])
    expect(R([])['&'] [1, 2]).toEqual R([])
    expect(R([ 1, 3, 5 ])['&'] [ 1, 2, 3 ]).toEqual R([1, 3])

  it "creates an array with no duplicates", ->
    arr = R([ 1, 1, 3, 5 ])['&']([ 1, 2, 3 ])
    expect(arr.uniq().size() ).toEqual arr.size()

  it "creates an array with elements in order they are first encountered", ->
    expect(R([ 1, 2, 3, 2, 5 ])['&']([ 5, 2, 3, 4 ])    ).toEqual R([2, 3, 5])
    expect(R([ 1, 2, 3, 2, R(5) ])['&']([ 5, 2, 3, 4 ])).toEqual R([2, 3, R(5)])

  it "does not modify the original Array", ->
    a = R [1, 1, 3, 5]
    a['&'] [1, 2, 3]
    expect( a ).toEqual R([1, 1, 3, 5])


  # ruby_bug "ruby-core #1448", "1.9.1", ->
  #   it "properly handles recursive arrays", ->
  #     empty = ArraySpecs.empty_recursive_array
  #     (empty & empty).should == empty

  #     (ArraySpecs.recursive_array & []).should == []
  #     ([] & ArraySpecs.recursive_array).should == []

  #     (ArraySpecs.recursive_array & ArraySpecs.recursive_array).should == [1, 'two', 3.0, ArraySpecs.recursive_array]

  it "tries to convert the passed argument to an Array using #to_ary", ->
    obj =
      to_ary: -> R([1, 2, 3])
    expect(R([1, 2]).intersection(obj).to_native(true)).toEqual([1, 2])

  # it "determines equivalence between elements in the sense of eql?", ->
  #   ([5.0, 4.0] & [5, 4]).should == []
  #   str = "x"
  #   ([str] & [str.dup]).should == [str]

  #   obj1 = mock('1')
  #   obj2 = mock('2')
  #   def obj1.hash; 0; end
  #   def obj2.hash; 0; end
  #   def obj1.eql? a; true; end
  #   def obj2.eql? a; true; end

  #   ([obj1] & [obj2]).should == [obj1]

  #   def obj1.eql? a; false; end
  #   def obj2.eql? a; false; end

  #   ([obj1] & [obj2]).should == []

  # it "does return subclass instances for Array subclasses", ->
  #   (ArraySpecs::MyArray[1, 2, 3] & []).should be_kind_of(Array)
  #   (ArraySpecs::MyArray[1, 2, 3] & ArraySpecs::MyArray[1, 2, 3]).should be_kind_of(Array)
  #   ([] & ArraySpecs::MyArray[1, 2, 3]).should be_kind_of(Array)

  # it "does not call to_ary on array subclasses", ->
  #   ([5, 6] & ArraySpecs::ToAryArray[1, 2, 5, 6]).should == [5, 6]
