describe "Array#<<", ->
  it "pushes the object onto the end of the array", ->
    expect(
      R([1, 2]).append("c").append("d").append([ 3, 4 ]).inspect()
    ).toEqual R('[1, 2, c, d, [3,4]]')


  it "returns self to allow chaining", ->
    a = R []
    b = a
    expect(a.append(1) == b).toEqual true
    expect(a.append(2).append(3) == b).toEqual true

  it "correctly resizes the Array", ->
    a = R []
    expect( +a.size() ).toEqual 0
    a.append 'foo'
    expect( +a.size() ).toEqual 1
    a.append('bar').append('baz')
    expect( +a.size() ).toEqual 3

    # a = [1, 2, 3]
    # a.shift
    # a.shift
    # a.shift
    # a << :foo
    # a.should == [:foo]

  xdescribe 'unsupported', ->
  # ruby_version_is '' ... '1.9' do
  #   it "raises a TypeError on a frozen array", ->
  #     lambda { ArraySpecs.frozen_array << 5 }.should raise_error(TypeError)


  # ruby_version_is '1.9' do
  #   it "raises a RuntimeError on a frozen array", ->
  #     lambda { ArraySpecs.frozen_array << 5 }.should raise_error(RuntimeError)

